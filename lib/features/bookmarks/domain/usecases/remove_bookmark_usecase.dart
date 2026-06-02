import '../repositories/bookmark_repository.dart';

/// Removes a story from bookmarks by its ID.
class RemoveBookmarkUseCase {
  final BookmarkRepository _repository;

  const RemoveBookmarkUseCase(this._repository);

  Future<void> call(int storyId) async {
    return _repository.removeBookmark(storyId);
  }
}
