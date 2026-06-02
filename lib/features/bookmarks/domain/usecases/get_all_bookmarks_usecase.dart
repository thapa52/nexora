import '../../../news/domain/entities/story_entity.dart';
import '../repositories/bookmark_repository.dart';

/// Retrieves all bookmarked stories.
/// Returns empty list if no bookmarks exist.
class GetAllBookmarksUseCase {
  final BookmarkRepository _repository;

  const GetAllBookmarksUseCase(this._repository);

  Future<List<StoryEntity>> call() async {
    return _repository.getAllBookmarks();
  }
}
