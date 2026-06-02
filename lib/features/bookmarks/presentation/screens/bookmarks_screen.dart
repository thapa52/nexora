import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/story_card.dart';
import '../providers/bookmark_notifier.dart';

/// Displays all bookmarked stories.
/// Shows empty state when no bookmarks exist
class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksState = ref.watch(bookmarkNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: bookmarksState.when(
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return _buildEmptyState(context);
          }
          return _buildBookmarkList(context, ref, bookmarks);
        },
        error: (error, _) => _buildError(context, ref, error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildBookmarkList(
    BuildContext context,
    WidgetRef ref,
    List bookmarks,
  ) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8, bottom: 24),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final story = bookmarks[index];
        return Dismissible(
          key: ValueKey(story.id),
          direction: DismissDirection.endToStart,
          background: _buildDismissBackground(),
          onDismissed: (_) {
            ref
                .read(bookmarkNotifierProvider.notifier)
                .removeBookmark(story.id);
            context.showSnackBar('Bookmark removed');
          },
          child: StoryCard(
            story: story,
            onTap: () {
              // story detail will add later
            },
          ),
        );
      },
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 24),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: 24,
              color: context.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Bookmarks Yet',
              style: AppTextStyles.headlineMedium.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stories you bookmark will appear here',
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load bookmarks',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(bookmarkNotifierProvider);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
