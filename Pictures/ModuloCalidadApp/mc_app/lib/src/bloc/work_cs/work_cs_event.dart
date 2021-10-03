import 'package:flutter/cupertino.dart';

@immutable
abstract class WorkCSEvent {
  final String contractId;

  WorkCSEvent({this.contractId});
}

class GetWorksCS extends WorkCSEvent {
  GetWorksCS({@required String contractId}) : super(contractId: contractId);
}
