import 'package:flutter/foundation.dart';

abstract interface class RemoteStorageService {
  /// Should upload a file
  ///
  /// Params:
  ///   * [bytes] represents the file
  ///   * [fileName] should be name and extension, like, 'whatever.png'
  ///   * [filePath] can be used if you need specify storage folder for file
  ///
  /// Response:
  ///   * The [String] response represents the access url from uploaded file
  Future<String> upload({
    required Uint8List bytes,
    required String fileName,
    String? filePath,
  });

  /// Should delete a file from your access url
  Future<void> deleteFromUrl(String url);
}
