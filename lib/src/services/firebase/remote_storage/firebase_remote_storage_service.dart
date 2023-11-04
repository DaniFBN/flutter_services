import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'remote_storage_service.dart';

class FirebaseRemoteStorageService implements RemoteStorageService {
  const FirebaseRemoteStorageService(this._firebaseStorage);

  final FirebaseStorage _firebaseStorage;

  @override
  Future<String> upload({
    required Uint8List bytes,
    required String fileName,
    String? filePath,
  }) async {
    final storageReference = _firebaseStorage.ref(filePath).child(fileName);
    final downloadUrl = await storageReference.putData(bytes);

    final url = await downloadUrl.ref.getDownloadURL();

    return url;
  }

  @override
  Future<void> deleteFromUrl(String url) async {
    if (url.isEmpty) return;

    await _firebaseStorage.refFromURL(url).delete();
  }
}
