import 'package:flutter/material.dart';

class CardReleasedOverseer extends StatelessWidget {
  final String initials;
  final String name;
  final String category;
  final String ficha;
  final void Function() released;
  final int weldingReleased;

  const CardReleasedOverseer(
      {Key key,
      this.initials,
      this.name,
      this.category,
      this.ficha,
      this.released,
      this.weldingReleased})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: Column(
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                this.initials,
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
            title: Text(
              this.name,
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${this.ficha} \n\n ${this.category}',
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              child: weldingReleased != 1
                  ? TextButton(
                      style: ElevatedButton.styleFrom(
                        primary: weldingReleased == 1
                            ? Colors.greenAccent
                            : Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      child: Text(
                        'Liberar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: this.released,
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: _weldingReleased(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weldingReleased() {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Icon(Icons.check_circle_sharp, size: 50.0, color: Colors.green),
    );
  }
}
