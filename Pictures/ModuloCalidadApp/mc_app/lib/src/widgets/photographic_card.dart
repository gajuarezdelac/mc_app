import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

class PhotographicCard extends StatelessWidget {
  final PhotographicEvidenceModel imagen;
  final void Function(String content) preview;
  final void Function(String id) delete;
  final bool readOnly;

  const PhotographicCard({
    Key key,
    this.imagen,
    this.preview,
    this.delete,
    this.readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                preview(imagen.content);
              },
              child: Container(
                  child: Image.memory(
                base64.decode(imagen.thumbnail),
                height: 150,
                width: 140,
                fit: BoxFit.fill,
              ))),
          Positioned(
              top: 0,
              right: 0,
              child: readOnly
                  ? Container(width: 0.0, height: 0.0)
                  : Padding(
                      child: GestureDetector(
                          onTap: () {
                            delete(imagen.fotoId);
                          },
                          child: Icon(Icons.close, color: Colors.red)),
                      padding: EdgeInsets.all(5))),
          Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Text(
                    imagen.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Regular'),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class PhotographicCardWelding extends StatelessWidget {
  final PhotographicEvidenceWeldingModel imagen;
  final void Function(String content) preview;
  final void Function(String id) delete;
  final int readOnly;

  const PhotographicCardWelding({
    Key key,
    this.imagen,
    this.preview,
    this.delete,
    this.readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                preview(imagen.content);
              },
              child: Container(
                  child: Image.memory(
                base64.decode(imagen.thumbnail),
                height: 150,
                width: 140,
                fit: BoxFit.fill,
              ))),
          Positioned(
              top: 0,
              right: 0,
              child: readOnly == 1
                  ? Container(width: 0.0, height: 0.0)
                  : Padding(
                      child: GestureDetector(
                          onTap: () {
                            delete(imagen.fotoId);
                          },
                          child: Icon(Icons.close, color: Colors.red)),
                      padding: EdgeInsets.all(5))),
          Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Text(
                    imagen.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Regular'),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class PhotographicCardIP extends StatelessWidget {
  final PhotographicEvidenceIPModel imagen;
  final void Function(String content) preview;
  final void Function(String id) delete;
  final bool readOnly;

  const PhotographicCardIP({
    Key key,
    this.imagen,
    this.preview,
    this.delete,
    this.readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                preview(imagen.content);
              },
              child: Container(
                  child: Image.memory(
                base64.decode(imagen.thumbnail),
                height: 150,
                width: 140,
                fit: BoxFit.fill,
              ))),
          Positioned(
              top: 0,
              right: 0,
              child: readOnly
                  ? Container(width: 0.0, height: 0.0)
                  : Padding(
                      child: GestureDetector(
                          onTap: () {
                            delete(imagen.fotoId);
                          },
                          child: Icon(Icons.close, color: Colors.red)),
                      padding: EdgeInsets.all(5))),
          Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Text(
                    imagen.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Regular'),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
