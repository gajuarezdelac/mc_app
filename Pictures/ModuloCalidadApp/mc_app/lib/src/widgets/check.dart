import 'package:flutter/material.dart';

Widget check(
  String title,
  bool value, {
  void Function(bool) onChangedCheck,
}) {
  return Row(
    children: <Widget>[
      Checkbox(
        activeColor: Color(0xFF001D85),
        value: value,
        onChanged: onChangedCheck,
      ),
      Text(title, style: TextStyle(fontSize: 17.0)),
    ],
  );
}
