import 'package:flutter/cupertino.dart';

@immutable
abstract class ActivityJointEvent {
  final String siteId;
  final double propuestaTecnicaId;
  final double actividadId;
  final int subActividadId;
  // final Final String id;

  ActivityJointEvent({
    this.siteId,
    this.propuestaTecnicaId,
    this.actividadId,
    this.subActividadId,
  });
}

// los eventos se entienden de la clase abstracta.
class GetJointActivity extends ActivityJointEvent {
  GetJointActivity(
      {@required String siteId,
      @required double propuestaTecnicaId,
      @required double actividadId,
      @required int subActividadId})
      : super(
          siteId: siteId,
          propuestaTecnicaId: propuestaTecnicaId,
          actividadId: actividadId,
          subActividadId: subActividadId,
        );
}
