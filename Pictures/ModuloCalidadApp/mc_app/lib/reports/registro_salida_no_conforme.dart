import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';
import 'package:mc_app/src/widgets/report_widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:async';
import 'dart:typed_data';
import 'package:mc_app/src/widgets/pdf_viewer.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart' as npdf;

ReportWidgets rw = new ReportWidgets();

Future<void> registroSalidaNoConforme(BuildContext context,
    RptNonCompliantOutputModel rptNonCompliantOutput) async {
  final image =
      await imageFromAssetBundle('assets/img/logo_cotemar_horizontal_azul.png');

  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4
          .copyWith(marginBottom: 1.5 * PdfPageFormat.cm)
          .portrait,
      header: (pw.Context context) => pw.Container(
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
                  margin: pw.EdgeInsets.only(left: 20.0, top: 20.0, right: 5.0),
                  child: pw.Image(image, width: 90.5, height: 90.5)),
              pw.Container(
                  margin: pw.EdgeInsets.only(top: 20.0, right: 5.0),
                  child: pw.Column(children: <pw.Widget>[
                    pw.Text('REGISTRO DE SALIDA NO CONFORME',
                        style: pw.TextStyle(
                            fontSize: 9.0, fontWeight: pw.FontWeight.bold))
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
                    pw.Text('CODIGO:    ', style: rw.fontWeightBold(8.0)),
                    pw.Text('REF:   ', style: rw.fontWeightBold(8.0)),
                    pw.Text('REV:   ', style: rw.fontWeightBold(8.0)),
                    pw.Text('FECHA:   ', style: rw.fontWeightBold(8.0)),
                  ]),
                  pw.Column(children: <pw.Widget>[
                    pw.Text('SSP-CCA-FOR-009',
                        style: pw.TextStyle(fontSize: 8.0)),
                    pw.Text('SSP-CCA-PRO-019',
                        style: pw.TextStyle(fontSize: 8.0)),
                    pw.Text('05', style: pw.TextStyle(fontSize: 8.0)),
                    pw.Text('01-FEBRERO-2021',
                        style: pw.TextStyle(fontSize: 8.0))
                  ])
                ]),
              ),
            ]),
      ),
      build: (pw.Context context) => <pw.Widget>[
        part2(context, rptNonCompliantOutput),
        part3(context, rptNonCompliantOutput),
        part4(context, rptNonCompliantOutput),
        part5(context, rptNonCompliantOutput),
        part6(context, rptNonCompliantOutput),
        part7(context, rptNonCompliantOutput),
        part8(context, rptNonCompliantOutput),
        part9(context, rptNonCompliantOutput),
        part10(context, rptNonCompliantOutput)
      ],
    ),
  );

  //Agregar archivos adjuntos a pdf
  if (rptNonCompliantOutput.documentsRpt.isNotEmpty) {
    for (var i = 0; i < rptNonCompliantOutput.documentsRpt.length; i++) {
      final document = await npdf.PdfDocument.openData(
          base64Decode(rptNonCompliantOutput.documentsRpt[i].data));

      for (var j = 1; j <= document.pagesCount; j++) {
        final page = await document.getPage(j);
        final pageImage = await page.render(
          width: page.width,
          height: page.height,
          format: npdf.PdfPageFormat.JPEG,
        );

        pdf.addPage(pw.Page(
            build: (pw.Context context) => pw.Image(
                  pw.MemoryImage(pageImage.bytes),
                )));

        await page.close();
      }
    }
  }

  Future<Uint8List> pdf2 = pdf.save();

  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (_) => PDFViewer(
              path: pdf2,
              titlePDF: 'Reporte: Salida No Conforme',
              canChangeOrientation: false,
            )),
  );
}

