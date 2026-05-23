import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:poseweave/core/constants/api_config.dart';
import 'package:poseweave/data/network/auth_interceptor.dart';
import 'package:poseweave/data/network/token_storage.dart';

/// Thin typed wrapper over the PoseWeave backend. All calls go through the
/// [AuthInterceptor] (bearer + refresh). Returns decoded `data` maps; throws
/// [DioException] on transport/HTTP errors (callers map to Failures).
@LazySingleton()
class PoseApiClient {
  PoseApiClient(this._tokens) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        contentType: 'application/json',
      ),
    )..interceptors.add(AuthInterceptor(_tokens));
  }

  final TokenStorage _tokens;
  late final Dio _dio;

  Map<String, dynamic> _data(Response<dynamic> res) =>
      ((res.data as Map)['data'] as Map).cast<String, dynamic>();

  Future<Map<String, dynamic>> register(
    String email,
    String password, {
    String? displayName,
  }) async {
    final Response<dynamic> res = await _dio.post<dynamic>(
      '/v1/auth/register',
      data: <String, dynamic>{
        'email': email,
        'password': password,
        if (displayName != null) 'displayName': displayName,
      },
    );
    return _data(res);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final Response<dynamic> res = await _dio.post<dynamic>(
      '/v1/auth/login',
      data: <String, String>{'email': email, 'password': password},
    );
    return _data(res);
  }

  Future<Map<String, dynamic>> me() async {
    final Response<dynamic> res = await _dio.get<dynamic>('/v1/auth/me');
    return _data(res);
  }

  Future<Map<String, dynamic>> analyticsSummary() async {
    final Response<dynamic> res = await _dio.get<dynamic>(
      '/v1/analytics/summary',
    );
    return _data(res);
  }

  Future<Map<String, dynamic>> weeklyLeaderboard(String exercise) async {
    final Response<dynamic> res = await _dio.get<dynamic>(
      '/v1/leaderboard',
      queryParameters: <String, String>{'exercise': exercise},
    );
    return _data(res);
  }

  Future<Map<String, dynamic>> pushSessions(
    String deviceId,
    List<Map<String, dynamic>> sessions,
  ) async {
    final Response<dynamic> res = await _dio.post<dynamic>(
      '/v1/sync/sessions',
      data: <String, dynamic>{'deviceId': deviceId, 'sessions': sessions},
    );
    return _data(res);
  }
}
