class AnticorrosiveIPAModel {
  String observacionesRF;
  String sustrato;
  String abrasivo;
  String anclaje;
  String limpieza;
  bool incluirEvidencias;
  String observaciones;

  AnticorrosiveIPAModel({
    this.observacionesRF,
    this.sustrato,
    this.abrasivo,
    this.anclaje,
    this.limpieza,
    this.incluirEvidencias,
    this.observaciones
  });

  //Convierte un Json en un objeto de tipo AnticorrosiveProtectionModel
  factory AnticorrosiveIPAModel.fromJson(Map<String, dynamic> json) =>
      AnticorrosiveIPAModel(
        observacionesRF: json['ObservacionesRF'],
        sustrato: json['Sustrato'],
        abrasivo: json['Abrasivo'],
        anclaje: json['Anclaje'],
        limpieza: json['Limpieza'],
        incluirEvidencias: json['IncluirEvidencias'] == 1 ? true : false,
        observaciones: json['Observaciones']
      );
}
