import 'dart:convert';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';
import 'package:mc_app/src/models/rpt_anticorrosive_protection_model.dart';
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

Future<void> proteccionAnticorrosiva(
    BuildContext context, RptAPModel rptAPModel) async {
  final pdf = pw.Document();

  final image =
      await imageFromAssetBundle('assets/img/logo_cotemar_horizontal_azul.png');

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat(8.5 * 72.0, 14.0 * PdfPageFormat.inch,
              marginAll: 2.0 * PdfPageFormat.cm)
          .copyWith(marginBottom: 1.5 * PdfPageFormat.cm)
          .portrait,
      header: (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Container(
                    height: 80.0,
                    child: pw.Column(children: <pw.Widget>[
                      pw.Row(children: <pw.Widget>[
                        pw.Container(
                            margin: pw.EdgeInsets.only(right: 5.0),
                            child: pw.Image(image, width: 120.5)),
                        pw.Container(
                            margin: pw.EdgeInsets.only(top: 30.0, right: 5.0),
                            child: pw.Column(children: <pw.Widget>[
                              pw.Text('SUBDIRECCIÓN DE SERVICIOS PETROLEROS',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 6.5)),
                              pw.Container(margin: pw.EdgeInsets.only(top: 10)),
                              pw.Text(
                                  'REGISTRO DE INSPECCIÓN DE PROTECCIÓN ANTICORROSIVA',
                                  style: pw.TextStyle(
                                      fontSize: 7.5,
                                      fontWeight: pw.FontWeight.bold))
                            ])),
                        pw.Container(
                          padding: pw.EdgeInsets.all(9.0),
                          height: 55.0,
                          margin: pw.EdgeInsets.only(right: 5),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                              width: 1,
                            ),
                          ),
                          child: pw.Row(children: <pw.Widget>[
                            pw.Column(children: <pw.Widget>[
                              pw.Text('CODIGO:    ',
                                  style: rw.fontWeightBold(6)),
                              pw.Text('REF:   ', style: rw.fontWeightBold(6)),
                              pw.Text('REV:   ', style: rw.fontWeightBold(6)),
                              pw.Text('FECHA:   ', style: rw.fontWeightBold(6)),
                            ]),
                            pw.Column(children: <pw.Widget>[
                              pw.Text('SSP-MYC-CCA-FO-002',
                                  style: pw.TextStyle(fontSize: 6)),
                              pw.Text('SSP-MYC-CCA-PG-002',
                                  style: pw.TextStyle(fontSize: 6)),
                              pw.Text('00', style: pw.TextStyle(fontSize: 6)),
                              pw.Text('31-MAYO-2018',
                                  style: pw.TextStyle(fontSize: 6))
                            ])
                          ]),
                        ),
                      ]),
                    ])),
                pw.Container(margin: pw.EdgeInsets.only(top: 12)),
                part1(context, rptAPModel.headerAP),
                pw.Container(margin: pw.EdgeInsets.only(top: 12)),
              ]),
      build: (pw.Context context) => <pw.Widget>[
            part2(rptAPModel.listConditionEnvironmentModel),
            pw.Container(margin: pw.EdgeInsets.only(top: 12)),
            part3(rptAPModel.headerAP),
            pw.Container(margin: pw.EdgeInsets.only(top: 12)),
            part4(rptAPModel.listAplicacionRecub),
            pw.Container(margin: pw.EdgeInsets.only(top: 12)),
            part5(rptAPModel.listEquiposIMP),
            pw.Container(margin: pw.EdgeInsets.only(top: 12)),
            part6(rptAPModel.headerAP.observaciones),
            pw.Container(margin: pw.EdgeInsets.only(top: 12)),
            part7(rptAPModel.headerAP.evaluacion),
            pw.Container(margin: pw.EdgeInsets.only(top: 60)),
            part8(rptAPModel.listTableRows),
            pw.Container(margin: pw.EdgeInsets.only(top: 30)),
            part9(rptAPModel.listPlaneRecords),
          ],
      footer: (pw.Context context) => footer(rptAPModel.headerAP)));

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat(8.5 * 72.0, 14.0 * PdfPageFormat.inch,
              marginAll: 2.0 * PdfPageFormat.cm)
          .copyWith(marginBottom: 1.5 * PdfPageFormat.cm)
          .portrait,
      header: (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Container(
                    height: 80.0,
                    child: pw.Column(children: <pw.Widget>[
                      pw.Row(children: <pw.Widget>[
                        pw.Container(
                            margin: pw.EdgeInsets.only(right: 5.0),
                            child: pw.Image(image, width: 120.5)),
                        pw.Container(
                            margin: pw.EdgeInsets.only(top: 30.0, right: 5.0),
                            child: pw.Column(children: <pw.Widget>[
                              pw.Text('SUBDIRECCIÓN DE SERVICIOS PETROLEROS',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 6.5)),
                              pw.Container(margin: pw.EdgeInsets.only(top: 10)),
                              pw.Text(
                                  'REGISTRO DE INSPECCIÓN DE PROTECCIÓN ANTICORROSIVA',
                                  style: pw.TextStyle(
                                      fontSize: 7.5,
                                      fontWeight: pw.FontWeight.bold))
                            ])),
                        pw.Container(
                          padding: pw.EdgeInsets.all(9.0),
                          height: 55.0,
                          margin: pw.EdgeInsets.only(right: 5),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                              width: 1,
                            ),
                          ),
                          child: pw.Row(children: <pw.Widget>[
                            pw.Column(children: <pw.Widget>[
                              pw.Text('CODIGO:    ',
                                  style: rw.fontWeightBold(6)),
                              pw.Text('REF:   ', style: rw.fontWeightBold(6)),
                              pw.Text('REV:   ', style: rw.fontWeightBold(6)),
                              pw.Text('FECHA:   ', style: rw.fontWeightBold(6)),
                            ]),
                            pw.Column(children: <pw.Widget>[
                              pw.Text('SSP-MYC-CCA-FO-002',
                                  style: pw.TextStyle(fontSize: 6)),
                              pw.Text('SSP-MYC-CCA-PG-002',
                                  style: pw.TextStyle(fontSize: 6)),
                              pw.Text('00', style: pw.TextStyle(fontSize: 6)),
                              pw.Text('31-MAYO-2018',
                                  style: pw.TextStyle(fontSize: 6))
                            ])
                          ]),
                        ),
                      ]),
                    ])),
              ]),
      build: (pw.Context context) => <pw.Widget>[
            pw.Container(margin: pw.EdgeInsets.only(top: 30)),
            part10(rptAPModel.pruebasAdherencia,
                rptAPModel.listRegistroImgAdherencia)
          ],
      footer: (pw.Context context) => footer(rptAPModel.headerAP)));

