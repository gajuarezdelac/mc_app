import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';

//ContractsSNC
@immutable
abstract class ContractsSNCState {
  final List<ContractDropdownModelSNC> contactModelList;
  final String error;

  ContractsSNCState({this.contactModelList, this.error});
}

class InitialContractsSNCState extends ContractsSNCState {}

class IsLoadingContractsSNC extends ContractsSNCState {}

class ErrorContractsSNC extends ContractsSNCState {
  final String error;

  ErrorContractsSNC({@required this.error}) : super(error: error);

  // @override
  // List<Object> get props => [error];
}

class SuccessContractsSNC extends ContractsSNCState {
  final List<ContractDropdownModelSNC> contractModelList;

  SuccessContractsSNC({@required this.contractModelList})
      : super(contactModelList: contractModelList);

  // @override
  // List<Object> get props => [contractModelList];
}
