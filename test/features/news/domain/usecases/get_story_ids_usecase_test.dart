import 'package:flutter_test/flutter_test.dart';
import 'package:nexora/features/news/domain/entities/story_category.dart';
import 'package:nexora/features/news/domain/usecases/get_story_ids_usecase.dart';

import '../../../../mock/fake_news_repository.dart';

void main() {
  late FakeNewsRepository fakeRepository;
  late GetStoryIdsUseCase getStoryIdsUseCase;

  setUp(() {
    fakeRepository = FakeNewsRepository();
    getStoryIdsUseCase = GetStoryIdsUseCase(fakeRepository);
  });

  group('GetStoryIdsUseCase', () {
    test('returns top story IDs for top category', () async {
      final result = await getStoryIdsUseCase(StoryCategory.top);

      expect(result, [1, 2, 3, 4, 5]);
    });

    test('returns new story IDs for latest category', () async {
      final result = await getStoryIdsUseCase(StoryCategory.latest);

      expect(result, [6, 7, 8, 9, 10]);
    });

    test('returns best story IDs for best category', () async {
      final result = await getStoryIdsUseCase(StoryCategory.best);

      expect(result, [11, 12, 13, 14, 15]);
    });

    test('returns non-empty list', () async {
      final result = await getStoryIdsUseCase(StoryCategory.top);

      expect(result, isNotEmpty);
    });

    test('returns list of integer', () async {
      final result = await getStoryIdsUseCase(StoryCategory.top);

      expect(result, isA<List<int>>());
    });
  });
}
