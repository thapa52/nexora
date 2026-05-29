import 'package:flutter_test/flutter_test.dart';
import 'package:nexora/features/auth/domain/usecases/register_usecase.dart';

import '../../../../mock/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository fakeRepository;
  late RegisterUseCase registerUseCase;

  setUp(() {
    fakeRepository = FakeAuthRepository();
    registerUseCase = RegisterUseCase(fakeRepository);
  });

  group('RegisterUseCase', () {
    test('returns UserEntity on a successful registration', () async {
      final result = await registerUseCase(
        name: 'Thapa',
        email: 'thapa@gmail.com',
        password: '123456',
      );

      expect(result.displayName, 'Thapa');
      expect(result.displayEmail, 'thapa@gmail.com');
      expect(result.isLoggedIn, true);
    });

    test('throws exception for duplicate email', () async {
      // Register first time
      await registerUseCase(
        name: 'Thapa',
        email: 'thapa@gmail.com',
        password: '123456',
      );

      // Try registering again with same email
      expect(
        () => registerUseCase(
          name: 'Random',
          email: 'thapa@gmail.com',
          password: '654321',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('throws exception for empty name', () async {
      expect(
        () => registerUseCase(
          name: '',
          email: 'thapa@gmail.com',
          password: '123456',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws exception for empty email', () async {
      expect(
        () => registerUseCase(name: 'Thapa', email: '', password: '123456'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws exception for short password', () async {
      expect(
        () => registerUseCase(
          name: 'Thapa',
          email: 'thapa@gmail.com',
          password: '123',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
