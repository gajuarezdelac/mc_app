import 'package:flutter/cupertino.dart';

@immutable
abstract class DropdownPartidaPUEvent {
  final String contractId;
  // final String id;

  DropdownPartidaPUEvent({this.contractId});
}

// los eventos se entienden de la clase abstracta.
class GetPartidaPU extends DropdownPartidaPUEvent {
  GetPartidaPU({@required String contractId}) : super(contractId: contractId);
}
