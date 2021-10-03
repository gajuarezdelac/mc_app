class StageMaterialsIPAModel {
  String noRegistro;
  int orden;
  String etapa;
  int porcentajeInspeccion;
  String fechaReporte;
  String fechaLiberacion;

  StageMaterialsIPAModel({
    this.noRegistro,
    this.orden,
    this.etapa,
    this.porcentajeInspeccion,
    this.fechaReporte,
    this.fechaLiberacion
  });

  factory StageMaterialsIPAModel.fromJson(Map<String, dynamic> json) => 
    StageMaterialsIPAModel(
      noRegistro: json['NoRegistro'],
      orden: json['Orden'],
      etapa: json['Etapa'],
      porcentajeInspeccion: json['PorcentajeInspeccion'],
      fechaReporte: json['FechaReporte'],
      fechaLiberacion: json['FechaLiberacion'],
    );
}