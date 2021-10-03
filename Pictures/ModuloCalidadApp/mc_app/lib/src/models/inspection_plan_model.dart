// Modelo para los contratos

import 'package:intl/intl.dart';

class ContractsInspectionPlanModel {
  String contratoId;
  String nombre;

  ContractsInspectionPlanModel({
    this.contratoId,
    this.nombre,
  });

  //Convierte un Json en un objeto de tipo ContractDropdownModel
  factory ContractsInspectionPlanModel.fromJson(Map<String, dynamic> json) =>
      ContractsInspectionPlanModel(
        contratoId: json["ContratoId"],
        nombre: json["Nombre"],
      );
}

// Modelo para las obras.
class WorksInspectionPlanModel {
  String obraId;
  String oT;
  String nombre;

  WorksInspectionPlanModel({this.obraId, this.oT, this.nombre});

  //Convierte un Json en un objeto de tipo ObraDropDownModel
  factory WorksInspectionPlanModel.fromJson(Map<String, dynamic> json) =>
      WorksInspectionPlanModel(
        obraId: json["ObraId"],
        oT: json["OT"],
        nombre: json["Nombre"],
      );
}

class InspectionPlanCModel {
  int semaforo;
  String noPlanInspeccion;
  String contrato;
  String obra;
  int actividades;
  String descripcion;
  String fechaCreacion;
  String instalacion;
  String plataforma;

  int dn;
  int fn;

  InspectionPlanCModel({
    this.semaforo,
    this.actividades,
    this.contrato,
    this.obra,
    this.descripcion,
    this.dn,
    this.fechaCreacion,
    this.fn,
    this.instalacion,
    this.noPlanInspeccion,
    this.plataforma,
  });

  factory InspectionPlanCModel.fromJson(Map<String, dynamic> json) =>
      InspectionPlanCModel(
        semaforo: json["Semaforo"],
        actividades: json["Actividades"],
        contrato: json["Contrato"],
        obra: json["Obra"],
        descripcion: json["Descripcion"],
        dn: json["DN"],
        fechaCreacion: json["FechaCreacion"],
        fn: json["FN"],
        instalacion: json["Instalacion"],
        noPlanInspeccion: json["NoPlanInspeccion"],
        plataforma: json["NoPlanInspeccion"],
      );
}

class InspectionPlanHeaderModel {
  int actividadesDN;
  String aprueba;
  String descripcion;
  String elabora;
  String embarcacion;
  String empleadoAprueba;
  String empleadoRevisa;
  String empleadoElabora;
  String fechaCreacion;
  String instalacion;
  String instalacionId;
  String revisa;
  String riaId;
  String claveRiaId;
  String semaforo;

  InspectionPlanHeaderModel({
    this.claveRiaId,
    this.actividadesDN,
    this.aprueba,
    this.descripcion,
    this.elabora,
    this.embarcacion,
    this.empleadoAprueba,
    this.empleadoRevisa,
    this.empleadoElabora,
    this.fechaCreacion,
    this.instalacion,
    this.instalacionId,
    this.revisa,
    this.riaId,
    this.semaforo,
  });

  factory InspectionPlanHeaderModel.fromJson(Map<String, dynamic> json) =>
      InspectionPlanHeaderModel(
        actividadesDN: json["ActividadesDN"],
        aprueba: json["Aprueba"],
        elabora: json["Elabora"],
        descripcion: json["Descripcion"],
        embarcacion: json["Embarcacion"],
        fechaCreacion: json["FechaCreacion"],
        empleadoRevisa: json["EmpleadoRevisa"],
        instalacion: json["Instalacion"],
        empleadoAprueba: json["EmpleadoAprueba"],
        empleadoElabora: json["EmpleadoElabora"],
        instalacionId: json["InstalacionId"],
        riaId: json["RIAId"],
        claveRiaId: json["RIAIdClave"],
        semaforo: json["Semaforo"],
        revisa: json["Revisa"],
      );
}

class InspectionPlanDModel {
  String semaforo; // Pendiente
  int folioId;
  String siteId; // Revisaod
  int propuestaTecnicaId; // Revisado
  int actividadId; // Revisado
  int subActividadId; // Revisado
  int reprogramacionOTId; // Revisado
  String partidaInterna;
  String anexo; // ARevisado
  String partidaPU;
  String primaveraId;
  String actividadCliente;
  String folio;
  String reprogramacionOT;
  String planoId;
  String plano;
  String descripcionActividad;
  dynamic especialidadId;
  String sistemaId;
  String sistema;
  String fechaInicio;
  String fechaFin;
  String estatus;
  int tipoInspeccion;
  int frecuencia;
  String observacion;
  int frenteId;
  String frente;
  dynamic avance;
  int detalle;
  String riaID;
  String procedimientos;
  String especialidad;
  int adicional;
  bool selected;
  String claveRIAId;

