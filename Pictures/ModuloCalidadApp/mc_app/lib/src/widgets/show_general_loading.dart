import 'package:flutter/material.dart';

void showGeneralLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20.0),
              Text("Cargando...", style: TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
      );
    },
  );
}
