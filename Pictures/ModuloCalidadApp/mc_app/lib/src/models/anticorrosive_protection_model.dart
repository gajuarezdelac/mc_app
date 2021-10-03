import 'package:intl/intl.dart';
import 'package:mc_app/src/models/rpt_anticorrosive_protection_model.dart';

import 'documents_rpt_model.dart';

class AnticorrosiveProtectionModel {
  String semaforo;
  String noRegistro;
  String contratoId;
  String oT;
  String instalacion;
  String plataforma;
  String sistema;
  String fecha;
  bool infoGeneral;
  bool condiciones;
  bool documentos;
  bool evidencia;
  bool equipos;
  bool aplicacionRecubrimiento;

  AnticorrosiveProtectionModel({
    this.semaforo,
    this.noRegistro,
    this.contratoId,
    this.oT,
    this.instalacion,
    this.plataforma,
    this.sistema,
    this.fecha,
    this.infoGeneral,
    this.condiciones,
    this.documentos,
    this.evidencia,
    this.equipos,
    this.aplicacionRecubrimiento,
  });

  //Convierte un Json en un objeto de tipo AnticorrosiveProtectionModel
  factory AnticorrosiveProtectionModel.fromJson(Map<String, dynamic> json) =>
      AnticorrosiveProtectionModel(
        semaforo: json['Semaforo'],
        noRegistro: json['NoRegistro'],
        contratoId: json['ContratoId'],
        oT: json['OT'],
        instalacion: json['Instalacion'],
        plataforma: json['Plataforma'],
        sistema: json['Sistema'],
        fecha: json['Fecha'],
        infoGeneral: json['InfoGeneral'] == 1 ? true : false,
        condiciones: json['Condiciones'] == 1 ? true : false,
        documentos: json['Documentos'] == 1 ? true : false,
        evidencia: json['Evidencia'] == 1 ? true : false,
        equipos: json['Equipos'] == 1 ? true : false,
        aplicacionRecubrimiento:
            json['AplicacionRecubrimiento'] == 1 ? true : false,
      );
}

class RptPrueba {
  String content;
  String contentType;

  RptPrueba({this.content, this.contentType});

  factory RptPrueba.fromJson(Map<String, dynamic> json) =>
      RptPrueba(content: json['Content'], contentType: json['ContentType']);
}

class TblEtapasRecubrimiento {
  int filaId;
  int orden;
  int continuidad;

  TblEtapasRecubrimiento({this.filaId, this.orden, this.continuidad});

  factory TblEtapasRecubrimiento.fromJson(Map<String, dynamic> json) =>
      TblEtapasRecubrimiento(
        filaId: json['FilaId'],
        orden: json['Orden'],
        continuidad: json["Continuidad"],
      );
}

class TblTempTotalRows {
  String observacion;
  String content1;
  String contentType1;
  String content2;
  String contentType2;

  TblTempTotalRows({
    this.observacion,
    this.content1,
    this.content2,
    this.contentType1,
    this.contentType2,
  });

  factory TblTempTotalRows.fromJson(Map<String, dynamic> json) =>
      TblTempTotalRows(
        observacion: json['Observacion'],
      );
}

class TblTempEvidecias {
  String fotoId;
  String content;
  String contentType;

  TblTempEvidecias({this.fotoId, this.content, this.contentType});
  factory TblTempEvidecias.fromJson(Map<String, dynamic> json) =>
      TblTempEvidecias(
        fotoId: json['FotoId'],
        content: json['Content'],
        contentType: json["ContentType"],
      );
}

class RptHeaderProteccionAnticorrosiva {
  String fecha;
  String noRegistro;
  String contratoId;
  String descripcionContrato;
  String ot;
  String instalacion;
  String descripcionObras;
  String sistema;
  String recubrimientos;
  String condicionesSustratos;
  String tipoAbrasivo;
  String perfilAnclajePromedio;
  String estandarLimpieza;
  String observaciones;
  String observacionesRF;
  String revisa;
  String elabora;
  String aprueba;
  int incluirImagenes;
  String content;
  String contentType;
  String plataforma;
  String evaluacion;

  RptHeaderProteccionAnticorrosiva(
      {this.content,
      this.evaluacion,
      this.plataforma,
      this.contentType,
      this.aprueba,
      this.condicionesSustratos,
      this.contratoId,
      this.descripcionContrato,
      this.descripcionObras,
      this.elabora,
      this.estandarLimpieza,
      this.fecha,
      this.incluirImagenes,
      this.instalacion,
      this.noRegistro,
      this.observaciones,
      this.observacionesRF,
      this.ot,
      this.perfilAnclajePromedio,
      this.recubrimientos,
      this.revisa,
      this.sistema,
      this.tipoAbrasivo});