pw.Container part2(
    pw.Context context, RptNonCompliantOutputModel rptNonCompliantOutput) {
  return pw.Container(
    height: 80.0,
    decoration: pw.BoxDecoration(
      border: pw.Border.all(
        width: 1,
      ),
    ),
    child: pw.Row(children: <pw.Widget>[
      pw.Container(
          margin: pw.EdgeInsets.only(left: 5.0, top: 10.0),
          child: pw.Row(children: <pw.Widget>[
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: <pw.Widget>[
                  pw.Row(children: <pw.Widget>[
                    pw.Text('DETECTA',
                        style: pw.TextStyle(
                            fontStyle: pw.FontStyle.italic, fontSize: 5.0)),
                    pw.Container(margin: pw.EdgeInsets.only(right: 5.0))
                  ])
                ]),
            rw.dottedLine(),
            pw.Column(children: <pw.Widget>[
              pw.Container(margin: pw.EdgeInsets.only(top: 5.0)),
              rw.widgetField2(
                  'Nombre: ',
                  'ING. ' +
                      (rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                          ? rptNonCompliantOutput
                              .listSalidaNoConforme[0].detecta
                          : ''),
                  110,
                  100),
              pw.Container(margin: pw.EdgeInsets.only(top: 27.0)),
              rw.widgetField2('Firma: ', '\n\n', 115, 100)
            ]),
            pw.Container(margin: pw.EdgeInsets.only(right: 5.0)),
            rw.dottedLine(),
            pw.Column(children: <pw.Widget>[
              pw.Container(margin: pw.EdgeInsets.only(top: 5.0)),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: <pw.Widget>[
                    rw.widgetField2(
                        'Departamento: ', 'Control de Calidad', 58, 50),
                    rw.widgetField2(
                        'Fecha: ',
                        (rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                            ? rptNonCompliantOutput
                                .listSalidaNoConforme[0].fecha
                            : ''),
                        44),
                    rw.widgetField2(
                        'Consecutivo: ',
                        (rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                            ? rptNonCompliantOutput
                                .listSalidaNoConforme[0].consecutivo
                            : ''),
                        75,
                        67)
                  ]),
              pw.Container(margin: pw.EdgeInsets.only(top: 20.0)),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: <pw.Widget>[
                    rw.widgetField2('INSTALACIÓN\n/EMBARCACIÓN: ',
                        'KM 10.5 AKAL-G dsa ads adsdsa wwedes', 40, 33),
                    rw.widgetField2(
                        'Contrato: ',
                        (rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                            ? rptNonCompliantOutput
                                .listSalidaNoConforme[0].contratoId
                            : ''),
                        33),
                    rw.widgetField2(
                        'OT/\nFOLIO/\nOBRA: ',
                        (rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                            ? rptNonCompliantOutput.listSalidaNoConforme[0].ot
                            : ''),
                        28),
                    rw.widgetField2(
                        'PLANO/\nISOMETRICO/\nDTI: ',
                        (rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                            ? rptNonCompliantOutput
                                .listSalidaNoConforme[0].plano
                            : ''),
                        36,
                        30)
                  ]),
            ])
          ])),
    ]),
  );
}

pw.Container part3(
    pw.Context context, RptNonCompliantOutputModel rptNonCompliantOutput) {
  return pw.Container(
      height: 70.0,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          width: 1,
        ),
      ),
      child: pw.Container(
          margin: pw.EdgeInsets.only(left: 10, top: -30),
          child: pw.Row(children: <pw.Widget>[
            pw.Text('DESCRIPCIÓN DE LA ACTIVIDAD: ',
                style: pw.TextStyle(fontSize: 6)),
            pw.Text(
                rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                    ? rptNonCompliantOutput
                        .listSalidaNoConforme[0].descripcionActividad
                    : '',
                style: pw.TextStyle(fontSize: 6))
          ])));
}

