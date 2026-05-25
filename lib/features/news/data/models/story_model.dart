import '../../domain/entities/story_entity.dart';

/// Data layer representation of a Hacker News story.
/// Knows how to convert from JSON (API response).
/// Converts to StoryEntity for domain layer.
class StoryModel {
  final int id;
  final String title;
  final String author;
  final int score;
  final int time;
  final int commentCount;
  final String? url;

  const StoryModel({
    required this.id,
    required this.title,
    required this.author,
    required this.score,
    required this.time,
    required this.commentCount,
    this.url,
  });

  /// Convert from JSON (API response)
  /// Handles missing or null fields safely
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Untitled',
      author: json['by'] as String? ?? 'Unknown',
      score: json['score'] as int? ?? 0,
      time: json['time'] as int? ?? 0,
      commentCount: json['descendants'] as int? ?? 0,
      url: json['url'] as String?,
    );
  }

  /// Convert to domain entity
  StoryEntity toEntity() {
    return StoryEntity(
      id: id,
      title: title,
      author: author,
      score: score,
      time: time,
      commentCount: commentCount,
      url: url,
    );
  }
}
