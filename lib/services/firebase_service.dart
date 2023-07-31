import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadFile(String filePath) async {
    final String fileName = filePath.split('/').last;
    final File file = File(filePath);
    UploadTask uploadTask = _storage.ref(fileName).putFile(file);

    uploadTask.whenComplete(() async {
      print('File Uploaded');

      // Get the download URL of the uploaded file.
      // String downloadURL = await _storage.ref(fileName).getDownloadURL();

      // Store the download URL in Firestore.
      // _firestore.collection('files').add({
      //   'fileName': fileName,
      //   'url': downloadURL,
      // });
    }).catchError((onError) {
      print(onError);
    });
  }
}
