import 'package:flutter/cupertino.dart';

@immutable
abstract class DropdownPlaneSubactivityEvent {
  final String contractId;
  final int folioId;
  // final String id;

  DropdownPlaneSubactivityEvent({this.contractId, this.folioId});
}

// los eventos se entienden de la clase abstracta.
class GetPlaneSubactivity extends DropdownPlaneSubactivityEvent {
  GetPlaneSubactivity({
    @required String contractId,
    @required int folioId,
  }) : super(contractId: contractId, folioId: folioId);
}
