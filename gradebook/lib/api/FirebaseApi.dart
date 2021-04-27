import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'FirebaseFile.dart';


class FirebaseApi{

  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
    Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());


  static UploadTask uploadFile(String destination, File file){
    try{
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e){
      return null;
    }
  }

  static bool deleteFile(String filename){
    try{
      final ref = FirebaseStorage
          .instance
          .ref(auth.currentUser.uid);
      ref.child(filename).delete().then((value) => print('Delete successful'));
      return true;
    } on FirebaseException catch (e){
      return false;
    }
  }

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);
    return  urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);
          return MapEntry(index, file);
        }).values.toList();
  }

}