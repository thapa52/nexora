import 'package:flutter_test/flutter_test.dart';
import 'package:nexora/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:nexora/features/auth/domain/usecases/logout_usecase.dart';

import '../../../../mock/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository fakeRepository;
  late LogoutUseCase logoutUseCase;
  late GetCurrentUserUseCase getCurrentUserUseCase;

  setUp(() async {
    fakeRepository = FakeAuthRepository();
    logoutUseCase = LogoutUseCase(fakeRepository);
    getCurrentUserUseCase = GetCurrentUserUseCase(fakeRepository);

    // Register and login a user first
    await fakeRepository.register(
      name: 'Thapa',
      email: 'thapa@gmail.com',
      password: '123456',
    );
  });

  group('LogoutUseCase', () {
    test('clears auth state after logout', () async {
      // Verify user is logged in
      final beforeLogout = await getCurrentUserUseCase();
      expect(beforeLogout.isLoggedIn, true);

      // Logout
      await logoutUseCase();

      // Verify user is logout
      final afterLogout = await getCurrentUserUseCase();
      expect(afterLogout.isLoggedIn, false);
    });
  });
}
