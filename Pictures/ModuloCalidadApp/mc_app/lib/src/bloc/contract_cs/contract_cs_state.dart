import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/contract_cs_dropdown_model.dart';

@immutable
abstract class ContractCSState {
  final List<ContractCSDropdownModel> contracts;
  final String error;

  ContractCSState({this.contracts, this.error});
}

class InitialContractCSState extends ContractCSState {}

class IsLoadingContractCS extends ContractCSState {}

class ErrorContractCS extends ContractCSState {
  ErrorContractCS({@required String error}) : super(error: error);
}

class SuccessContractCS extends ContractCSState {
  SuccessContractCS({@required List<ContractCSDropdownModel> contracts})
      : super(contracts: contracts);
}
