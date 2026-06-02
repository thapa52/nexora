import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/errors/exceptions.dart';

/// Handles all Hive operations for bookmarks.
/// Stores stories as Maps in a Hive box.
/// Only the repository calls this — never UI or domain.
abstract class BookmarkLocalDatasource {
  /// Save a story map to bookmarks
  Future<void> addBookmark(Map<String, dynamic> storyMap);

  /// Remove a bookmark by story ID
  Future<void> removeBookmark(int storyId);

  /// Get all bookmarked story maps
  Future<List<Map<String, dynamic>>> getAllBookmarks();

  /// Check if a story is bookmarked
  Future<bool> isBookmarked(int storyId);
}

class BookmarkLocalDataSourceImpl implements BookmarkLocalDatasource {
  static const String _boxName = 'bookmarks';

  /// Get or open the bookmarks box
  Future<Box> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }

    return await Hive.openBox(_boxName);
  }

  @override
  Future<void> addBookmark(Map<String, dynamic> storyMap) async {
    try {
      final box = await _getBox();
      final storyId = storyMap['id'] as int;
      await box.put(storyId.toString(), storyMap);
    } catch (e) {
      throw const CacheException(message: 'Failed to save bookmark.');
    }
  }

  @override
  Future<void> removeBookmark(int storyId) async {
    try {
      final box = await _getBox();
      await box.delete(storyId.toString());
    } catch (e) {
      throw const CacheException(message: 'Failed to remove bookmark.');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllBookmarks() async {
    try {
      final box = await _getBox();
      return box.values
          .map((value) => Map<String, dynamic>.from(value as Map))
          .toList();
    } catch (e) {
      throw const CacheException(message: 'Failed to load bookmarks.');
    }
  }

  @override
  Future<bool> isBookmarked(int storyId) async {
    try {
      final box = await _getBox();
      return box.containsKey(storyId.toString());
    } catch (e) {
      throw const CacheException(message: 'Failed to check bokkmark status.');
    }
  }
}
