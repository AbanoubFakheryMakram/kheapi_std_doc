import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
  TRUE  >>  OPERATION DONE
  FALSE >>  OPERATION FAILED
 */

class FirebaseUtils {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;

  static Future<bool> uploadDoctorProfileImageToFirebaseStorage(
    StorageReference storage,
    File imageFile,
  ) async {
    storage.putFile(imageFile);
    return true;
  }

  static Future<String> downloadImageURL(StorageReference storage) async {
    return await storage.getDownloadURL();
  }

  // method to save data in a collection
  static saveData({
    @required Map<String, dynamic> dataInMap,
    @required String ssn,
  }) async {
    try {
      await _firestore.collection('Studients').document(ssn).setData(dataInMap);
      print('>>>>>>>>>>>>>>>>> data saved');
    } catch (e) {
      print('>>>>>>>>>>>>>>>>> data not saved ${e.toString()}');
    }
  }

  // method to save data in a collection
  static Future<bool> updateData({
    @required Map<String, dynamic> dataInMap,
    @required String ssn,
  }) async {
    try {
      await _firestore
          .collection('human doctors')
          .document(ssn)
          .updateData(dataInMap);
      return true;
    } catch (e) {
      return false;
    }
  }

  // method to check if ssn is exist or not
  static Future<DocumentSnapshot> getCurrentUserData({
    @required String username,
  }) async {
    try {
      var querySnapshot =
          await _firestore.collection('Students').document(username).get();

      return querySnapshot;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> doesUsernameExist({@required String username}) async {
    bool exist = false;
    QuerySnapshot qs = await _firestore.collection('Students').getDocuments();
    qs.documents.forEach(
      (DocumentSnapshot snap) {
        if (snap.documentID == username) {
          exist = true;
        }
      },
    );

    return exist;
  }

  static Future<bool> doesPhoneExist({@required String phone}) async {
    bool exist = false;
    QuerySnapshot qs = await _firestore.collection('Students').getDocuments();
    qs.documents.forEach(
      (DocumentSnapshot snap) {
        if (snap.data['phone'] == phone) {
          exist = true;
        }
      },
    );

    return exist;
  }

  // method to loged out
  static void logout() async {
    await _auth.signOut();
    print('logged out');
  }

  // method to delete user account
  static Future<bool> deleteAccount() async {
    try {
      FirebaseUser user = await _auth.currentUser();
      user.delete();
      print('successfully deleted user account');
      return true;
    } catch (error) {
      print('can not delete this account');
      return false;
    }
  }

  // method to get last sign in time
  static Future<DateTime> getLastSignInTime() async {
    FirebaseUser user = await _auth.currentUser();
    return user.metadata.lastSignInTime;
  }

  // method to get current user
  static Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  // get all data in a specefic collection
  static Future<List<DocumentSnapshot>> getAllData({
    @required String collectionName,
  }) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionName).getDocuments();
      return querySnapshot.documents;
    } catch (error) {
      print('>>>>>> ${error.toString()}');
      return []; // in case of an error return an empty list
    }
  }

  // get all data in a specefic collection
  static Future<List<DocumentSnapshot>> getAllDataOrderByAField({
    @required String collectionName,
    @required String field,
    bool des = false,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .orderBy(field, descending: des)
          .getDocuments();
      return querySnapshot.documents;
    } catch (error) {
      print('>>>>>> ${error.toString()}');
      return []; // in case of an error return an empty list
    }
  }
}
