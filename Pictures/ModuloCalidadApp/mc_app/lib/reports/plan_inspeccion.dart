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

Future<void> planInspeccion(BuildContext context, String noPlanInspection,
    RptInspectionPlanModel model) async {
  final image = await imageFromAssetBundle('assets/img/logo_cotemar.png');

  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
        pageFormat: PdfPageFormat.a4
            .copyWith(marginBottom: 1.5 * PdfPageFormat.cm)
            .landscape,
        header: (pw.Context context) => pw.Column(children: <pw.Widget>[
              pw.Container(
                height: 80.0,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    width: 1,
                  ),
                ),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Container(
                          margin: pw.EdgeInsets.only(left: 10.0, top: 10.0),
                          child: pw.Image(image, width: 75.5, height: 75.5)),
                      pw.Container(
                          margin: pw.EdgeInsets.only(top: 20.0),
                          child: pw.Column(children: <pw.Widget>[
                            pw.Text('SUBDIRECCIÓN DE SERVICIOS PETROLEROS',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 10.0)),
                            pw.Text('PLAN DE INSPECCIÓN',
                                style: pw.TextStyle(fontSize: 10.0))
                          ])),
                      pw.Container(
                        padding: pw.EdgeInsets.all(9.0),
                        height: 60.0,
                        margin: pw.EdgeInsets.only(right: 20.0, top: 10.0),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            width: 1,
                          ),
                        ),
                        child: pw.Row(children: <pw.Widget>[
                          pw.Column(children: <pw.Widget>[
                            pw.Text('CODIGO:    ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 6.0)),
                            pw.Text('REF:   ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 6.0)),
                            pw.Text('REV:   ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 6.0)),
                            pw.Text('FECHA:   ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 6.0)),
                          ]),
                          pw.Column(children: <pw.Widget>[
                            pw.Text('SSP-EJE-FOR-001',
                                style: pw.TextStyle(fontSize: 6.0)),
                            pw.Text('SSP-EJE-FOR-001',
                                style: pw.TextStyle(fontSize: 6.0)),
                            pw.Text('01', style: pw.TextStyle(fontSize: 6.0)),
                            pw.Text('14-JULIO-2015',
                                style: pw.TextStyle(fontSize: 6.0))
                          ])
                        ]),
                      ),
                    ]),
              ),
              secondPartHeader(context, model),
              pw.Container(margin: pw.EdgeInsets.only(bottom: 10.0))
            ]),
        build: (pw.Context context) => <pw.Widget>[body(context, model)],
        footer: (pw.Context context) => footer(model)),
  );

  Future<Uint8List> pdf2 = pdf.save();

  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (_) => PDFViewer(
              path: pdf2,
              titlePDF: 'Reporte ${model.element.noPlanInspection}',
              canChangeOrientation: true,
            )),
  );
}

