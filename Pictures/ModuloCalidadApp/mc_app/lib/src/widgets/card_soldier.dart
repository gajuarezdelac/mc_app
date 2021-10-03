import 'package:flutter/material.dart';

class CardSoldier extends StatelessWidget {
  final String initials;
  final String nombre;
  final String ficha;
  final String puestoDescripcion;
  final void Function() remove;
  final void Function() firmar;
  final int firmado;

  const CardSoldier({
    Key key,
    this.initials,
    this.remove,
    this.firmar,
    this.ficha,
    this.puestoDescripcion,
    this.nombre,
    this.firmado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            ListTile(
              isThreeLine: true,
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(
                  this.initials,
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              title: Text(
                this.nombre,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.0),
                  Text(this.ficha),
                  SizedBox(height: 5.0),
                  Text(this.puestoDescripcion),
                ],
              ),
            ),
            this.firmado != 1
                ? Container(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: Text('Remover',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: this.remove,
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Expanded(
                            child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                child: Text('Firmar',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: this.firmar),
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 21.0),
                    child: _signedWelder(),
                  )
          ],
        ),
      ),
    );
  }

  Widget _signedWelder() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Icon(Icons.check_circle_sharp, size: 50.0, color: Colors.green),
    );
  }
}
