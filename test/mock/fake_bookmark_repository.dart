import 'package:nexora/features/bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:nexora/features/news/domain/entities/story_entity.dart';

/// Fake implementation of BookmarkRepository for testing.
/// Stores bookmarks in memory without Hive.
class FakeBookmarkRepository implements BookmarkRepository {
  final Map<int, StoryEntity> _bookmarks = {};

  @override
  Future<void> addBookmark(StoryEntity story) async {
    _bookmarks[story.id] = story;
  }

  @override
  Future<void> removeBookmark(int storyId) async {
    _bookmarks.remove(storyId);
  }

  @override
  Future<List<StoryEntity>> getAllBookmarks() async {
    return _bookmarks.values.toList();
  }

  @override
  Future<bool> isBookmarked(int storyId) async {
    return _bookmarks.containsKey(storyId);
  }
}
