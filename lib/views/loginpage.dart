import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quemdeve_app/auth/auth.dart';
import 'package:quemdeve_app/models/itemModel.dart';
import 'package:quemdeve_app/views/logo.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLogged = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ItemModel>(
      model: ItemModel(),
      child: ScopedModelDescendant<ItemModel>(builder: (context, child, model) {
        return FutureBuilder(
            future: model.checkLogged(),
            builder: (context, snapshot) {
              if (model.isLogged == false) {
                return Center(
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            SignInButton(
                                buttonType: ButtonType.google,
                                buttonSize: ButtonSize.large,
                                onPressed: () {
                                  _isLogged = true;
                                  signInWithGoogle();
                                }),
                            (_isLogged == false)
                                ? Text("")
                                : Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: CircularProgressIndicator(),
                                )
                          ],
                        ),
                      ),
                    ],
                  )),
                );
              } else {
                model.getUserInfo();
                return Center(
                  child: Container(
                      child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: (model.user.photoURL != null)
                                    ? NetworkImage(model.user.photoURL)
                                    : NetworkImage(
                                        "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-mulher-no-icone-redondo_24640-14047.jpg"),
                                radius: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Seja bem vindo, ${model.user.displayName}.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 26,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xffff37a6)),
                                  child: Text(
                                    "Sair",
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                  onPressed: () {
                                    model.logOut();
                                    _isLogged = false;
                                  })
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                );
              }
            });
      }),
    );
  }
}
