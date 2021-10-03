import 'package:flutter/cupertino.dart';

@immutable
abstract class DropdownPrimaveraIdEvent {
  final String contractId;
  final String obraId;
  // final String id;

  DropdownPrimaveraIdEvent({this.contractId, this.obraId});
}

// los eventos se entienden de la clase abstracta.
class GetPrimaveraId extends DropdownPrimaveraIdEvent {
  GetPrimaveraId({
    @required String contractId,
    @required String obraId,
  }) : super(contractId: contractId, obraId: obraId);
}
