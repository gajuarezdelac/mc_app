import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PDFViewer extends StatefulWidget {
  PDFViewer(
      {Key key, @required this.path, this.titlePDF, this.canChangeOrientation})
      : super(key: key);

  final String titlePDF;
  final Future<Uint8List> path;
  final bool canChangeOrientation;

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titlePDF),
      ),
      body: PdfPreview(
        allowSharing: false,
        maxPageWidth: 800,
        build: assetToBytes,
        canChangeOrientation: widget.canChangeOrientation,
      ),
    );
  }

  Future<Uint8List> assetToBytes(PdfPageFormat format) async {
    return widget.path;
  }
}