pw.Row part4(
    pw.Context context, RptNonCompliantOutputModel rptNonCompliantOutput) {
  return pw.Row(children: <pw.Widget>[
    pw.Container(
        height: 30,
        width: 241,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            width: 1,
          ),
        ),
        child: pw.Column(children: <pw.Widget>[
          pw.Container(
              margin: pw.EdgeInsets.only(top: 1),
              width: 239.5,
              decoration: pw.BoxDecoration(color: PdfColors.grey400),
              alignment: pw.Alignment.topCenter,
              child: pw.Text('APLICA A:',
                  style: pw.TextStyle(
                      fontSize: 5, fontWeight: pw.FontWeight.bold))),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: <pw.Widget>[
                rw.widgetCheckWithText(
                    false,
                    'PREFABRICADOS',
                    rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                        ? rptNonCompliantOutput
                            .listSalidaNoConforme[0].prefabricado
                        : ''),
                rw.widgetCheckWithText(
                    false,
                    'INSTALACIÓN',
                    rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                        ? rptNonCompliantOutput
                            .listSalidaNoConforme[0].instalacion
                        : ''),
                rw.widgetCheckWithText(
                    false,
                    'SERVIVIO',
                    rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                        ? rptNonCompliantOutput.listSalidaNoConforme[0].servicio
                        : '')
              ])
        ])),
    pw.Container(
        height: 30,
        width: 241,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            width: 1,
          ),
        ),
        child: pw.Column(children: <pw.Widget>[
          pw.Container(
              margin: pw.EdgeInsets.only(top: 1),
              width: 239.5,
              decoration: pw.BoxDecoration(color: PdfColors.grey400),
              alignment: pw.Alignment.topCenter,
              child: pw.Text('ATRIBUIBLE A:',
                  style: pw.TextStyle(
                      fontSize: 5, fontWeight: pw.FontWeight.bold))),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: <pw.Widget>[
                rw.widgetCheckWithText(
                    false,
                    'COTEMAR',
                    rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                        ? rptNonCompliantOutput.listSalidaNoConforme[0].cotemar
                        : ''),
                rw.widgetCheckWithText(
                    false,
                    'CLIENTE',
                    rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                        ? rptNonCompliantOutput.listSalidaNoConforme[0].cliente
                        : ''),
                rw.widgetCheckWithText(
                    false,
                    'SUBCONTRATISTA',
                    rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                        ? rptNonCompliantOutput
                            .listSalidaNoConforme[0].subcontratista
                        : '')
              ])
        ]))
  ]);
}

pw.Container part5(
    pw.Context context, RptNonCompliantOutputModel rptNonCompliantOutput) {
  return pw.Container(
    height: 90,
    width: 482,
    decoration: pw.BoxDecoration(
        border: pw.Border.all(
      width: 1,
    )),
    child: pw.Column(children: <pw.Widget>[
      pw.Container(
          margin: pw.EdgeInsets.only(top: 1),
          width: 480,
          decoration: pw.BoxDecoration(color: PdfColors.grey400),
          alignment: pw.Alignment.topCenter,
          child: pw.Text('DETALLE DE LA NO CONFOMIDAD:',
              style: rw.fontWeightBold(5))),
      pw.Container(margin: pw.EdgeInsets.only(top: 5)),
      pw.Row(children: <pw.Widget>[
        pw.Container(margin: pw.EdgeInsets.only(left: 15)),
        pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: <pw.Widget>[
              pw.Text('REQUISITO INCUMPLIDO:', style: rw.fontWeightBold(6)),
              pw.Text('(Cláusula, Norma, Código, Procedimiento, Especiicación',
                  style: rw.fontWeightBold(4)),
              pw.Text('del Cliente, Requisito Legal, Otro.)',
                  style: rw.fontWeightBold(4))
            ]),
        pw.Container(margin: pw.EdgeInsets.only(left: 5)),
        pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: <pw.Widget>[
              pw.Container(margin: pw.EdgeInsets.only(top: 10)),
              pw.Text(
                  rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                      ? rptNonCompliantOutput.listSalidaNoConforme[0].requisito
                      : '',
                  style: pw.TextStyle(fontSize: 5)),
              rw.widgetUnderline(330)
            ])
      ]),
      pw.Container(margin: pw.EdgeInsets.only(top: 10)),
      pw.Row(children: <pw.Widget>[
        pw.Container(margin: pw.EdgeInsets.only(left: 40)),
        pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: <pw.Widget>[
              pw.Text('FALLA O INCUMPLIMIENTO:', style: rw.fontWeightBold(6)),
              pw.Text('(Acción realizada contraria al requisito)',
                  style: rw.fontWeightBold(4)),
            ]),
        pw.Container(margin: pw.EdgeInsets.only(left: 5)),
        pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: <pw.Widget>[
              pw.Container(margin: pw.EdgeInsets.only(top: 10)),
              pw.Text(
                  rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                      ? rptNonCompliantOutput.listSalidaNoConforme[0].falla
                      : '',
                  style: pw.TextStyle(fontSize: 5)),
              rw.widgetUnderline(330)
            ])
      ]),
      pw.Container(margin: pw.EdgeInsets.only(top: 10)),
      pw.Row(children: <pw.Widget>[
        pw.Container(margin: pw.EdgeInsets.only(left: 10)),
        pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: <pw.Widget>[
              pw.Text('EVIDENCIA DE INCUMPLIMIENTO:',
                  style: rw.fontWeightBold(6)),
              pw.Text('(Cualquier documento o hecho que demuestre la falta de',
                  style: rw.fontWeightBold(4)),
              pw.Text('cumplimiento al requisito)', style: rw.fontWeightBold(4))
            ]),
        pw.Container(margin: pw.EdgeInsets.only(left: 5)),
        pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: <pw.Widget>[
              pw.Container(margin: pw.EdgeInsets.only(top: 10)),
              pw.Text(
                  rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                      ? rptNonCompliantOutput.listSalidaNoConforme[0].evidencia
                      : '',
                  style: pw.TextStyle(fontSize: 5)),
              rw.widgetUnderline(330)
            ])
      ])
    ]),
  );
}

