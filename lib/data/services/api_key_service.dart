import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:poseweave/core/errors/failures.dart';

/// Stores the user's Anthropic API key (BYOK) encrypted on-device and verifies
/// it with a minimal Claude request. The key never leaves the device except in
/// direct calls to api.anthropic.com.
@LazySingleton()
class ApiKeyService {
  ApiKeyService();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _keyName = 'anthropic_api_key';

  Future<String?> getKey() => _storage.read(key: _keyName);
  Future<void> saveKey(String key) => _storage.write(key: _keyName, value: key);
  Future<void> clearKey() => _storage.delete(key: _keyName);
  Future<bool> hasKey() async => (await getKey())?.isNotEmpty ?? false;

  /// Verifies a key with a 1-token request. Returns a specific failure on 401
  /// (invalid), 429 (rate limited), other non-200, or a network error.
  Future<Either<Failure, Unit>> testKey(String key) async {
    try {
      final http.Response res = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: <String, String>{
          'x-api-key': key,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        },
        body: jsonEncode(<String, Object>{
          'model': 'claude-haiku-4-5-20251001',
          'max_tokens': 1,
          'messages': <Map<String, String>>[
            <String, String>{'role': 'user', 'content': 'hi'},
          ],
        }),
      );
      if (res.statusCode == 200) return const Right<Failure, Unit>(unit);
      if (res.statusCode == 401) {
        return const Left<Failure, Unit>(AiServiceFailure('Invalid API key'));
      }
      if (res.statusCode == 429) {
        return const Left<Failure, Unit>(AiServiceFailure('Rate limited'));
      }
      return Left<Failure, Unit>(
        AiServiceFailure('API error ${res.statusCode}'),
      );
    } catch (e) {
      return Left<Failure, Unit>(AiServiceFailure('Network error: $e'));
    }
  }
}
