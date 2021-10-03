import 'package:flutter/cupertino.dart';

@immutable
abstract class DropdownFolioEvent {
  final String contractId;
  final String obraId;
  final String site;
  // final String id;

  DropdownFolioEvent({this.contractId, this.obraId, this.site});
}

// los eventos se entienden de la clase abstracta.
class GetFolio extends DropdownFolioEvent {
  GetFolio({
    @required String contractId,
    @required String obraId,
    @required String site,
  }) : super(contractId: contractId, obraId: obraId, site: site);
}
