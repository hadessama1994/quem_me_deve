import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        color: Color(0xff5cf64a),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Column(
                      children: [
                        RotationTransition(
                          turns: AlwaysStoppedAnimation(-16/360),
                          child: Text(
                            "QUEM",
                            style: TextStyle(
                              fontSize: 46,
                              fontFamily: 'Raleway',
                              color: Color(0xff12130f),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text("ME",
                          style: TextStyle(
                            fontSize: 46,
                            fontFamily: 'Raleway',
                            color: Color(0xff12130f),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text("DEVE",
                          style: TextStyle(
                            fontSize: 46,
                            fontFamily: 'Raleway',
                            color: Color(0xff12130f),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 45, bottom: 32),
                      child: Image.asset(
                        "images/money.png",
                        height: 250,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
