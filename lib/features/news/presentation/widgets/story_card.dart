import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/story_entity.dart';

/// A single story card displayed in the news feed.
/// Shows title, metadata (score, author, time, comments).
/// Tapping opens the story detail/URL.
class StoryCard extends StatelessWidget {
  final StoryEntity story;
  final VoidCallback? onTap;

  const StoryCard({super.key, required this.story, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Domain Tag
            if (story.hasUrl) _buildDomainTag(context),
            if (story.hasUrl) SizedBox(height: 8),

            // Title
            _buildTitle(context),
            SizedBox(height: 12),

            // Metadata Row
            _buildMetaData(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainTag(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        story.domain,
        style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
      ),
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

  Widget _buildMetaData(BuildContext context) {
    final metaDataStyle = AppTextStyles.bodySmall.copyWith(
      color: context.colorScheme.onSurface.withValues(alpha: 0.5),
    );

    return Row(
      children: [
        // Score
        Icon(Icons.arrow_upward_rounded, size: 14, color: AppColors.accent),
        const SizedBox(width: 4),
        Text('${story.score}', style: metaDataStyle),
        const SizedBox(width: 16),

        // Author
        Icon(
          Icons.person_outline_rounded,
          size: 14,
          color: context.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            story.author,
            style: metaDataStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 16),

        // Time
        Icon(
          Icons.access_time_rounded,
          size: 14,
          color: context.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        const SizedBox(width: 4),
        Text(DateFormatter.timeAgo(story.time), style: metaDataStyle),
        const SizedBox(width: 16),

        // Comments
        Icon(
          Icons.chat_bubble_outline_rounded,
          size: 14,
          color: context.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        const SizedBox(width: 4),
        Text('${story.commentCount}', style: metaDataStyle),
      ],
    );
  }
}
