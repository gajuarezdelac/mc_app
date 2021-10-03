class FNSelCantidadModel {
  String siteId;
  dynamic propuestaTecnicaId;
  dynamic actividadId;
  dynamic subActividadId;
  dynamic reprogramacionOTId;
  dynamic regBorrado;
  String semaforo;

  FNSelCantidadModel(
      {this.siteId,
      this.propuestaTecnicaId,
      this.actividadId,
      this.regBorrado,
      this.reprogramacionOTId,
      this.subActividadId,
      this.semaforo});

  factory FNSelCantidadModel.fromJson(Map<String, dynamic> json) =>
      FNSelCantidadModel(
        siteId: json["SiteId"],
        propuestaTecnicaId: json["PropuestaTecnicaId"],
        actividadId: json["ActividadId"],
        subActividadId: json["SubActividadId"],
        reprogramacionOTId: json["ReprogramacionOTId"],
        regBorrado: json["RegBorrado"],
      );
}

class FNSelSemaforoActividadesModel {
  String color;

  FNSelSemaforoActividadesModel({this.color});
}

class FNPartidaInternaModel {
  String partidaInterna;
  FNPartidaInternaModel({this.partidaInterna});
}

class EquiposFnSelDetallesActividadesA {
  String clave;
  String valor;

  EquiposFnSelDetallesActividadesA({this.clave, this.valor});
}

class TablaEvaluacionesModel {
  String evaluacion;

  TablaEvaluacionesModel({this.evaluacion});

  factory TablaEvaluacionesModel.fromJson(Map<String, dynamic> json) =>
      TablaEvaluacionesModel(
        evaluacion: json["Evaluacion"],
      );
}
