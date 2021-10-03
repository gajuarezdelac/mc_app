import 'package:flutter/material.dart';

class CardWeldingMachine extends StatelessWidget {
  final String imagen;
  final String noSerie;
  final String marca;
  final String descripcion;
  final Function() remove;
  final int firmado;

  const CardWeldingMachine(
      {Key key,
      this.imagen = 'assets/img/maquina.png',
      this.noSerie = '',
      this.descripcion = '',
      this.marca = '',
      this.firmado,
      this.remove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 3.0,
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ListTile(
              isThreeLine: true,
              leading: ClipRRect(
                child: Image.asset(this.imagen),
              ),
              title: Text(
                this.noSerie,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Text(this.descripcion, maxLines: 1),
                  SizedBox(height: 10.0),
                  Text(this.marca),
                ],
              ),
            ),
            this.firmado != 1
                ? Container(
                    padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                    child: SizedBox(
                      width: double.infinity,
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
                  )
                : _signedMachineWelding(),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _signedMachineWelding() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Icon(Icons.check_circle_sharp, size: 50.0, color: Colors.green),
    );
  }
}
