import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/acceptance_criteria_model.dart';
import 'package:mc_app/src/models/params/require_change_material_model.dart';

@immutable
abstract class QualifyCaboNormEvent {
  // params

  final String folioSoldadura;
  final int inspectorCCAId;
  final String norma;
  final String motivoFN;
  final String juntaId;
  final int ficha;
  final RequireChangeMaterialModel params;
  final List<AcceptanceCriteriaWeldingModel> listACS;
  final String nombreTabla;

  QualifyCaboNormEvent(
      {this.folioSoldadura,
      this.inspectorCCAId,
      this.norma,
      this.motivoFN,
      this.juntaId,
      this.ficha,
      this.params,
      this.listACS,
      this.nombreTabla});
}

// Evento para calificar dentro o fuera de norma
class QualifyCaboNorm extends QualifyCaboNormEvent {
  QualifyCaboNorm({
    @required String folioSoldadura,
    @required int inspectorCCAId,
    @required String norma,
    @required String motivoFN,
    @required String juntaId,
    @required List<AcceptanceCriteriaWeldingModel> listACS,
    @required String nombreTabla,
  }) : super(
          juntaId: juntaId,
          inspectorCCAId: inspectorCCAId,
          norma: norma,
          motivoFN: motivoFN,
          folioSoldadura: folioSoldadura,
          listACS: listACS,
          nombreTabla: nombreTabla,
        );
}

// Evento para el cambio de material

class ChangeMaterial extends QualifyCaboNormEvent {
  ChangeMaterial({@required RequireChangeMaterialModel params})
      : super(params: params);
}

class GetQAUser extends QualifyCaboNormEvent {
  GetQAUser({@required int ficha}) : super(ficha: ficha);
}
