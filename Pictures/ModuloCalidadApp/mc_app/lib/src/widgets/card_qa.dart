import 'package:flutter/material.dart';

class CardQA extends StatelessWidget {
  final String initialsQA;
  final String name;
  final String category;
  final String normStatus;
  final String ficha;
  final String cambioMaterial;
  final void Function() onPressedOutNorm;
  final void Function() onPressedFN;
  final void Function() onpressedDN;

  const CardQA({
    Key key,
    this.ficha,
    this.name,
    this.category,
    this.initialsQA,
    this.normStatus,
    this.onPressedFN,
    this.onpressedDN,
    this.onPressedOutNorm,
    this.cambioMaterial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: normStatus == 'D/N'
          ? Colors.blue[700]
          : normStatus == 'F/N'
              ? Colors.red[700]
              : Colors.white,
      elevation: 2.0,
      child: GestureDetector(
        onTap: this.normStatus == "F/N" && this.cambioMaterial == "NO APLICA"
            ? this.onPressedOutNorm
            : null,
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text(
                    this.initialsQA,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                title: Text(
                  this.name,
                  style: TextStyle(
                      color: normStatus == 'D/N' || normStatus == 'F/N'
                          ? Colors.white
                          : Colors.black),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.0),
                    Text(
                      this.ficha,
                      style: TextStyle(
                        color: normStatus == 'D/N' || normStatus == 'F/N'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      this.category,
                      style: TextStyle(
                        color: normStatus == 'D/N' || normStatus == 'F/N'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              normStatus == 'D/N' || normStatus == 'F/N'
                  ? Container(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        left: 10.0,
                        right: 10.0,
                        bottom: 10.0,
                      ),
                      child: Text(
                        normStatus == 'D/N'
                            ? 'D/N (Dentro de Norma)'
                            : 'F/N (Fuera de Norma)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  : Container(
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
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  child: Text('F/N',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: this.onPressedFN),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: TextButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                                  child: Text('D/N',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: this.onpressedDN),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
