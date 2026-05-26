import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../domain/entities/story_category.dart';
import '../providers/news_feed_notifier.dart';
import '../providers/news_providers.dart';
import '../widgets/story_card.dart';

/// Main news feed screen.
/// Shows stories from Hacker News with category tabs.
/// Supports infinite scroll and pull to refresh.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Detect when user scrolls near the bottom
  void _onScroll() {
    if (_isNearBottom) {
      ref.read(newsFeedNotifierProvider.notifier).loadMore();
    }
  }

  bool get _isNearBottom {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    // Load more when 200px from bottom
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    final newsFeedState = ref.watch(newsFeedNotifierProvider);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Category Tabs
          _buildCategoryTabs(),

          // Story List
          Expanded(
            child: newsFeedState.when(
              data: (feedState) => _buildStoryList(feedState),
              error: (error, _) => _buildError(error.toString()),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Nexora',
        style: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            ref.read(authNotifierProvider.notifier).logout();
          },
          icon: Icon(Icons.logout_rounded),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children:
            StoryCategory.values.map((category) {
              final isSelected = category == selectedCategory;

              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category.label),
                  onSelected: (_) {
                    ref
                        .read(selectedCategoryProvider.notifier)
                        .change(category);
                  },
                  labelStyle: AppTextStyles.labelLarge.copyWith(
                    color:
                        isSelected
                            ? AppColors.primary
                            : context.colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            ),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  selectedColor: AppColors.primary.withValues(alpha: 0.1),
                  checkmarkColor: AppColors.primary,
                  side: BorderSide(
                    color:
                        isSelected
                            ? AppColors.primary.withValues(alpha: 0.3)
                            : context.colorScheme.onSurface.withValues(
                              alpha: 0.15,
                            ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildStoryList(NewsFeedState feedState) {
    if (feedState.stories.isEmpty) {
      return const Center(child: Text('No stories found'));
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.read(newsFeedNotifierProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: feedState.stories.length + 1,
        itemBuilder: (context, index) {
          // Last item — loading indicator or end message
          if (index == feedState.stories.length) {
            return _buildBottomLoader(feedState);
          }

          final story = feedState.stories[index];
          return StoryCard(
            story: story,
            onTap: () {
              // Story detail navigation — will add later
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomLoader(NewsFeedState feedState) {
    if (feedState.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (feedState.hasReachedEnd) {
      return Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'You\'ve reached the end',
          style: AppTextStyles.bodySmall.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    return SizedBox(height: 24);
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Something went wrong', style: AppTextStyles.headlineMedium),
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
                ref.read(newsFeedNotifierProvider.notifier).refresh();
              },
              icon: Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
