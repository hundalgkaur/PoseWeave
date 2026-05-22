import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:poseweave/injection.config.dart';

/// Global service locator. Datasources and the repository are lazy singletons;
/// `PoseBloc` is a factory so each screen gets a fresh, disposable instance.
final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
