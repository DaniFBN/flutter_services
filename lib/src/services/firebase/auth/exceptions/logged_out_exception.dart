import 'auth_exception.dart';

class LoggedOutException extends AuthException {
  LoggedOutException(
    super.message, {
    super.stackTrace,
    super.innerException,
    super.innerStacktrace,
  }) : super(code: 'logged-out');
}
