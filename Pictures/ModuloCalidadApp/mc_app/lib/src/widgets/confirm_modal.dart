import 'package:flutter/material.dart';
import 'package:mc_app/src/utils/constants.dart';

Future confirmModal(
  BuildContext context,
  String message,
  String positiveText, {
  Function positiveAction,
  Function negativeAction,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
          child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius + Constants.padding,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(top: 55.0),
              decoration: new BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Confirmación',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Text(message),
                  ),
                  SizedBox(height: 22),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            positiveAction();
                          },
                          child: Text(
                            positiveText,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: Constants.padding,
              right: Constants.padding,
              child: CircleAvatar(
                backgroundColor: Color(0xffFF8C00),
                radius: Constants.avatarRadius,
                child: Icon(
                  Icons.warning,
                  size: 64.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ));
    },
  );
}
