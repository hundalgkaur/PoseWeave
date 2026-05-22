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
import 'package:poseweave/data/repositories/pose_repository_impl.dart' as _i298;
import 'package:poseweave/domain/repositories/pose_repository.dart' as _i154;
import 'package:poseweave/presentation/bloc/pose_bloc.dart' as _i1064;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i799.VideoFrameDataSource>(
      () => _i799.VideoFrameDataSourceImpl(),
    );
    gh.lazySingleton<_i258.MLKitCameraDataSource>(
      () => _i733.MLKitCameraDataSourceImpl(),
    );
    gh.lazySingleton<_i154.PoseRepository>(
      () => _i298.PoseRepositoryImpl(
        gh<_i258.MLKitCameraDataSource>(),
        gh<_i799.VideoFrameDataSource>(),
      ),
    );
    gh.factory<_i1064.PoseBloc>(
      () => _i1064.PoseBloc(gh<_i154.PoseRepository>()),
    );
    return this;
  }
}
