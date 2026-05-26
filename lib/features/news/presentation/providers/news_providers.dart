import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/news_remote_datasource.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/entities/story_category.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/get_stories_usecase.dart';
import '../../domain/usecases/get_story_ids_usecase.dart';

part 'news_providers.g.dart';

/// Data Layer Providers

@riverpod
NewsRemoteDatasource newsRemoteDatasource(Ref ref) {
  return NewsRemoteDatasourceImpl();
}

@riverpod
NewsRepository newsRepository(Ref ref) {
  final datasource = ref.watch(newsRemoteDatasourceProvider);
  return NewsRepositoryImpl(datasource);
}

/// Domain Layer (Use Cases) Providers
@riverpod
GetStoryIdsUseCase getStoryIdsUseCase(Ref ref) {
  final repository = ref.watch(newsRepositoryProvider);
  return GetStoryIdsUseCase(repository);
}

@riverpod
GetStoriesUseCase getStoriesUseCase(Ref ref) {
  final repository = ref.watch(newsRepositoryProvider);
  return GetStoriesUseCase(repository);
}

/// UI State Providers

/// Tracks the currently selected story category
/// UI rebuilds when category changes
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  StoryCategory build() {
    return StoryCategory.top;
  }

  void change(StoryCategory category) {
    state = category;
  }
}
