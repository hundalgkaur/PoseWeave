import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/core/utils/segment_aggregator.dart';
import 'package:poseweave/data/services/recommendation_service.dart';
import 'package:poseweave/domain/entities/gait_parameters.dart';
import 'package:poseweave/domain/entities/recommendation_entity.dart';

part 'recommendations_bloc.freezed.dart';

@freezed
class RecommendationsEvent with _$RecommendationsEvent {
  const factory RecommendationsEvent.fetch({
    required GaitParameters gait,
    required Map<String, SegmentSummary> segments,
  }) = FetchRecommendations;
}

@freezed
class RecommendationsState with _$RecommendationsState {
  const factory RecommendationsState.initial() = RecommendationsInitial;
  const factory RecommendationsState.loading() = RecommendationsLoading;
  const factory RecommendationsState.loaded(List<RecommendationEntity> items) =
      RecommendationsLoaded;

  /// [needsKey] true means route the user to Settings (BYOK not configured).
  const factory RecommendationsState.error({
    required String message,
    @Default(false) bool needsKey,
  }) = RecommendationsError;
}

@injectable
class RecommendationsBloc
    extends Bloc<RecommendationsEvent, RecommendationsState> {
  RecommendationsBloc(this._service)
    : super(const RecommendationsState.initial()) {
    on<FetchRecommendations>(_onFetch);
  }

  final RecommendationService _service;

  Future<void> _onFetch(
    FetchRecommendations event,
    Emitter<RecommendationsState> emit,
  ) async {
    emit(const RecommendationsState.loading());
    final result = await _service.getRecommendations(
      gait: event.gait,
      segments: event.segments,
    );
    result.fold(
      (Failure f) => emit(
        RecommendationsState.error(
          message: f.message,
          needsKey: f is NoApiKeyFailure,
        ),
      ),
      (List<RecommendationEntity> items) =>
          emit(RecommendationsState.loaded(items)),
    );
  }
}