pw.Container part6(
    pw.Context context, RptNonCompliantOutputModel rptNonCompliantOutput) {
  return pw.Container(
      height: 43,
      width: 482,
      decoration: pw.BoxDecoration(
          border: pw.Border.all(
        width: 1,
      )),
      child: pw.Row(children: <pw.Widget>[
        pw.Column(children: <pw.Widget>[
          pw.Container(
              margin: pw.EdgeInsets.only(top: 8, left: 7),
              width: 60,
              height: 20,
              decoration: pw.BoxDecoration(color: PdfColors.grey400),
              alignment: pw.Alignment.center,
              child: pw.Text('DISPOSICIÓN:', style: rw.fontWeightBold(5)))
        ]),
        pw.Column(children: <pw.Widget>[
          pw.Row(children: <pw.Widget>[
            pw.Column(children: <pw.Widget>[
              pw.Container(margin: pw.EdgeInsets.only(top: 8)),
              rw.widgetField2(
                  '1.- CONCESIÓN No: ',
                  rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                      ? (rptNonCompliantOutput
                                      .listSalidaNoConforme[0].noConcesion ==
                                  null ||
                              rptNonCompliantOutput
                                      .listSalidaNoConforme[0].noConcesion ==
                                  '')
                          ? '\n\n'
                          : rptNonCompliantOutput
                              .listSalidaNoConforme[0].noConcesion
                      : '',
                  35,
                  37)
            ]),
            pw.Container(margin: pw.EdgeInsets.only(right: 20)),
            rw.widgetCheckWithText(
                true,
                '2.- RECHAZO: ',
                rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                    ? rptNonCompliantOutput.listSalidaNoConforme[0].rechazo
                    : '',
                10),
            pw.Container(margin: pw.EdgeInsets.only(right: 20)),
            rw.widgetCheckWithText(
                true,
                '3.- DEVUELTO AL CLIENTE: ',
                rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                    ? rptNonCompliantOutput.listSalidaNoConforme[0].devuelto
                    : '',
                10),
            pw.Container(margin: pw.EdgeInsets.only(right: 20)),
            rw.widgetCheckWithText(
                true,
                '4.- CORRECCIÓN: ',
                rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                    ? rptNonCompliantOutput.listSalidaNoConforme[0].correccion
                    : '',
                10)
          ]),
          pw.Container(
              margin: pw.EdgeInsets.only(left: 1, top: 8),
              child: pw.Row(children: <pw.Widget>[
                pw.Text('5.- OTRA (DESCRIBIR): ',
                    style: pw.TextStyle(fontSize: 5)),
                pw.Column(children: <pw.Widget>[
                  pw.Text(
                      (rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                          ? rptNonCompliantOutput
                                          .listSalidaNoConforme[0].otra ==
                                      null ||
                                  rptNonCompliantOutput
                                          .listSalidaNoConforme[0].otra ==
                                      ''
                              ? '\n\n'
                              : rptNonCompliantOutput
                                  .listSalidaNoConforme[0].otra
                          : ''),
                      style: pw.TextStyle(fontSize: 5)),
                  rw.widgetUnderline(302)
                ])
              ]))
        ])
      ]));
}

