// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:poseweave/data/datasources/mlkit_camera_datasource.dart'
    as _i258;
import 'package:poseweave/data/datasources/mlkit_camera_datasource_impl.dart'
    as _i733;
import 'package:poseweave/data/datasources/video_frame_datasource.dart'
    as _i799;
import 'package:poseweave/data/network/pose_api_client.dart' as _i1023;
import 'package:poseweave/data/network/token_storage.dart' as _i1058;
import 'package:poseweave/data/repositories/auth_repository.dart' as _i1056;
import 'package:poseweave/data/repositories/pose_repository_impl.dart' as _i298;
import 'package:poseweave/data/services/api_key_service.dart' as _i297;
import 'package:poseweave/data/services/pdf_report_service.dart' as _i962;
import 'package:poseweave/data/services/recommendation_service.dart' as _i340;
import 'package:poseweave/domain/repositories/pose_repository.dart' as _i154;
import 'package:poseweave/presentation/bloc/pose_bloc.dart' as _i1064;
import 'package:poseweave/presentation/bloc/pose_classifier_bloc.dart' as _i597;
import 'package:poseweave/presentation/bloc/pose_match_bloc.dart' as _i70;
import 'package:poseweave/presentation/bloc/profile_cubit.dart' as _i995;
import 'package:poseweave/presentation/bloc/recommendations_bloc.dart' as _i490;
import 'package:poseweave/presentation/bloc/rep_counter_bloc.dart' as _i986;
import 'package:poseweave/presentation/bloc/settings_bloc.dart' as _i790;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i986.RepCounterBloc>(() => _i986.RepCounterBloc());
    gh.factory<_i597.PoseClassifierBloc>(() => _i597.PoseClassifierBloc());
    gh.factory<_i70.PoseMatchBloc>(() => _i70.PoseMatchBloc());
    gh.lazySingleton<_i1058.TokenStorage>(() => _i1058.TokenStorage());
    gh.lazySingleton<_i297.ApiKeyService>(() => _i297.ApiKeyService());
    gh.lazySingleton<_i962.PdfReportService>(() => _i962.PdfReportService());
    gh.lazySingleton<_i799.VideoFrameDataSource>(
      () => _i799.VideoFrameDataSourceImpl(),
    );
    gh.factory<_i790.SettingsBloc>(
      () => _i790.SettingsBloc(gh<_i297.ApiKeyService>()),
    );
    gh.lazySingleton<_i258.MLKitCameraDataSource>(
      () => _i733.MLKitCameraDataSourceImpl(),
    );
    gh.lazySingleton<_i340.RecommendationService>(
      () => _i340.RecommendationService(gh<_i297.ApiKeyService>()),
    );
    gh.factory<_i490.RecommendationsBloc>(
      () => _i490.RecommendationsBloc(gh<_i340.RecommendationService>()),
    );
    gh.lazySingleton<_i1023.PoseApiClient>(
      () => _i1023.PoseApiClient(gh<_i1058.TokenStorage>()),
    );
    gh.lazySingleton<_i154.PoseRepository>(
      () => _i298.PoseRepositoryImpl(
        gh<_i258.MLKitCameraDataSource>(),
        gh<_i799.VideoFrameDataSource>(),
      ),
    );
    gh.lazySingleton<_i1056.AuthRepository>(
      () => _i1056.AuthRepository(
        gh<_i1023.PoseApiClient>(),
        gh<_i1058.TokenStorage>(),
      ),
    );
    gh.factory<_i1064.PoseBloc>(
      () => _i1064.PoseBloc(
        gh<_i154.PoseRepository>(),
        gh<_i962.PdfReportService>(),
      ),
    );
    gh.factory<_i995.ProfileCubit>(
      () => _i995.ProfileCubit(gh<_i1056.AuthRepository>()),
    );
    return this;
  }
}