  InspectionPlanDModel({
    this.claveRIAId,
    this.actividadCliente,
    this.actividadId,
    this.anexo,
    this.avance,
    this.descripcionActividad,
    this.detalle,
    this.especialidadId,
    this.estatus,
    this.fechaFin,
    this.fechaInicio,
    this.folio,
    this.frecuencia,
    this.frenteId,
    this.observacion,
    this.folioId,
    this.partidaInterna,
    this.partidaPU,
    this.plano,
    this.planoId,
    this.primaveraId,
    this.procedimientos,
    this.propuestaTecnicaId,
    this.reprogramacionOT,
    this.reprogramacionOTId,
    this.riaID,
    this.semaforo,
    this.sistema,
    this.sistemaId,
    this.siteId,
    this.subActividadId,
    this.tipoInspeccion,
    this.especialidad,
    this.adicional,
    this.frente,
    this.selected = false,
  });

  factory InspectionPlanDModel.fromJson(Map<String, dynamic> json) =>
      InspectionPlanDModel(
        claveRIAId: json["ClaveRIAId"],
        siteId: json["SiteId"],
        propuestaTecnicaId: json["PropuestaTecnicaId"],
        actividadId: json["ActividadId"],
        subActividadId: json["SubActividadId"],
        reprogramacionOTId: json["ReprogramacionOTId"],
        partidaInterna: json["PartidaInterna"],
        anexo: json["Anexo"],
        partidaPU: json["PartidaPU"],
        primaveraId: json["PrimaveraId"],
        actividadCliente: json["ActividadCliente"],
        folioId: json["FolioId"],
        folio: json["Folio"],
        reprogramacionOT: json["ReprogramacionOT"],
        plano: json["Plano"],
        planoId: json["PlanoId"],
        descripcionActividad: json["DescripcionActividad"],
        especialidadId: json["EspecialidadId"],
        especialidad: json["Especialidad"],
        sistema: json["Sistema"],
        sistemaId: json["SistemaId"],
        fechaInicio: json["FechaInicio"],
        fechaFin: json["FechaFin"],
        estatus: json["Estatus"],
        tipoInspeccion: json["TipoInspeccion"],
        frecuencia: json["Frecuencia"],
        observacion: json["Observacion"],
        frenteId: json["FrenteId"],
        frente: json["Frente"],
        detalle: json["Detalle"],
        adicional: json["Adicional"],
        riaID: json["RIAId"],
        procedimientos: json["Procedimiento"],
      );
}

class ReporteInspeccionMaterialModel {
  String materialId;
  String descripcion;
  String idTrazabilidad;
  String uM;
  dynamic cantidad;
  int resultado;
  int incluirReporte;
  String observaciones;
  String fechaInspeccion;
  String siteId;
  bool selected = false;

  ReporteInspeccionMaterialModel({
    this.cantidad,
    this.materialId,
    this.descripcion,
    this.uM,
    this.fechaInspeccion,
    this.idTrazabilidad,
    this.incluirReporte,
    this.observaciones,
    this.resultado,
    this.selected,
    this.siteId,
  });

  factory ReporteInspeccionMaterialModel.fromJson(Map<String, dynamic> json) =>
      ReporteInspeccionMaterialModel(
        materialId: json["MaterialId"],
        descripcion: json["Descripcion"],
        idTrazabilidad: json["IdTrazabilidad"],
        uM: json["UM"],
        cantidad: json["Cantidad"],
        resultado: json["Resultado"],
        incluirReporte: json["IncluirReporte"],
        observaciones: json["Observaciones"],
        fechaInspeccion: json["FechaInspeccion"],
        siteId: json["SiteId"],
      );
}

class FetchWelderModel {
  String soldadorId;
  dynamic ficha;
  String nombre;
  String puesto;
  int regBorrado;

  FetchWelderModel(
      {this.ficha, this.nombre, this.puesto, this.soldadorId, this.regBorrado});

  factory FetchWelderModel.fromJson(Map<String, dynamic> json) {
    return FetchWelderModel(
      soldadorId: json["SoldadorId"],
      ficha: json["Ficha"],
      nombre: json["Nombre"],
      puesto: json["Puesto"],
      regBorrado: json["RegBorrado"],
    );
  }
}

