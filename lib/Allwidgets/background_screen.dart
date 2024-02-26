import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(children: [
    Positioned(
        left: 0,
        top: 0,
        child: Image.asset(
          "assets/images/rectangle3.png",
          width: 180,
        )),
    Positioned(
      right: MediaQuery.of(context).size.width / 8,
      top: MediaQuery.of(context).size.height / 2.5,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color(0xFFE8EBFF)),
      ),
    ),
    Positioned(
        right: 0,
        bottom: 0,
        child: Image.asset(
          "assets/images/rectangle2.png",
          width: 180,
        )),
  ]);
}