pw.Container part7(
    pw.Context context, RptNonCompliantOutputModel rptNonCompliantOutput) {
  return pw.Container(
      width: 482,
      decoration: pw.BoxDecoration(
        border: pw.Border(
            left: pw.BorderSide(width: 1),
            right: pw.BorderSide(width: 1),
            bottom: pw.BorderSide(width: 1)),
      ),
      child: pw.Column(children: <pw.Widget>[
        pw.Container(
            margin: pw.EdgeInsets.only(top: 1),
            width: 482,
            height: 10,
            decoration: pw.BoxDecoration(
                border: pw.Border(
                    left: pw.BorderSide(width: 1),
                    right: pw.BorderSide(width: 1)),
                color: PdfColors.grey400),
            alignment: pw.Alignment.topCenter,
            child: pw.Text('DESCRIPCIÓN DE LA DISPOSICIÓN:',
                style: rw.fontWeightBold(5))),
        pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Container(
                  width: 272,
                  decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                    width: 1,
                  )),
                  child: table1(rptNonCompliantOutput)),
              pw.Container(
                  width: 210,
                  child: pw.Column(children: <pw.Widget>[
                    pw.Container(
                        width: 210,
                        height: 12,
                        alignment: pw.Alignment.center,
                        decoration: pw.BoxDecoration(
                            border: pw.Border(
                          top: pw.BorderSide(
                            width: 1,
                          ),
                          right: pw.BorderSide(
                            width: 1,
                          ),
                        )),
                        child: pw.Text('RECURSOS PLANEADOS / UTILIZADOS',
                            style: rw.fontWeightBold(6))),
                    table2(rptNonCompliantOutput)
                  ]))
            ]),
        pw.Container(
            decoration: pw.BoxDecoration(
                border: pw.Border(
              left: pw.BorderSide(width: 1),
              right: pw.BorderSide(width: 1),
            )),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: <pw.Widget>[
                  firm(
                      'REALIZA DISPOSICIÓN',
                      rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                          ? rptNonCompliantOutput
                              .listSalidaNoConforme[0].responsable
                          : ''),
                  firm(
                      'AUTORIZA POSICIÓN',
                      rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                          ? rptNonCompliantOutput
                              .listSalidaNoConforme[0].autoriza
                          : ''),
                ]))
      ]));
}

pw.Container part8(
    pw.Context context, RptNonCompliantOutputModel rptNonCompliantOutput) {
  return pw.Container(
      height: 70.0,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          width: 1,
        ),
      ),
      child: pw.Column(children: <pw.Widget>[
        pw.Container(margin: pw.EdgeInsets.only(top: 5)),
        pw.Container(
            height: 25,
            width: 450,
            decoration: pw.BoxDecoration(color: PdfColors.grey400),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: <pw.Widget>[
                  pw.Text('RESULTADO DE LA REINSPECCIÓN',
                      style: rw.fontWeightBold(6)),
                  rw.widgetCheckWithText(
                      true,
                      'D/N',
                      rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                          ? rptNonCompliantOutput.listSalidaNoConforme[0].dn
                          : '',
                      5,
                      7),
                  rw.widgetCheckWithText(
                      true,
                      'F/N',
                      rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                          ? rptNonCompliantOutput.listSalidaNoConforme[0].fn
                          : '',
                      5,
                      7),
                  rw.widgetCheckWithText(
                      true,
                      'N/A',
                      rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                          ? rptNonCompliantOutput.listSalidaNoConforme[0].na
                          : '',
                      5,
                      7),
                ])),
        pw.Container(
            width: 450,
            margin: pw.EdgeInsets.only(top: 10),
            child: pw.Row(children: <pw.Widget>[
              pw.Text('EVIDENCIA DE LA CORRECCIÓN / INFORMACIÓN SOPORTE:',
                  style: pw.TextStyle(fontSize: 6)),
              pw.Container(
                  width: 277,
                  margin: pw.EdgeInsets.only(left: 4),
                  child: pw.Text(
                      rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                          ? rptNonCompliantOutput
                              .listSalidaNoConforme[0].informacionSoporte
                          : '',
                      style: pw.TextStyle(
                        fontSize: 6,
                      ))),
            ])),
        pw.Container(
            width: 450,
            margin: pw.EdgeInsets.only(top: 10),
            child: pw.Row(children: <pw.Widget>[
              pw.Text('FECHA DE CORRECCIÓN:', style: pw.TextStyle(fontSize: 6)),
              pw.Container(
                  width: 277,
                  margin: pw.EdgeInsets.only(left: 4),
                  child: pw.Text(
                      rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                          ? rptNonCompliantOutput
                              .listSalidaNoConforme[0].fechaCorreccion
                          : '',
                      style: pw.TextStyle(
                        fontSize: 6,
                      ))),
            ])),
      ]));
}