//Agregar archivos adjuntos a pdf
  if (rptAPModel.listDocumentsRpt.isNotEmpty) {
    for (var i = 0; i < rptAPModel.listDocumentsRpt.length; i++) {
      final document = await npdf.PdfDocument.openData(
          base64Decode(rptAPModel.listDocumentsRpt[i].data));

      for (var j = 1; j <= document.pagesCount; j++) {
        final page = await document.getPage(j);
        final pageImage = await page.render(
          width: page.width,
          height: page.height,
          format: npdf.PdfPageFormat.PNG,
          // backgroundColor: '#0e0e0e'
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
              titlePDF: 'Reporte: Protección Anticorrosiva',
              canChangeOrientation: false,
            )),
  );
}

pw.Column part1(pw.Context context, RptHeaderProteccionAnticorrosiva headerAP) {
  return pw.Column(children: <pw.Widget>[
    pw.Container(
        // margin: pw.EdgeInsets.only(left: -10.0),
        decoration: rw.borderAll(),
        width: 482,
        child: pw.Row(children: <pw.Widget>[
          pw.Container(
              height: 20,
              width: 100,
              padding: pw.EdgeInsets.all(5),
              decoration: rw.borderAll(),
              alignment: pw.Alignment.centerLeft,
              child: pw.Text('FECHA:', style: rw.fontWeightBold(6))),
          pw.Container(
              height: 20,
              width: 100,
              padding: pw.EdgeInsets.all(5),
              decoration: rw.borderAll(),
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(headerAP.fecha, style: pw.TextStyle(fontSize: 6))),
          pw.Container(
              height: 20,
              width: 182,
              padding: pw.EdgeInsets.all(5),
              decoration: rw.borderAll(),
              child: pw.Row(children: <pw.Widget>[
                pw.Text('NÚMERO DE REPORTE: ', style: rw.fontWeightBold(6)),
                pw.Text(headerAP.noRegistro, style: pw.TextStyle(fontSize: 6))
              ])),
          pw.Container(
              height: 20,
              width: 100,
              padding: pw.EdgeInsets.all(5),
              decoration: rw.borderAll(),
              alignment: pw.Alignment.center,
              child: pw.Text(
                  'HOJA ' +
                      (context.pageNumber).toString() +
                      '  DE  ' +
                      (context.pagesCount).toString(),
                  style: pw.TextStyle(fontSize: 6)))
        ])),
    row1('CONTRATO:', headerAP.contratoId),
    row2('DESCRIPCIÓN DE CONTRATO:', headerAP.descripcionContrato),
    row1('ORDEN:', headerAP.ot),
    row1('INSTALACIÓN:', headerAP.instalacion),
    row1('EMBARCACIÓN:', headerAP.plataforma),
    row2('DESCRIPCIÓN DE LA OBRA:', headerAP.descripcionObras),
    pw.Container(
        decoration: rw.borderAll(),
        height: 40,
        width: 482,
        child: pw.Row(children: <pw.Widget>[
          pw.Container(
              height: 40,
              width: 100,
              padding: pw.EdgeInsets.all(5),
              decoration: rw.borderAll(),
              alignment: pw.Alignment.centerLeft,
              child: pw.Text('SISTEMA APLICADO:', style: rw.fontWeightBold(6))),
          pw.Container(
              height: 40,
              width: 100,
              padding: pw.EdgeInsets.all(5),
              alignment: pw.Alignment.centerRight,
              child:
                  pw.Text(headerAP.sistema, style: pw.TextStyle(fontSize: 6))),
          pw.Container(
              height: 40,
              width: 282,
              padding: pw.EdgeInsets.all(5),
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(headerAP.recubrimientos,
                  style: pw.TextStyle(fontSize: 6))),
        ]))
  ]);
}

