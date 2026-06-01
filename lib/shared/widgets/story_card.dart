import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/context_extentions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../features/bookmarks/presentation/providers/bookmark_notifier.dart';
import '../../features/news/domain/entities/story_entity.dart';

/// A single story card displayed in the news feed.
/// Shows title, metadata, and bookmark button.
class StoryCard extends ConsumerWidget {
  final StoryEntity story;
  final VoidCallback? onTap;

  const StoryCard({super.key, required this.story, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(isStoryBookmarkedProvider(story.id));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colorScheme.outline.withOpacity(0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Top Row (Domain + Bookmark) ─────
            _buildTopRow(context, ref, isBookmarked),
            const SizedBox(height: 8),

            // ─── Title ───────────────────────────
            _buildTitle(context),
            const SizedBox(height: 12),

            // ─── Metadata Row ────────────────────
            _buildMetadata(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<bool> isBookmarked,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Domain tag
        if (story.hasUrl)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              story.domain,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          )
        else
          const SizedBox.shrink(),

        // Bookmark button
        GestureDetector(
          onTap: () {
            ref.read(bookmarkNotifierProvider.notifier).toggleBookmark(story);
          },
          child: isBookmarked.when(
            data:
                (bookmarked) => Icon(
                  bookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color:
                      bookmarked
                          ? AppColors.primary
                          : context.colorScheme.onSurface.withOpacity(0.4),
                  size: 24,
                ),
            loading:
                () => const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            error:
                (_, __) => Icon(
                  Icons.bookmark_border_rounded,
                  color: context.colorScheme.onSurface.withOpacity(0.4),
                  size: 24,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      story.title,
      style: AppTextStyles.headlineSmall.copyWith(
        color: context.colorScheme.onSurface,
        height: 1.3,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetadata(BuildContext context) {
    final metadataStyle = AppTextStyles.bodySmall.copyWith(
      color: context.colorScheme.onSurface.withOpacity(0.5),
    );

    return Row(
      children: [
        // Score
        Icon(Icons.arrow_upward_rounded, size: 14, color: AppColors.accent),
        const SizedBox(width: 4),
        Text('${story.score}', style: metadataStyle),
        const SizedBox(width: 16),

        // Author
        Icon(
          Icons.person_outline_rounded,
          size: 14,
          color: context.colorScheme.onSurface.withOpacity(0.4),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            story.author,
            style: metadataStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 16),

        // Time
        Icon(
          Icons.access_time_rounded,
          size: 14,
          color: context.colorScheme.onSurface.withOpacity(0.4),
        ),
        const SizedBox(width: 4),
        Text(DateFormatter.timeAgo(story.time), style: metadataStyle),
        const SizedBox(width: 16),

        // Comments
        Icon(
          Icons.chat_bubble_outline_rounded,
          size: 14,
          color: context.colorScheme.onSurface.withOpacity(0.4),
        ),
        const SizedBox(width: 4),
        Text('${story.commentCount}', style: metadataStyle),
      ],
    );
  }
}
