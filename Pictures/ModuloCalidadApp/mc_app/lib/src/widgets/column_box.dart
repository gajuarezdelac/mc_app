import 'package:flutter/material.dart';

class ColumnBox extends StatelessWidget {
  final String titlePrincipal;
  final String information;
  final double fontSize;

  const ColumnBox(
      {Key key,
      this.information = '',
      this.titlePrincipal = '',
      this.fontSize = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              this.titlePrincipal,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: this.fontSize),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              this.information,
              overflow: TextOverflow.visible,
              softWrap: true,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: this.fontSize,
              ),
            ),
          ),
          SizedBox(
            height: 3,
          )
        ],
      ),
    );
  }
}
