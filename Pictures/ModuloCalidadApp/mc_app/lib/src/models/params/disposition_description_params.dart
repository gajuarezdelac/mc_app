class DispositionDescriptionParams {
  String dispositionDescriptionId;
  String nonCompliantOutputId;
  String actions;
  DateTime executionDate;
  int employeeMakes; //ficha
  int employeeAuth; //ficha
  List<PlannedResourceParams> resources;

  DispositionDescriptionParams({
    this.dispositionDescriptionId,
    this.nonCompliantOutputId,
    this.actions,
    this.executionDate,
    this.employeeMakes,
    this.employeeAuth,
    this.resources,
  });
}

class PlannedResourceParams {
  String orden;
  int cantidad;
  String puesto;
  String hrPlaneadas;
  String hrReales;

  PlannedResourceParams({
    this.orden,
    this.cantidad,
    this.puesto,
    this.hrPlaneadas,
    this.hrReales,
  });
}
