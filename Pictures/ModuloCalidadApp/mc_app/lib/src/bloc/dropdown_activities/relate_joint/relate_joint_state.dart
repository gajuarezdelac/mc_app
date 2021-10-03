import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/relate_activity_model.dart';

@immutable
abstract class RelateJointState {
  final RelateActivityModel relateActivity;
  final String messageError;
  final int messgeSuccess;
  RelateJointState({
    this.messageError,
    this.messgeSuccess,
    this.relateActivity,
  });
}

class InitialRelateJointState extends RelateJointState {}

class IsLoadingRelateJoint extends RelateJointState {}

class ErrorRelateJoint extends RelateJointState {
  ErrorRelateJoint({@required String messageError})
      : super(messageError: messageError);
}

class SuccessRelateJoint extends RelateJointState {
  SuccessRelateJoint({@required RelateActivityModel relateActivity})
      : super(relateActivity: relateActivity);
}
