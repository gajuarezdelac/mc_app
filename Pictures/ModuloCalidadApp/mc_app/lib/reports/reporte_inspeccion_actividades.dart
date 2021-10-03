import 'package:intl/intl.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/widgets/report_widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:async';
import 'dart:typed_data';
import 'package:mc_app/src/widgets/pdf_viewer.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

ReportWidgets rw = new ReportWidgets();
Future<void> rptInspeccionActividades(
    BuildContext context, String noPlanInspection, RptRIAModel riaModel) async {
  final image = await imageFromAssetBundle('assets/img/logo_cotemar.png');

  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
        pageFormat: PdfPageFormat.a4
            .copyWith(marginBottom: 1.5 * PdfPageFormat.cm)
            .landscape,
        header: (pw.Context context) => pw.Container(
              margin: pw.EdgeInsets.only(top: 10, bottom: 10),
              child: pw.Column(children: <pw.Widget>[
                headerLogo(context, image),
                firstPartHeader(context, riaModel),
              ]),
            ),
        build: (pw.Context context) => <pw.Widget>[
              for (var i = 0; i < riaModel.rptRIAList.length; i++)
                secondpart(riaModel.rptRIAList[i])
            ],
        footer: (pw.Context context) => footer(riaModel)),
  );

  Future<Uint8List> pdf2 = pdf.save();

  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (_) => PDFViewer(
              path: pdf2,
              titlePDF: 'PLAN DE INSPECCIÓN',
              canChangeOrientation: true,
            )),
  );
}

pw.Container genericCells(String title,
    [double widthCell = 30, bool isHeader = false]) {
  return pw.Container(
    width: widthCell,
    padding: pw.EdgeInsets.all(1),
    child: pw.Column(children: [
      pw.Text(title,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
              fontWeight: !isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: 7))
    ]),
  );
}

pw.Table secondpart(RptRIAList reportedItems) {
  return pw.Table(
      border: pw.TableBorder.all(),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        pw.TableRow(children: <pw.Widget>[
          genericCells('No. ACT/PDA', 3),
          genericCells('Descripcion Actividad', 50),
          genericCells('Folio', 3),
          genericCells('Frente', 3),
          genericCells('Especialidad', 3),
          genericCells('Sistema', 3),
          genericCells('Plano', 40),
          genericCells('Procedimiento o Dumentacion de Referencia', 25)
        ]),
        pw.TableRow(children: <pw.Widget>[
          genericCells(reportedItems.partidaInterna, 3, false),
          genericCells(reportedItems.actividad.toString()),
          genericCells(reportedItems.folio, 3, false),
          genericCells(reportedItems.frente, 3, false),
          genericCells(reportedItems.especialidad, 3, false),
          genericCells(reportedItems.sistema, 3, false),
          genericCells(reportedItems.plano, 3, false),
          genericCells(reportedItems.procedimiento, 25, false)
        ]),
        if (reportedItems.listMaterialsReports.length > 0)
          pw.TableRow(
              verticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: <pw.Widget>[
                genericCells('', 15),
                genericCells('C.SAP', 15),
                genericCells('Descripcion', 15),
                genericCells('Trazabilidad', 15),
                genericCells('Resultado Inspección', 15),
                genericCells('Fecha Inspección', 15),
                genericCells('Observación', 15),
                genericCells('', 15),
              ]),
        for (var lstreport in reportedItems.listMaterialsReports)
          pw.TableRow(
              verticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: <pw.Widget>[
                genericCells('', 15),
                genericCells(lstreport.materialId, 15, false),
                genericCells(lstreport.descripcion, 15, false),
                genericCells(lstreport.idTrazabilidad, 15, false),
                genericCells(lstreport.result, 15, false),
                genericCells(lstreport.fechaInspeccion, 15, false),
                genericCells(lstreport.observaciones, 15, false),
                genericCells('', 15, false),
              ]),
      ]);
}

pw.Container headerLogo(pw.Context context, pw.ImageProvider image) {
  return pw.Container(
    child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Container(
              margin: pw.EdgeInsets.only(left: 10.0, top: 10.0),
              child: pw.Image(image, width: 75.5, height: 75.5)),
          pw.Container(
            padding: pw.EdgeInsets.all(9.0),
            height: 60.0,
            margin: pw.EdgeInsets.only(right: 50.0, top: 10.0),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                width: 1,
              ),
            ),
            child: pw.Row(children: <pw.Widget>[
              pw.Column(children: <pw.Widget>[
                pw.Text('CODIGO:    ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8.0)),
                pw.Text('REF:   ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8.0)),
                pw.Text('REV:   ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8.0)),
                pw.Text('FECHA:   ',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 8.0)),
              ]),
              pw.Column(children: <pw.Widget>[
                pw.Text('SSP-EJE-FOR-001', style: pw.TextStyle(fontSize: 8.0)),
                pw.Text('SSP-EJE-FOR-001', style: pw.TextStyle(fontSize: 8.0)),
                pw.Text('01', style: pw.TextStyle(fontSize: 8.0)),
                pw.Text(DateFormat('dd-MMM-yyyy').format(DateTime.now()),
                    style: pw.TextStyle(fontSize: 8.0))
              ])
            ]),
          ),
        ]),
  );
}