pw.Container rowDoubleWithoutMarginColumn(String title, String valueRow1,
    [String title2 = '',
    String valueRow2 = '',
    double titleWidth = 100,
    double titleValue = 100,
    String myAlignament = 'center',
    String myAlignamentValue = 'center',
    String myAlignament2 = 'center',
    String myAlignamentValue2 = 'center']) {
  // double widthValue = 482 + titleWidth;
  return pw.Container(
      width: 482,
      child: pw.Row(children: <pw.Widget>[
        pw.Container(
          height: 18,
          width: titleWidth,
          padding: pw.EdgeInsets.all(5),
          // decoration: rw.borderAll(),
          // alignment: pw.Alignment.centerLeft,
          alignment: alignamentGeneric(myAlignament),
          child: pw.Text(title, style: rw.fontWeightBold(6.0)),
        ),
        pw.Container(
          height: 18,
          width: titleValue,
          padding: pw.EdgeInsets.all(5),
          decoration: myBoxDecoration(),
          // alignment: pw.Alignment.center,
          alignment: alignamentGeneric(myAlignamentValue),
          child: pw.Text(valueRow1,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 6.0)),
        ),
        if (title2 != '')
          pw.Container(
              height: 18,
              width: titleWidth,
              padding: pw.EdgeInsets.all(5),
              // alignment: pw.Alignment.centerLeft,
              alignment: alignamentGeneric(myAlignament2),
              child: pw.Text(title2, style: rw.fontWeightBold(6.0))),
        if (valueRow2 != '')
          pw.Container(
            height: 18,
            width: titleValue,
            padding: pw.EdgeInsets.all(5),
            decoration: myBoxDecoration(),
            // alignment: pw.Alignment.centerLeft,
            alignment: alignamentGeneric(myAlignamentValue2),
            child: pw.Text(valueRow2,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontSize: 6.0)),
          ),
      ]));
}

pw.BoxDecoration myBoxDecoration() {
  return pw.BoxDecoration(
    border: pw.Border(
      bottom: pw.BorderSide(
        color: PdfColors.black,
        width: 1.0,
      ),
    ),
  );
}

// ignore: missing_return
pw.Alignment alignamentGeneric(String typeAlignament) {
  if (typeAlignament == "bottomCenter") {
    return pw.Alignment.bottomCenter;
  }
  if (typeAlignament == "bottomLeft") {
    return pw.Alignment.bottomLeft;
  }
  if (typeAlignament == "bottomRight") {
    return pw.Alignment.bottomRight;
  }
  if (typeAlignament == "center") {
    return pw.Alignment.center;
  }
  if (typeAlignament == "centerLeft") {
    return pw.Alignment.centerLeft;
  }
  if (typeAlignament == "centerRight") {
    return pw.Alignment.centerRight;
  }
  if (typeAlignament == "topCenter") {
    return pw.Alignment.topCenter;
  }
  if (typeAlignament == "topLeft") {
    return pw.Alignment.topLeft;
  }
  if (typeAlignament == "topRight") {
    return pw.Alignment.topRight;
  }
}

pw.Container part10(PruebasAdherencia pruebasAdherencia,
    List<TempRegistroImgAdherencia> listRegistroImgAdherencia) {
  List<pw.Container> result = [];

  listRegistroImgAdherencia.forEach((element) {
    final image1 = pw.MemoryImage(base64.decode(element.content1));
    final image2 = pw.MemoryImage(base64.decode(element.content2));
    result.add(viewDescriptionTest(
        element.prueba, image1, image2, element.observacion));
  });

  return pw.Container(
      child: pw.Column(children: <pw.Widget>[
    pw.Container(
      decoration: rw.borderAll(),
      width: 482,
      height: 100,
      child: pw.Column(children: <pw.Widget>[
        rowDoubleWithoutMarginColumn(
            'FECHA:  ',
            pruebasAdherencia.fecha,
            'NÚMERO REPORTE: ',
            pruebasAdherencia.noRegistro,
            90,
            145,
            'center',
            'centerLeft',
            'center',
            'centerLeft'),
        rowDoubleWithoutMarginColumn(
            'CONTRATO:  ',
            pruebasAdherencia.contratoId,
            'INSTALACIÓN: ',
            pruebasAdherencia.instalacion,
            90,
            145,
            'center',
            'centerLeft',
            'center',
            'centerLeft'),
        rowDoubleWithoutMarginColumn(
            'DOCUMENTO APLICABLE:  ',
            pruebasAdherencia.documentoAplicable,
            'PLATAFORMA: ',
            pruebasAdherencia.plataforma,
            90,
            145,
            'center',
            'centerLeft',
            'center',
            'centerLeft'),
        rowDoubleWithoutMarginColumn('OT:  ', pruebasAdherencia.ot, '', '', 90,
            382, 'center', 'centerLeft'),
        rowDoubleWithoutMarginColumn(
            'NO. PLANOISOMÉTRICO:  ',
            'INFORMACIÓN EN LA SECCIÓN DE REGISTROS DE PLANOS',
            'ELEMENTO PINTADO: ',
            'INFORMACIÓN EN LA SECCIÓN DE REGISTRO DE PLANOS',
            90,
            145,
            'center',
            'centerLeft',
            'center',
            'centerLeft')
      ]),
    ),
    pw.Column(children: result)
  ]));
}

