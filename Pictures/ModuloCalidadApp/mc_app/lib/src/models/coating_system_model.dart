class CoatingSystemModel {
  int orden;
  String etapa;
  String actividadRecubrimiento;
  int recubrimiento;
  int adherencia;
  int continuidad;

  CoatingSystemModel({
    this.orden,
    this.etapa,
    this.actividadRecubrimiento,
    this.recubrimiento,
    this.adherencia,
    this.continuidad
  });

  //Convierte un Json en un objeto de tipo AnticorrosiveProtectionModel
  factory CoatingSystemModel.fromJson(Map<String, dynamic> json) =>
      CoatingSystemModel(
        orden: json['Orden'],
        etapa: json['Etapa'],
        actividadRecubrimiento: json['ActividadRecubrimiento'],
        recubrimiento: json['Recubrimiento'],
        adherencia: json['Adherencia'],
        continuidad: json['Continuidad']
      );
}