pw.Container firstPartHeader(pw.Context context, RptRIAModel model) {
  return pw.Container(
    height: 100,
    width: 740,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(
        width: 1,
      ),
    ),
    child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: <pw.Widget>[
          pw.Container(
            height: 50,
            width: 400,
            margin: pw.EdgeInsets.only(top: 20.0),
            child: pw.Column(
              children: <pw.Widget>[
                pw.Text('SUBDIRECCIÓN DE SERVICIOS PETROLEROS',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 10.0)),
                pw.Text('REPORTES DE INSPECCIÓN DE ACTIVIDAD',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10.0)),
                pw.SizedBox(height: 10),
                pw.Text('${model.rptRIAHeader.obra}',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 6,
                    ))
              ],
            ),
          ),
          pw.Container(
              decoration: borderAll(),
              width: 300,
              child: pw.Column(children: <pw.Widget>[
                pw.Container(
                    height: 20,
                    width: 300,
                    padding: pw.EdgeInsets.all(5),
                    decoration: borderAll(),
                    alignment: pw.Alignment.topLeft,
                    child: pw.Row(children: <pw.Widget>[
                      pw.Text('HOJA:   ', style: rw.fontWeightBold(8.0)),
                      pw.Text(
                          (context.pageNumber).toString() +
                              '  DE  ' +
                              (context.pagesCount).toString(),
                          style: rw.fontWeightBold(8.0))
                    ])),
                pw.Container(
                  height: 20,
                  width: 300,
                  padding: pw.EdgeInsets.all(5),
                  decoration: borderAll(),
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Row(children: <pw.Widget>[
                    pw.Text('NO. Reporte:   ', style: rw.fontWeightBold(8.0)),
                    pw.Text(model.rptRIAHeader.noReporte,
                        style: rw.fontWeightBold(8.0))
                  ]),
                ),
                rowDoubleColumn('Contratos:  ', model.rptRIAHeader.contrato,
                    'Embarcaciones: ', model.rptRIAHeader.embarcacion, 160),
                rowDoubleColumn('Obra:  ', model.rptRIAHeader.ot, 'Fecha: ',
                    model.rptRIAHeader.fecha, 160),
                rowDoubleColumn('Intalación:  ', model.rptRIAHeader.instalacion,
                    'NO. Plan: ', model.rptRIAHeader.noPlanInspeccion, 160),
              ])),
        ]),
  );
}

pw.Container rowDoubleColumn(
    String title, String valueRow1, String title2, String valueRow2,
    [double titleWidth = 100]) {
  double widthValue = 300 - titleWidth;
  return pw.Container(
      decoration: borderAll(),
      width: 300,
      child: pw.Row(children: <pw.Widget>[
        pw.Container(
            height: 20,
            width: titleWidth,
            padding: pw.EdgeInsets.all(5),
            decoration: borderAll(),
            alignment: pw.Alignment.centerLeft,
            child: pw.Row(children: <pw.Widget>[
              pw.Text(title, style: rw.fontWeightBold(8.0)),
              pw.Text(valueRow1, style: rw.fontWeightBold(8.0))
            ])),
        pw.Container(
            height: 20,
            width: widthValue,
            padding: pw.EdgeInsets.all(5),
            decoration: borderAll(),
            alignment: pw.Alignment.centerLeft,
            child: pw.Row(children: <pw.Widget>[
              pw.Text(title2, style: rw.fontWeightBold(8.0)),
              pw.Text(valueRow2, style: rw.fontWeightBold(8.0))
            ])),
      ]));
}

borderAll() {
  return pw.BoxDecoration(
      border: pw.Border.all(
    width: 1,
  ));
}

pw.Container footer(RptRIAModel model) {
  return pw.Container(
      padding: pw.EdgeInsets.only(top: 20),
      child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: <pw.Widget>[
            firm('Elabora', model.rptRIAHeader.nombreElabora,
                model.rptRIAHeader.puestoElabora),
            firm('Valida', model.rptRIAHeader.nombreRevisa,
                model.rptRIAHeader.puestoRevisa),
            firm('Aprueba', model.rptRIAHeader.nombreAprueba,
                model.rptRIAHeader.puestoAprueba),
          ]));
}

pw.Container firm(String accion, String name, String puesto) {
  return pw.Container(
      width: 241,
      child: pw.Column(children: <pw.Widget>[
        pw.Container(margin: pw.EdgeInsets.only(top: 5)),
        pw.Text(name, style: pw.TextStyle(fontSize: 6)),
        rw.widgetUnderline(130),
        pw.Text(puesto, style: pw.TextStyle(fontSize: 6)),
        pw.Container(margin: pw.EdgeInsets.only(top: 10)),
        pw.Text(accion, style: pw.TextStyle(fontSize: 6)),
        pw.Container(margin: pw.EdgeInsets.only(top: 10)),
      ]));
}