class InformacionadicionalModel {
  String soldadorId;
  dynamic ficha;
  String nombre;
  String puesto;
  bool newWidget = false;
  TrazabilidadGroup trazabilidadGrupo1;
  TrazabilidadGroup trazabilidadGrupo2;

  InformacionadicionalModel(
      {this.newWidget = false,
      this.soldadorId,
      this.ficha,
      this.nombre,
      this.puesto,
      this.trazabilidadGrupo1,
      this.trazabilidadGrupo2});

  factory InformacionadicionalModel.fromJson(
          Map<String, dynamic> json, bool newWidget) =>
      InformacionadicionalModel(
        newWidget: newWidget,
        soldadorId: json["SoldadorId"],
        ficha: json["Ficha"],
        nombre: json["Nombre"],
        puesto: json["Puesto"],
      );
}

class InsUpdateReporteIPModel {
  String noPlanInspection;
  String siteId;
  dynamic propuestaTecnicaId;
  dynamic actividadId;
  dynamic subActividadId;
  dynamic reprogramacionOTId;
  String materialId;
  String idTrazabilidad;
  int resultado;
  int incluirReporte;
  String comentarios;
  String actionResult;

  InsUpdateReporteIPModel({
    this.actividadId,
    this.comentarios,
    this.idTrazabilidad,
    this.incluirReporte,
    this.materialId,
    this.noPlanInspection,
    this.actionResult,
    this.propuestaTecnicaId,
    this.reprogramacionOTId,
    this.resultado,
    this.siteId,
    this.subActividadId,
  });
}

class TrazabilidadGroup {
  TrazabilidadModel trazabilida1;
  TrazabilidadModel trazabilida2;

  TrazabilidadGroup({this.trazabilida1, this.trazabilida2});
}

class TrazabilidadModel {
  String materialId;
  String soldadorId;
  String um;
  dynamic volumen;
  String idTrazabilidad;
  String descripcion;
  bool showTrazability;

  TrazabilidadModel(
      {this.showTrazability,
      this.materialId,
      this.soldadorId,
      this.um,
      this.volumen,
      this.idTrazabilidad,
      this.descripcion});

  factory TrazabilidadModel.fromJson(
          Map<String, dynamic> json, bool showTrazability) =>
      TrazabilidadModel(
        showTrazability: showTrazability,
        materialId: json["MaterialId"],
        soldadorId: json["SoldadorId"],
        um: json["UM"],
        volumen: json["Volumen"],
        idTrazabilidad: json["IdTrazabilidad"],
        descripcion: json["Descripcion"],
      );
}

class SoldadorTrazabilidadRIA {
  String soldadorActividadId;
  String soldadorId;
  String idTrazabilidad;
  int numero;
  dynamic volumen;

  SoldadorTrazabilidadRIA(
      {this.idTrazabilidad,
      this.numero,
      this.soldadorActividadId,
      this.soldadorId,
      this.volumen});

  factory SoldadorTrazabilidadRIA.fromJson(Map<String, dynamic> json) =>
      SoldadorTrazabilidadRIA(
        soldadorActividadId: json["SoldadorActividadId"],
      );
}

class RptInspectionPlanHeader {
  String noPlanInspection;
  String contratoId;
  String ot;
  String embarcacion;
  String instalacion;
  String obra;
  String fechaCreacion;
  String elabora;
  String revisa;
  String aprueba;
  String puestoAprueba;
  String puestoElabora;
  String puestoRevisa;

  RptInspectionPlanHeader({
    this.aprueba,
    this.contratoId,
    this.elabora,
    this.embarcacion,
    this.fechaCreacion,
    this.instalacion,
    this.obra,
    this.ot,
    this.noPlanInspection,
    this.puestoAprueba,
    this.revisa,
    this.puestoElabora,
    this.puestoRevisa,
  });

  factory RptInspectionPlanHeader.fromJson(Map<String, dynamic> json) =>
      RptInspectionPlanHeader(
          aprueba: json["Aprueba"],
          contratoId: json["ContratoId"],
          elabora: json["Elabora"],
          embarcacion: json["Embarcacion"],
          fechaCreacion: json['FechaCreacion'] == ''
              ? ''
              : DateFormat.yMd()
                  .add_jm()
                  .format(DateTime.parse(json["FechaCreacion"])),
          instalacion: json["Instalacion"],
          obra: json["Obra"],
          ot: json["OT"],
          noPlanInspection: json["NoPlanInspeccion"],
          puestoAprueba: json["PuestoAprueba"],
          revisa: json["Revisa"],
          puestoRevisa: json["PuestoRevisa"],
          puestoElabora: json["PuestoElabora"]);
}

