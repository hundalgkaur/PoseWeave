import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/core/utils/segment_aggregator.dart';
import 'package:poseweave/data/services/api_key_service.dart';
import 'package:poseweave/data/services/recommendation_prompt_builder.dart';
import 'package:poseweave/domain/entities/gait_parameters.dart';
import 'package:poseweave/domain/entities/recommendation_entity.dart';

/// Calls the Claude API with the user's own key (BYOK) to turn gait/segment
/// measurements into physiotherapy recommendations.
@LazySingleton()
class RecommendationService {
  RecommendationService(this._keyService);

  final ApiKeyService _keyService;

  Future<Either<Failure, List<RecommendationEntity>>> getRecommendations({
    required GaitParameters gait,
    required Map<String, SegmentSummary> segments,
  }) async {
    final String? key = await _keyService.getKey();
    if (key == null || key.isEmpty) {
      return const Left<Failure, List<RecommendationEntity>>(
        NoApiKeyFailure('Add your Anthropic API key in Settings'),
      );
    }

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
