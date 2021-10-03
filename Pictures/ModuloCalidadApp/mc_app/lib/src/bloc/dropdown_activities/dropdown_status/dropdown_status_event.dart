import 'package:flutter/cupertino.dart';

@immutable
abstract class DropdownStatusEvent {
  final String selectedEstatus;
  // final String id;

  DropdownStatusEvent({this.selectedEstatus});
}

// los eventos se entienden de la clase abstracta.
class GetStatus extends DropdownStatusEvent {}
