import 'package:flutter/cupertino.dart';

@immutable
abstract class DropdownSpecialtyEvent {
  final String contractId;
  final int folioId;
  // final String id;

  DropdownSpecialtyEvent({this.contractId, this.folioId});
}

// los eventos se entienden de la clase abstracta.
class GetSpeciality extends DropdownSpecialtyEvent {
  GetSpeciality({
    @required String contractId,
    @required int folioId,
  }) : super(contractId: contractId, folioId: folioId);
}
