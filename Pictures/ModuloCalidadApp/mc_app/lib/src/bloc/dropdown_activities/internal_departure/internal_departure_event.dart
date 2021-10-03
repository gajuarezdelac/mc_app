import 'package:flutter/cupertino.dart';

@immutable
abstract class InternalDepartureEvent {
  final String siteId;
  final String contractId;
  final String workId;

  InternalDepartureEvent({
    this.siteId,
    this.contractId,
    this.workId,
  });
}

class GetInternalDeparture extends InternalDepartureEvent {
  GetInternalDeparture({
    @required String siteId,
    @required String contractId,
    @required String workId,
  }) : super(
          siteId: siteId,
          contractId: contractId,
          workId: workId,
        );
}
