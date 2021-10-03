class NonCompliantOutputPaginatorModel {
  int totalCount;
  String salidaNoConformeId;
  String semaforo;
  String consecutivo;
  String tipo;
  String contrato;
  String ot;
  String detecta;
  String plano;
  String aplica;
  String atribuible;
  String descripcionActividad;
  String estatus;
  int totalDocumentos;
  bool selected;

  NonCompliantOutputPaginatorModel({
    this.totalCount,
    this.salidaNoConformeId,
    this.semaforo,
    this.consecutivo,
    this.tipo,
    this.contrato,
    this.ot,
    this.detecta,
    this.plano,
    this.aplica,
    this.atribuible,
    this.descripcionActividad,
    this.estatus,
    this.totalDocumentos,
    this.selected=false,
  });

  //Convierte un Json en un objeto de tipo NonCompliantOutputPaginatorModel
  factory NonCompliantOutputPaginatorModel.fromJson(
          Map<String, dynamic> json) =>
      NonCompliantOutputPaginatorModel(
        totalCount: json["TotalCount"],
        salidaNoConformeId: json["SalidaNoConformeId"],
        semaforo: json["Semaforo"],
        consecutivo: json["Consecutivo"],
        tipo: json["Tipo"],
        contrato: json["Contrato"],
        ot: json["OT"],
        detecta: json["Detecta"],
        plano: json["Plano"],
        aplica: json["Aplica"],
        atribuible: json["Atribuible"],
        descripcionActividad: json["DescripcionActividad"],
        estatus: json["Estatus"],
        totalDocumentos: json["TotalDocumentos"],
      );
}
