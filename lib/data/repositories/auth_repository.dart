import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/data/network/pose_api_client.dart';
import 'package:poseweave/data/network/token_storage.dart';

/// Real (JWT) auth against the backend. The demo login flow stays independent;
/// this is used by the cloud Profile feature.
@LazySingleton()
class AuthRepository {
  AuthRepository(this._api, this._tokens);

  final PoseApiClient _api;
  final TokenStorage _tokens;

  Future<bool> get isLoggedIn => _tokens.isLoggedIn;

  Future<Either<Failure, Unit>> login(String email, String password) async {
    try {
      final Map<String, dynamic> data = await _api.login(email, password);
      await _saveTokens(data['tokens'] as Map<String, dynamic>);
      return const Right<Failure, Unit>(unit);
    } on DioException catch (e) {
      return Left<Failure, Unit>(_map(e));
    } catch (e) {
      return Left<Failure, Unit>(NetworkFailure('$e'));
    }
  }

  Future<Either<Failure, Unit>> register(
    String email,
    String password, {
    String? displayName,
  }) async {
    try {
      final Map<String, dynamic> data = await _api.register(
        email,
        password,
        displayName: displayName,
      );
      await _saveTokens(data['tokens'] as Map<String, dynamic>);
      return const Right<Failure, Unit>(unit);
    } on DioException catch (e) {
      return Left<Failure, Unit>(_map(e));
    } catch (e) {
      return Left<Failure, Unit>(NetworkFailure('$e'));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> profileSummary() async {
    try {
      return Right<Failure, Map<String, dynamic>>(
        await _api.analyticsSummary(),
      );
    } on DioException catch (e) {
      return Left<Failure, Map<String, dynamic>>(_map(e));
    } catch (e) {
      return Left<Failure, Map<String, dynamic>>(NetworkFailure('$e'));
    }
  }

  Future<void> logout() => _tokens.clear();

  Future<void> _saveTokens(Map<String, dynamic> tokens) => _tokens.save(
    access: tokens['accessToken'] as String,
    refresh: tokens['refreshToken'] as String,
  );

  NetworkFailure _map(DioException e) {
    final int? code = e.response?.statusCode;
    if (code == 401) return const NetworkFailure('Invalid email or password');
    if (code == 409) {
      return const NetworkFailure('That email is already registered');
    }
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkFailure(
        'Cannot reach the server — check your connection',
      );
    }
    return NetworkFailure('Request failed${code != null ? ' ($code)' : ''}');
  }
}
