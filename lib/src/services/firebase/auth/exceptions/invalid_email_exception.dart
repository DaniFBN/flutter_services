import 'auth_exception.dart';

class InvalidEmailException extends AuthException {
  InvalidEmailException(
    super.message, {
    super.stackTrace,
    super.innerException,
    super.innerStacktrace,
  }) : super(code: 'invalid-email');
}