pw.Container part9(
    pw.Context context, RptNonCompliantOutputModel rptNonCompliantOutput) {
  return pw.Container(
      height: 80.0,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          width: 1,
        ),
      ),
      child: pw.Row(children: <pw.Widget>[
        firm2(
            'ING. ' +
                (rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                    ? rptNonCompliantOutput.listSalidaNoConforme[0].responsable
                    : ''),
            'ENTERADO',
            '(Responsable de ejecución)'),
        firm2(
            'ING. ' +
                (rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                    ? rptNonCompliantOutput.listSalidaNoConforme[0].detecta
                    : ''),
            'REINSPECCIÓN Y/O CIERRE',
            '(Detecta)')
      ]));
}

pw.Container part10(
    pw.Context context, RptNonCompliantOutputModel rptNonCompliantOutput) {
  return pw.Container(
      height: 30,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          width: 1,
        ),
      ),
      child: pw.Row(children: <pw.Widget>[
        pw.Container(
            height: 30,
            width: 238,
            alignment: pw.Alignment.centerLeft,
            decoration: pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(width: 1)),
                color: PdfColors.grey400),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Container(margin: pw.EdgeInsets.only(left: 6)),
                  pw.Text('Fecha de notificación de apertura:',
                      style: pw.TextStyle(fontSize: 6)),
                  pw.Container(
                    padding: pw.EdgeInsets.only(top: 4, left: 3),
                    height: 15,
                    width: 110,
                    margin: pw.EdgeInsets.only(left: 4),
                    decoration: pw.BoxDecoration(color: PdfColors.white),
                    child: pw.Text(
                        rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                            ? rptNonCompliantOutput
                                .listSalidaNoConforme[0].fecha
                            : '',
                        style: pw.TextStyle(
                          fontSize: 6,
                        )),
                  )
                ])),
        pw.Container(
            height: 30,
            width: 243.5,
            decoration: pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(width: 1)),
                color: PdfColors.grey400),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Container(margin: pw.EdgeInsets.only(left: 6)),
                  pw.Text('Fecha real de cierre / Recepción de cierre:',
                      style: pw.TextStyle(fontSize: 6)),
                  pw.Container(
                    padding: pw.EdgeInsets.only(top: 4, left: 3),
                    height: 15,
                    width: 110,
                    margin: pw.EdgeInsets.only(left: 4),
                    decoration: pw.BoxDecoration(color: PdfColors.white),
                    child: pw.Text(
                        rptNonCompliantOutput.listSalidaNoConforme.isNotEmpty
                            ? rptNonCompliantOutput
                                .listSalidaNoConforme[0].fechaRecepcionCierre
                            : '',
                        style: pw.TextStyle(
                          fontSize: 6,
                        )),
                  )
                ]))
      ]));
}

