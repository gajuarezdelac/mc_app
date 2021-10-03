class NonCompliantOutputIdModel {
  String salidaNoConformeId;
  int ficha;
  String fecha;
  String consecutivo;
  String contratoId;
  String obraId;
  String planoDetalleId;
  String descripcionActividad;
  int aplica;
  int atribuible;
  String requisito;
  String falla;
  String evidencia;
  String noConcesion;
  int disposicion;
  String otra;
  String tipo;
  String estatus;
  String informacionSoporte;
  String origen;
  String fechaCorreccion;
  String fechaRecepcionCierre;

  NonCompliantOutputIdModel({
    this.salidaNoConformeId,
    this.ficha,
    this.fecha,
    this.consecutivo,
    this.contratoId,
    this.obraId,
    this.planoDetalleId,
    this.descripcionActividad,
    this.aplica,
    this.atribuible,
    this.requisito,
    this.falla,
    this.evidencia,
    this.noConcesion,
    this.disposicion,
    this.otra,
    this.tipo,
    this.estatus,
    this.informacionSoporte,
    this.origen,
    this.fechaCorreccion,
    this.fechaRecepcionCierre,
  });

  //Convierte un Json en un objeto de tipo NonCompliantOutputId
  factory NonCompliantOutputIdModel.fromJson(Map<String, dynamic> json) =>
      NonCompliantOutputIdModel(
        salidaNoConformeId:json["SalidaNoConformeId"],
        ficha: json["Ficha"],
        fecha: json["Fecha"].toString().substring(0,10),
        consecutivo: json["Consecutivo"],
        contratoId: json["ContratoId"],
        obraId: json["ObraId"],
        planoDetalleId: json["PlanoDetalleId"],
        descripcionActividad: json["DescripcionActividad"],
        aplica: json["Aplica"],
        atribuible: json["Atribuible"],
        requisito: json["Requisito"],
        falla: json["Falla"],
        evidencia: json["Evidencia"],
        noConcesion: json["NoConcesion"],
        disposicion: json["Disposicion"],
        otra: json["Otra"],
        tipo: json["Tipo"],
        estatus: json["Estatus"],
        informacionSoporte: json["InformacionSoporte"],
        origen: json["Origen"],
        fechaCorreccion: json["FechaCorreccion"],
        fechaRecepcionCierre: json["FechaRecepcionCierre"],
      );
}
