import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/contract_dropdown_model.dart';

@immutable
abstract class DropDownContractState {
  final List<ContractDropdownModel> contracts;
  final String selectedContract;
  final String message;

  DropDownContractState({this.contracts, this.selectedContract, this.message});
}

class InitialDropDownContractState extends DropDownContractState {}

class IsLoadingContract extends DropDownContractState {}

class ErrorContract extends DropDownContractState {
  ErrorContract({@required String errorMessage}) : super(message: errorMessage);
}

class SuccessContract extends DropDownContractState {
  SuccessContract({@required List<ContractDropdownModel> contracts})
      : super(contracts: contracts);
}
