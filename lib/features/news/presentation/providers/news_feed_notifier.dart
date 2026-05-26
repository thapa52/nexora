import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/story_entity.dart';
import 'news_providers.dart';

part 'news_feed_notifier.g.dart';

/// State class to hold news feed data
/// Tracks stories, pagination, loading, and errors
class NewsFeedState {
  final List<StoryEntity> stories;
  final List<int> allIds;
  final int currentPage;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final String? error;

  const NewsFeedState({
    this.stories = const [],
    this.allIds = const [],
    this.currentPage = 0,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.error,
  });

  /// Create a copy with updated fields
  NewsFeedState copyWith({
    List<StoryEntity>? stories,
    List<int>? allIds,
    int? currentPage,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    String? error,
  }) {
    return NewsFeedState(
      stories: stories ?? this.stories,
      allIds: allIds ?? this.allIds,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: error,
    );
  }
}

/// Manages the news feed state
/// Handles initial load, pagination, and refresh
@riverpod
class NewsFeedNotifier extends _$NewsFeedNotifier {
  @override
  FutureOr<NewsFeedState> build() async {
    // Watch selected category — rebuild when it changes
    final category = ref.watch(selectedCategoryProvider);

    // Fetch story IDs for selected category
    final getStoryIds = ref.watch(getStoryIdsUseCaseProvider);
    final allIds = await getStoryIds(category);

    // Fetch first page of stories
    final getStories = ref.read(getStoriesUseCaseProvider);
    final firstPageIds = allIds.take(AppConstants.pageSize).toList();
    final stories = await getStories(firstPageIds);

    return NewsFeedState(
      stories: stories,
      allIds: allIds,
      currentPage: 1,
      hasReachedEnd: firstPageIds.length >= allIds.length,
    );
  }

  /// Load next page of stories (infinite scroll)
  Future<void> loadMore() async {
    // Get current state
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    // Don't load if already loading or reached end
    if (currentState.isLoadingMore || currentState.hasReachedEnd) return;

    // Set loading state
    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    try {
      final getStories = ref.read(getStoriesUseCaseProvider);

      // Calculate next page IDs
      final startIndex = currentState.currentPage * AppConstants.pageSize;
      final endIndex = startIndex + AppConstants.pageSize;
      final nextPageIds =
          currentState.allIds
              .skip(startIndex)
              .take(AppConstants.pageSize)
              .toList();

      // No more stories to load
      if (nextPageIds.isEmpty) {
        state = AsyncData(
          currentState.copyWith(isLoadingMore: false, hasReachedEnd: true),
        );
        return;
      }

      // Fetch next page stories
      final newStories = await getStories(nextPageIds);

      state = AsyncData(
        currentState.copyWith(
          stories: [...currentState.stories, ...newStories],
          currentPage: currentState.currentPage + 1,
          isLoadingMore: false,
          hasReachedEnd: endIndex >= currentState.allIds.length,
        ),
      );
    } catch (e) {
      state = AsyncData(
        currentState.copyWith(isLoadingMore: false, error: e.toString()),
      );
    }
  }

  /// Refresh — reload everything from scratch
  Future<void> refresh() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
  }
}
