import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quemdeve_app/auth/auth.dart';
import 'package:quemdeve_app/models/itemModel.dart';
import 'package:quemdeve_app/views/logo.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sign_button/sign_button.dart';

import 'add.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
      return ScopedModel<ItemModel>(
        model: ItemModel(),
        child: ScopedModelDescendant<ItemModel>(
        builder: (context, child, model) {
          return FutureBuilder(
              future: model.checkLogged(),
              builder: (context, snapshot) {
                if (model.isLogged == false) {
                  return Container(
                      child: Column(
                        children: [
                          Logo(),
                          Container(
                            child: Column(
                              children: [
                                SignInButton(
                                    buttonType: ButtonType.google,
                                    buttonSize: ButtonSize.large,
                                    onPressed: () {
                                      signInWithGoogle();
                                    }),
                                SignInButton(
                                    buttonType: ButtonType.facebook,
                                    buttonSize: ButtonSize.large,
                                    onPressed: () {

                                    }),
                                SignInButton(
                                    buttonType: ButtonType.twitter,
                                    buttonSize: ButtonSize.large,
                                    onPressed: () {
                                      print('click');
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ));
                }

                else {
                  return Container(
                      child: Column(
                        children: [
                          Logo(),
                          Container(
                            child: Column(
                              children: [
                                RaisedButton(onPressed: () {
                                  model.logOut();
                                })
                              ],
                            ),
                          ),
                        ],
                      ));
                }
              }
          );
        }
        ),
      );

  }
}
