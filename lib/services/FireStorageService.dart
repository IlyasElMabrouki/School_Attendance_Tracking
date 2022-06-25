import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }

  static UploadTask? uploadFile(String destination, File file, String path){
    try{
      final ref = FirebaseStorage.instance.ref().child(path);
      return ref.putFile(file);
    }
    on FirebaseException catch(e){
      return null;
    }
  }
}

