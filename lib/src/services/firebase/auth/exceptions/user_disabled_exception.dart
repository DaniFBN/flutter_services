import 'auth_exception.dart';

class UserDisabledException extends AuthException {
  UserDisabledException(
    super.message, {
    super.stackTrace,
    super.innerException,
    super.innerStacktrace,
  }) : super(code: 'user-disabled');
}
