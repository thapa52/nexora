import '../entities/story_category.dart';
import '../repositories/news_repository.dart';

/// Fetches story IDs based on selected category.
/// Returns a list of integer IDs.
/// These IDs are then used to fetch actual story details.
class GetStoryIdsUseCase {
  final NewsRepository _repository;

  const GetStoryIdsUseCase(this._repository);

  Future<List<int>> call(StoryCategory category) async {
    switch (category) {
      case StoryCategory.top:
        return await _repository.getTopStoryIds();
      case StoryCategory.latest:
        return await _repository.getNewStoryIds();
      case StoryCategory.best:
        return await _repository.getBestStoryIds();
    }
  }
}
