import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Modal
abstract class Dialogs {
  static alert(
    BuildContext context, {
    @required String title,
    @required String description,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(_);
            },
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  static confirm(
      BuildContext context, {
        @required String title,
        @required String description,
        Function onConfirm
      }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed:  () {Navigator.pop(_);},
          ),
          TextButton(
            child: Text("Aceptar"),
            onPressed:  onConfirm,
          )
        ],
      ),
    );
  }

  static modalConfirmOkOnly(
      BuildContext context, {
        @required String title,
        @required String description,
        Function onConfirm,
        String buttonText,
      }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            child: buttonText!=null && buttonText!='' ? Text(buttonText) : Text("OK"),
            onPressed:  onConfirm,
          )
        ],
      ),
    );
  }

}




// Loading
abstract class ProgressDialog {
  static show(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.9),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            onWillPop: () async => false,
          );
        });
  }

  static dissmiss(BuildContext context) {
    Navigator.pop(context);
  }
}
