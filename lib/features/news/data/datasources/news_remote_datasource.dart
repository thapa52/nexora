import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/story_model.dart';

/// Handles all API calls to Hacker News.
/// Uses Dio for HTTP requests.
/// Only the repository calls this — never UI or domain.

abstract class NewsRemoteDatasource {
  /// Fetch top story IDs
  Future<List<int>> getTopStoryIds();

  /// Fetch new story IDs
  Future<List<int>> getNewStoryIds();

  /// Fetch best story IDs
  Future<List<int>> getBestStoryIds();

  /// Fetch a single story by ID
  Future<StoryModel> getStory(int id);
}

class NewsRemoteDatasourceImpl implements NewsRemoteDatasource {
  final Dio _dio;

  NewsRemoteDatasourceImpl({Dio? dio}) : _dio = dio ?? DioClient.instance;

  @override
  Future<List<int>> getTopStoryIds() {
    return _fetchStoryIds(ApiConstants.topStories);
  }

  @override
  Future<List<int>> getNewStoryIds() {
    return _fetchStoryIds(ApiConstants.newStories);
  }

  @override
  Future<List<int>> getBestStoryIds() {
    return _fetchStoryIds(ApiConstants.bestStories);
  }

  @override
  Future<StoryModel> getStory(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.item}/$id.json');

      if (response.data == null) {
        throw const ServerException(message: 'Story not found');
      }

      return StoryModel.fromJson(Map<String, dynamic>.from(response.data));
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  /// Private helper to fetch story IDs
  /// Reused by top, new, and best methods
  Future<List<int>> _fetchStoryIds(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return List<int>.from(response.data);
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
