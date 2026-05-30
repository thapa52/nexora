import 'package:flutter_test/flutter_test.dart';
import 'package:nexora/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns null for valid email', () {
      final result = Validators.email('thapa@gmail.com');
      expect(result, null);
    });

    test('returns null for email with dots', () {
      final result = Validators.email('thapa.test@gmail.com');
      expect(result, null);
    });

    test('returns null for email with plus', () {
      final result = Validators.email('thapa+test@gmail.com');
      expect(result, null);
    });

    test('returns error for empty email', () {
      final result = Validators.email('');
      expect(result, 'Email is required');
    });

    test('returns error for null email', () {
      final result = Validators.email(null);
      expect(result, 'Email is required');
    });

    test('returns error for email without @', () {
      final result = Validators.email('thapagmail.com');
      expect(result, 'Enter a valid email address');
    });

    test('returns error for email without domain', () {
      final result = Validators.email('thapa@');
      expect(result, 'Enter a valid email address');
    });

    test('returns error for email with spaces', () {
      final result = Validators.email('thapa @gmail.com');
      expect(result, 'Enter a valid email address');
    });
  });

  group('Validators.password', () {
    test('returns null for valid password', () {
      final result = Validators.password('123456');
      expect(result, null);
    });

    test('returns null for long password', () {
      final result = Validators.password('thisIsLongPassword5488');
      expect(result, null);
    });

    test('returns error for empty password', () {
      final result = Validators.password('');
      expect(result, 'Password is required');
    });

    test('returns error for null password', () {
      final result = Validators.password(null);
      expect(result, 'Password is required');
    });

    test('returns error for short password', () {
      final result = Validators.password('bca');
      expect(result, 'Password must be atleast 6 characters');
    });

    test('returns error for 5 chracter password', () {
      final result = Validators.password('12345');
      expect(result, 'Password must be atleast 6 characters');
    });
  });

  group('Validators.name', () {
    test('returns null for valid name', () {
      final result = Validators.name('Thapa');
      expect(result, null);
    });

    test('returns null for full name', () {
      final result = Validators.name('Thapa Test');
      expect(result, null);
    });

    test('returns error for empty name', () {
      final result = Validators.name('');
      expect(result, 'Name is required');
    });

    test('returns error for null name', () {
      final result = Validators.name(null);
      expect(result, 'Name is required');
    });

    test('returns error for single character name', () {
      final result = Validators.name('T');
      expect(result, 'Name must be atleast 2 characters');
    });
  });

  group('Validators.required', () {
    test('returns null for non-empty value', () {
      final result = Validators.required('hello');
      expect(result, null);
    });

    test('return error with default field name', () {
      final result = Validators.required('');
      expect(result, 'Field is required');
    });

    test('returns error with custom field name', () {
      final result = Validators.required('', fieldName: 'Username');
      expect(result, 'Username is required');
    });

    test('returns error for null value', () {
      final result = Validators.required(null);
      expect(result, 'Field is required');
    });
  });
}