  factory RptHeaderProteccionAnticorrosiva.fromJson(
          Map<String, dynamic> json) =>
      RptHeaderProteccionAnticorrosiva(
        plataforma: json["Plataforma"],
        content: json["Content1"],
        contentType: json["Mime1"],
        aprueba: json["Aprueba"],
        condicionesSustratos: json["CondicionesSustrato"],
        contratoId: json["ContratoId"],
        descripcionObras: json["DescripcionObra"],
        descripcionContrato: json["DescripcionContrato"],
        elabora: json["Elabora"],
        estandarLimpieza: json["EstandarLimpieza"],
        // fecha: json["Fecha"],
        fecha: json["Fecha"] == ''
            ? ''
            : DateFormat('dd-MMM-yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(json['Fecha'])),
        incluirImagenes: json["IncluirImagenes"],
        instalacion: json["Instalacion"],
        noRegistro: json["NoRegistro"],
        observacionesRF: json["ObservacionRF"],
        observaciones: json["Observaciones"],
        ot: json["OT"],
        perfilAnclajePromedio: json["PerfilAnclajePromedio"],
        revisa: json["Revisa"],
        sistema: json["Sistema"],
        tipoAbrasivo: json["TipoAbrasivo"],
        recubrimientos: json["Recubrimientos"],
      );
}

class EquiposIMPAP {
  String nombre;

  EquiposIMPAP({this.nombre});

  factory EquiposIMPAP.fromJson(Map<String, dynamic> json) =>
      EquiposIMPAP(nombre: json["Nombre"]);
}

class EvidenciaAPA {
  String observacion;
  String content1;
  String contentType1;
  String content2;
  String contentType2;

  EvidenciaAPA({
    this.observacion,
    this.content1,
    this.content2,
    this.contentType1,
    this.contentType2,
  });
}

class RptAPModel {
  RptHeaderProteccionAnticorrosiva headerAP;
  List<DataTableDymanic> listAplicacionRecub;
  List<EquiposIMPAP> listEquiposIMP;
  List<TblTempTotalRows> listTableRows;
  List<DataTableDymanic> listConditionEnvironmentModel;
  List<PlaneRecordsModel> listPlaneRecords;
  PruebasAdherencia pruebasAdherencia;
  List<TempRegistroImgAdherencia> listRegistroImgAdherencia;
  List<DocumentsRptModel> listDocumentsRpt;

  RptAPModel(
      {this.headerAP,
      this.listAplicacionRecub,
      this.listEquiposIMP,
      this.listTableRows,
      this.listConditionEnvironmentModel,
      this.listPlaneRecords,
      this.pruebasAdherencia,
      this.listRegistroImgAdherencia,
      this.listDocumentsRpt});
}

class EvidenciaImgAdherencia {
  int filaId;
  String content;
  String contentType;

  EvidenciaImgAdherencia({
    this.filaId,
    this.content,
    this.contentType,
  });

  factory EvidenciaImgAdherencia.fromJson(Map<String, dynamic> json) =>
      EvidenciaImgAdherencia(
        filaId: json["FilaId"],
        contentType: json["ContentType"],
        content: json["Content"],
      );
}

class TempRegistroImgAdherencia {
  String observacion;
  String prueba;
  String content1;
  String content2;
  String contentType1;
  String contentType2;

  TempRegistroImgAdherencia({
    this.observacion,
    this.prueba,
    this.content1,
    this.content2,
    this.contentType1,
    this.contentType2,
  });
}

class PruebasAdherencia {
  String fecha;
  String contratoId;
  String noRegistro;
  String instalacion;
  String plataforma;
  String ot;
  String documentoAplicable;
  String observacion;
  int orden;

  PruebasAdherencia({
    this.fecha,
    this.contratoId,
    this.noRegistro,
    this.instalacion,
    this.plataforma,
    this.ot,
    this.documentoAplicable,
    this.observacion,
    this.orden,
  });

  factory PruebasAdherencia.fromJson(Map<String, dynamic> json) =>
      PruebasAdherencia(
        fecha: json["Fecha"] == ''
            ? ''
            : DateFormat('dd/MM/yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(json['Fecha']))
        // ? ''
        // : DateFormat('dd/MM/yyyy h:mm:ss a')
        //     .format(DateFormat('yyyy-MM-dd h:mm:ss').parse(json['Fecha']))
        ,
        contratoId: json["ContratoId"],
        noRegistro: json["NoRegistro"],
        instalacion: json["Instalacion"],
        plataforma: json["Plataforma"],
        ot: json["OT"],
        documentoAplicable: json["DocumentoAplicable"],
        observacion: json["Observacion"],
        orden: json["Orden"],
      );
}
