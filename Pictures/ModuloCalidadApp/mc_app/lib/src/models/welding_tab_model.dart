import 'empleado_soldador_not_valid_model.dart';

class ActividadesSoldaduraModel {
  String juntaId;
  String folioSoldadura;
  int firmado;
  String idEquipo;
  String noSerie;
  String marca;
  String equipoDescripcion;
  String norma;
  String registroSoldaduraId;
  String fechaReporteRSI;
  String noTarjeta;
  int inspectorCCAId;
  String inspectorCCAFoto;
  String inspectorCCANombre;
  int inspectorCCAFicha;
  String inspectorCCAPuestoDescripcion;
  String motivoFN;
  String cambioMaterial;
  double longitudSoldada;
  String observaciones;
  String otrosElementos;
  String cuadranteSoldaduraId;
  String zonaSoldaduraId;
  String soldadorId;
  String etapaRealizada;
  String cuadranteRealizado;
  String zonaRealizada;
  String nombreSoldador;
  dynamic ficha;
  String categoria;
  String fechaInicio;
  String fechaFin;
  String criteriosAceptacion;

  bool isExpanded;

  ActividadesSoldaduraModel(
      {this.juntaId,
      this.folioSoldadura,
      this.firmado,
      this.idEquipo,
      this.noSerie,
      this.marca,
      this.equipoDescripcion,
      this.norma,
      this.registroSoldaduraId,
      this.fechaReporteRSI,
      this.noTarjeta,
      this.inspectorCCAId,
      this.inspectorCCAFoto,
      this.inspectorCCANombre,
      this.inspectorCCAFicha,
      this.inspectorCCAPuestoDescripcion,
      this.motivoFN,
      this.cambioMaterial,
      this.longitudSoldada,
      this.observaciones,
      this.otrosElementos,
      this.cuadranteSoldaduraId,
      this.zonaSoldaduraId,
      this.soldadorId,
      this.cuadranteRealizado,
      this.etapaRealizada,
      this.zonaRealizada,
      this.nombreSoldador,
      this.ficha,
      this.categoria,
      this.criteriosAceptacion,      
      this.isExpanded = false,
      this.fechaInicio,
      this.fechaFin});

  factory ActividadesSoldaduraModel.fromJson(Map<String, dynamic> json) =>
      ActividadesSoldaduraModel(
          juntaId: json["JuntaId"],
          folioSoldadura: json["FolioSoldadura"],
          firmado: json["Firmado"],
          idEquipo: json["IdEquipo"],
          noSerie: json["EquipoNoSerie"],
          marca: json["EquipoMarca"],
          equipoDescripcion: json["EquipoDescripcion"],
          norma: json["Norma"],
          registroSoldaduraId: json["RegistroSoldaduraId"],
          fechaReporteRSI: json["FechaReporteRSI"],
          noTarjeta: json["NoTarjeta"],
          inspectorCCAId: json["InspectorCCAId"],
          inspectorCCAFoto: json["InspectorCCAFoto"],
          inspectorCCANombre: json["InspectorCCANombre"],
          inspectorCCAFicha: json["InspectorCCAFicha"],
          inspectorCCAPuestoDescripcion: json["InspectorCCAPuestoDescripcion"],
          motivoFN: json["MotivoFN"],
          cambioMaterial: json["CambioMaterial"],
          longitudSoldada: json["LongitudSoldada"],
          observaciones: json["Observaciones"],
          otrosElementos: json["OtrosElementos"],
          cuadranteSoldaduraId: json["CuadranteSoldaduraId"],
          zonaSoldaduraId: json["ZonaSoldaduraId"],
          soldadorId: json["SoldadorId"],
          cuadranteRealizado: json["Cuadrante"],
          etapaRealizada: json["EtapaRealizada"],
          zonaRealizada: json["Zona"],
          nombreSoldador: json["NombreSoldador"],
          ficha: json["Ficha"],
          categoria: json["Categoria"],
          criteriosAceptacion: json["CriteriosAceptacionId"],
          fechaInicio: json["FechaInicio"],
          fechaFin: json["FechaFin"],);
}

class MachineWeldingModel {
  String folioSoldaduraId;
  String idEquipo = '';
  String equipoNoSerie = '';
  String equipoMarca = '';
  String equipoDescripcion = '';
  int vigente = 0;
  String message = '';
  String material = '';
  String noMaterialSAP = '';
  int existe = 0;

  MachineWeldingModel({
    this.folioSoldaduraId,
    this.idEquipo,
    this.equipoNoSerie,
    this.equipoMarca,
    this.equipoDescripcion,
    this.vigente,
    this.message,
    this.material,
    this.noMaterialSAP,
    this.existe,
  });

  factory MachineWeldingModel.fromJson(
          Map<String, dynamic> json, String folioSoldaduraId) =>
      MachineWeldingModel(
        folioSoldaduraId: folioSoldaduraId,
        idEquipo: json['IdEquipo'],
        equipoNoSerie: json['EquipoNoSerie'],
        equipoMarca: json['EquipoMarca'],
        equipoDescripcion: json['EquipoDescripcion'],
        material: json['Material'],
        noMaterialSAP: json['NoMaterialSAP'],
        vigente: json['Vigente'],
        existe: json['Existe'],
      );
}

class AddWelderModelResponse {
  final String message;
  final String actionResult;
  final EmpleadoSoldadorNotValidModel empleadoSoldadorNotValidModel;

  AddWelderModelResponse(
      {this.message, this.actionResult, this.empleadoSoldadorNotValidModel});
}

class AddMachineWeldingResponseModel {
  final String actionResult;
  final String mensaje;
  final MachineWeldingModel maquina;

  AddMachineWeldingResponseModel(
      {this.actionResult, this.mensaje, this.maquina});
}

class AddMachineWeldingListResponseModel {
  final String actionResult;
  final String mensaje;
  final List<MachineWeldingModel> maquinas;

  AddMachineWeldingListResponseModel(
      {this.actionResult, this.mensaje, this.maquinas});
}

class RemoveMachineWeldingResponseModel {
  final int rowsAffected;
  final String actionResult;
  final String mensaje;
  final String folioSoldaduraId;

  RemoveMachineWeldingResponseModel(
      {this.actionResult,
      this.mensaje,
      this.rowsAffected,
      this.folioSoldaduraId});
}

class RemoveWeldingActivityModel {
  final String actionResult;
  final String mensaje;
  final int rowsAffected;
  final String folioSoldaduraId;

  RemoveWeldingActivityModel({
    this.actionResult,
    this.mensaje,
    this.rowsAffected,
    this.folioSoldaduraId,
  });
}

class ReleaseWeldingResponseModel {
  final String message;
  final String actionResult;
  final int rowsAffected;

  ReleaseWeldingResponseModel(
      {this.actionResult, this.message, this.rowsAffected});
}
