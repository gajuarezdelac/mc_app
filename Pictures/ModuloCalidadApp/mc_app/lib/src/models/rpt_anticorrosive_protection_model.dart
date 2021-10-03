import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

class DataTableDymanic {
  String orden;
  String rowDescription;
  String dynamicColumnHeader;
  String value;
  int oa;

  DataTableDymanic(
      {this.orden,
      this.rowDescription,
      this.dynamicColumnHeader,
      this.value,
      this.oa});

  factory DataTableDymanic.fromJson(Map<String, dynamic> json) =>
      DataTableDymanic(
        orden: json['Orden'],
        rowDescription: json['RowDescription'],
        dynamicColumnHeader: json['DynamicColumnHeader'],
        value: json['Value'],
        oa: json['OA'],
      );
}

class PlaneRecordsModel {
  String orden;
  String orden2;
  String ubicacion;
  String concepto;
  String localizacion;
  String planoDetalle;
  String liberacion;
  String observaciones;
  String fecha1;
  String fecha2;
  String fecha3;

  PlaneRecordsModel({
    this.orden,
    this.orden2,
    this.ubicacion,
    this.concepto,
    this.localizacion,
    this.planoDetalle,
    this.liberacion,
    this.observaciones,
    this.fecha1,
    this.fecha2,
    this.fecha3,
  });

  factory PlaneRecordsModel.fromJson(Map<String, dynamic> json) =>
      PlaneRecordsModel(
        orden: json['Orden'],
        orden2: json['Orden2'],
        ubicacion: json['Ubicacion'],
        concepto: json['Concepto'],
        localizacion: json['Localizacion'],
        planoDetalle: json['PlanoDetalle'],
        liberacion: json['Liberacion'] == ''
            ? ''
            : DateFormat('dd.MM.yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(json['Liberacion'])),
        observaciones: json['Observaciones'],
        fecha1: json['Fecha1'] == ''
            ? ''
            : DateFormat('dd.MM.yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(json['Fecha1'])),
        fecha2: json['Fecha2'] == ''
            ? ''
            : DateFormat('dd.MM.yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(json['Fecha2'])),
        fecha3: json['Fecha3'] == ''
            ? ''
            : DateFormat('dd.MM.yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(json['Fecha3'])),
      );
}

class DataWithList {
  String isometrico;
  String planoDetalle;
  List<String> listConcepto;
  double heightIsoPlano;
  double heightConcepto;

  DataWithList(
      {this.isometrico,
      this.planoDetalle,
      this.listConcepto,
      this.heightIsoPlano,
      this.heightConcepto});
}

class PlaneRecordsColumns {
  List<pw.Widget> listIsometrico;
  List<pw.Widget> listPlanoDetalle;
  List<pw.Widget> listConcepto;
  List<pw.Widget> listPrimario;
  List<pw.Widget> listEnlace;
  List<pw.Widget> listAcabado;
  List<pw.Widget> listLiberado;
  PlaneRecordsColumns(
      {this.listIsometrico,
      this.listPlanoDetalle,
      this.listConcepto,
      this.listPrimario,
      this.listEnlace,
      this.listAcabado,
      this.listLiberado});
}

class StagesModel {
  int filaId;
  String etapa;
  int orden;

  StagesModel({this.filaId, this.etapa, this.orden});

  factory StagesModel.fromJson(Map<String, dynamic> json) => StagesModel(
      filaId: json['FilaId'], etapa: json['Etapa'], orden: json['Orden']);
}
