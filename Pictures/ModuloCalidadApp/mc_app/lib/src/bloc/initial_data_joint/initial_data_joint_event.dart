import 'package:flutter/cupertino.dart';

@immutable
abstract class InitialDataJointEvent {
  final String juntaId;
  // final Final String id;

  InitialDataJointEvent({
    this.juntaId,
  });
}

// los eventos se entienden de la clase abstracta.
class GetInitialDataJoint extends InitialDataJointEvent {
  GetInitialDataJoint({
    @required String juntaId,
  }) : super(juntaId: juntaId);
}
