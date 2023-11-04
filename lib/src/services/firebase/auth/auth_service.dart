import 'models/user_auth_model.dart';

abstract class AuthService {
  /// Should login user if [email] and [password] it's correct
  ///
  /// Will throws:
  ///   * [WrongPasswordException] with code 'wrong-password'
  ///   * [InvalidEmailException] with code 'invalid-email'
  ///   * [UserNotFoundException] with code 'user-not-found'
  ///   * [UserDisabledException] with code 'user-disabled'
  ///   * [AuthException] with code 'empty-user' when login is successful but receive null
  ///   * [AuthException] with exception code
  Future<UserAuthModel> login(String email, String password);

  /// Should logout
  Future<void> logout();

  /// Should get the current user.
  ///
  /// Will throws:
  ///   * [LoggedOutException] with code 'logged-out' when user is logged out.
  Future<UserAuthModel> getCurrentUser();
}
