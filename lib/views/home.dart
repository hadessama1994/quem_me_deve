import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quemdeve_app/views/lend.dart';
import 'package:quemdeve_app/views/start.dart';
import 'add.dart';
import 'borrow.dart';
import 'cards.dart';
import 'loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final FirebaseAuth auth = FirebaseAuth.instance;

  // void inputData() async {
  //   final FirebaseUser user = await auth.currentUser();
  //   final uid = user.displayName;
  //   print (uid);
  //   // here you write the codes to input the data into firestore
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      StartPage(),
      LendMoney(),
      StartPage(),
      BorrowMoney(),
      LoginPage(),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
          duration: Duration(milliseconds: 200), child: pages[_currentIndex]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xffff37a6),
        onPressed: () async {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User user = auth.currentUser;

          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Add()),
            );
          } else {
           setState(() {
             _currentIndex = 4;
           });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: "Início",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Emprestei",
            icon: Icon(Icons.monetization_on),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(
              Icons.add,
              size: 26,
            ),
          ),
          BottomNavigationBarItem(
            label: "Dívidaas",
            icon: Icon(Icons.payments),
          ),
          BottomNavigationBarItem(
            label: "Conta",
            icon: Icon(Icons.person),
          ),
        ],
        selectedItemColor: Color(0xffff37a6),
      ),
    );
  }
}
