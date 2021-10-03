class SynchronizationListModel {
  List<SynchronizationModel> items = [];

  SynchronizationListModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final synchronizationModel = SynchronizationModel.fromJson(item);
      items.add(synchronizationModel);
    }
  }
}

class SynchronizationModel {
  int sincronizacionId;
  String fechaUltimaActualizacion;
  String siteId;
  String nombrePlataforma;
  int estatus;
  String tablasNoProcesadas;
  int regBorrado;
  String regCreadoPor;
  String regFechaCreacion;
  String ultTablaProcesada;
  int tipoSincronizacion;

  SynchronizationModel({
    this.sincronizacionId,
    this.fechaUltimaActualizacion,
    this.siteId,
    this.nombrePlataforma,
    this.estatus,
    this.tablasNoProcesadas,
    this.regBorrado,
    this.regCreadoPor,
    this.regFechaCreacion,
    this.ultTablaProcesada,
    this.tipoSincronizacion,
  });

  factory SynchronizationModel.fromJson(Map<String, dynamic> json) =>
      SynchronizationModel(
        sincronizacionId: json["SincronizacionId"],
        fechaUltimaActualizacion: json["FechaUltimaActualizacion"],
        siteId: json["SiteId"],
        nombrePlataforma: json["NombrePlataforma"],
        estatus: json["Estatus"],
        tablasNoProcesadas: json["TablasNoProcesadas"],
        regBorrado: json["RegBorrado"],
        regCreadoPor: json["RegCreadoPor"],
        regFechaCreacion: json["RegFechaCreacion"],
        ultTablaProcesada: json["UltTablaProcesada"],
        tipoSincronizacion: json["TipoSincronizacion"],
      );

  Map<String, dynamic> toJson() => {
        "SincronizacionId": sincronizacionId,
        "FechaUltimaActualizacion": fechaUltimaActualizacion,
        "SiteId": siteId,
        "NombrePlataforma": nombrePlataforma,
        "Estatus": estatus,
        "TablasNoProcesadas": tablasNoProcesadas,
        "RegBorrado": regBorrado,
        "RegCreadoPor": regCreadoPor,
        "RegFechaCreacion": regFechaCreacion,
        "UltTablaProcesada": ultTablaProcesada,
        "TipoSincronizacion": tipoSincronizacion,
      };
}
