import '../../../../core/exceptions/flutter_services_exception.dart';

class AuthException extends FlutterServicesException {
  AuthException(
    super.message, {
    required super.code,
    super.stackTrace,
    super.innerException,
    super.innerStacktrace,
  });
}
