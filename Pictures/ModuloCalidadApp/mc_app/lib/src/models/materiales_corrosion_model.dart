class MaterialesCorrosionModel {
  String noEnvio;
  String noRegistroInspeccion;
  String contratoId;
  String contrato;
  String obraId;
  String obra;
  String destino;
  String deptoSolicitante;
  String observaciones;
  String fecha;

  MaterialesCorrosionModel(
      {this.noEnvio,
      this.noRegistroInspeccion,
      this.contratoId,
      this.contrato,
      this.obraId,
      this.obra,
      this.destino,
      this.deptoSolicitante,
      this.observaciones,
      this.fecha});

  factory MaterialesCorrosionModel.fromJson(Map<String, dynamic> json) =>
      MaterialesCorrosionModel(
          noEnvio: json['NoEnvio'],
          noRegistroInspeccion: json['NoRegistroInspeccion'],
          contratoId: json['ContratoId'],
          contrato: json['Contrato'],
          obraId: json['ObraId'],
          obra: json['Obra'],
          destino: json['Destino'],
          deptoSolicitante: json['DeptoSolicitante'],
          observaciones: json['Observaciones'],
          fecha: json['Fecha']);

  Map<String, dynamic> toMap() => {
        'NoEnvio': noEnvio,
        'NoRegistroInspeccion': noRegistroInspeccion,
        'ContratoId': contratoId,
        'Contrato': contrato,
        'ObraId': obraId,
        'Obra': obra,
        'Destino': destino,
        'DeptoSolicitante': deptoSolicitante,
        'Observaciones': observaciones
      };

  Map<String, dynamic> toJson() => {
        'NoEnvio': noEnvio,
        'NoRegistroInspeccion': noRegistroInspeccion,
        'ContratoId': contratoId,
        'Contrato': contrato,
        'ObraId': obraId,
        'Obra': obra,
        'Destino': destino,
        'DeptoSolicitante': deptoSolicitante,
        'Observaciones': observaciones
      };
}

class SpoolDetalleProteccionModel {
  int partida;
  String nombreElemento;
  String folio;
  String plataforma;
  String plano;
  String cantidad;
  String um;
  String descripcion;
  String idTrazabilidad;
  int esSpool;
  int primero;
  String materialId;
  String juntaId;
  bool isReport = false;

  SpoolDetalleProteccionModel({
    this.partida,
    this.nombreElemento,
    this.folio,
    this.plataforma,
    this.plano,
    this.cantidad,
    this.um,
    this.descripcion,
    this.idTrazabilidad,
    this.esSpool,
    this.primero,
    this.juntaId,
    this.materialId,
    this.isReport = false,
  });

  factory SpoolDetalleProteccionModel.fromJson(
          Map<String, dynamic> json, bool isReport) =>
      SpoolDetalleProteccionModel(
          isReport: isReport,
          partida: int.parse(json['Partida']),
          nombreElemento: json['NombreElemento'].toString(),
          folio: json['Folio'].toString(),
          plataforma: json['Plataforma'].toString(),
          plano: json['Plano'].toString(),
          cantidad: json['Cantidad'].toString(),
          um: json['UM'].toString(),
          descripcion: json['Descripcion'].toString(),
          idTrazabilidad: json['IdTrazabilidad'].toString(),
          esSpool: json['EsSpool'],
          primero: json['Primero'],
          juntaId: json['JuntaId'].toString(),
          materialId: json['MaterialId'].toString());

  Map<String, dynamic> toMap() => {
        'Partida': partida,
        'NombreElemento': nombreElemento,
        'folio': folio,
        'plataforma': plataforma,
        'plano': plano,
        'cantidad': cantidad,
        'um': um,
        'descripcion': descripcion,
        'idTrazabilidad': idTrazabilidad,
        'esSpool': esSpool,
        'primero': primero
      };

  Map<String, dynamic> toJson() => {
        'Partida': partida,
        'NombreElemento': nombreElemento,
        'folio': folio,
        'plataforma': plataforma,
        'plano': plano,
        'cantidad': cantidad,
        'um': um,
        'descripcion': descripcion,
        'idTrazabilidad': idTrazabilidad,
        'esSpool': esSpool,
        'primero': primero
      };
}

class PartidasModel {
  String materialId;
  String juntaId;
  int partida;

  PartidasModel({this.partida, this.materialId, this.juntaId});

  factory PartidasModel.fromJson(Map<String, dynamic> json) {
    return PartidasModel(
        materialId: json["MaterialId"].toString(),
        juntaId: json["JuntaId"].toString());
  }
}

class SpoolDetalleProteccionDataTable {
  int partida;
  String nombreElemento;
  String folio;
  String plataforma;
  String plano;
  String cantidad;
  String um;
  String descripcion;
  String idTrazabilidad;

  SpoolDetalleProteccionDataTable(
      {this.partida,
      this.nombreElemento,
      this.folio,
      this.plataforma,
      this.plano,
      this.cantidad,
      this.um,
      this.descripcion,
      this.idTrazabilidad});
}

class RptMaterialsCorrosionHeader {
  String noEnvio;
  String contrato;
  String obra;
  String destino;
  String deptoSolicitante;
  String fecha;
  String observaciones;

  RptMaterialsCorrosionHeader(
      {this.noEnvio,
      this.contrato,
      this.obra,
      this.destino,
      this.deptoSolicitante,
      this.fecha,
      this.observaciones});

  factory RptMaterialsCorrosionHeader.fromJson(Map<String, dynamic> json) =>
      RptMaterialsCorrosionHeader(
        noEnvio: json["NoEnvio"],
        contrato: json["Contrato"],
        obra: json["Obra"],
        destino: json["Destino"],
        deptoSolicitante: json["DeptoSolicitante"],
        fecha: json["Fecha"],
        observaciones: json["Observaciones"],
      );
}