pw.Container secondPartHeader(
    pw.Context context, RptInspectionPlanModel model) {
  return pw.Container(
    decoration: pw.BoxDecoration(
      border: pw.Border.all(
        width: 1,
      ),
    ),
    child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Expanded(
            flex: 1,
            child: pw.Container(
                padding: pw.EdgeInsets.only(
                    right: 10.0, left: 10.0, top: 10, bottom: 10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    width: 1,
                  ),
                ),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Row(children: <pw.Widget>[
                        rw.widgetField(
                            'Contrato', '${model.element.contratoId}', 0, 8),
                      ]),
                      pw.Row(children: <pw.Widget>[
                        rw.widgetField('OT', '${model.element.ot}', 0, 8),
                      ]),
                      pw.Row(children: <pw.Widget>[
                        rw.widgetField('Instalación',
                            '${model.element.instalacion}', 0, 8),
                      ]),
                      pw.Row(children: <pw.Widget>[
                        rw.widgetField('Embarcación',
                            '${model.element.embarcacion}', 0, 8),
                      ])
                    ])),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Container(
                padding: pw.EdgeInsets.only(
                    right: 30.0, left: 30.0, top: 20, bottom: 13),
                decoration: pw.BoxDecoration(
                    border: pw.Border(
                  left: pw.BorderSide(
                    color: PdfColors.black,
                    width: 1,
                  ),
                  top: pw.BorderSide(
                    color: PdfColors.black,
                    width: 1,
                  ),
                  right: pw.BorderSide(
                    color: PdfColors.black,
                    width: 1,
                  ),
                  // bottom: pw.BorderSide(
                  //   color: PdfColors.orange,
                  //   width: 2,
                  // ),
                )),
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Text('OBRA:',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 6)),
                      pw.SizedBox(height: 5),
                      pw.Text('${model.element.obra}',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 6))
                    ])),
          ),
          pw.Expanded(
              flex: 1,
              child: pw.Container(
                  padding: pw.EdgeInsets.only(
                      right: 10.0, left: 10.0, top: 10, bottom: 10),
                  decoration: pw.BoxDecoration(
                      border: pw.Border(
                    left: pw.BorderSide(
                      color: PdfColors.black,
                      width: 1,
                    ),
                    top: pw.BorderSide(
                      color: PdfColors.black,
                      width: 1,
                    ),
                    right: pw.BorderSide(
                      color: PdfColors.black,
                      width: 1,
                    ),
                    // bottom: pw.BorderSide(
                    //   color: PdfColors.orange,
                    //   width: 2,
                    // ),
                  )),
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: <pw.Widget>[
                        pw.Row(children: <pw.Widget>[
                          rw.widgetField(
                              'Hoja:  ',
                              (context.pageNumber).toString() +
                                  '  DE  ' +
                                  (context.pagesCount).toString(),
                              0,
                              8),
                        ]),
                        pw.Row(children: <pw.Widget>[
                          rw.widgetField('NO. REPORTE: ',
                              '${model.element.noPlanInspection}', 0, 8),
                        ]),
                        pw.Row(children: <pw.Widget>[
                          rw.widgetField('FECHA: ',
                              '${model.element.fechaCreacion}', 0, 8),
                        ])
                      ])))
        ]),
  );
}

pw.Table body(pw.Context context, RptInspectionPlanModel model) {
  return pw.Table(
    border: pw.TableBorder.all(),
    defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
    children: [
      pw.TableRow(children: [
        cellHeader('No. DE ACTIVIDAD/\nPARTIDA', 20),
        cellHeader('DESCRIPCIÓN', 40),
        cellHeader('TIPO DE\nINSPECCIÓN\n(PIO/PV)', 20),
        cellHeader('TECNICAS DE\nINSPECCIÓN'),
        cellHeader('PROCEDIMIENTO/ \n NORMATIVIDAD'),
        cellHeader('DIBUJO DE\nREFERENCIA'),
        cellHeader('FREC./\nPORC.', 15),
        cellHeader('REGISTRO'),
        cellHeader('PERSONAL\n RESPONSABLE'),
        cellHeader('EQUIPO A\nUTILIZAR'),
        cellHeader('FOLIO', 20),
        cellHeader('ESPECIALIDAD'),
        cellHeader('SISTEMA', 35),
        cellHeader('FRENTE', 20),
      ]),
      for (var i = 0; i < model.list.length; i++) celdas(model.list[i]),
    ],
  );
}

pw.TableRow celdas(RtpInspectionPlanList e) {
  return pw.TableRow(children: <pw.Widget>[
    cellHeader(e.partidaInterna, 20),
    cellHeader(e.descripcion.replaceAll("”", '"'), 40),
    cellHeader(e.tipoInspeccion, 20),
    cellHeader(e.tecnicas),
    cellHeader(e.procedimientos),
    cellHeader(e.planos),
    cellHeader(e.frecuencia, 15),
    cellHeader(e.formatos),
    cellHeader(e.responsable),
    cellHeader(e.equipos),
    cellHeader(e.folio, 20),
    cellHeader(e.especialidad),
    cellHeader(e.sistema, 35),
    cellHeader(e.frente, 20),
  ]);
}

pw.Container cellHeader(String title, [double widthCell = 30]) {
  return pw.Container(
    width: widthCell,
    padding: pw.EdgeInsets.all(2),
    child: pw.Column(children: [
      pw.Text(title,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 5.0))
    ]),
  );
}

pw.Container footer(RptInspectionPlanModel model) {
  return pw.Container(
      padding: pw.EdgeInsets.only(top: 20),
      child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: <pw.Widget>[
            firm('Elabora', model.element.elabora, model.element.puestoElabora),
            firm('Valida', model.element.revisa, model.element.puestoRevisa),
            firm('Aprueba', model.element.aprueba, model.element.puestoAprueba),
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
