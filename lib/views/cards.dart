import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quemdeve_app/models/itemModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'edit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Cards extends StatefulWidget {
  @override
  _CardsState createState() => _CardsState();

  final bool isMain, isLend;

  Cards({this.isMain, this.isLend});
}

class _CardsState extends State<Cards> {
  int _itemLength(List<DocumentSnapshot> doc) {
    if (widget.isMain == true) {
      switch (doc.length) {
        case 0:
          return 0;
        case 1:
          return 1;
        case 2:
          return 2;
        default:
          return 3;
      }
    } else if (doc.length == 0) {
      return 0;
    } else {
      return doc.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ItemModel>(
      model: ItemModel(),
      child: ScopedModelDescendant<ItemModel>(builder: (context, child, model) {
        return FutureBuilder(
            future: model.getUserUid(),
            builder: (context, snapshot) {
              print(model.userUid);
              return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("main")
                      .doc(model.userUid)
                      .collection("cards")
                      .orderBy('Timestamp')
                      .where('isLend', isEqualTo: widget.isLend)
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        List<DocumentSnapshot> documents =
                            snapshot.data.docs.reversed.toList();
                        if (_itemLength(documents) == 0) {
                          return Container(
                            child: Center(
                                child: Column(
                              children: [
                                Text(
                                  "Sem itens a serem exibidos",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 36, color: Colors.black26),
                                ),
                                Text(
                                  "Ou você não está logado...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 36, color: Colors.black26),
                                ),
                              ],
                            )),
                          );
                        }
                        return ListView.builder(
                          itemCount: _itemLength(documents),
                          //(isMain == false) ? documents.length : 3,
                          itemBuilder: (context, index) {
                            final item = documents[index].id;
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.40,
                              direction: Axis.horizontal,
                              actions: <Widget>[
                                IconSlideAction(
                                  onTap: () {
                                    model.deleteItems(documents[index].id);
                                  },
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                ),
                              ],
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Card(
                                  elevation: 1,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Edit(
                                            value: documents[index]
                                                .data()['valor'],
                                            date:
                                                documents[index].data()['date'],
                                            desc:
                                                documents[index].data()['desc'],
                                            photo: documents[index]
                                                .data()['imgUrl'],
                                            name: documents[index]
                                                .data()['pessoa'],
                                            docID: documents[index].id,
                                            timestamp: documents[index]
                                                .data()['Timestamp'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Card(
                                                color: Color(0xff87e752),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.schedule,
                                                        size: 16,
                                                      ),
                                                      Text(documents[index]
                                                          .data()['date']),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: (documents[
                                                                          index]
                                                                      .data()[
                                                                  'imgUrl'] !=
                                                              null)
                                                          ? NetworkImage(
                                                              documents[index]
                                                                      .data()[
                                                                  'imgUrl'],
                                                            )
                                                          : NetworkImage(
                                                              "https://image.freepik.com/vetores-gratis/perfil-de-avatar-de-mulher-no-icone-redondo_24640-14047.jpg"),
                                                      radius: 30,
                                                    ),
                                                    Card(
                                                        color: Colors.grey[200],
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          child: Text(
                                                            documents[index]
                                                                    .data()[
                                                                'pessoa'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 1),
                                                  child: Text(
                                                    documents[index]
                                                        .data()['desc'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(r"Valor: "),
                                                    Text(
                                                      r"R$ " +
                                                          documents[index]
                                                              .data()['valor'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                    }
                  });
            });
      }),
    );
  }
}