pw.Container viewDescriptionTest(String prueba, pw.MemoryImage image1,
    pw.MemoryImage image2, String comentarios) {
  return pw.Container(
      decoration: rw.borderAll(),
      width: 482,
      height: 175,
      child: pw.Row(children: <pw.Widget>[
        pw.Column(children: <pw.Widget>[
          pw.Container(
              height: 20,
              decoration: rw.borderAll(),
              width: 110,
              alignment: pw.Alignment.center,
              child: pw.Text('DESCRIPCION DE LA UBICACIÓN',
                  style: rw.fontWeightBold(6))),
          pw.Container(
              height: 155,
              width: 110,
              decoration: rw.borderAll(),
              alignment: pw.Alignment.center,
              child: pw.Text('', style: rw.fontWeightBold(6)))
        ]),
        pw.Container(
            alignment: pw.Alignment.topCenter,
            child: pw.Column(children: <pw.Widget>[
              pw.Container(
                height: 20,
                decoration: rw.borderAll(),
                width: 372,
                alignment: pw.Alignment.center,
                child: pw.Text(prueba, style: rw.fontWeightBold(6)),
              ),
              pw.Container(
                height: 120,
                width: 372,
                alignment: pw.Alignment.topCenter,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: <pw.Widget>[
                      pw.Container(
                          decoration: rw.borderAll(),
                          alignment: pw.Alignment.centerLeft,
                          padding: pw.EdgeInsets.all(5),
                          height: 120,
                          width: 186,
                          child: pw.Image(image1)),
                      pw.Container(
                          decoration: rw.borderAll(),
                          padding: pw.EdgeInsets.all(5),
                          alignment: pw.Alignment.centerLeft,
                          height: 120,
                          width: 186,
                          child: pw.Image(image2)),
                    ]),
              ),
              pw.Container(
                height: 35,
                width: 372,
                padding: pw.EdgeInsets.all(5),
                decoration: rw.borderAll(),
                alignment: pw.Alignment.centerLeft,
                child: pw.Column(children: <pw.Widget>[
                  pw.Text("    OBSERVACIONES   ", style: rw.fontWeightBold(6)),
                  pw.Text(comentarios,
                      style: pw.TextStyle(
                          decoration: pw.TextDecoration.underline, fontSize: 6))
                ]),
                // pw.Container(
                //     height: 35,
                //     width: 313,
                //     padding: pw.EdgeInsets.all(5),
                //     alignment: pw.Alignment.centerLeft,
                //     child: pw.Text(
                //         "",
                //         style: pw.TextStyle(fontSize: 6))),
              ),
            ])),
      ]));
}

pw.Column part2(List<DataTableDymanic> listConditionEnvironment) {
  return pw.Column(children: <pw.Widget>[
    rowTitle('CONDICIONES AMBIENTALES'),
    pw.Container(
        decoration: rw.borderAll(),
        width: 482,
        child: tableEnvironmentalConditions(listConditionEnvironment))
  ]);
}

pw.Column part3(RptHeaderProteccionAnticorrosiva headerAP) {
  return pw.Column(children: <pw.Widget>[
    rowTitle('PREPARACIÓN DE SUPERFICIE'),
    row1('CONDICIONES DEL SUSTRATO:', headerAP.condicionesSustratos, 120),
    row1('TIPO DE ABRASIVO:', headerAP.tipoAbrasivo, 120),
    row1('PERFIL DE ANCLEJE PROMEDIO:', headerAP.perfilAnclajePromedio, 120),
    row1('ESTANDAR DE LIMPIEZA:', headerAP.estandarLimpieza, 120)
  ]);
}

pw.Column part4(List<DataTableDymanic> listAplicacionRecub) {
  return pw.Column(children: <pw.Widget>[
    rowTitle('APLICACIÓN DEL RECUBRIMIENTO'),
    pw.Container(
        decoration: rw.borderAll(),
        width: 482,
        child: tableCoatingApplication(listAplicacionRecub))
  ]);
}

pw.Column part5(List<EquiposIMPAP> listEquiposIMP) {
  String equipos = '';

  listEquiposIMP.forEach((element) {
    equipos += element.nombre + '\n';
  });
  return pw.Column(children: <pw.Widget>[
    rowTitle('EQUIPOS DE I.M Y P.UTILIZADOS'),
    pw.Container(
        decoration: rw.borderAll(),
        width: 482,
        padding: pw.EdgeInsets.only(top: 5, bottom: 5),
        alignment: pw.Alignment.center,
        child: pw.Text(equipos, style: pw.TextStyle(fontSize: 6)))
  ]);
}

pw.Container part6(String observaciones) {
  return pw.Container(
      child: pw.Column(children: <pw.Widget>[
    rowTitle('OBSERVACIONES'),
    pw.Container(
        decoration: rw.borderAll(),
        width: 482,
        height: 50,
        alignment: pw.Alignment.center,
        child: pw.Text(observaciones, style: pw.TextStyle(fontSize: 6)))
  ]));
}

pw.Column part7(String evaluacion) {
  return pw.Column(children: <pw.Widget>[
    pw.Container(
        width: 482,
        height: 20,
        alignment: pw.Alignment.centerRight,
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: <pw.Widget>[
              pw.Text('RESULTADO FINAL DE INSPECCIÓN:',
                  style: rw.fontWeightBold(6)),
              pw.Container(
                  margin: pw.EdgeInsets.only(left: 15, right: 50),
                  width: 60,
                  height: 10,
                  decoration: rw.borderAll(),
                  alignment: pw.Alignment.center,
                  child: pw.Text(evaluacion, style: pw.TextStyle(fontSize: 6))),
            ]))
  ]);
}

