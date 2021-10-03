import 'package:flutter/cupertino.dart';

@immutable
abstract class WeldingListEvent {
  final String plainDetailId;
  final int frontId;
  final String state;
  final bool clear;

  WeldingListEvent({this.plainDetailId, this.frontId, this.state, this.clear});
}

class GetJointsWC extends WeldingListEvent {
  GetJointsWC({
    @required String plainDetailId,
    @required int frontId,
    @required state,
    @required clear,
  }) : super(
          plainDetailId: plainDetailId,
          frontId: frontId,
          state: state,
          clear: clear,
        );
}
