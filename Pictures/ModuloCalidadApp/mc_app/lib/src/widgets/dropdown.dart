import 'package:flutter/material.dart';

Widget dropDown(
  String inputDecoratio,
  String hint, {
  dynamic value,
  Widget icon,
  List<DropdownMenuItem<dynamic>> items,
  void Function(dynamic) onChangeEvent,
}) {
  return Expanded(
    child: InputDecorator(
      decoration: _inputDecoration(inputDecoratio),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          icon: icon,
          isExpanded: true,
          isDense: true,
          hint: _hintDropDown(hint),
          value: value,
          items: items,
          onChanged: onChangeEvent,
        ),
      ),
    ),
  );
}

InputDecoration _inputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
    ),
    border: OutlineInputBorder(),
  );
}

Widget _hintDropDown(String title) {
  return Text(
    title,
    style: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 20,
    ),
    overflow: TextOverflow.ellipsis,
  );
}
