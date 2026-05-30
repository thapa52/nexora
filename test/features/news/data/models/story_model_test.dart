import 'package:flutter_test/flutter_test.dart';
import 'package:nexora/features/news/data/models/story_model.dart';

void main() {
  group('StoryModel.fromJson', () {
    test('creates model from complete JSON', () {
      final json = {
        'id': 12345,
        'title': 'Flutter is awesome',
        'by': 'Thapa',
        'score': 150,
        'time': 1700000000,
        'descendants': 45,
        'url': 'https://github.com/thapa52',
      };

      final model = StoryModel.fromJson(json);

      expect(model.id, 12345);
      expect(model.title, 'Flutter is awesome');
      expect(model.author, 'Thapa');
      expect(model.score, 150);
      expect(model.time, 1700000000);
      expect(model.commentCount, 45);
      expect(model.url, 'https://github.com/thapa52');
    });

    test('handles missing title with default', () {
      final json = {
        'id': 12345,
        'by': 'Thapa',
        'score': 150,
        'time': 1700000000,
        'descendants': 45,
      };

      final model = StoryModel.fromJson(json);

      expect(model.title, 'Untitled');
    });

    test('handles missing adults with default', () {
      final json = {
        'id': 12345,
        'title': 'Flutter is awesome',
        'score': 150,
        'time': 1700000000,
        'descendants': 45,
      };

      final model = StoryModel.fromJson(json);

      expect(model.author, 'Unknown');
    });

    test('handles missing score with default zero', () {
      final json = {
        'id': 12345,
        'title': 'Flutter is awesome',
        'by': 'Thapa',
        'time': 1700000000,
        'descendants': 45,
      };

      final model = StoryModel.fromJson(json);

      expect(model.score, 0);
    });

    test('handles missing descendants with default zero', () {
      final json = {
        'id': 12345,
        'title': 'Flutter is awesome',
        'by': 'Thapa',
        'score': 150,
        'time': 1700000000,
      };

      final model = StoryModel.fromJson(json);

      expect(model.commentCount, 0);
    });

    test('handles missing url as null', () {
      final json = {
        'id': 12345,
        'title': 'Flutter is awesome',
        'by': 'Thapa',
        'score': 150,
        'time': 1700000000,
        'descendants': 45,
      };

      final model = StoryModel.fromJson(json);

      expect(model.url, null);
    });

    test('handles null value with defaults', () {
      final json = {
        'id': 12345,
        'title': null,
        'by': null,
        'score': null,
        'time': null,
        'descendants': null,
        'url': null,
      };

      final model = StoryModel.fromJson(json);

      expect(model.title, 'Untitled');
      expect(model.author, 'Unknown');
      expect(model.score, 0);
      expect(model.time, 0);
      expect(model.commentCount, 0);
      expect(model.url, null);
    });
  });

  group('StoryMode.toEntity', () {
    test('converts models to entity correctly', () {
      final model = StoryModel(
        id: 12345,
        title: 'Flutter is awesome',
        author: 'Thapa',
        score: 150,
        time: 1700000000,
        commentCount: 45,
        url: 'https://github.com/thapa52',
      );

      final entity = model.toEntity();

      expect(entity.id, 12345);
      expect(entity.title, 'Flutter is awesome');
      expect(entity.author, 'Thapa');
      expect(entity.score, 150);
      expect(entity.time, 1700000000);
      expect(entity.commentCount, 45);
      expect(entity.url, 'https://github.com/thapa52');
    });

    test('converts model without url to entity', () {
      final model = StoryModel(
        id: 12345,
        title: 'Flutter is awesome',
        author: 'Thapa',
        score: 150,
        time: 1700000000,
        commentCount: 45,
      );

      final entity = model.toEntity();

      expect(entity.url, null);
      expect(entity.hasUrl, false);
    });

    test('entity domain getter works after conversion', () {
      final model = StoryModel(
        id: 12345,
        title: 'Flutter is awesome',
        author: 'Thapa',
        score: 150,
        time: 1700000000,
        commentCount: 45,
        url: 'https://github.com/thapa52',
      );

      final entity = model.toEntity();

      expect(entity.hasUrl, true);
      expect(entity.domain, 'github.com');
    });
  });
}
