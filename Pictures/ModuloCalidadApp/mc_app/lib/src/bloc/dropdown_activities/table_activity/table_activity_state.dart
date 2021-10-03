import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/activities_table_model.dart';

@immutable
abstract class ActivitiesTableState {
  final List<ActivitiesTableModel> activitiesTableModel;
  final String message;

  ActivitiesTableState({
    this.activitiesTableModel,
    this.message,
  });
}

class InitialTableActivityState extends ActivitiesTableState {}

class IsLoadingTableActivity extends ActivitiesTableState {}

class ErrorTableActivity extends ActivitiesTableState {
  ErrorTableActivity({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessTableActivity extends ActivitiesTableState {
  SuccessTableActivity(
      {@required List<ActivitiesTableModel> activitiesTableModel})
      : super(activitiesTableModel: activitiesTableModel);
}
