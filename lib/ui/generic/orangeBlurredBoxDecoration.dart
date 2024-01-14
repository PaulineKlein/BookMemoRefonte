import 'package:flutter/material.dart';

import '../bookMemo_theme.dart';

BoxDecoration orangeBlurredBoxDecoration(Color? background) {
  return BoxDecoration(
    color: background,
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    boxShadow: [
      BoxShadow(
        offset: const Offset(5.0, 5.0),
        blurRadius: 1.0,
        spreadRadius: 1.0,
        color: colorPrimary,
      ),
    ],
    border: Border.all(
      color: Colors.black,
    ),
  );
}
