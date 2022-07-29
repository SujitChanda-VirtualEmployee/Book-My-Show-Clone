
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  CollectionReference user = FirebaseFirestore.instance.collection('user');
  CollectionReference boys = FirebaseFirestore.instance.collection('boys');
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await user.doc(id).set(values);
  }

  Future<void> updateToken(Map<String, dynamic> values) async {
    String id = values['id'];
    await user.doc(id).update(values);
  }

  //update user data

  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await user.doc(id).update(values);
  }

  //get user data by User id

  Future<DocumentSnapshot> getUserById(String id) async {
    var result = await user.doc(id).get();

    return result;
  }





}
