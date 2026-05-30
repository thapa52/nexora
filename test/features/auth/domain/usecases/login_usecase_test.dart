import 'package:flutter_test/flutter_test.dart';
import 'package:nexora/features/auth/domain/usecases/login_usecase.dart';

import '../../../../mock/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository fakeRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    fakeRepository = FakeAuthRepository();
    loginUseCase = LoginUseCase(fakeRepository);

    // Register a test user before login tests
    fakeRepository.register(
      name: 'Thapa',
      email: 'thapa@gmail.com',
      password: '123456',
    );
  });

  group('LoginUseCase', () {
    test('returns UserEntity on successful login', () async {
      final result = await loginUseCase(
        email: 'thapa@gmail.com',
        password: '123456',
      );

      expect(result.displayName, 'Thapa');
      expect(result.displayEmail, 'thapa@gmail.com');
      expect(result.isLoggedIn, true);
    });

    test('throws exception for wrong password', () async {
      expect(
        () => loginUseCase(email: 'thapa@gmail.com', password: 'wrongPassword'),
        throwsA(isA<Exception>()),
      );
    });

    test('throws exception for ungestered email', () async {
      expect(
        () => loginUseCase(email: 'random@gmail.com', password: '123456'),
        throwsA(isA<Exception>()),
      );
    });

    test('throws exception for empty email', () async {
      expect(
        () => loginUseCase(email: '', password: '123456'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws exception for empty password', () async {
      expect(
        () => loginUseCase(email: 'thapa@gmail.com', password: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
