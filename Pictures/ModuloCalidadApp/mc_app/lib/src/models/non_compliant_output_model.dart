import 'package:intl/intl.dart';
import 'package:mc_app/src/models/planned_resource_model.dart';

import 'documents_rpt_model.dart';

class NonCompliantOutputModel {
  String salidaNoConformeId;
  String departamento;
  String fecha;
  String consecutivo;
  String contratoId;
  String ot;
  String plano;
  String descripcionActividad;
  String ficha;

  NonCompliantOutputModel({
    this.salidaNoConformeId,
    this.departamento,
    this.fecha,
    this.consecutivo,
    this.contratoId,
    this.ot,
    this.plano,
    this.descripcionActividad,
    this.ficha,
  });

  //Convierte un Json en un objeto de tipo NonCompliantOutputModel
  factory NonCompliantOutputModel.fromJson(Map<String, dynamic> json) =>
      NonCompliantOutputModel(
        salidaNoConformeId: json["SalidaNoConformeId"],
        departamento: json["Departamento"],
        fecha: json["Fecha"],
        consecutivo: json["Consecutivo"],
        contratoId: json["ContratoId"],
        ot: json["OT"],
        plano: json["Plano"],
        descripcionActividad: json["DescripcionActividad"],
        ficha: json["Ficha"],
      );
}

class WorkDropDownModelSNC {
  String obraId;
  String oT;
  String nombre;

  WorkDropDownModelSNC({this.obraId, this.oT, this.nombre});

  //Convierte un Json en un objeto de tipo ObraDropDownModel
  factory WorkDropDownModelSNC.fromJson(Map<String, dynamic> json) =>
      WorkDropDownModelSNC(
        obraId: json["ObraId"],
        oT: json["OT"],
        nombre: json["Nombre"],
      );
}

class ContractDropdownModelSNC {
  String contratoId;
  String nombre;
  String contratoNombre;
  String embarcacion;

  ContractDropdownModelSNC({
    this.contratoId,
    this.nombre,
    this.contratoNombre,
    this.embarcacion,
  });

  //Convierte un Json en un objeto de tipo ContractDropdownModel
  factory ContractDropdownModelSNC.fromJson(Map<String, dynamic> json) =>
      ContractDropdownModelSNC(
        contratoId: json["ContratoId"],
        nombre: json["Nombre"],
        contratoNombre: json["ContratoNombre"],
        embarcacion: json["Embarcacion"],
      );
}

class PlainDetailDropDownModelSNC {
  String planoDetalleId;
  String numeroPlano;
  int revision;
  int hoja;

  PlainDetailDropDownModelSNC({
    this.planoDetalleId,
    this.numeroPlano,
    this.revision,
    this.hoja,
  });

  //Convierte un Json en un objeto de tipo PlainDetailDropDownModel
  factory PlainDetailDropDownModelSNC.fromJson(Map<String, dynamic> json) =>
      PlainDetailDropDownModelSNC(
        planoDetalleId: json["PlanoDetalleId"],
        numeroPlano: json["NumeroPlano"],
        revision: json["Revision"],
        hoja: json["Hoja"],
      );
}

class TypeModelSNC {
  String tipo;

  TypeModelSNC({
    this.tipo,
  });

  //Convierte un Json en un objeto de tipo TypeModelSNC
  factory TypeModelSNC.fromJson(Map<String, dynamic> json) => TypeModelSNC(
        tipo: json["Tipo"],
      );
}

class NonCompliantOutputModel2 {
  String detecta;
  String fecha;
  String consecutivo;
  String contratoId;
  String ot;
  String plano;
  String descripcionActividad;
  String prefabricado;
  String instalacion;
  String servicio;
  String cotemar;
  String cliente;
  String subcontratista;
  String requisito;
  String falla;
  String evidencia;
  String noConcesion;
  String rechazo;
  String devuelto;
  String correccion;
  String otra;
  String acciones;
  String responsable;
  String fechaEjecucion;
  String autoriza;
  String dn;
  String fn;
  String na;
  String informacionSoporte;
  String descripcionDisposicionId;
  String fechaCorreccion;
  String fechaRecepcionCierre;

  NonCompliantOutputModel2(
      {this.detecta,
      this.fecha,
      this.consecutivo,
      this.contratoId,
      this.ot,
      this.plano,
      this.descripcionActividad,
      this.prefabricado,
      this.instalacion,
      this.servicio,
      this.cotemar,
      this.cliente,
      this.subcontratista,
      this.requisito,
      this.falla,
      this.evidencia,
      this.noConcesion,
      this.rechazo,
      this.devuelto,
      this.correccion,
      this.otra,
      this.acciones,
      this.responsable,
      this.fechaEjecucion,
      this.autoriza,
      this.dn,
      this.fn,
      this.na,
      this.informacionSoporte,
      this.descripcionDisposicionId,
      this.fechaCorreccion,
      this.fechaRecepcionCierre});

  //Convierte un Json en un objeto de tipo NonCompliantOutputModel2
  factory NonCompliantOutputModel2.fromJson(Map<String, dynamic> json) =>
      NonCompliantOutputModel2(
        detecta: json["Detecta"],
        fecha: json['Fecha'] == ''
            ? ''
            : DateFormat('dd-MMM-yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(json['Fecha'])),
        consecutivo: json["Consecutivo"],
        contratoId: json["ContratoId"],
        ot: json["OT"],
        plano: json["Plano"],
        descripcionActividad: json["DescripcionActividad"],
        prefabricado: json["Prefabricado"],
        instalacion: json["Instalacion"],
        servicio: json["Servicio"],
        cotemar: json["Cotemar"],
        cliente: json["Cliente"],
        subcontratista: json["Subcontratista"],
        requisito: json["Requisito"],
        falla: json["Falla"],
        evidencia: json["Evidencia"],
        noConcesion: json["NoConcesion"],
        rechazo: json["Rechazo"],
        devuelto: json["Devuelto"],
        correccion: json["Correccion"],
        otra: json["Otra"],
        acciones: json["Acciones"],
        responsable: json["Responsable"],
        fechaEjecucion: json["FechaEjecucion"],
        autoriza: json["Autoriza"],
        dn: json["DN"],
        fn: json["FN"],
        na: json["NA"],
        informacionSoporte: json["InformacionSoporte"],
        descripcionDisposicionId: json["DescripcionDisposicionId"],
        fechaCorreccion: json['FechaCorreccion'] == '' || json['FechaCorreccion'] == null
            ? ''
            : DateFormat('dd-MMM-yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(json['FechaCorreccion'])),
        fechaRecepcionCierre: json['FechaRecepcionCierre'] == '' || json['FechaRecepcionCierre'] == null
            ? ''
            : DateFormat('dd-MMM-yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(json['FechaRecepcionCierre'])),
      );
}

class RptNonCompliantOutputModel {
  List<NonCompliantOutputModel2> listSalidaNoConforme;
  List<PlannedResourceModel2> recursosPlaneados;
  List<DocumentsRptModel> documentsRpt;
  RptNonCompliantOutputModel(
      {this.listSalidaNoConforme, this.recursosPlaneados, this.documentsRpt});
}
