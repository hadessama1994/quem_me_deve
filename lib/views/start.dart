import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'cards.dart';
import 'logo.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';



class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffeae6e5),
        child: Column(
          children: [
            Logo(),
            Expanded(
              child: Container(
                color: Color(0xffeae6e5),
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                 child:
                  Container(
                  child: ContainedTabBarView(
                    tabs: [
                      Text('Emprestei'),
                      Text('Dívidas')
                    ],
                    views: [
                     Cards(isMain: true, isLend: true,),
                     Cards(isMain: true, isLend: false,),
                    ],
                    onChange: (index) => print(index),
                  ),
                ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
