import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference user = FirebaseFirestore.instance.collection('user');
  CollectionReference booking =
      FirebaseFirestore.instance.collection('bookings');
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await user.doc(id).set(values);
  }

  Future<void> createNewBookingData(Map<String, dynamic> values) async {
    String id = values['bookingID'];
    await booking.doc(id).set(values);
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

  static Future<DocumentSnapshot> getUserById(String id) async {
    var result =
        await FirebaseFirestore.instance.collection('user').doc(id).get();

    return result;
  }

  Future<String> getAndSetCurrentBookingID() async {
    var result = await booking.doc("current_booking_id").get();

    String oldBmsID = result['BMS_ID'];
    int bmsIDNumber = int.parse(oldBmsID.substring(6)) + 1;
    String newBmsID = "BMS_ID$bmsIDNumber";
    Map<String, dynamic> values = {"BMS_ID": newBmsID};
    await booking.doc("current_booking_id").set(values);

    return newBmsID;
  }

  Future<DocumentSnapshot> getbookingsById(String id) async {
    var result = await booking.doc(id).get();

    return result;
  }
}