class RtpInspectionPlanList {
  String partidaInterna;
  String partidaA;
  dynamic propuestaTecnicaId;
  dynamic actividadId;
  dynamic subActividadId;
  dynamic reprogramacionOTId;
  String siteId;
  dynamic descripcion;
  String tipoInspeccion;
  String tecnicas;
  String frecuencia;
  String responsable;
  String equipos;
  String procedimientos;
  String formatos;
  String observacion;
  String folio;
  String especialidad;
  String sistema;
  String frente;
  String planos;
  int tipo;

  RtpInspectionPlanList({
    this.partidaInterna,
    this.partidaA,
    this.actividadId,
    this.subActividadId,
    this.propuestaTecnicaId,
    this.reprogramacionOTId,
    this.siteId,
    this.descripcion,
    this.tipoInspeccion,
    this.equipos,
    this.especialidad,
    this.folio,
    this.formatos,
    this.frecuencia,
    this.frente,
    this.observacion,
    this.procedimientos,
    this.responsable,
    this.sistema,
    this.tecnicas,
    this.planos,
    this.tipo,
  });

  factory RtpInspectionPlanList.fromJson(Map<String, dynamic> json) =>
      RtpInspectionPlanList(
        partidaA: json["Partida"],
        propuestaTecnicaId: json["PropuestaTecnicaId"],
        actividadId: json["ActividadId"],
        subActividadId: json["SubActividadId"],
        siteId: json["SiteId"],
        reprogramacionOTId: json["ReprogramacionOTId"],
        partidaInterna: json["PartidaInterna"],
        descripcion: json['''Descripcion'''],
        tipoInspeccion: json["TipoInspeccion"],
        procedimientos: json["Procedimientos"],
        equipos: json["Equipos"],
        especialidad: json["Especialidad"],
        folio: json["Folio"],
        formatos: json["Formatos"],
        frecuencia: json["Frecuencia"],
        frente: json["Frente"],
        observacion: json["Observacion"],
        responsable: json["Responsables"],
        sistema: json["Sistema"],
        planos: json["Planos"],
        tipo: json["Tipo"],
        tecnicas: json["Tecnicas"],
      );
}

class RptInspectionPlanModel {
  List<RtpInspectionPlanList> list;
  RptInspectionPlanHeader element;

  RptInspectionPlanModel({
    this.list,
    this.element,
  });
}

class SoldadoresIP {
  int filaId;
  String soldadorId;
  String soldadorActividadId;

  SoldadoresIP({
    this.filaId,
    this.soldadorActividadId,
    this.soldadorId,
  });

  factory SoldadoresIP.fromJson(Map<String, dynamic> json) => SoldadoresIP(
      filaId: json["FilaId"],
      soldadorId: json["SoldadorId"],
      soldadorActividadId: json["SoldadorActividadId"]);
}

class ResponseSaveWelder {
  String soldadorId;
  String soldadorActividadId;

  ResponseSaveWelder({
    this.soldadorActividadId,
    this.soldadorId,
  });

  factory ResponseSaveWelder.fromJson(Map<String, dynamic> json) =>
      ResponseSaveWelder(
          soldadorId: json["SoldadorId"],
          soldadorActividadId: json["SoldadorActividadId"]);
}

class ResponseSaveTrazability {
  String soldadorActividadId;
  String soldadorId;
  String idTrazabilidad;
  int numero;
  dynamic volumen;
  String noPlanInspection;
  int regBorrado;

  ResponseSaveTrazability({
    this.idTrazabilidad,
    this.noPlanInspection,
    this.numero,
    this.regBorrado,
    this.soldadorActividadId,
    this.soldadorId,
    this.volumen,
  });

  factory ResponseSaveTrazability.fromJson(Map<String, dynamic> json) =>
      ResponseSaveTrazability(
          soldadorActividadId: json["SoldadorActividadId"],
          soldadorId: json["SoldadorId"],
          idTrazabilidad: json["IdTrazabilidad"],
          numero: json["Numero"],
          volumen: json["Volumen"],
          noPlanInspection: json["NoPlanInspeccion"],
          regBorrado: json["RegBorrado"]);
}

class RptRIAHeader {
  String obra;
  String noReporte;
  String contrato;
  String ot;
  String instalacion;
  String embarcacion;
  String fecha;
  String noPlanInspeccion;
  String nombreElabora;
  String nombreAprueba;
  String nombreRevisa;
  String puestoRevisa;
  String puestoElabora;
  String puestoAprueba;

