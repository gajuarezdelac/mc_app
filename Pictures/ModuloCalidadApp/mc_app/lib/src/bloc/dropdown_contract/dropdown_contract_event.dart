import 'package:flutter/cupertino.dart';

@immutable
abstract class DropDownContractEvent {
  final String selectedContract;

  DropDownContractEvent({this.selectedContract});
}

class GetContracts extends DropDownContractEvent {}
