import 'package:flutter/material.dart';

class ListCheckCuadrant extends StatelessWidget {
  final bool f;
  final bool pc;
  final bool r1;
  final bool r2;
  final bool r3;
  final bool r4;
  final bool r5;
  final bool r6;
  final bool v;
  final bool validatorCheck;
  final Function(bool value) onChangedF;
  final Function(bool value) onchangedPC;

  const ListCheckCuadrant({
    Key key,
    this.f = false,
    this.pc = false,
    this.r1 = false,
    this.r2 = false,
    this.r3 = false,
    this.r4 = false,
    this.r5 = false,
    this.r6 = false,
    this.v = false,
    this.validatorCheck = false,
    this.onChangedF,
    this.onchangedPC,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Checkbox(
                checkColor: Colors.greenAccent,
                activeColor: Colors.blue,
                value: this.f,
                onChanged: this.onChangedF,
              ),
              Text('F',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.greenAccent,
                activeColor: Colors.blue,
                value: this.pc,
                onChanged: this.onChangedF,
              ),
              Text('PC',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.greenAccent,
                activeColor: Colors.blue,
                value: this.r1,
                onChanged: this.onChangedF,
              ),
              Text('R1',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.greenAccent,
                activeColor: Colors.blue,
                value: this.r1,
                onChanged: this.onChangedF,
              ),
              Text('R2',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.greenAccent,
                activeColor: Colors.blue,
                value: this.r1,
                onChanged: this.onChangedF,
              ),
              Text('R3',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.greenAccent,
                activeColor: Colors.blue,
                value: this.r1,
                onChanged: this.onChangedF,
              ),
              Text('R4',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.greenAccent,
                activeColor: Colors.blue,
                value: this.r1,
                onChanged: this.onChangedF,
              ),
              Text('R5',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.greenAccent,
                activeColor: Colors.blue,
                value: this.r1,
                onChanged: this.onChangedF,
              ),
              Text('R6',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.greenAccent,
                activeColor: Colors.blue,
                value: this.r1,
                onChanged: this.onChangedF,
              ),
              Text('V',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 10),
            alignment: Alignment.bottomLeft,
            child: Text(
                'Marcar segun la etapa marcada F: Fondeo, PC: Paso Caliente, R: Refresco, V: Vista'),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.bottomLeft,
            child: Text(this.validatorCheck == false
                ? 'Recuerda seleccionar una opción *'
                : ''),
          ),
        ],
      ),
    );
  }
}
