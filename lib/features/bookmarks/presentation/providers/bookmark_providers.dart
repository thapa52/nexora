import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/bookmark_local_datasource.dart';
import '../../data/repositories/bookmark_repository_impl.dart';
import '../../domain/repositories/bookmark_repository.dart';
import '../../domain/usecases/add_bookmark_usecase.dart';
import '../../domain/usecases/get_all_bookmarks_usecase.dart';
import '../../domain/usecases/is_bookmarked_usecase.dart';
import '../../domain/usecases/remove_bookmark_usecase.dart';

part 'bookmark_providers.g.dart';

/// Data Layer Providers

@riverpod
BookmarkLocalDatasource bookmarkLocalDatasource(Ref ref) {
  return BookmarkLocalDataSourceImpl();
}

@riverpod
BookmarkRepository bookmarkRepository(Ref ref) {
  final datasource = ref.watch(bookmarkLocalDatasourceProvider);
  return BookmarkRepositoryImpl(datasource);
}

/// Domain Layer (Use Cases) Providers

@riverpod
AddBookmarkUseCase addBookmarkUseCase(Ref ref) {
  final repository = ref.watch(bookmarkRepositoryProvider);
  return AddBookmarkUseCase(repository);
}

@riverpod
RemoveBookmarkUseCase removeBookmarkUseCase(Ref ref) {
  final repository = ref.watch(bookmarkRepositoryProvider);
  return RemoveBookmarkUseCase(repository);
}

@riverpod
GetAllBookmarksUseCase getAllBookmarksUseCase(Ref ref) {
  final repository = ref.watch(bookmarkRepositoryProvider);
  return GetAllBookmarksUseCase(repository);
}

@riverpod
IsBookmarkedUseCase isBookmarkedUseCase(Ref ref) {
  final repository = ref.watch(bookmarkRepositoryProvider);
  return IsBookmarkedUseCase(repository);
}
