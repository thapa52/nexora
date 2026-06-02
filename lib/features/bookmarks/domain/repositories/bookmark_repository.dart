import '../../../news/domain/entities/story_entity.dart';

/// Abstract repository interface for bookmark operations.
/// Uses StoryEntity from news feature — no need to create a separate entity.
/// Bookmarks are just saved stories.
abstract class BookmarkRepository {
  /// Save a story to bookmarks
  Future<void> addBookmark(StoryEntity story);

  /// Remove a story from bookmarks
  Future<void> removeBookmark(int storyId);

  /// Get all bookmarked stories
  Future<List<StoryEntity>> getAllBookmarks();

  /// Check if a story is bookmarked
  Future<bool> isBookmarked(int storyId);
}
