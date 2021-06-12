import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

class CRUDFirebase {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  create(String age, String name, String phone, String image) async {
    try {
      await firestore.collection('Userdata').doc('profile').set({
        'age' : age,
        'name' : name,
        'phone': phone,
        'image' : image
      });
    } catch (e){
      print(e);
    }
  }

  update(String age, String name, String phone) async {
    try {
      await firestore.collection('Userdata').doc('profile').update({
        'age' : age,
        'name' : name,
        'phone': phone
      });
    } catch (e){
      print(e);
    }
  }

  read()  {
    try{
      return  firestore.collection('Userdata').doc('profile').snapshots();
    } catch (e) {
      print(e);
    }
  }

  delete() async {
    try{
      await firestore.collection('Userdata').doc('profile').update({
        'age' : '',
        'image': '',
        'name' : '',
        'phone': ''
      });
    } catch (e) {
      print(e);
    }
  }

  deleteimage(String deleteimage) async {
    FirebaseStorage.instance.ref().child(deleteimage).delete();
  }

  uploadimage(File imagefile, String deleteimage) async {
    String filename = basename(imagefile.path);
    FirebaseStorage.instance.ref().child(deleteimage).delete();
    Reference ref = FirebaseStorage.instance.ref().child(filename);
    UploadTask task = ref.putFile(imagefile);
    TaskSnapshot snapshot = await task.whenComplete(() => firestore.collection('Userdata').doc('profile').update({'image' : filename}));
  }

  Future getImage(image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}