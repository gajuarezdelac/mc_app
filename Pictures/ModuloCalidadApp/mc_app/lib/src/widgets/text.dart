import 'package:flutter/material.dart';

Widget text(String text, isBold) {
  return Expanded(
    child: Text(
      text,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : null,
        fontSize: 20.0,
      ),
    ),
  );
}
