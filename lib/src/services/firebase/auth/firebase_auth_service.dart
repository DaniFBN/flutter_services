import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';
import 'exceptions/_exceptions.dart';
import 'models/user_auth_model.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth;

  const FirebaseAuthService(this._auth);

  @override
  Future<UserAuthModel> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      throw LoggedOutException(
        "Wasn't possible get current user, because it's logged out",
      );
    }

    return _toModel(firebaseUser);
  }

  @override
  Future<UserAuthModel> login(String email, String password) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credentials.user;

      if (user == null) {
        throw AuthException(
          'Credentials received with an empty user',
          code: 'empty-user',
        );
      }

      return _toModel(user);
    } on FirebaseAuthException catch (exception, stackTrace) {
      throw switch (exception.code) {
        'invalid-email' => InvalidEmailException(
            exception.message ?? 'Invalid Email',
            innerException: exception,
            innerStacktrace: exception.stackTrace ?? stackTrace,
          ),
        'user-disabled' => UserDisabledException(
            exception.message ?? 'User with email $email was disabled',
            innerException: exception,
            innerStacktrace: exception.stackTrace ?? stackTrace,
          ),
        'wrong-password' => WrongPasswordException(
            exception.message ?? 'Wrong password',
            innerException: exception,
            innerStacktrace: exception.stackTrace ?? stackTrace,
          ),
        'user-not-found' => UserNotFoundException(
            exception.message ?? 'Not found an user with email $email',
            innerException: exception,
            innerStacktrace: exception.stackTrace ?? stackTrace,
          ),
        _ => AuthException(
            exception.message ?? 'Authentication Failure',
            code: exception.code,
            innerException: exception,
            innerStacktrace: exception.stackTrace ?? stackTrace,
          )
      };
    }
  }

  @override
  Future<void> logout() async {
    _auth.signOut();
  }

  UserAuthModel _toModel(User user) {
    return UserAuthModel(
      id: user.uid,
      email: user.email,
    );
  }
}
