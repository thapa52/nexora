import 'package:nexora/features/news/domain/entities/story_entity.dart';

import '../../domain/repositories/bookmark_repository.dart';
import '../datasources/bookmark_local_datasource.dart';
import '../models/bookmark_model.dart';

/// Concrete implementation of BookmarkRepository.
/// Converts between StoryEntity and Map for Hive storage.
class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDatasource _datasource;

  const BookmarkRepositoryImpl(this._datasource);
  @override
  Future<void> addBookmark(StoryEntity story) async {
    final map = BookmarkModel.toMap(story);
    await _datasource.addBookmark(map);
  }

  @override
  Future<void> removeBookmark(int storyId) async {
    await _datasource.removeBookmark(storyId);
  }

  @override
  Future<List<StoryEntity>> getAllBookmarks() async {
    final maps = await _datasource.getAllBookmarks();
    return maps.map((value) => BookmarkModel.fromMap(value)).toList();
  }

  @override
  Future<bool> isBookmarked(int storyId) async {
    return await _datasource.isBookmarked(storyId);
  }
}
