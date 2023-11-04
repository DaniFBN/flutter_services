import 'auth_exception.dart';

class WrongPasswordException extends AuthException {
  WrongPasswordException(
    super.message, {
    super.stackTrace,
    super.innerException,
    super.innerStacktrace,
  }) : super(code: 'wrong-password');
}
