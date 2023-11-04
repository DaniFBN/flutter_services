import 'package:dio/dio.dart';

typedef RequestContentLengthMethod = int? Function(RequestOptions options);

typedef ResponseContentLengthMethod = int? Function(Response options);
