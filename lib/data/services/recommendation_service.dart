import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/core/utils/segment_aggregator.dart';
import 'package:poseweave/data/services/api_key_service.dart';
import 'package:poseweave/data/services/recommendation_prompt_builder.dart';
import 'package:poseweave/domain/entities/gait_parameters.dart';
import 'package:poseweave/domain/entities/recommendation_entity.dart';

/// Turns gait/segment measurements into physiotherapy recommendations.
///
/// Primary provider is **Google Gemini**, keyed from a git-ignored `.env`
/// (`GEMINI_API_KEY`). If no Gemini key is present it falls back to the
/// Anthropic Claude BYOK key entered in Settings, so either path works. The
/// same prompt (real gait + segment numbers) and JSON parser are reused for
/// both via [RecommendationPromptBuilder].
@LazySingleton()
class RecommendationService {
  RecommendationService(this._keyService);

  final ApiKeyService _keyService;

  Future<Either<Failure, List<RecommendationEntity>>> getRecommendations({
    required GaitParameters gait,
    required Map<String, SegmentSummary> segments,
  }) async {
    final String? geminiKey = _env('GEMINI_API_KEY');
    if (geminiKey != null && geminiKey.isNotEmpty) {
      return _gemini(key: geminiKey, gait: gait, segments: segments);
    }

    final String? claudeKey = await _keyService.getKey();
    if (claudeKey != null && claudeKey.isNotEmpty) {
      return _claude(key: claudeKey, gait: gait, segments: segments);
    }

    return const Left<Failure, List<RecommendationEntity>>(
      NoApiKeyFailure(
        'Add GEMINI_API_KEY to .env, or an Anthropic key in Settings',
      ),
    );
  }

  /// Reads a value from the loaded `.env`, tolerating an uninitialized dotenv
  /// (e.g. when no file is bundled).
  String? _env(String name) {
    try {
      if (!dotenv.isInitialized) return null;
      return dotenv.env[name]?.trim();
    } catch (_) {
      return null;
    }
  }

  // --- Gemini ---------------------------------------------------------------

  Future<Either<Failure, List<RecommendationEntity>>> _gemini({
    required String key,
    required GaitParameters gait,
    required Map<String, SegmentSummary> segments,
  }) async {
    final String model = () {
      final String? m = _env('GEMINI_MODEL');
      return (m == null || m.isEmpty) ? 'gemini-2.0-flash' : m;
    }();
    try {
      final http.Response res = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/'
          '$model:generateContent?key=$key',
        ),
        headers: <String, String>{'content-type': 'application/json'},
        body: jsonEncode(<String, Object>{
          'systemInstruction': <String, Object>{
            'parts': <Map<String, String>>[
              <String, String>{'text': RecommendationPromptBuilder.system},
            ],
          },
          'contents': <Map<String, Object>>[
            <String, Object>{
              'parts': <Map<String, String>>[
                <String, String>{
                  'text':
                      RecommendationPromptBuilder.buildUser(gait, segments),
                },
              ],
            },
          ],
          'generationConfig': <String, Object>{
            'responseMimeType': 'application/json',
            'temperature': 0.4,
          },
        }),
      );

      if (res.statusCode == 400) {
        return const Left<Failure, List<RecommendationEntity>>(
          AiServiceFailure('Gemini rejected the request — check key/model'),
        );
      }
      if (res.statusCode == 403) {
        return const Left<Failure, List<RecommendationEntity>>(
          AiServiceFailure('Gemini key rejected — check GEMINI_API_KEY in .env'),
        );
      }
      if (res.statusCode == 429) {
        return const Left<Failure, List<RecommendationEntity>>(
          AiServiceFailure('Rate limited — try again in a minute'),
        );
      }
      if (res.statusCode != 200) {
        return Left<Failure, List<RecommendationEntity>>(
          AiServiceFailure('Gemini error ${res.statusCode}'),
        );
      }

      final Map<String, dynamic> body =
          jsonDecode(res.body) as Map<String, dynamic>;
      final List<dynamic>? candidates = body['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        return const Left<Failure, List<RecommendationEntity>>(
          AiServiceFailure('Gemini returned no candidates'),
        );
      }
      final Map<String, dynamic>? content =
          (candidates.first as Map<String, dynamic>)['content']
              as Map<String, dynamic>?;
      final List<dynamic>? parts = content?['parts'] as List<dynamic>?;
      final String? text = (parts != null && parts.isNotEmpty)
          ? (parts.first as Map<String, dynamic>)['text'] as String?
          : null;
      if (text == null || text.isEmpty) {
        return const Left<Failure, List<RecommendationEntity>>(
          AiServiceFailure('Gemini returned an empty response'),
        );
      }
      return Right<Failure, List<RecommendationEntity>>(
        RecommendationPromptBuilder.parse(text),
      );
    } catch (e) {
      return Left<Failure, List<RecommendationEntity>>(
        AiServiceFailure('Failed to get recommendations: $e'),
      );
    }
  }

  // --- Claude (BYOK fallback) ----------------------------------------------

  Future<Either<Failure, List<RecommendationEntity>>> _claude({
    required String key,
    required GaitParameters gait,
    required Map<String, SegmentSummary> segments,
  }) async {
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
          'max_tokens': 1024,
          'system': RecommendationPromptBuilder.system,
          'messages': <Map<String, String>>[
            <String, String>{
              'role': 'user',
              'content': RecommendationPromptBuilder.buildUser(gait, segments),
            },
          ],
        }),
      );

      if (res.statusCode == 401) {
        return const Left<Failure, List<RecommendationEntity>>(
          AiServiceFailure('Key rejected — check it in Settings'),
        );
      }
      if (res.statusCode == 429) {
        return const Left<Failure, List<RecommendationEntity>>(
          AiServiceFailure('Rate limited — try again in a minute'),
        );
      }
      if (res.statusCode != 200) {
        return Left<Failure, List<RecommendationEntity>>(
          AiServiceFailure('AI service error ${res.statusCode}'),
        );
      }

      final Map<String, dynamic> body =
          jsonDecode(res.body) as Map<String, dynamic>;
      final List<dynamic> content = body['content'] as List<dynamic>;
      final String text =
          (content.first as Map<String, dynamic>)['text'] as String;
      return Right<Failure, List<RecommendationEntity>>(
        RecommendationPromptBuilder.parse(text),
      );
    } catch (e) {
      return Left<Failure, List<RecommendationEntity>>(
        AiServiceFailure('Failed to get recommendations: $e'),
      );
    }
  }
}
