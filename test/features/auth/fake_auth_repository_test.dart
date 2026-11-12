import 'package:bitebox_app/features/auth/data/fake_auth_repository.dart';
import 'package:bitebox_app/features/auth/domain/auth_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sign up then sign in round-trip', () async {
    final auth = FakeAuthRepository();

    final created = await auth.signUp(
      email: 'Demo@BiteBox.dev',
      password: 'secret1',
    );
    expect(created.email, 'demo@bitebox.dev');
    expect(auth.currentUser?.email, 'demo@bitebox.dev');

    await auth.signOut();
    expect(auth.currentUser, isNull);

    final signedIn = await auth.signIn(
      email: 'demo@bitebox.dev',
      password: 'secret1',
    );
    expect(signedIn.email, 'demo@bitebox.dev');
  });

  test('rejects invalid credentials and duplicates', () async {
    final auth = FakeAuthRepository();

    await expectLater(
      auth.signIn(email: 'a@b.com', password: 'secret1'),
      throwsA(isA<AuthException>()),
    );

    await auth.signUp(email: 'a@b.com', password: 'secret1');
    await expectLater(
      auth.signUp(email: 'a@b.com', password: 'secret1'),
      throwsA(
        isA<AuthException>().having(
          (error) => error.message,
          'message',
          'This email is already registered.',
        ),
      ),
    );
  });

  test('validates email and password', () async {
    final auth = FakeAuthRepository();

    await expectLater(
      auth.signUp(email: 'bad', password: 'secret1'),
      throwsA(isA<AuthException>()),
    );
    await expectLater(
      auth.signUp(email: 'ok@bitebox.dev', password: '123'),
      throwsA(isA<AuthException>()),
    );
  });
}
