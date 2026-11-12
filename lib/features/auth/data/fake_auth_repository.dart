import 'package:bitebox_app/features/auth/domain/auth_exception.dart';
import 'package:bitebox_app/features/auth/domain/auth_repository.dart';
import 'package:bitebox_app/features/auth/domain/auth_user.dart';
import 'package:bitebox_app/features/auth/domain/auth_validators.dart';

/// In-memory auth for phase 4 demos. Replaced by Supabase in phase 5.
class FakeAuthRepository implements AuthRepository {
  final Map<String, String> _passwordByEmail = {};
  AuthUser? _currentUser;
  int _idSequence = 0;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    _assertCredentials(email, password);
    final normalized = email.trim().toLowerCase();
    final stored = _passwordByEmail[normalized];
    if (stored == null || stored != password) {
      throw const AuthException('Invalid email or password.');
    }
    _currentUser = AuthUser(id: 'local-$normalized', email: normalized);
    return _currentUser!;
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    _assertCredentials(email, password);
    final normalized = email.trim().toLowerCase();
    if (_passwordByEmail.containsKey(normalized)) {
      throw const AuthException('This email is already registered.');
    }
    _idSequence += 1;
    _passwordByEmail[normalized] = password;
    _currentUser = AuthUser(id: 'local-$_idSequence', email: normalized);
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  void _assertCredentials(String email, String password) {
    final emailError = AuthValidators.emailErrorEn(email);
    if (emailError != null) throw AuthException(emailError);
    final passwordError = AuthValidators.passwordErrorEn(password);
    if (passwordError != null) throw AuthException(passwordError);
  }
}
