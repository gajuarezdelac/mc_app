import 'package:flutter/cupertino.dart';

@immutable
abstract class DropdownReprogramationEvent {
  final String workId;
  // final String id;

  DropdownReprogramationEvent({this.workId});
}

// los eventos se entienden de la clase abstracta.
class GetReprogramation extends DropdownReprogramationEvent {
  GetReprogramation({
    @required String workId,
  }) : super(workId: workId);
}