pw.Column part8(List<TblTempTotalRows> listTableRows) {
  List<pw.Container> result = [];

  pw.Container title = pw.Container(
      width: 482,
      child: pw.Row(children: <pw.Widget>[
        pw.Container(
            height: 13,
            width: 482,
            alignment: pw.Alignment.center,
            child:
                pw.Text('REGISTRO FOTOGRÁFICO', style: rw.fontWeightBold(6.5)))
      ]));

  pw.Container space = pw.Container(margin: pw.EdgeInsets.only(top: 4));

  result.add(title);
  result.add(space);

  listTableRows.forEach((element) {
    final image1 = pw.MemoryImage(base64.decode(element.content1));
    final image2 = pw.MemoryImage(base64.decode(element.content2));
    result.add(photographicRecord(image1, image2, element.observacion));
  });
  return pw.Column(children: result);
}

pw.Container part9(List<PlaneRecordsModel> listPlaneRecords) {
  return pw.Container(
      child: pw.Column(children: <pw.Widget>[
    rowTitle('REGISTRO DE PLANOS'),
    pw.Container(
      width: 482,
      child: pw.Row(children: <pw.Widget>[
        pw.Container(
          decoration: rw.borderAll(),
          width: 310,
          height: 20,
        ),
        pw.Container(
            decoration: rw.borderAll(),
            width: 172,
            height: 20,
            alignment: pw.Alignment.center,
            child: pw.Text('FECHA DE PROTECCIÓN ANTICORROSIVA APLICADA',
                style: rw.fontWeightBold(6))),
      ]),
    ),
    pw.Container(
        decoration: rw.borderAll(),
        width: 482,
        child: tablePlanRecords(listPlaneRecords))
  ]));
}

pw.Container footer(RptHeaderProteccionAnticorrosiva headerAP) {
  return pw.Container(
      width: 482,
      child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: <pw.Widget>[
            firm(headerAP.elabora, 'ELABORA'),
            firm(headerAP.revisa, 'REVISA'),
            firm(headerAP.aprueba, 'APRUEBA'),
          ]));
}

pw.Container row1(String title, String value, [double titleWidth = 100]) {
  double widthValue = 482 - titleWidth;
  return pw.Container(
      decoration: rw.borderAll(),
      width: 482,
      child: pw.Row(children: <pw.Widget>[
        pw.Container(
            height: 20,
            width: titleWidth,
            padding: pw.EdgeInsets.all(5),
            decoration: rw.borderAll(),
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(title, style: rw.fontWeightBold(6))),
        pw.Container(
            height: 20,
            width: widthValue,
            padding: pw.EdgeInsets.all(5),
            decoration: rw.borderAll(),
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(value, style: pw.TextStyle(fontSize: 6))),
      ]));
}

pw.Container row2(String title, String value) {
  return pw.Container(
      decoration: rw.borderAll(),
      height: 40,
      width: 482,
      child: pw.Row(children: <pw.Widget>[
        pw.Container(
            height: 40,
            width: 100,
            padding: pw.EdgeInsets.all(5),
            decoration: rw.borderAll(),
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(title, style: rw.fontWeightBold(6))),
        pw.Container(
            height: 40,
            width: 382,
            padding: pw.EdgeInsets.all(5),
            decoration: rw.borderAll(),
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(value, style: pw.TextStyle(fontSize: 6))),
      ]));
}

pw.Container rowTitle(String title) {
  return pw.Container(
      decoration: rw.borderAll(),
      width: 482,
      child: pw.Row(children: <pw.Widget>[
        pw.Container(
            height: 13,
            width: 482,
            alignment: pw.Alignment.center,
            child: pw.Text(title, style: rw.fontWeightBold(6.5)))
      ]));
}

pw.Table tableEnvironmentalConditions(
    List<DataTableDymanic> listConditionEnvironment) {
  return pw.Table.fromTextArray(
    border: pw.TableBorder.all(width: 0.5),
    headerHeight: 13,
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 5.5),
    headers: headersEnvironmentalConditions(listConditionEnvironment),
    data: dataEnvironmentalConditions(listConditionEnvironment),
    cellAlignment: pw.Alignment.center,
    cellStyle: pw.TextStyle(fontSize: 6),
  );
}

pw.Table tableCoatingApplication(
    List<DataTableDymanic> listCoatingApplication) {
  return pw.Table.fromTextArray(
    border: pw.TableBorder.all(width: 0.5),
    headerHeight: 13,
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 5.5),
    headers: headersCoatingApplication(listCoatingApplication),
    data: dataCoatingApplication(listCoatingApplication),
    cellAlignment: pw.Alignment.center,
    cellStyle: pw.TextStyle(fontSize: 6),
  );
}

