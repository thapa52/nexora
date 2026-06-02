import '../../../news/domain/entities/story_entity.dart';

/// Handles conversion between StoryEntity and Map.
/// Used for storing bookmarks in Hive.
class BookmarkModel {
  BookmarkModel._();

  /// Convert StoryEntity to Map (for Hive storage)
  static Map<String, dynamic> toMap(StoryEntity story) {
    return {
      'id': story.id,
      'title': story.title,
      'author': story.author,
      'score': story.score,
      'time': story.time,
      'commentCount': story.commentCount,
      'url': story.url,
    };
  }

  /// Convert Map to StoryEntity (from Hive storage)
  static StoryEntity fromMap(Map<String, dynamic> map) {
    return StoryEntity(
      id: map['id'] as int,
      title: map['title'] as String? ?? 'Untitled',
      author: map['author'] as String? ?? 'Unknown',
      score: map['score'] as int? ?? 0,
      time: map['time'] as int? ?? 0,
      commentCount: map['commentCount'] as int? ?? 0,
      url: map['url'] as String?,
    );
  }
}
