import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  // Params
  final String label;
  final bool habilitado;
  final String subLabel;
  final void Function(String text) onChanged;

  const TextFieldWidget({
    Key key,
    this.label = '',
    this.habilitado = true,
    this.subLabel,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      enableInteractiveSelection: false,
      enabled: this.habilitado,
      //controller: _inputFieldDateController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        hintText: 'Contrato',
        labelText: this.label,
        enabled: false,
      ),
      onChanged: this.onChanged,
    );
  }
}
