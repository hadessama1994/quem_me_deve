import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemModel extends Model {
  String userUid;
  bool isLogged;
  User user;


  getUserUid() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.userUid = user.uid;


  }

  getUserInfo() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    this.user = user;
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

  void insertItems(
      {@required Map<String, dynamic> cardData,
      @required String action,
      @required Timestamp timestamp,
      @required VoidCallback onSuccess,
      @required VoidCallback onFailure,
      String docEdit,
      @required File imageFile}) async {
    String url;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    sendData() async {
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
        'isLend': cardData["isLend"]
      });
    }

    if (imageFile != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
      UploadTask uploadTask = ref.putFile(imageFile);
      uploadTask.whenComplete(() async {
        url = await ref.getDownloadURL();
        sendData();
      }).catchError((onError) {
        print(onError);
      });
    }
    else{ sendData();}
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

  void editItems(
      {@required Map<String, dynamic> cardData,
        @required String action,
        @required Timestamp timestamp,
        @required VoidCallback onSuccess,
        @required VoidCallback onFailure,
        String docEdit,
        @required File imageFile}) async {
    String url;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;

    sendData() async {
      print (cardData["isLend"]);
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
        'isLend': cardData["isLend"]
      });
    }

    if (imageFile != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
      storage.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
      UploadTask uploadTask = ref.putFile(imageFile);
      uploadTask.whenComplete(() async {
        url = await ref.getDownloadURL();
        sendData();
      }).catchError((onError) {
        print(onError);
      });
    }
    else{ sendData();}
    onSuccess();
    onFailure();
  }


}
