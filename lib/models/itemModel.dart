import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemModel extends Model {
  String userUid;
  bool isLogged;

  getUserUid() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.userUid = user.uid;
  }

  checkLogged() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    if (user == null) {
      isLogged = false;
      notifyListeners();
    } else {
      isLogged = true;
      notifyListeners();
    }
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    isLogged = false;
    notifyListeners();
  }

  void insertItems (
      {@required Map<String, dynamic> cardData,
      @required String action,
      @required Timestamp timestamp,
      @required VoidCallback onSuccess,
      @required VoidCallback onFailure, String docEdit, @required File imageFile})  async {

    String url;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    if (imageFile != null) {
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imageFile);
      TaskSnapshot taskSnapshot;
       url = await taskSnapshot.ref.getDownloadURL();
    }

   await FirebaseFirestore.instance
        .collection("main")
        .doc(user.uid)
        .collection("cards")
        .doc(docEdit)
        .set({
      'valor': cardData["valor"],
      'pessoa': cardData["pessoa"],
      'desc': cardData["desc"],
      'date': cardData["date"],
      'imgUrl': url,
      'Timestamp': cardData["Timestamp"],
      'isLend' : cardData["isLend"]
    });

    onSuccess();
    onFailure();
  }

  void deleteItems(String docID) async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    FirebaseFirestore.instance
        .collection("main")
        .doc(user.uid)
        .collection("cards")
        .doc(docID)
        .delete();
  }

  void listItems() {}
}
