import 'package:flutter/material.dart';

Widget customFloatingActionButton(
    bool isSmallFAB, String buttonText, Function() onClick()) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 200),
    curve: Curves.linear,
    width: isSmallFAB ? 50 : 150,
    height: 50,
    child: FloatingActionButton.extended(
      onPressed: onClick(),
      icon: isSmallFAB
          ? Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(Icons.send),
            )
          : Icon(Icons.send),
      label: isSmallFAB
          ? SizedBox()
          : Text(
              buttonText,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
    ),
  );
}
