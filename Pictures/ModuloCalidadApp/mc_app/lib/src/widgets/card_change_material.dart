import 'package:flutter/material.dart';

class CardChangeMaterial extends StatelessWidget {
  final void Function() onpressedYesChanged;
  final void Function() onpressedNotchanged;

  const CardChangeMaterial(
      {Key key, this.onpressedNotchanged, this.onpressedYesChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Center(
              child: Text(
                '¿Requiere cambio de material?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              right: 30.0,
              left: 30.0,
              bottom: 20.0,
              top: 5.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text('No', style: TextStyle(color: Colors.white)),
                      onPressed: this.onpressedNotchanged),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: TextButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                      ),
                      child: Text('Si', style: TextStyle(color: Colors.white)),
                      onPressed: this.onpressedYesChanged),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