pw.Table tablePlanRecords(List<PlaneRecordsModel> planeRecords) {
  PlaneRecordsColumns planeRecordsColumns = new PlaneRecordsColumns();
  planeRecordsColumns = getDataTablePlaneRecords(planeRecords);
  List<pw.Widget> listIsometrico = planeRecordsColumns.listIsometrico;
  List<pw.Widget> listPlano = planeRecordsColumns.listPlanoDetalle;
  List<pw.Widget> listConcepto = planeRecordsColumns.listConcepto;
  List<pw.Widget> listPrimario = planeRecordsColumns.listPrimario;
  List<pw.Widget> listEnlace = planeRecordsColumns.listEnlace;
  List<pw.Widget> listAcabado = planeRecordsColumns.listAcabado;
  List<pw.Widget> listLiberado = planeRecordsColumns.listLiberado;

  return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: <int, pw.TableColumnWidth>{
        0: pw.FixedColumnWidth(60),
        1: pw.FixedColumnWidth(70),
        2: pw.FixedColumnWidth(60),
        3: pw.FixedColumnWidth(60),
        4: pw.FixedColumnWidth(60),
        5: pw.FixedColumnWidth(43),
        6: pw.FixedColumnWidth(43),
        7: pw.FixedColumnWidth(43),
        8: pw.FixedColumnWidth(43),
      },
      children: <pw.TableRow>[
        pw.TableRow(
            verticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: getHeaderTable(planeRecords)),
        pw.TableRow(
            verticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: <pw.Widget>[
              pw.Column(children: <pw.Widget>[
                pw.Text(planeRecords[1].ubicacion,
                    style: pw.TextStyle(fontSize: 6))
              ]),
              pw.Column(children: <pw.Widget>[
                pw.Text(planeRecords[1].observaciones,
                    style: pw.TextStyle(fontSize: 6),
                    textAlign: pw.TextAlign.center)
              ]),
              pw.Column(children: listIsometrico),
              pw.Column(children: listPlano),
              pw.Column(children: listConcepto),
              pw.Column(children: listPrimario),
              pw.Column(children: listEnlace),
              pw.Column(children: listAcabado),
              pw.Column(children: listLiberado),
            ])
      ]);
}

List<String> headersEnvironmentalConditions(List<DataTableDymanic> list) {
  List<String> listHeaders = [];
  listHeaders.add('');
  list.forEach((element) {
    if (!listHeaders.contains(element.dynamicColumnHeader)) {
      listHeaders.add(element.dynamicColumnHeader);
    }
  });

  return listHeaders;
}

List<String> headersCoatingApplication(List<DataTableDymanic> list) {
  List<String> listHeaders = [];
  listHeaders.add('APLICACIONES');
  list.forEach((element) {
    if (!listHeaders.contains(element.dynamicColumnHeader)) {
      listHeaders.add(element.dynamicColumnHeader);
    }
  });

  return listHeaders;
}

List<List<String>> dataEnvironmentalConditions(List<DataTableDymanic> list) {
  List<List<String>> result = [];
  List<String> tempAmbiente = [];
  tempAmbiente.add('TEMPERATURA AMBIENTE:');
  list.forEach((element) {
    if (element.rowDescription == 'TEMPERATURA AMBIENTE:') {
      tempAmbiente.add(element.value);
    }
  });

  List<String> tempSustrato = [];
  tempSustrato.add('TEMPERATURA DEL SUSTRATO:');
  list.forEach((element) {
    if (element.rowDescription == 'TEMPERATURA DEL SUSTRATO:') {
      tempSustrato.add(element.value);
    }
  });

  List<String> humedadRelativa = [];
  humedadRelativa.add('HUMEDAD RELATIVA:');
  list.forEach((element) {
    if (element.rowDescription == 'HUMEDAD RELATIVA:') {
      humedadRelativa.add(element.value);
    }
  });

  result.add(tempAmbiente);
  result.add(tempSustrato);
  result.add(humedadRelativa);
  return result;
}

List<List<String>> dataCoatingApplication(List<DataTableDymanic> list) {
  List<List<String>> result = [];
  List<String> noLote = [];
  noLote.add('No. DE LOTE:');
  list.forEach((element) {
    if (element.rowDescription == 'No. DE LOTE:') {
      noLote.add(element.value);
    }
  });

  List<String> fechaCaducidad = [];
  fechaCaducidad.add('FECHA DE CADUCIDAD:');
  list.forEach((element) {
    if (element.rowDescription == 'FECHA DE CADUCIDAD:') {
      fechaCaducidad.add(element.value);
    }
  });

  List<String> metodoAplicacion = [];
  metodoAplicacion.add('MÉTODO DE APLICACIÓN:');
  list.forEach((element) {
    if (element.rowDescription == 'MÉTODO DE APLICACIÓN:') {
      metodoAplicacion.add(element.value);
    }
  });

  List<String> tipoRecubrimiento = [];
  tipoRecubrimiento.add('TIPO DE RECUBRIMIENTO:');
  list.forEach((element) {
    if (element.rowDescription == 'TIPO DE RECUBRIMIENTO:') {
      tipoRecubrimiento.add(element.value);
    }
  });

  List<String> mezcla = [];
  mezcla.add('% DE MEZCLA:');
  list.forEach((element) {
    if (element.rowDescription == '% DE MEZCLA:') {
      mezcla.add(element.value);
    }
  });

  List<String> espesorSP = [];
  espesorSP.add('ESPESOR SECO PROMEDIO:');
  list.forEach((element) {
    if (element.rowDescription == 'ESPESOR SECO PROMEDIO:') {
      espesorSP.add(element.value);
    }
  });

  List<String> tiempoSecado = [];
  tiempoSecado.add('TIEMPO DE SECADO:');
  list.forEach((element) {
    if (element.rowDescription == 'TIEMPO DE SECADO:') {
      tiempoSecado.add(element.value);
    }
  });

  List<String> tipoSA = [];
  tipoSA.add('TIPO DE SOLVENTE O ADELGAZADOR:');
  list.forEach((element) {
    if (element.rowDescription == 'TIPO DE SOLVENTE O ADELGAZADOR:') {
      tipoSA.add(element.value);
    }
  });

  List<String> pruebaContinuidad = [];
  pruebaContinuidad.add('PRUEBA DE CONTINUIDAD:');
  list.forEach((element) {
    if (element.rowDescription == 'PRUEBA DE CONTINUIDAD:') {
      pruebaContinuidad.add(element.value);
    }
  });

  List<String> pruebaAdherencia = [];
  pruebaAdherencia.add('PRUEBA DE ADHERENCIA:');
  list.forEach((element) {
    if (element.rowDescription == 'PRUEBA DE ADHERENCIA:') {
      pruebaAdherencia.add(element.value);
    }
  });

  result.add(noLote);
  result.add(fechaCaducidad);
  result.add(metodoAplicacion);
  result.add(tipoRecubrimiento);
  result.add(mezcla);
  result.add(espesorSP);
  result.add(tiempoSecado);
  result.add(tipoSA);
  result.add(pruebaContinuidad);
  result.add(pruebaAdherencia);
  return result;
}

