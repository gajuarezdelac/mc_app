import 'dart:typed_data';

import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Uint8List bytes;
  DetailScreen({@required this.bytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
        colors: <Color>[
          const Color.fromRGBO(0, 0, 0, 0.9),
          const Color.fromRGBO(0, 0, 0, 0.5),
        ],
        stops: [0.2, 1.0],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(0.0, 1.0),
      )),
      child: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.memory(
              bytes,
              width: 700,
              height: 600,
              fit: BoxFit.fill,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ));
  }
}