  RptRIAHeader({
    this.puestoAprueba,
    this.puestoRevisa,
    this.puestoElabora,
    this.nombreAprueba,
    this.nombreElabora,
    this.nombreRevisa,
    this.contrato,
    this.embarcacion,
    this.fecha,
    this.instalacion,
    this.noPlanInspeccion,
    this.noReporte,
    this.obra,
    this.ot,
  });

  factory RptRIAHeader.fromJson(Map<String, dynamic> json) => RptRIAHeader(
      puestoElabora: json["PuestoElabora"],
      puestoRevisa: json["PuestoRevisa"],
      puestoAprueba: json["PuestoAprueba"],
      nombreRevisa: json["Revisa"],
      nombreAprueba: json["Aprueba"],
      nombreElabora: json["Elabora"],
      contrato: json["Contrato"],
      noReporte: json["NoReporte"],
      embarcacion: json["Embarcacion"],
      fecha: json['Fecha'] == ''
          ? ''
          : DateFormat('dd/MM/yyyy').format(DateTime.parse(json['Fecha'])),
      instalacion: json["Instalacion"],
      noPlanInspeccion: json["NoPlanInspeccion"],
      ot: json["OT"],
      obra: json["Obra"]);
}

class RptRIAList {
  String noPlanInspection;
  String siteId;
  dynamic propuestaTecnicaId;
  dynamic actividadId;
  dynamic subActividadId;
  dynamic reprogramacionOTId;
  String partidaInterna;
  String actividad;
  String folio;
  String frente;
  String especialidad;
  String sistema;
  String plano;
  String procedimiento;

  List<RptMaterialesReportados> listMaterialsReports;

  RptRIAList({
    this.actividad,
    this.actividadId,
    this.especialidad,
    this.folio,
    this.frente,
    this.noPlanInspection,
    this.partidaInterna,
    this.plano,
    this.procedimiento,
    this.propuestaTecnicaId,
    this.reprogramacionOTId,
    this.sistema,
    this.siteId,
    this.subActividadId,
    this.listMaterialsReports,
  });

  factory RptRIAList.fromJson(Map<String, dynamic> json) => RptRIAList(
      actividad: json["Actividad"],
      actividadId: json["ActividadId"],
      especialidad: json["Especialidad"],
      folio: json["Folio"],
      frente: json["Frente"],
      noPlanInspection: json["NoPlanInspeccion"],
      partidaInterna: json["NoPlanInspeccion"],
      plano: json["Plano"],
      procedimiento: json["Procedimiento"],
      propuestaTecnicaId: json["PropuestaTecnicaId"],
      reprogramacionOTId: json["ReprogramacionOTId"],
      sistema: json["Sistema"],
      siteId: json["SiteId"],
      subActividadId: json["SubActividadId"]);
}

class RptMaterialesReportados {
  String noPlanInspection;
  String siteId;
  String materialId;
  String descripcion;
  String idTrazabilidad;
  String result;
  String fechaInspeccion;
  String observaciones;

  RptMaterialesReportados({
    this.noPlanInspection,
    this.siteId,
    this.descripcion,
    this.fechaInspeccion,
    this.idTrazabilidad,
    this.materialId,
    this.observaciones,
    this.result,
  });

  factory RptMaterialesReportados.fromJson(Map<String, dynamic> json) =>
      RptMaterialesReportados(
        siteId: json["SiteId"],
        noPlanInspection: json["NoPlanInspeccion"],
        descripcion: json["Descripcion"],
        fechaInspeccion: json['FechaInspeccion'] == ''
            ? ''
            : DateFormat.yMd()
                .add_jm()
                .format(DateTime.parse(json["FechaInspeccion"])),
        idTrazabilidad: json["IdTrazabilidad"],
        materialId: json["MaterialId"],
        observaciones: json["Observaciones"],
        result: json["Resultado"],
      );
}

class RptRIAModel {
  RptRIAHeader rptRIAHeader;
  List<RptRIAList> rptRIAList;

  RptRIAModel({this.rptRIAHeader, this.rptRIAList});
}

// ActividadesPT

class ActividadesPT {
  String siteId;
  dynamic propuestaTecnicaId;
  dynamic actividadId;
  dynamic subActividadId;
  dynamic reprogramacionOT;

  ActividadesPT(
    this.actividadId,
    this.propuestaTecnicaId,
    this.reprogramacionOT,
    this.siteId,
    this.subActividadId,
  );
}

class ResInsRIA {
  String consecutivoFolio;
  String riaID;

  ResInsRIA({this.consecutivoFolio, this.riaID});
}
