import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

import '../../extensions/_extensions.dart';
import 'helpers/response_http_metric.dart';
import 'helpers/typedefs.dart';

class DioFirebasePerformanceInterceptor extends Interceptor {
  DioFirebasePerformanceInterceptor({
    this.requestContentLengthMethod = defaultRequestContentLength,
    this.responseContentLengthMethod = defaultResponseContentLength,
  }) : _map = {};

  final RequestContentLengthMethod requestContentLengthMethod;
  final ResponseContentLengthMethod responseContentLengthMethod;

  /// key: requestKey hash code, value: ongoing metric
  final Map<int, HttpMetric> _map;

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final metric = FirebasePerformance.instance.newHttpMetric(
        options.uri.normalized(),
        options.method.asHttpMethod()!,
      )..putAttribute('path', options.uri.path);

      final requestKey = options.extra.hashCode;
      _map[requestKey] = metric;

      final requestContentLength = requestContentLengthMethod(options);
      await metric.start();

      if (requestContentLength != null) {
        metric.requestPayloadSize = requestContentLength;
      }
    } catch (exception, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: exception.toString());
    }
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    try {
      final requestKey = response.requestOptions.extra.hashCode;
      final metric = _map[requestKey];

      metric?.setResponse(response, responseContentLengthMethod);

      await metric?.stop();

      _map.remove(requestKey);
    } catch (exception, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: exception.toString());
    }
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      final requestKey = err.requestOptions.extra.hashCode;
      final metric = _map[requestKey];

      metric?.setResponse(err.response, responseContentLengthMethod);

      await metric?.stop();
      _map.remove(requestKey);
    } catch (exception, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: exception.toString());
    }
    return super.onError(err, handler);
  }
}

int? defaultRequestContentLength(RequestOptions options) {
  try {
    final data = options.data;
    final headers = options.headers;

    if (data is String || data is Map) {
      return headers.toString().length + (data.toString().length);
    }
  } catch (_) {
    return null;
  }
  return null;
}

int? defaultResponseContentLength(Response response) {
  final data = response.data;
  final headers = response.headers;

  if (data is String) {
    return headers.toString().length + data.length;
  } else {
    return null;
  }
}
