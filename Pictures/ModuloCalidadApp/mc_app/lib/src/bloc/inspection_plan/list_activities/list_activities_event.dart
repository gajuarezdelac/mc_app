import 'package:flutter/cupertino.dart';

@immutable
abstract class ListActivitiesEvent {
  final String contractId;
  final String workId;
  final bool clear;

  ListActivitiesEvent({this.contractId, this.workId, this.clear});
}

class GetListActivitiesC extends ListActivitiesEvent {
  GetListActivitiesC({
    @required String contractId,
    @required String workId,
    @required bool clear,
  }) : super(
          contractId: contractId,
          workId: workId,
          clear: clear,
        );
}