List<List<String>> dataPlanRecords() {
  List<List<String>> result = [];

  List<String> temp = [];
  temp.add('COT ESS');
  temp.add(
      'LOS MATERIALEES SE VEN EN LA HOJA DE RESGITROS DE PLANOS ES UNA PRUEBA');
  temp.add('NEW-PTA-001 Rev. 0 Hoja 1');
  temp.add('');
  temp.add('NPSP001 NP 1');
  temp.add('05.03.2021');
  temp.add('05.03.2021');
  temp.add('05.03.2021');
  temp.add('05.03.2021');

  List<String> temp2 = [];
  temp2.add('COT ESS');
  temp2.add(
      'LOS MATERIALEES SE VEN EN LA HOJA DE RESGITROS DE PLANOS ES UNA PRUEBA');
  temp2.add('NEW.-IPA-001 Rev. 1 Hoja 1\nNEW-PTA-001 Rev. 0 Hoja 1');
  temp2.add('');
  temp2.add('NPSP001 NP 1');
  temp2.add('');
  temp2.add('');
  temp2.add('');
  temp2.add('05.03.2021');

  List<String> temp3 = [];
  temp3.add('COT ESS');
  temp3.add(
      'LOS MATERIALEES SE VEN EN LA HOJA DE RESGITROS DE PLANOS ES UNA PRUEBA');
  temp3.add('NEW.-IPA-001');
  temp3.add('');
  temp3.add('NSP002 NI 1 R ');
  temp3.add('');
  temp3.add('');
  temp3.add('');
  temp3.add('05.03.2021');

  result.add(temp);
  result.add(temp2);
  result.add(temp3);

  return result;
}

pw.Container firm(String name, title) {
  return pw.Container(
      height: 74,
      margin: pw.EdgeInsets.only(left: 1),
      child: pw.Column(children: <pw.Widget>[
        pw.Container(margin: pw.EdgeInsets.only(top: 40)),
        pw.Text(name, style: pw.TextStyle(fontSize: 6)),
        rw.widgetUnderline(130),
        pw.Text(title, style: rw.fontWeightBold(6)),
      ]));
}

pw.Container photographicRecord(
    pw.MemoryImage image1, pw.MemoryImage image2, String observacion) {
  return pw.Container(
      margin: pw.EdgeInsets.only(top: 16),
      alignment: pw.Alignment.topCenter,
      child: pw.Column(children: <pw.Widget>[
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: <pw.Widget>[
            pw.Container(
                // decoration: rw.borderAll(),
                height: 100,
                width: 100,
                child: pw.Image(image1)),
            pw.Container(
              // decoration: rw.borderAll(),
              height: 100,
              width: 90,
            ),
            pw.Container(
                // decoration: rw.borderAll(),
                height: 100,
                width: 100,
                child: pw.Image(image2))
          ],
        ),
        pw.Container(
            margin: pw.EdgeInsets.only(
          top: 8,
        )),
        pw.Container(
            width: 290,
            alignment: pw.Alignment.topCenter,
            child: pw.Table.fromTextArray(
              border: pw.TableBorder.all(width: 0.5),
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 5.5),
              headers: <String>['ELEMENTO', 'VER LISTA ANEXA EN HOJA 4'],
              cellAlignment: pw.Alignment.center,
              cellStyle: pw.TextStyle(fontSize: 6),
              data: <List<String>>[
                <String>['Observaciones', observacion]
              ],
            ))
      ]));
}

// List<List<String>> data() {
//   List<List<String>> data = [];
//   for (var i = 0; i < 3; i++) {
//     List<String> dataTemp = [];
//     dataTemp.add('Observaciones' + i.toString());
//     dataTemp.add('-----');

//     data.add(dataTemp);
//   }

//   return data;
// }

