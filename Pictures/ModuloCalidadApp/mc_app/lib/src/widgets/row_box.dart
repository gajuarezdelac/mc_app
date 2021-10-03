import 'package:flutter/material.dart';

class RowBox extends StatelessWidget {
  final String titlePrincipal;
  final String information;
  final double fontSize;

  const RowBox(
      {Key key,
      this.information = '',
      this.titlePrincipal = '',
      this.fontSize = 13})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Text(
              this.titlePrincipal,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            this.information,
            overflow: TextOverflow.visible,
            softWrap: true,
            style: TextStyle(
              fontSize: this.fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
