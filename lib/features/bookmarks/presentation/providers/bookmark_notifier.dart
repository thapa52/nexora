import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../news/domain/entities/story_entity.dart';
import 'bookmark_providers.dart';

part 'bookmark_notifier.g.dart';

/// Manages bookmark state.
/// Handles add, remove, and loading all bookmarks.
@riverpod
class BookmarkNotifier extends _$BookmarkNotifier {
  @override
  FutureOr<List<StoryEntity>> build() async {
    return _loadBookmarks();
  }

  Future<List<StoryEntity>> _loadBookmarks() async {
    final getAllBookmarks = ref.read(getAllBookmarksUseCaseProvider);
    return await getAllBookmarks();
  }

  /// Add a story to bookmarks
  Future<void> addBookmark(StoryEntity story) async {
    final addBookmarkUseCase = ref.read(addBookmarkUseCaseProvider);
    await addBookmarkUseCase(story);

    // Refresh bookmarks list
    state = AsyncData(await _loadBookmarks());
  }

  /// Remove a story from bookmarks
  Future<void> removeBookmark(int storyId) async {
    final removeBookmarkUseCase = ref.read(removeBookmarkUseCaseProvider);
    await removeBookmarkUseCase(storyId);

    // Refresh bookmarks list
    state = AsyncData(await _loadBookmarks());
  }

  /// Toggle bookmark — add if not bookmarked, remove if bookmarked
  Future<void> toggleBookmark(StoryEntity story) async {
    final isBookmarked = ref.read(isBookmarkedUseCaseProvider);
    final alreadyBookmarked = await isBookmarked(story.id);

    if (alreadyBookmarked) {
      await removeBookmark(story.id);
    } else {
      await addBookmark(story);
    }
  }
}

/// Checks if a specific story is bookmarked.
/// Used by individual story cards to show bookmark icon state.
@riverpod
Future<bool> isStoryBookmarked(Ref ref, int storyId) async {
  // Watch bookmark notifier to rebuild when bookmarks change
  ref.watch(bookmarkNotifierProvider);

  final isBookmarked = ref.read(isBookmarkedUseCaseProvider);
  return await isBookmarked(storyId);
}
