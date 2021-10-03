import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget textField(
  String labelText,
  String hintText, {
  FocusNode focusNode,
  bool enabled,
  TextEditingController controller,
  List<TextInputFormatter> inputFormatters,
  void Function(String) onSubmittedEvent,
  void Function() onTapEvent,
  void Function(String) onChanged,
}) {
  return Expanded(
    child: TextField(
      obscureText: false,
      focusNode: focusNode,
      enabled: enabled,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 20),
        labelText: labelText,
        hintText: hintText,
        alignLabelWithHint: true,
      ),
      inputFormatters: inputFormatters,
      onSubmitted: onSubmittedEvent,
      onTap: onTapEvent,
      onChanged: onChanged,
    ),
  );
}
