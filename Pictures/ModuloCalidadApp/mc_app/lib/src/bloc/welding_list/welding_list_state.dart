import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/joint_wc_model.dart';

@immutable
abstract class WeldingListState {
  final List<JointWCModel> joints;
  final String message;

  WeldingListState({this.joints, this.message});
}

class InitialWeldingListState extends WeldingListState {}

class IsLoadingWeldingList extends WeldingListState {}

class ErrorWeldingList extends WeldingListState {
  ErrorWeldingList({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessWeldingList extends WeldingListState {
  SuccessWeldingList({@required List<JointWCModel> joints})
      : super(joints: joints);
}
