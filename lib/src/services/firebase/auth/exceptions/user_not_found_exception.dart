import 'auth_exception.dart';

class UserNotFoundException extends AuthException {
  UserNotFoundException(
    super.message, {
    super.stackTrace,
    super.innerException,
    super.innerStacktrace,
  }) : super(code: 'user-not-found');
}
