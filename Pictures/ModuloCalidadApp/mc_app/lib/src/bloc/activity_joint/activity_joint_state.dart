import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/activity_joint_model.dart';

@immutable
abstract class ActivityJointState {
  final ActivityJointModel activityJointModel;
  final String message;

  ActivityJointState({
    this.activityJointModel,
    this.message,
  });
}

class InitialActivityJoint extends ActivityJointState {}

class IsLoadingActivityJoint extends ActivityJointState {}

class ErrorActivityJoint extends ActivityJointState {
  ErrorActivityJoint({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessActivityJoint extends ActivityJointState {
  SuccessActivityJoint({@required ActivityJointModel activityJointModel})
      : super(activityJointModel: activityJointModel);
}