List<pw.Widget> getHeaderTable(List<PlaneRecordsModel> listPlaneRecords) {
  List<pw.Widget> listHeaders = [];
  listPlaneRecords.forEach((element) {
    if (element.orden == 'A' && element.orden2 == 'A') {
      listHeaders.add(textHeaderRow(element.ubicacion));
      listHeaders.add(textHeaderRow(element.observaciones));
      listHeaders.add(textHeaderRow(element.planoDetalle));
      listHeaders.add(textHeaderRow(element.localizacion));
      listHeaders.add(textHeaderRow(element.concepto));
      listHeaders.add(textHeaderRow(element.fecha1));
      listHeaders.add(textHeaderRow(element.fecha2));
      listHeaders.add(textHeaderRow(element.fecha3));
      listHeaders.add(textHeaderRow(element.liberacion));
    }
  });
  return listHeaders;
}

PlaneRecordsColumns getDataTablePlaneRecords(
    List<PlaneRecordsModel> listPlaneRecords) {
  PlaneRecordsColumns planeRecordsColumns = new PlaneRecordsColumns();
  planeRecordsColumns.listIsometrico = [];
  planeRecordsColumns.listPlanoDetalle = [];
  planeRecordsColumns.listConcepto = [];
  planeRecordsColumns.listPrimario = [];
  planeRecordsColumns.listEnlace = [];
  planeRecordsColumns.listAcabado = [];
  planeRecordsColumns.listLiberado = [];
  List<String> listIsometrico = [];

  List<DataWithList> dataAll = [];

  listIsometrico = listPlaneRecords.map((e) => e.planoDetalle).toList();
  listIsometrico.remove('ISOMÉTRICO DE LOCALIZACIÓN');
  listIsometrico = listIsometrico.toSet().toList();

  listIsometrico.forEach((isometrico) {
    DataWithList temp = new DataWithList();
    temp.listConcepto = [];
    PlaneRecordsModel planeRecord;

    planeRecord = listPlaneRecords
        .where((element) => element.planoDetalle == isometrico)
        .first;
    temp.isometrico = isometrico;
    temp.planoDetalle = planeRecord
        .localizacion; //Obtenemos plano detalle de cada Isometrico de Localización
    listPlaneRecords.forEach((planeRecord) {
      if (planeRecord.planoDetalle == isometrico) {
        temp.listConcepto.add(planeRecord.concepto);
      }
    });
    dataAll.add(temp);
  });

  //Obtener la cadena mas larga de ISOMETRICO, PLANO DETALLE Y CONCEPTO
  dataAll.forEach((element) {
    double isoLength = element.isometrico.length.toDouble();
    double planoLength = element.planoDetalle.length.toDouble();

    double numberLargestConcepto = 0;
    double numberLargestIsoPlano = 0;

    element.listConcepto.forEach((value) {
      numberLargestConcepto = value.length.toDouble() > numberLargestConcepto
          ? value.length.toDouble()
          : numberLargestConcepto;
    });

    //obtenemos la cadena mas larga de isometrico o plano
    numberLargestIsoPlano = isoLength > planoLength ? isoLength : planoLength;
    //Calculamos un alto para las filas
    element.heightIsoPlano = numberLargestIsoPlano + numberLargestConcepto;
    var totalHeightRowConcepto = element.listConcepto.length.toDouble() *
        10; //minimo una fila de tener 10 de alto
    element.heightIsoPlano = element.heightIsoPlano > totalHeightRowConcepto
        ? element.heightIsoPlano
        : totalHeightRowConcepto;

    element.heightConcepto =
        element.heightIsoPlano / element.listConcepto.length.toDouble();
    // element.heightIsoPlano = element.heightIsoPlano >= 10
    //     ? element.heightIsoPlano
    //     : element.listConcepto.length.toDouble() * 10;
    // element.heightConcepto =
    //     element.heightIsoPlano / element.listConcepto.length.toDouble();
  });
  int count = 1;
  dataAll.forEach((element) {
    planeRecordsColumns.listIsometrico
        .add(textBodyRow(element.heightIsoPlano, element.isometrico));

    planeRecordsColumns.listPlanoDetalle
        .add(textBodyRow(element.heightIsoPlano, element.planoDetalle));

    element.listConcepto.forEach((concepto) {
      planeRecordsColumns.listConcepto
          .add(textBodyRow(element.heightConcepto, concepto));

      planeRecordsColumns.listPrimario.add(
          textBodyRow(element.heightConcepto, listPlaneRecords[count].fecha1));

      planeRecordsColumns.listEnlace.add(
          textBodyRow(element.heightConcepto, listPlaneRecords[count].fecha2));

      planeRecordsColumns.listAcabado.add(
          textBodyRow(element.heightConcepto, listPlaneRecords[count].fecha3));

      planeRecordsColumns.listLiberado.add(textBodyRow(
          element.heightConcepto, listPlaneRecords[count].liberacion));

      count++;
    });
  });
  return planeRecordsColumns;
}

pw.Text textHeaderRow(String title) {
  return pw.Text(title,
      style: rw.fontWeightBold(5.5), textAlign: pw.TextAlign.center);
}

pw.Container textBodyRow(double height, String text) {
  return pw.Container(
      alignment: pw.Alignment.center,
      decoration: rw.borderAll(),
      height: height,
      child: pw.Text(text,
          style: pw.TextStyle(fontSize: 6), textAlign: pw.TextAlign.center));
}
