import 'package:flutter/cupertino.dart';

@immutable
abstract class DropDownPlainDetailEvent {
  final String workId;
  final bool clear;
  DropDownPlainDetailEvent({this.workId, this.clear});
}

class GetPlainDetails extends DropDownPlainDetailEvent {
  GetPlainDetails({@required String workId, bool clear})
      : super(workId: workId, clear: clear);
}
