import 'package:mc_app/src/models/params/disposition_description_params.dart';

class EvaluationSNCParams {
  String nonCompliantOutputId;
  String estatus;
  String informacionSoporte;
  List<PlannedResourceParams> resources;
  String fechaCorreccion;
  String fechaRecepcionCierre;

  EvaluationSNCParams({
    this.nonCompliantOutputId,
    this.estatus,
    this.informacionSoporte,
    this.resources,
    this.fechaCorreccion,
    this.fechaRecepcionCierre,
  });
}
