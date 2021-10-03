import 'package:flutter/cupertino.dart';

@immutable
abstract class DropdownAnexoEvent {
  final String selectedAnexo;
  // final String id;

  DropdownAnexoEvent({this.selectedAnexo});
}

// los eventos se entienden de la clase abstracta.
class GetAnexo extends DropdownAnexoEvent {}
