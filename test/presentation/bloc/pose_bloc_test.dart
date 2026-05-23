import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/core/utils/segment_aggregator.dart';
import 'package:poseweave/data/models/report_data.dart';
import 'package:poseweave/data/services/pdf_report_service.dart';
import 'package:poseweave/domain/entities/gait_parameters.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/video_analysis_progress.dart';
import 'package:poseweave/domain/repositories/pose_repository.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';

import '../../helpers/test_data.dart';

class MockPoseRepository extends Mock implements PoseRepository {}

class MockPdfReportService extends Mock implements PdfReportService {}

ReportData _reportData() => ReportData(
  generatedAt: DateTime(2026),
  exerciseType: 'Gait analysis',
  gait: const GaitParameters(
    speedMps: 0,
    cadenceSpm: 0,
    symmetryPercent: 0,
    leftArmSwingDeg: 0,
    rightArmSwingDeg: 0,
    kneeFlexionMaxDeg: 0,
    leftLegRotInDeg: 0,
    leftLegRotOutDeg: 0,
    rightLegRotInDeg: 0,
    rightLegRotOutDeg: 0,
    stancePercent: 0,
    swingPercent: 0,
    framesAnalyzed: 0,
  ),
  segments: const <String, SegmentSummary>{},
);

void main() {
  late MockPoseRepository repo;
  late MockPdfReportService pdf;

  setUpAll(() => registerFallbackValue(_reportData()));

  setUp(() {
    repo = MockPoseRepository();
    pdf = MockPdfReportService();
    when(
      () => repo.setMockMode(enabled: any(named: 'enabled')),
    ).thenReturn(null);
    when(() => repo.disposeCamera()).thenAnswer((_) async {});
  });

  group('PoseBloc', () {
    blocTest<PoseBloc, PoseState>(
      'StopDetection emits streaming',
      setUp: () {
        when(
          () => repo.stopDetection(),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
      },
      build: () => PoseBloc(repo, pdf),
      act: (PoseBloc bloc) => bloc.add(const PoseEvent.stopDetection()),
      expect: () => <Matcher>[isA<PoseStreaming>()],
    );

    blocTest<PoseBloc, PoseState>(
      'StartDetection with a failing stream emits error',
      setUp: () {
        when(() => repo.getPoseStream()).thenReturn(
          const Left<Failure, Stream<PoseEntity>>(MLFailure('boom')),
        );
      },
      build: () => PoseBloc(repo, pdf),
      act: (PoseBloc bloc) => bloc.add(const PoseEvent.startDetection()),
      expect: () => <Matcher>[isA<PoseError>()],
    );

    late StreamController<PoseEntity> stream;
    blocTest<PoseBloc, PoseState>(
      'StartDetection then a received pose emits streaming then active',
      setUp: () {
        stream = StreamController<PoseEntity>.broadcast();
        when(
          () => repo.getPoseStream(),
        ).thenReturn(Right<Failure, Stream<PoseEntity>>(stream.stream));
        when(
          () => repo.startDetection(),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
      },
      build: () => PoseBloc(repo, pdf),
      act: (PoseBloc bloc) async {
        bloc.add(const PoseEvent.startDetection());
        await Future<void>.delayed(const Duration(milliseconds: 20));
        stream.add(buildTestPose());
        await Future<void>.delayed(const Duration(milliseconds: 20));
      },
      expect: () => <Matcher>[isA<PoseStreaming>(), isA<PoseActive>()],
      tearDown: () => stream.close(),
    );

    blocTest<PoseBloc, PoseState>(
      'StartVideoRecording emits recordingVideo',
      setUp: () {
        when(
          () => repo.startVideoRecording(),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
      },
      build: () => PoseBloc(repo, pdf),
      act: (PoseBloc bloc) => bloc.add(const PoseEvent.startVideoRecording()),
      expect: () => <Matcher>[isA<PoseRecordingVideo>()],
    );

    blocTest<PoseBloc, PoseState>(
      'StopVideoRecording analyzes the clip through to videoComplete',
      setUp: () {
        when(() => repo.stopVideoRecording()).thenAnswer(
          (_) async => const Right<Failure, String>('/tmp/clip.mp4'),
        );
        when(() => repo.analyzeVideo('/tmp/clip.mp4')).thenAnswer(
          (_) => Stream<VideoAnalysisProgress>.fromIterable(
            <VideoAnalysisProgress>[
              VideoAnalysisProgress(
                currentFrame: 1,
                totalFrames: 1,
                pose: buildTestPose(),
              ),
            ],
          ),
        );
      },
      build: () => PoseBloc(repo, pdf),
      act: (PoseBloc bloc) => bloc.add(const PoseEvent.stopVideoRecording()),
      expect:
          () => <Matcher>[
            isA<PoseVideoProcessing>(), // initial 0%
            isA<PoseVideoProcessing>(), // per-frame
            isA<PoseVideoComplete>(),
          ],
    );

    blocTest<PoseBloc, PoseState>(
      'PickAndAnalyzeImage emits imageProcessing then imageComplete',
      setUp: () {
        when(
          () => repo.pickImage(),
        ).thenAnswer((_) async => const Right<Failure, String?>('/img.jpg'));
        when(
          () => repo.analyzeImage('/img.jpg'),
        ).thenAnswer((_) async => Right<Failure, PoseEntity?>(buildTestPose()));
      },
      build: () => PoseBloc(repo, pdf),
      act: (PoseBloc bloc) => bloc.add(const PoseEvent.pickAndAnalyzeImage()),
      expect:
          () => <Matcher>[isA<PoseImageProcessing>(), isA<PoseImageComplete>()],
    );

    blocTest<PoseBloc, PoseState>(
      'GenerateReport emits reportGenerating then reportReady',
      setUp: () {
        when(() => pdf.generateReport(any())).thenAnswer(
          (_) async => const Right<Failure, String>('/report.pdf'),
        );
      },
      build: () => PoseBloc(repo, pdf),
      act: (PoseBloc bloc) =>
          bloc.add(PoseEvent.generateReport(_reportData())),
      expect:
          () =>
              <Matcher>[isA<PoseReportGenerating>(), isA<PoseReportReady>()],
    );
  });
}
