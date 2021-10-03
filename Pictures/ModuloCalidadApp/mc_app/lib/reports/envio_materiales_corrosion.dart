import 'package:intl/intl.dart';
import 'package:mc_app/src/models/materiales_corrosion_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:async';
import 'dart:typed_data';
import 'package:mc_app/src/widgets/pdf_viewer.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

Future<void> envioMaterialesCorrosion(
    BuildContext context,
    RptMaterialsCorrosionHeader rptMaterialsCorrosionHeader,
    List<SpoolDetalleProteccionModel> lstSpoolDetalleProteccion) async {
  final image =
      await imageFromAssetBundle('assets/img/logo_horizontal_2019.png');

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
                          margin: pw.EdgeInsets.only(left: 20.0, top: 20.0),
                          child: pw.Image(image, width: 100.5, height: 100.5)),
                      pw.Container(
                          margin: pw.EdgeInsets.only(top: 20.0),
                          child: pw.Column(children: <pw.Widget>[
                            pw.Text('SUBDIRECCIÓN DE SERVICIOS PETROLEROS',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 10.0)),
                            pw.Text('ENVIÓ DE MATERIALES A CORROSIÓN',
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
                                    fontSize: 8.0)),
                            pw.Text('REF:   ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.0)),
                            pw.Text('REV:   ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.0)),
                            pw.Text('FECHA:   ',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.0)),
                          ]),
                          pw.Column(children: <pw.Widget>[
                            pw.Text('SSP-EJE-FOR-001',
                                style: pw.TextStyle(fontSize: 8.0)),
                            pw.Text('SSP-EJE-FOR-001',
                                style: pw.TextStyle(fontSize: 8.0)),
                            pw.Text('01', style: pw.TextStyle(fontSize: 8.0)),
                            pw.Text(
                                DateFormat('dd-MMM-yyyy')
                                    .format(DateTime.now()),
                                style: pw.TextStyle(fontSize: 8.0))
                          ])
                        ]),
                      ),
                    ]),
              ),
              secondPartHeader(context, rptMaterialsCorrosionHeader),
              pw.Container(margin: pw.EdgeInsets.only(bottom: 8.0))
            ]),
        build: (pw.Context context) =>
            <pw.Widget>[body(lstSpoolDetalleProteccion)],
        footer: (pw.Context context) => footer(rptMaterialsCorrosionHeader)),
  );

  Future<Uint8List> pdf2 = pdf.save();

  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (_) => PDFViewer(
              path: pdf2,
              titlePDF: 'Reporte: ${rptMaterialsCorrosionHeader.noEnvio}',
              canChangeOrientation: true,
            )),
  );
}

pw.Container secondPartHeader(pw.Context context,
    RptMaterialsCorrosionHeader rptMaterialsCorrosionHeader) {
  return pw.Container(
    height: 100.0,
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
              margin: pw.EdgeInsets.only(left: 20.0, top: 20.0),
              child: pw.Row(children: <pw.Widget>[
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: <pw.Widget>[
                      pw.Text('Nó. Envió: ',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10.0)),
                      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
                      pw.Text('Contrato: ',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10.0)),
                      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
                      pw.Text('Obra: ',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10.0)),
                      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
                    ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Text(rptMaterialsCorrosionHeader.noEnvio,
                          style: pw.TextStyle(fontSize: 10.0)),
                      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
                      pw.Text(rptMaterialsCorrosionHeader.contrato,
                          style: pw.TextStyle(fontSize: 10.0)),
                      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
                      pw.Text(rptMaterialsCorrosionHeader.obra,
                          style: pw.TextStyle(fontSize: 10.0)),
                      pw.Container(margin: pw.EdgeInsets.only(top: 2.0))
                    ])
              ])),
          pw.Container(
              margin: pw.EdgeInsets.only(top: 20.0),
              child: pw.Row(children: <pw.Widget>[
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: <pw.Widget>[
                      pw.Text('Destino: ',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10.0)),
                      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
                      pw.Text('Depto. Solicitante: ',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10.0)),
                      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
                      pw.Text('Fecha: ',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10.0)),
                      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
                    ]),
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Text(rptMaterialsCorrosionHeader.destino,
                          style: pw.TextStyle(fontSize: 10.0)),
                      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
                      pw.Text(rptMaterialsCorrosionHeader.deptoSolicitante,
                          style: pw.TextStyle(fontSize: 10.0)),
                      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
                      pw.Text(rptMaterialsCorrosionHeader.fecha,
                          style: pw.TextStyle(fontSize: 10.0)),
                      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
                    ])
              ])),
          pw.Container(
              padding: pw.EdgeInsets.only(right: 20.0, left: 20.0),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  width: 1,
                ),
              ),
              child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: <pw.Widget>[
                    pw.Row(children: <pw.Widget>[
                      pw.Text('Hoja:    ',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 10.0)),
                      pw.Text(
                          (context.pageNumber).toString() +
                              '  DE  ' +
                              (context.pagesCount).toString(),
                          style: pw.TextStyle(fontSize: 10.0))
                    ])
                  ]))
        ]),
  );
}

pw.Table body(List<SpoolDetalleProteccionModel> lstSpoolDetalleProteccion) {
  return pw.Table.fromTextArray(
      border: pw.TableBorder.all(),
      columnWidths: <int, pw.TableColumnWidth>{
        0: pw.FixedColumnWidth(140),
        1: pw.FixedColumnWidth(140),
        2: pw.FixedColumnWidth(170),
        3: pw.FixedColumnWidth(120),
        4: pw.FixedColumnWidth(40),
        5: pw.FixedColumnWidth(250),
        6: pw.FixedColumnWidth(130),
      },
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.0),
      headers: <String>[
        'Nombre del Elemento',
        'Plataforma',
        'Plano de Localización/Isométrico',
        'Cantidad',
        'UM',
        'Descripción',
        'Trazabilidad'
      ],
      data: providesListOfLists(lstSpoolDetalleProteccion),
      cellAlignment: pw.Alignment.center,
      cellStyle: pw.TextStyle(fontSize: 10.0));
}

pw.Container footer(RptMaterialsCorrosionHeader rptMaterialsCorrosionHeader) {
  return pw.Container(
      padding: pw.EdgeInsets.only(left: 10.0),
      height: 50.0,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          width: 1,
        ),
      ),
      child: pw.Row(children: <pw.Widget>[
        pw.Text('Observaciones: ',
            style:
                pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10.0)),
        pw.Text(rptMaterialsCorrosionHeader.observaciones,
            style: pw.TextStyle(fontSize: 10.0))
      ]));
}

List<List<String>> providesListOfLists(
    List<SpoolDetalleProteccionModel> lstSpoolDetalleProteccion) {
  List<List<String>> lisListData = [];
  lstSpoolDetalleProteccion.forEach((element) {
    List<String> listData = [];
    listData.add(element.nombreElemento);
    listData.add(element.plataforma);
    listData.add(element.plano);
    listData.add(element.cantidad);
    listData.add(element.um);
    listData.add(element.descripcion);
    listData.add(element.idTrazabilidad);
    lisListData.add(listData);
  });

  return lisListData;
}
