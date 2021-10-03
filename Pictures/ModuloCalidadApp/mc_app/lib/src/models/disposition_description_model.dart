class DispositionDescriptionModel {
  String dispositionDescriptionId;
  String nonCompliantOutputId;
  String actions;
  int employeMakes; //ficha
  int employeeAuth; //ficha
  String executionDate;

  DispositionDescriptionModel({
    this.dispositionDescriptionId,
    this.nonCompliantOutputId,
    this.actions,
    this.employeMakes,
    this.employeeAuth,
    this.executionDate,
  });

  factory DispositionDescriptionModel.fromJson(Map<String, dynamic> json) =>
      DispositionDescriptionModel(
        dispositionDescriptionId: json["DescripcionDisposicionId"],
        nonCompliantOutputId: json["SalidaNoConformeId"],
        actions: json["Acciones"],
        employeeAuth: json["FichaAutoriza"],
        employeMakes: json["FichaRealiza"],
        executionDate: json["FechaEjecucion"],
      );

  Map<String, dynamic> toJson() => {
        "DescripcionDisposicionId": dispositionDescriptionId,
        "SalidaNoConformeId": nonCompliantOutputId,
        "Acciones": actions,
        "FichaAutoriza": employeeAuth,
        "FichaRealiza": employeMakes,
        "FechaEjecucion": executionDate,
      };
}
