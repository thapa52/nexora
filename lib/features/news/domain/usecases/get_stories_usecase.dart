import '../entities/story_entity.dart';
import '../repositories/news_repository.dart';

/// Fetches story details for a list of IDs.
/// Used for pagination — fetch one page of stories at a time.
///
/// Flow:
///   1. GetStoryIdsUseCase returns [101, 102, ..., 500]
///   2. Take first 20 IDs → pass to this use case
///   3. This returns 20 StoryEntity objects
///   4. User scrolls → take next 20 IDs → repeat
class GetStoriesUseCase {
  final NewsRepository _repository;

  const GetStoriesUseCase(this._repository);

  Future<List<StoryEntity>> call(List<int> ids) async {
    if (ids.isEmpty) return [];
    return await _repository.getStories(ids);
  }
}