pw.Table table1(RptNonCompliantOutputModel rptNonCompliantOutput) {
  return pw.Table.fromTextArray(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: <int, pw.TableColumnWidth>{
        0: pw.FixedColumnWidth(90),
        1: pw.FixedColumnWidth(60),
        2: pw.FixedColumnWidth(50)
      },
      headerHeight: 28,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 5.5),
      headers: <String>[
        'ACCIONES',
        'RESPONSABLE',
        'FECHA DE EJECUCIÓN',
      ],
      data: descriptionProvision(rptNonCompliantOutput),
      cellAlignment: pw.Alignment.center,
      cellStyle: pw.TextStyle(fontSize: 6),
      cellHeight: (rptNonCompliantOutput.recursosPlaneados.length * 2) * 7.9);
}

List<List<String>> descriptionProvision(
    RptNonCompliantOutputModel rptNonCompliantOutput) {
  List<List<String>> lisListData = [];

  String acciones = '';
  String responsable = '';
  String fecha = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  rptNonCompliantOutput.listSalidaNoConforme.forEach((element) {
    acciones += element.acciones + '\n';
    responsable += element.responsable + '\n';
  });

  List<String> listData = [];
  listData.add(acciones);
  listData.add(responsable);
  listData.add(fecha);

  lisListData.add(listData);

  return lisListData;
}

List<List<String>> plannedResources(
    RptNonCompliantOutputModel rptNonCompliantOutput) {
  List<List<String>> lisListData = [];

  rptNonCompliantOutput.recursosPlaneados.forEach((element) {
    List<String> listData = [];
    listData.add(element.cantidad.toString());
    listData.add(element.puesto);
    listData.add(element.hrPlaneadas);
    listData.add(element.hrReales);

    lisListData.add(listData);
  });

  return lisListData;
}

pw.Table table2(RptNonCompliantOutputModel rptNonCompliantOutput) {
  return pw.Table.fromTextArray(
    border: pw.TableBorder.all(width: 1),
    columnWidths: <int, pw.TableColumnWidth>{
      0: pw.FixedColumnWidth(10),
      1: pw.FixedColumnWidth(10),
      2: pw.FixedColumnWidth(10),
      3: pw.FixedColumnWidth(10),
    },
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 5),
    headers: <String>[
      'CANTIDAD',
      'PUESTO',
      'H.H PLANEADAS',
      'H.H REALES',
    ],
    data: plannedResources(rptNonCompliantOutput),
    cellAlignment: pw.Alignment.center,
    cellStyle: pw.TextStyle(fontSize: 5),
  );
}

pw.Container firm(String title, name) {
  return pw.Container(
      height: 74,
      width: 241,
      child: pw.Column(children: <pw.Widget>[
        pw.Container(margin: pw.EdgeInsets.only(top: 5)),
        pw.Text(title, style: pw.TextStyle(fontSize: 6)),
        pw.Container(margin: pw.EdgeInsets.only(top: 10)),
        pw.Text('FRIMA X FRIMAS DASLNAS', style: pw.TextStyle(fontSize: 6)),
        rw.widgetUnderline(130),
        pw.Text(name, style: pw.TextStyle(fontSize: 6)),
        pw.Container(margin: pw.EdgeInsets.only(top: 10)),
        pw.Row(children: <pw.Widget>[
          pw.Container(margin: pw.EdgeInsets.only(left: 30)),
          pw.Text('Fecha', style: pw.TextStyle(fontSize: 6)),
          pw.Container(margin: pw.EdgeInsets.only(right: 8)),
          pw.Column(children: <pw.Widget>[
            pw.Text('12/21/3212', style: pw.TextStyle(fontSize: 6)),
            rw.widgetUnderline(130),
          ])
        ])
      ]));
}

pw.Container firm2(String name, title, subTitle) {
  return pw.Container(
      height: 74,
      width: 240,
      margin: pw.EdgeInsets.only(left: 1),
      child: pw.Column(children: <pw.Widget>[
        pw.Container(margin: pw.EdgeInsets.only(top: 30)),
        pw.Container(margin: pw.EdgeInsets.only(top: 10)),
        pw.Text(name, style: rw.fontWeightBold(6)),
        rw.widgetUnderline(130),
        pw.Text(title, style: pw.TextStyle(fontSize: 6)),
        pw.Text(subTitle, style: pw.TextStyle(fontSize: 6)),
      ]));
}
