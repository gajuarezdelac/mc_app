import 'package:flutter/material.dart';

class SelectFieldWidget extends StatelessWidget {
  final String labelText;
  final void Function(dynamic value) onChanged;
  final void Function(String value) validator;
  final String value;
  final String title;
  final FontWeight fontWeight;
  final List<DropdownMenuItem<String>> list;

  const SelectFieldWidget({
    Key key,
    this.labelText,
    this.value,
    this.onChanged,
    this.validator,
    this.title = '',
    this.list,
    this.fontWeight = FontWeight.w400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: this.fontWeight,
        ),
        border: OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          onChanged: this.onChanged,
          validator: this.validator,
          isExpanded: true,
          isDense: true,
          value: this.value,
          hint: Text(
            title,
            style: TextStyle(
              fontWeight: this.fontWeight,
              fontSize: 20,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          items: this.list,
        ),
      ),
    );
  }
}
