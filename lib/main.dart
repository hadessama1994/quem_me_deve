import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quemdeve_app/models/itemModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'views/home.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ScopedModel<ItemModel>(
    model: ItemModel(),
    child: MaterialApp(
      home: Home(),
      theme: ThemeData(
        primaryColor: Color(0xff5cf64a),
        accentColor: Color(0xffff37a6),

      ),
    ),
  ));



}
