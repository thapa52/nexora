import 'package:nexora/features/news/domain/entities/story_entity.dart';

import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';

/// Concrete implementation of NewsRepository.
/// Fetches data from remote datasource.
/// Converts models to entities for domain layer.

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDatasource _datasource;

  const NewsRepositoryImpl(this._datasource);

  @override
  Future<List<int>> getTopStoryIds() async {
    return await _datasource.getTopStoryIds();
  }

  @override
  Future<List<int>> getNewStoryIds() async {
    return await _datasource.getNewStoryIds();
  }

  @override
  Future<List<int>> getBestStoryIds() async {
    return await _datasource.getBestStoryIds();
  }

  @override
  Future<StoryEntity> getStory(int id) async {
    final model = await _datasource.getStory(id);
    return model.toEntity();
  }

  @override
  Future<List<StoryEntity>> getStories(List<int> ids) async {
    final futures = ids.map((id) => _datasource.getStory(id));
    final models = await Future.wait(futures);
    return models.map((model) => model.toEntity()).toList();
  }
}
