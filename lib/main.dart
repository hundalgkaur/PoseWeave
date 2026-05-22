import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/app.dart';
import 'package:poseweave/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const _AppBlocObserver();
  configureDependencies();
  // Phase 1 is portrait-only.
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
  runApp(const PoseWeaveApp());
}

/// Logs state transitions and errors during development.
class _AppBlocObserver extends BlocObserver {
  const _AppBlocObserver();

  @override
  void onChange(BlocBase<Object?> bloc, Change<Object?> change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType}: ${change.nextState.runtimeType}');
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType} error: $error');
    super.onError(bloc, error, stackTrace);
  }
}
