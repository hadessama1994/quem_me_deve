import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quemdeve_app/models/itemModel.dart';
import 'package:scoped_model/scoped_model.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();

  String user;

  Add({this.user});
}

class _AddState extends State<Add> {
  final format = DateFormat("dd-MM-yyyy");
  String _valueCode = "";
  String _personCode = "";
  String url;
  int _valueRadio = 0;
  bool _isLend = true;

  File _imageFile;
  final picker = ImagePicker();

  TextEditingController _valueController = TextEditingController();
  TextEditingController _personController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  bool _handleErrors() {
    if (double.tryParse(_valueController.text) != null &&
        _personController.text != "") {
      return false;
    } else {
      if (double.tryParse(_valueController.text) == null) {
        setState(() {
          _valueCode = "Digite um número válido";
        });
      }
      if (_personController.text == "") {
        setState(() {
          _personCode = "Digite um nome valido";
        });
      }
    }
  }

  void _handleRadio(value) {
    if (value == 0) {
      _isLend = true;
    } else {
      _isLend = false;
    }

    setState(() {
      _valueRadio = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ItemModel>(
      model: ItemModel(),
      child: ScopedModelDescendant<ItemModel>(builder: (context, child, model) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff5cf64a),
              title: Text(
                "Adicionar",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    icon: Icon(Icons.check, color: Colors.black),
                    onPressed: () {
                      String action;

                      Map<String, dynamic> cardData = {
                        'valor': _valueController.text,
                        'pessoa': _personController.text,
                        'desc': _descController.text,
                        'date': _dateController.text,
                        'Timestamp': FieldValue.serverTimestamp(),
                        'isLend': _isLend
                      };
                      if (_valueRadio == 0) {
                        action = "emprestei";
                      } else {
                        action = "pegueiEmprestado";
                      }

                      if (_handleErrors() == false) {
                        model.insertItems(
                          cardData: cardData,
                          action: action,
                          onSuccess: onSuccess,
                          onFailure: onFailure,
                          imageFile: _imageFile,
                        );
                        Navigator.pop(context);
                      }
                    })
              ],
              iconTheme: IconThemeData(color: Colors.black),
            ),
            body: SingleChildScrollView(
              child: Container(
                  child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    TextField(
                      controller: _valueController,
                      decoration: InputDecoration(
                        hintText: "ex 0.00",
                        hintStyle:
                            TextStyle(fontSize: 30, color: Colors.black12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        _valueCode,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.red[600]),
                      ),
                    ),
                    Column(
                      children: [
                        TextField(
                          controller: _personController,
                          decoration: InputDecoration(
                            hintText: "Nome da dívida / devedor",
                            prefixIcon: Icon(Icons.person_add),
                            hintStyle:
                                TextStyle(fontSize: 16, color: Colors.black12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            _personCode,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.red[600]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: _descController,
                            decoration: InputDecoration(
                              hintText: "Descrição",
                              prefixIcon: Icon(Icons.description),
                              hintStyle: TextStyle(
                                  fontSize: 16, color: Colors.black12),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: DateTimeField(
                            controller: _dateController,
                            format: format,
                            decoration: InputDecoration(
                              hintText: "Data do pagamento",
                              prefixIcon: Icon(Icons.calendar_today),
                              hintStyle: TextStyle(
                                  fontSize: 16, color: Colors.black12),
                            ),
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: IconButton(
                              onPressed: () async {
                                final pickedFile = await picker.getImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  _imageFile = File(pickedFile.path);
                                });
                              },
                              icon: Icon(
                                Icons.add_a_photo,
                                size: 46,
                              )),
                        ),
                        ListTile(
                            title: Text("Emprestei"),
                            leading: Radio(
                              value: 0,
                              groupValue: _valueRadio,
                              onChanged: (value) {
                                _handleRadio(value);
                              },
                            )),
                        ListTile(
                            title: Text("Peguei Emprestado"),
                            leading: Radio(
                              value: 1,
                              groupValue: _valueRadio,
                              onChanged: (value) {
                                _handleRadio(value);
                              },
                            )),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                              width: 150,
                              height: 150,
                              child: (_imageFile != null)
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _imageFile = null;
                                        });
                                      },
                                      child: Image.file(
                                        _imageFile,
                                      ))
                                  : Text("")),
                        ),
                      ],
                    )
                  ],
                ),
              )),
            ));
      }),
    );
  }

  void onSuccess() {
  }

  void onFailure() {}
}
