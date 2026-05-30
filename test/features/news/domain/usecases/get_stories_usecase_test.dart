import 'package:flutter_test/flutter_test.dart';
import 'package:nexora/features/news/domain/usecases/get_stories_usecase.dart';

import '../../../../mock/fake_news_repository.dart';

void main() {
  late FakeNewsRepository fakeRepository;
  late GetStoriesUseCase getStoriesUseCase;

  setUp(() {
    fakeRepository = FakeNewsRepository();
    getStoriesUseCase = GetStoriesUseCase(fakeRepository);
  });

  group('GetStoriesUseCase', () {
    test('return stories for given IDs', () async {
      final result = await getStoriesUseCase([1, 2, 3]);

      expect(result.length, 3);
      expect(result[0].id, 1);
      expect(result[1].id, 2);
      expect(result[2].id, 3);
    });

    test('returns empty list for empty IDs', () async {
      final result = await getStoriesUseCase([]);

      expect(result, isEmpty);
    });

    test('stories have valid URLs', () async {
      final result = await getStoriesUseCase([1, 2]);

      expect(result[0].hasUrl, true);
      expect(result[0].domain, 'example.com');
    });

    test('returns correct count for multiple stories', () async {
      final result = await getStoriesUseCase([1, 2, 3, 4, 5, 6]);

      expect(result.length, 6);
    });
  });
}
