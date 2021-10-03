class CoatingAplicationModel {
  int orden;
  String observacion;
  String noLote;
  String fechaCaducidad;
  String metodoAplicacion;
  String tipoRecubrimiento;
  String mezcla;
  String espesorSecoPromedio;
  String tiempoSecado;
  String tipoEnvolvente;
  String pruebaContinuidad;
  String pruebaAdherencia;
  String documentoAplicable;
  String comentariosContinuidad;
  String comentariosAdherencia;
  int numeroPruebas;

  CoatingAplicationModel({
    this.orden,
    this.observacion,
    this.noLote,
    this.fechaCaducidad,
    this.metodoAplicacion,
    this.tipoRecubrimiento,
    this.mezcla,
    this.espesorSecoPromedio,
    this.tiempoSecado,
    this.tipoEnvolvente,
    this.pruebaContinuidad,
    this.pruebaAdherencia,
    this.documentoAplicable,
    this.comentariosContinuidad,
    this.comentariosAdherencia,
    this.numeroPruebas
  });

  //Convierte un Json en un objeto de tipo AnticorrosiveProtectionModel
  factory CoatingAplicationModel.fromJson(Map<String, dynamic> json) =>
      CoatingAplicationModel(
        orden: json['Orden'],
        observacion: json['Observacion'],
        noLote: json['NoLote'],
        fechaCaducidad: json['FechaCaducidad'],
        metodoAplicacion: json['MetodoAplicacion'],
        tipoRecubrimiento: json['TipoRecubrimiento'],
        mezcla: json['Mezcla'],
        espesorSecoPromedio: json['EspesorSecoPromedio'],
        tiempoSecado: json['TiempoSecado'],
        tipoEnvolvente: json['TipoEnvolvente'],
        pruebaContinuidad: json['PruebaContinuidad'],
        pruebaAdherencia: json['PruebaAdherencia'],
        documentoAplicable: json['DocumentoAplicable'],
        comentariosContinuidad: json['ComentariosContinuidad'],
        comentariosAdherencia: json['ComentariosAdherencia'],
        numeroPruebas: json['NumeroPruebas']
      );
}
