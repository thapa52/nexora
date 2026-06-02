import 'package:flutter_test/flutter_test.dart';
import 'package:nexora/features/bookmarks/domain/usecases/add_bookmark_usecase.dart';
import 'package:nexora/features/bookmarks/domain/usecases/get_all_bookmarks_usecase.dart';
import 'package:nexora/features/bookmarks/domain/usecases/is_bookmarked_usecase.dart';
import 'package:nexora/features/bookmarks/domain/usecases/remove_bookmark_usecase.dart';
import 'package:nexora/features/news/domain/entities/story_entity.dart';
import '../../../../mock/fake_bookmark_repository.dart';

void main() {
  late FakeBookmarkRepository fakeRepository;
  late AddBookmarkUseCase addBookmarkUseCase;
  late RemoveBookmarkUseCase removeBookmarkUseCase;
  late GetAllBookmarksUseCase getAllBookmarksUseCase;
  late IsBookmarkedUseCase isBookmarkedUseCase;

  /// Helper to create a test story
  StoryEntity createTestStory(int id) {
    return StoryEntity(
      id: id,
      title: 'Story $id',
      author: 'author_$id',
      score: id * 10,
      time: 1700000000 + id,
      commentCount: id * 5,
      url: 'https://example.com/story/$id',
    );
  }

  setUp(() {
    fakeRepository = FakeBookmarkRepository();
    addBookmarkUseCase = AddBookmarkUseCase(fakeRepository);
    removeBookmarkUseCase = RemoveBookmarkUseCase(fakeRepository);
    getAllBookmarksUseCase = GetAllBookmarksUseCase(fakeRepository);
    isBookmarkedUseCase = IsBookmarkedUseCase(fakeRepository);
  });

  group('AddBookmarkUseCase', () {
    test('adds a story to bookmarks', () async {
      final story = createTestStory(1);
      await addBookmarkUseCase(story);

      final isBookmarked = await isBookmarkedUseCase(1);
      expect(isBookmarked, true);
    });

    test('does not duplicate if already bookmarked', () async {
      final story = createTestStory(1);
      await addBookmarkUseCase(story);
      await addBookmarkUseCase(story);

      final bookmarks = await getAllBookmarksUseCase();
      expect(bookmarks.length, 1);
    });
  });

  group('RemoveBookmarkUseCase', () {
    test('removes a bookmarked story', () async {
      final story = createTestStory(1);
      await addBookmarkUseCase(story);
      await removeBookmarkUseCase(1);

      final isBookmarked = await isBookmarkedUseCase(1);
      expect(isBookmarked, false);
    });

    test('does nothing if story is not bookmarked', () async {
      await removeBookmarkUseCase(999);

      final bookmarks = await getAllBookmarksUseCase();
      expect(bookmarks, isEmpty);
    });
  });

  group('GetAllBookmarksUseCase', () {
    test('returns empty list when no bookmarks', () async {
      final bookmarks = await getAllBookmarksUseCase();
      expect(bookmarks, isEmpty);
    });

    test('returns all bookmarked stories', () async {
      await addBookmarkUseCase(createTestStory(1));
      await addBookmarkUseCase(createTestStory(2));
      await addBookmarkUseCase(createTestStory(3));

      final bookmarks = await getAllBookmarksUseCase();
      expect(bookmarks.length, 3);
    });

    test('returns correct stories after removal', () async {
      await addBookmarkUseCase(createTestStory(1));
      await addBookmarkUseCase(createTestStory(2));
      await removeBookmarkUseCase(1);

      final bookmarks = await getAllBookmarksUseCase();
      expect(bookmarks.length, 1);
      expect(bookmarks.first.id, 2);
    });
  });

  group('IsBookmarkedUseCase', () {
    test('returns true for bookmarked story', () async {
      await addBookmarkUseCase(createTestStory(1));

      final result = await isBookmarkedUseCase(1);
      expect(result, true);
    });

    test('returns false for non-bookmarked story', () async {
      final result = await isBookmarkedUseCase(999);
      expect(result, false);
    });

    test('returns false after bookmark is removed', () async {
      await addBookmarkUseCase(createTestStory(1));
      await removeBookmarkUseCase(1);

      final result = await isBookmarkedUseCase(1);
      expect(result, false);
    });
  });
}
