import 'package:flutter/cupertino.dart';

@immutable
abstract class RelateJointEvent {
  final String siteId;
  final double propuestaTecnicaId;
  final double actividadId;
  final int subActividadId;
  final String juntaId;
  // final Final String id;

  RelateJointEvent({
    this.siteId,
    this.propuestaTecnicaId,
    this.actividadId,
    this.subActividadId,
    this.juntaId,
  });
}

// los eventos se entienden de la clase abstracta.
class PutRelateJoint extends RelateJointEvent {
  PutRelateJoint({
    @required String siteId,
    @required double propuestaTecnicaId,
    @required double actividadId,
    @required int subActividadId,
    @required String juntaId,
  }) : super(
          siteId: siteId,
          propuestaTecnicaId: propuestaTecnicaId,
          actividadId: actividadId,
          subActividadId: subActividadId,
          juntaId: juntaId,
        );
}
