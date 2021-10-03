import 'package:flutter/cupertino.dart';

@immutable
abstract class DropdownClientActivityEvent {
  final String contractId;
  final String workId;
  // final String id;

  DropdownClientActivityEvent({this.contractId, this.workId});
}

// los eventos se entienden de la clase abstracta.
class GetClienActivity extends DropdownClientActivityEvent {
  GetClienActivity({
    @required String contractId,
    @required String workId,
  }) : super(contractId: contractId, workId: workId);
}
