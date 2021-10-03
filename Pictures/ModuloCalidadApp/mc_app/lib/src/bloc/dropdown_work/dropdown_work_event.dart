import 'package:flutter/cupertino.dart';

@immutable
abstract class DropDownWorkEvent {
  final String contractId;

  DropDownWorkEvent({this.contractId});
}

class GetWorksById extends DropDownWorkEvent {
  GetWorksById({@required String contractId}) : super(contractId: contractId);
}
