import '../repositories/bookmark_repository.dart';

/// Checks if a specific story is bookmarked.
/// Used by story cards to show bookmark icon state.
class IsBookmarkedUseCase {
  final BookmarkRepository _repository;

  const IsBookmarkedUseCase(this._repository);

  Future<bool> call(int storyId) async {
    return _repository.isBookmarked(storyId);
  }
}
