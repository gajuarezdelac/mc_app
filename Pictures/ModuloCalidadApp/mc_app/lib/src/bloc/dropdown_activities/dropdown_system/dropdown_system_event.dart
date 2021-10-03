import 'package:flutter/cupertino.dart';

@immutable
abstract class DropdownSystemEvent {
  final String contractId;
  final int folioId;
  // final String id;

  DropdownSystemEvent({this.contractId, this.folioId});
}

// los eventos se entienden de la clase abstracta.
class GetSystem extends DropdownSystemEvent {
  GetSystem({
    @required String contractId,
    @required int folioId,
  }) : super(contractId: contractId, folioId: folioId);
}
