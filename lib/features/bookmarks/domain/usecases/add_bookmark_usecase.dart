import '../../../news/domain/entities/story_entity.dart';
import '../repositories/bookmark_repository.dart';

/// Saves a story to bookmarks.
/// Checks if already bookmarked to prevent duplicates.
class AddBookmarkUseCase {
  final BookmarkRepository _repository;

  const AddBookmarkUseCase(this._repository);

  Future<void> call(StoryEntity story) async {
    final isAlreadyBookmarked = await _repository.isBookmarked(story.id);
    if (isAlreadyBookmarked) return;

    await _repository.addBookmark(story);
  }
}
