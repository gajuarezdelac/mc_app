import 'package:pdf/widgets.dart' as pw;

class ReportWidgets {
  pw.Container widgetField(String title, value,
      [double widthUnderline = 120, double fontSizeText = 5.0]) {
    return pw.Container(
        margin: pw.EdgeInsets.only(left: 5.0),
        child: pw.Row(children: <pw.Widget>[
          pw.Text(title,
              softWrap: true,
              style: pw.TextStyle(
                  fontSize: fontSizeText, fontWeight: pw.FontWeight.bold)),
          pw.Container(margin: pw.EdgeInsets.only(left: 3.0)),
          pw.Column(children: <pw.Widget>[
            pw.Container(
              // decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
              alignment: pw.Alignment.bottomCenter,
              child:
                  pw.Text(value, style: pw.TextStyle(fontSize: fontSizeText)),
            ),
            pw.Container(
              width: widthUnderline,
              height: 1,
              decoration: pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(width: 0.4))),
            ),
          ])
        ]));
  }

  pw.Container widgetField2(String title, value,
      [double widthUnderline = 120, double widthValue = 30]) {
    return pw.Container(
        margin: pw.EdgeInsets.only(left: 5.0),
        child: pw.Row(children: <pw.Widget>[
          pw.Text(title, style: pw.TextStyle(fontSize: 5.0)),
          pw.Container(margin: pw.EdgeInsets.only(left: 3.0)),
          pw.Column(children: <pw.Widget>[
            pw.Container(
              // decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
              width: widthValue,
              alignment: pw.Alignment.bottomCenter,
              child: pw.Text(value,
                  style: pw.TextStyle(
                    fontSize: 5.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center),
            ),
            pw.Container(
              width: widthUnderline,
              height: 1,
              decoration: pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(width: 0.4))),
            ),
          ])
        ]));
  }

  pw.Container widgetCheck([String symbol = '']) {
    return pw.Container(
        margin: pw.EdgeInsets.only(left: 5, top: 5, right: 4),
        height: 14,
        width: 14,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            width: 1,
          ),
        ),
        child: pw.Text(symbol));
  }

  pw.Row widgetCheckWithText(bool checkRight, String text,
      [String symbol = '', double topText = 5, double fontSizeText = 5]) {
    if (checkRight) {
      return pw.Row(children: <pw.Widget>[
        pw.Container(
            margin: pw.EdgeInsets.only(top: topText),
            alignment: pw.Alignment.center,
            child: pw.Text(text, style: pw.TextStyle(fontSize: fontSizeText))),
        widgetCheck(symbol)
      ]);
    } else {
      return pw.Row(children: <pw.Widget>[
        widgetCheck(symbol),
        pw.Container(
            margin: pw.EdgeInsets.only(top: 5),
            alignment: pw.Alignment.center,
            child: pw.Text(text, style: pw.TextStyle(fontSize: fontSizeText)))
      ]);
    }
  }

  pw.Column dottedLine() {
    return pw.Column(children: <pw.Widget>[
      pw.Text('|', style: pw.TextStyle(fontSize: 10.0)),
      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
      pw.Text('|', style: pw.TextStyle(fontSize: 10.0)),
      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
      pw.Text('|', style: pw.TextStyle(fontSize: 10.0)),
      pw.Container(margin: pw.EdgeInsets.only(top: 4.0)),
      pw.Text('|', style: pw.TextStyle(fontSize: 10.0)),
      pw.Container(margin: pw.EdgeInsets.only(top: 4.0))
    ]);
  }

  pw.Container widgetUnderline(double widthUnderline) {
    return pw.Container(
      width: widthUnderline,
      height: 1,
      decoration:
          pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(width: 0.4))),
    );
  }

  pw.TextStyle fontWeightBold(double fontSize) {
    return pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: fontSize);
  }

  pw.BoxDecoration borderAll([double width = 1.0]) {
    return pw.BoxDecoration(
      border: pw.Border.all(
        width: width,
      ),
    );
  }
}
