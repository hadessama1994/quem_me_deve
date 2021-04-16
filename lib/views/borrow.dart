import 'package:flutter/material.dart';
import 'cards.dart';

class BorrowMoney extends StatefulWidget {
  @override
  _BorrowMoneyState createState() => _BorrowMoneyState();
}

class _BorrowMoneyState extends State<BorrowMoney> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffeae6e5),
      child: SafeArea(
          child: Container(
        child: Column(
          children: [
            Flexible(child: Cards(isMain: false, isLend: false,)),
          ],
        ),
      )),
    );
  }
}
