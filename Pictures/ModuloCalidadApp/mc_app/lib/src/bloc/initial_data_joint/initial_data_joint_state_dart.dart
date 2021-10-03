import 'package:flutter/material.dart';
import 'package:mc_app/src/models/initial_data_joint_model.dart';

@immutable
abstract class InitialDataJointState {
  final InitialDataJointModel initialDataJointModel;
  final String message;

  InitialDataJointState({this.initialDataJointModel, this.message});
}

class InitialJoinDatatState extends InitialDataJointState {}

class IsLoadingInitialDataJoint extends InitialDataJointState {}

class ErrorInitialDataJoint extends InitialDataJointState {
  ErrorInitialDataJoint({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessInitialDataJoint extends InitialDataJointState {
  SuccessInitialDataJoint(
      {@required InitialDataJointModel initialDataJointModel})
      : super(initialDataJointModel: initialDataJointModel);
}
