import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:poseweave/core/errors/failures.dart';

/// Contract for a single application action.
///
/// Every use case takes a [Params] and returns either a [Failure] or a result
/// of type [Type]. Use cases keep the BLoC thin: business intent lives here,
/// orchestration lives in the BLoC, and I/O lives in the repository.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Placeholder for use cases that take no arguments.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => <Object?>[];
}
