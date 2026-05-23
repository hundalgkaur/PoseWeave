import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/data/repositories/auth_repository.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.summary);
  final Map<String, dynamic> summary;
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);
  final String message;
}

/// Loads the signed-in user's cloud analytics summary. Cloud-only — used by the
/// Profile screen when a backend is configured.
@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._auth) : super(const ProfileInitial());

  final AuthRepository _auth;

  Future<void> load() async {
    emit(const ProfileLoading());
    final Either<Failure, Map<String, dynamic>> result =
        await _auth.profileSummary();
    result.fold(
      (Failure f) => emit(ProfileError(f.message)),
      (Map<String, dynamic> s) => emit(ProfileLoaded(s)),
    );
  }

  Future<void> logout() => _auth.logout();
}
