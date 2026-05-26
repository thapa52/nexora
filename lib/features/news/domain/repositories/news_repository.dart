import '../entities/story_entity.dart';

/// Abstract repository interface for news operations.
/// Defines what the news feature can do.
/// Data layer provides the actual implementation.
abstract class NewsRepository {
  /// Fetch top story IDs from Hacker News
  /// Returns list of story IDs
  Future<List<int>> getTopStoryIds();

  /// Fetch new story IDs from Hacker News
  /// Returns list of story IDs
  Future<List<int>> getNewStoryIds();

  /// Fetch best story IDs from Hacker News
  /// Returns list of story IDs
  Future<List<int>> getBestStoryIds();

  /// Fetch a single story by ID
  /// Returns full story details
  Future<StoryEntity> getStory(int id);

  /// Fetch multiple stories by IDs
  /// Used for pagination — fetch a page of stories at a time
  Future<List<StoryEntity>> getStories(List<int> ids);
}
