class PlannedResourceModel {
  String orden;
  int cantidad;
  String puesto;
  String hrPlaneadas;
  String hrReales;
  String acciones;
  String responsable;
  String fechaEjecucion;
  int fichaRealiza;
  int fichaAutoriza;

  PlannedResourceModel({
    this.orden,
    this.cantidad,
    this.puesto,
    this.hrPlaneadas,
    this.hrReales,
    this.acciones,
    this.responsable,
    this.fechaEjecucion,
    this.fichaRealiza,
    this.fichaAutoriza,
  });

  factory PlannedResourceModel.fromJson(Map<String, dynamic> json) =>
      PlannedResourceModel(
        orden: json["Orden"],
        cantidad: json["Cantidad"],
        puesto: json["Puesto"],
        hrPlaneadas: json["HrPlaneadas"],
        hrReales: json["HrReales"],
        acciones: json["Acciones"],
        responsable: json["Responsable"],
        fechaEjecucion: json["FechaEjecucion"],
      );
}

class PlannedResourceModel2 {
  int cantidad;
  String puesto;
  String hrPlaneadas;
  String hrReales;

  PlannedResourceModel2(
      {this.cantidad, this.puesto, this.hrPlaneadas, this.hrReales});

  factory PlannedResourceModel2.fromJson(Map<String, dynamic> json) =>
      PlannedResourceModel2(
          cantidad: json["Cantidad"],
          puesto: json["Puesto"],
          hrPlaneadas: json["HrPlaneadas"],
          hrReales: json["HrReales"]);
}
