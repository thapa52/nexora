import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_entity.freezed.dart';

/// Story entity represents a single Hacker News story.
/// Pure Dart — no API or storage knowledge.
/// This is what the UI works with.
@freezed
sealed class StoryEntity with _$StoryEntity {
  const StoryEntity._();

  const factory StoryEntity({
    required int id,
    required String title,
    required String author,
    required int score,
    required int time,
    required int commentCount,
    String? url,
  }) = _StoryEntity;

  /// Check if story has an external URL
  bool get hasUrl => url != null && url!.isNotEmpty;

  /// Get domain from URL for display
  /// "https://www.example.com/article" → "example.com"
  String get domain {
    if (!hasUrl) return '';
    try {
      final uri = Uri.parse(url!);
      String host = uri.host;
      if (host.startsWith('www.')) {
        host = host.substring(4);
      }
      return host;
    } catch (_) {
      return '';
    }
  }
}
