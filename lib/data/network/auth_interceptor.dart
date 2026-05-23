import 'package:dio/dio.dart';
import 'package:poseweave/core/constants/api_config.dart';
import 'package:poseweave/data/network/token_storage.dart';

/// Attaches the Bearer access token and, on a 401, tries a one-shot refresh
/// (rotating tokens) before retrying the original request once.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokens);

  final TokenStorage _tokens;
  bool _refreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await _tokens.getAccessToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 || _refreshing) {
      return handler.next(err);
    }
    _refreshing = true;
    try {
      final String? refresh = await _tokens.getRefreshToken();
      if (refresh == null) return handler.next(err);

      // Use a bare Dio so this refresh call doesn't recurse through this
      // interceptor.
      final Dio bare = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
      final Response<dynamic> res = await bare.post<dynamic>(
        '/v1/auth/refresh',
        data: <String, String>{'refreshToken': refresh},
      );
      final Map<String, dynamic> body =
          (res.data as Map).cast<String, dynamic>();
      final Map<String, dynamic> data =
          (body['data'] as Map).cast<String, dynamic>();
      final Map<String, dynamic> tokens =
          (data['tokens'] as Map).cast<String, dynamic>();
      final String access = tokens['accessToken'] as String;
      await _tokens.save(
        access: access,
        refresh: tokens['refreshToken'] as String,
      );

      // Retry the original request with the new token.
      final RequestOptions o = err.requestOptions;
      o.headers['Authorization'] = 'Bearer $access';
      final Response<dynamic> retry = await bare.fetch<dynamic>(o);
      return handler.resolve(retry);
    } catch (_) {
      await _tokens.clear();
      return handler.next(err);
    } finally {
      _refreshing = false;
    }
  }
}
