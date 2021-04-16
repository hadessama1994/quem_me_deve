import 'package:flutter/material.dart';
import 'cards.dart';

class LendMoney extends StatefulWidget {
  @override
  _LendMoneyState createState() => _LendMoneyState();
}

class _LendMoneyState extends State<LendMoney> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffeae6e5),
      child: SafeArea(
          child: Container(
        child: Column(
          children: [
            Flexible(child: Cards(isMain: false, isLend: true,)),
          ],
        ),
      )),
    );
  }
}
