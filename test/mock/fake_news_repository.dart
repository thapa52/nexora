import 'package:nexora/features/news/domain/entities/story_entity.dart';
import 'package:nexora/features/news/domain/repositories/news_repository.dart';

/// Fake implementation of NewsRepository for testing.
/// Returns predefined data without making real API calls.
class FakeNewsRepository implements NewsRepository {
  @override
  Future<List<int>> getTopStoryIds() async {
    return [1, 2, 3, 4, 5];
  }

  @override
  Future<List<int>> getNewStoryIds() async {
    return [6, 7, 8, 9, 10];
  }

  @override
  Future<List<int>> getBestStoryIds() async {
    return [11, 12, 13, 14, 15];
  }

  @override
  Future<StoryEntity> getStory(int id) async {
    return StoryEntity(
      id: id,
      title: 'Story $id',
      author: 'author_$id',
      score: id * 10,
      time: 1700000000 + id,
      commentCount: id * 5,
      url: 'https://example.com/story/$id',
    );
  }

  @override
  Future<List<StoryEntity>> getStories(List<int> ids) async {
    return ids
        .map(
          (id) => StoryEntity(
            id: id,
            title: 'title_$id',
            author: 'author_$id',
            score: id * 10,
            time: 1700000000 + id,
            commentCount: id * 5,
            url: 'https://example.com/story/$id',
          ),
        )
        .toList();
  }
}
