import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';

class AnticorrosiveItems extends StatelessWidget {
  final ScrollController controller;
  final Orientation orientation;

  const AnticorrosiveItems({
    Key key,
    this.orientation,
    this.controller,
    this.navigateToDetails,
    this.printReport,
  }) : super(key: key);

  final Future Function(AnticorrosiveProtectionModel noRegistro)
      navigateToDetails;

  final Future<void> Function(AnticorrosiveProtectionModel noRegistro)
      printReport;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: _itemsGridBuilder(),
      ),
    );
  }

  Widget _itemList(
      BuildContext context, List<AnticorrosiveProtectionModel> data) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) /
        (orientation == Orientation.portrait || size.width < 800 ? 2.8 : 1);
    final double itemWidth = size.width / 1.9;

    return Container(
        child: GridView.count(
      crossAxisCount:
          orientation == Orientation.portrait || size.width < 800 ? 2 : 3,
      childAspectRatio: (itemWidth / itemHeight),
      // controller: new ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      controller: controller,
      scrollDirection: Axis.vertical,
      children: List.generate(data.length, (index) {
        return _item(context, data[index]);
      }),
    ));
  }

  Widget _item(BuildContext context, AnticorrosiveProtectionModel data) {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd");
    DateFormat outputDateFormat = DateFormat("dd/MM/yyyy");
    DateTime dateInput = inputFormat.parse(data.fecha);
    String dateOutput = outputDateFormat.format(dateInput);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[300], width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          ListTileTheme(
            textColor: Colors.white,
            tileColor: Color(int.parse(data.semaforo)),
            child: ListTile(
              title: Text(
                data.noRegistro,
                style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: data.semaforo == '0xFFFFFFFF'
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(top: 5, left: 15),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Text('Contrato: '),
                      Expanded(
                        child: Text(
                          data.contratoId,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Text('OT: '),
                      Expanded(
                        child: Text(
                          data.oT,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      Text('Fecha: '),
                      Expanded(
                        child: Text(
                          dateOutput,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      Text('Instalación: '),
                      Expanded(
                        child: Text(
                          data.instalacion,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      Text('Plataforma: '),
                      Expanded(
                        child: Text(
                          data.plataforma,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(top: 0),
                          child: Text('Sistema Aplicado: '),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          child: Text(
                            data.sistema,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  height: 2.0,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.verified_user,
                    size: 30.0,
                    color: Color(0xFF001D85),
                  ),
                  onPressed: () => navigateToDetails(data),
                ),
                SizedBox(width: 20.0),
                IconButton(
                  icon: Icon(Icons.print, size: 30.0, color: Color(0xFF001D85)),
                  onPressed: () => printReport(data),
                  // onPressed: () => proteccionAnticorrosiva(context, ''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //BlocBuilder para los items del Grid principal
  BlocBuilder _itemsGridBuilder() {
    return BlocBuilder<AnticorrosiveGridBloc, AnticorrosiveGridState>(
        builder: (context, state) {
      return (state is SuccessAntiItems)
          ? state.data.length > 0
              ? _itemList(context, state.data)
              : Container(height: 0.0)
          : Container(height: 0.0);
    });
  }
}
