import 'package:flutter/material.dart';

Widget flatButton(
  Color buttonColor,
  IconData icon,
  String title,
  Color titleColor,
  Function onPressedEvent,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: buttonColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
    child: Row(
      children: [
        Icon(icon, color: titleColor, size: 26.0),
        SizedBox(width: 10.0),
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    onPressed: onPressedEvent,
  );
}
