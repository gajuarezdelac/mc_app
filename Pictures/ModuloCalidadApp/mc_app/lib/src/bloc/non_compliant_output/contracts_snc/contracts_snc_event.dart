import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ContractsSNCEvent extends Equatable {
  @override
  List<Object> get props => [];
  Object get prop => [];
}

class FetchContractsSNC extends ContractsSNCEvent {
  final int bandeja;

  FetchContractsSNC({@required this.bandeja});

  @override
  List<Object> get props => [bandeja];
}
