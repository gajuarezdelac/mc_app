import 'package:flutter/cupertino.dart';

@immutable
abstract class DropDownFrontEvent {
  final bool clear;
  final String planDetailId;
  DropDownFrontEvent({this.clear, this.planDetailId});
}

class GetFronts extends DropDownFrontEvent {
  GetFronts({@required bool clear, @required String planDetailId})
      : super(clear: clear, planDetailId: planDetailId);
}
