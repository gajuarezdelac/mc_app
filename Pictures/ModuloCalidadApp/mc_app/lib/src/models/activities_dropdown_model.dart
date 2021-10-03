// Folio Model
class FolioDropdownModel {
  int folioId;
  String folio;

  FolioDropdownModel({
    this.folio,
    this.folioId,
  });

  //Convierte un Json en un objeto de tipo FrontDropdownModel
  factory FolioDropdownModel.fromJson(Map<String, dynamic> json) =>
      FolioDropdownModel(folioId: json["FolioId"], folio: json["Folio"]);
}

// Partida model
class PartidaDropdownModel {
  String siteId;
  String propuestaTecnicaId;
  String actividadId;
  int subActividadId;
  String reprogramacionOTId;

  PartidaDropdownModel({
    this.siteId,
    this.propuestaTecnicaId,
    this.actividadId,
    this.subActividadId,
    this.reprogramacionOTId,
  });

  factory PartidaDropdownModel.fromJson(Map<String, dynamic> json) =>
      PartidaDropdownModel(
        siteId: json["siteId"],
        propuestaTecnicaId: json["propuestaTecnicaId"],
        actividadId: json["actividadId"],
        subActividadId: json["subActividadId"],
        reprogramacionOTId: json["reprogramacionOTId"],
      );
}

// Reprogramación Model
class ReprogramacionModel {
  int key;
  String value;

  ReprogramacionModel({this.key, this.value});

  factory ReprogramacionModel.fromJson(Map<String, dynamic> json) =>
      ReprogramacionModel(
          key: json["ReprogramacionOTId"], value: json["Nombre"]);
}

// EspecialidadModel
class EspecialidadModel {
  double key;
  String value;

  EspecialidadModel({this.key, this.value});

  factory EspecialidadModel.fromJson(Map<String, dynamic> json) =>
      EspecialidadModel(
          key: json["EspecialidadId"], value: json["DescripcionLarga"]);
}

// SistemaModel
class SistemaModel {
  String key;
  String value;

  SistemaModel({this.key, this.value});

  factory SistemaModel.fromJson(Map<String, dynamic> json) =>
      SistemaModel(key: json["SistemaId"], value: json["DescripcionCorta"]);
}

// PlanoSubActividadModel
class PlanoSubActividadModel {
  String key;
  String value;

  PlanoSubActividadModel({this.key, this.value});

  factory PlanoSubActividadModel.fromJson(Map<String, dynamic> json) =>
      PlanoSubActividadModel(key: json["PlanoId"], value: json["Nombre"]);
}

class AnexoModel {
  String anexo;

  AnexoModel({this.anexo});
  factory AnexoModel.fromJson(Map<String, dynamic> json) => AnexoModel(
        anexo: json["Anexo"],
      );
}

// Partida PU
class PartidaPUModel {
  String partidaPU;
  PartidaPUModel({this.partidaPU});
  factory PartidaPUModel.fromJson(Map<String, dynamic> json) => PartidaPUModel(
        partidaPU: json["Partida"],
      );
}

// Primavera Id
class PrimaveraIdModel {
  String primaveraId;

  PrimaveraIdModel({this.primaveraId});
  factory PrimaveraIdModel.fromJson(Map<String, dynamic> json) =>
      PrimaveraIdModel(primaveraId: json["PrimaveraId"]);
}

// Actividad cliente
class ActividadClienteModel {
  String actividadCliente;

  ActividadClienteModel({this.actividadCliente});

  factory ActividadClienteModel.fromJson(Map<String, dynamic> json) =>
      ActividadClienteModel(actividadCliente: json["NoActividadCliente"]);
}

// Estatus Model
class EstatusIdModel {
  String estatusId;
  String descripcionCorta;

  EstatusIdModel({this.estatusId, this.descripcionCorta});

  factory EstatusIdModel.fromJson(Map<String, dynamic> json) => EstatusIdModel(
      estatusId: json["EstatusId"], descripcionCorta: json["DescripcionCorta"]);
}

class FechaDelModel {
  String del;
  FechaDelModel({this.del});
  factory FechaDelModel.fromJson(Map<String, dynamic> json) =>
      FechaDelModel(del: json["del"]);
}

class FechaAlModel {
  String del;
  FechaAlModel({this.del});
  factory FechaAlModel.fromJson(Map<String, dynamic> json) =>
      FechaAlModel(del: json["al"]);
}

class ContractAcitivityModel {
  String contratoId;
  String nombre;

  ContractAcitivityModel({
    this.contratoId,
    this.nombre,
  });

  //Convierte un Json en un objeto de tipo ContractDropdownModel
  factory ContractAcitivityModel.fromJson(Map<String, dynamic> json) =>
      ContractAcitivityModel(
        contratoId: json["ContratoId"],
        nombre: json["Nombre"],
      );
}

class WorkActivityModel {
  String obraId;
  String oT;
  String nombre;

  WorkActivityModel({this.obraId, this.oT, this.nombre});

  //Convierte un Json en un objeto de tipo ObraDropDownModel
  factory WorkActivityModel.fromJson(Map<String, dynamic> json) =>
      WorkActivityModel(
        obraId: json["ObraId"],
        oT: json["OT"],
        nombre: json["Nombre"],
      );
}

class FrontActivityModel {
  int frenteId;
  String descripcion;

  FrontActivityModel({
    this.frenteId,
    this.descripcion,
  });

  //Convierte un Json en un objeto de tipo FrontDropdownModel
  factory FrontActivityModel.fromJson(Map<String, dynamic> json) =>
      FrontActivityModel(
        frenteId: json["FrenteId"],
        descripcion: json["Descripcion"],
      );
}
