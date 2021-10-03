import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/src/bloc/materials_corrosion/bloc.dart';
import 'package:mc_app/src/bloc/materials_corrosion/spool_detalle_proteccion/spool_detalle_proteccion_state.dart';
import 'package:mc_app/src/models/materiales_corrosion_model.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';
import 'package:mc_app/src/widgets/spinkit.dart';
import 'package:mc_app/src/widgets/text.dart';

class MaterialToCorrosion extends StatefulWidget {
  static String id = "Material a Corrosión";
  final MaterialesCorrosionModel item;

  MaterialToCorrosion({Key key, @required this.item}) : super(key: key);

  @override
  _MaterialToCorrosionState createState() => _MaterialToCorrosionState();
}

class _MaterialToCorrosionState extends State<MaterialToCorrosion> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(MaterialToCorrosion.id)),
      body: Container(
          padding: EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text('No. Envio:', true),
                          SizedBox(width: 0),
                          text(widget.item.noEnvio, false),
                          SizedBox(width: 10.0),
                          text('Destino:', true),
                          text(widget.item.destino, false),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text('Contrato:', true),
                          SizedBox(width: 10.0),
                          text(widget.item.contrato, false),
                          SizedBox(width: 10.0),
                          text('Depto. Solicitante:', true),
                          text(widget.item.deptoSolicitante, false),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text('Obra:', true),
                          SizedBox(width: 10.0),
                          text(widget.item.obra, false),
                          SizedBox(width: 10.0),
                          text('Fecha:', true),
                          text(
                              DateFormat('dd/MM/yyyy').format(
                                  DateFormat("yyyy-MM-dd HH:mm:ss")
                                      .parse(widget.item.fecha)),
                              false)
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Observaciones',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              widget.item.observaciones,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          )
                          // text(widget.item.observaciones, false),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              BlocBuilder<SpoolDetalleProteccionBloc,
                  SpoolDetalleProteccionState>(builder: (context, state) {
                if (state is SuccessGetSpoolDetalleProteccion) {
                  return Expanded(
                      child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Container(
                              padding: EdgeInsets.all(15.0),
                              child: ListView(children: <Widget>[
                                SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                        sortColumnIndex: 1,
                                        sortAscending: true,
                                        headingRowColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.hovered))
                                            return Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.08);
                                          return null;
                                        }),
                                        columns: _columns(),
                                        rows: _rows(
                                            state.lstSpoolDetalleProteccion)))
                              ]))));
                }

                if (state is ErrorSpoolDetalleProteccion) {
                  return errorLoadMaterials(state.errorMessage);
                }

                return loading();
              })
            ],
          )),
    );
  }

  List<DataRow> _rows(List<SpoolDetalleProteccionModel> progress) {
    List<DataRow> rows = [];

    progress.sort((a, b) => (a.partida).compareTo(b.partida));

    List<SpoolDetalleProteccionDataTable> rowsBD = mergeRow(progress);

    rowsBD.forEach((item) {
      rows.add(
        DataRow(
          cells: [
            DataCell(Text(item.partida.toString())),
            DataCell(Text(item.nombreElemento)),
            DataCell(Text(item.folio)),
            DataCell(Text(item.plataforma)),
            DataCell(Text(item.plano)),
            DataCell(Text(item.cantidad)),
            DataCell(Text(item.um)),
            DataCell(Text(item.descripcion)),
            DataCell(Text(item.idTrazabilidad)),
          ],
        ),
      );
    });

    return rows;
  }

  List<DataColumn> _columns() {
    List<DataColumn> columns = [];
    List<String> labels = [
      'Partida',
      'Nombre del Elemento',
      'No. de Folio',
      'Plataforma',
      'Plano de Localización/Isometrico',
      'Cantidad',
      'UM',
      'Descripción',
      'Trazabilidad',
    ];

    labels.forEach((item) => columns.add(DataColumn(label: Text(item))));

    return columns;
  }

  //Método para indicar la carga de información
  Widget loading() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          spinkit,
          SizedBox(height: 10),
          Text(
            "Buscando registros...",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
  }

  //Muestra mensaje de error
  Widget errorLoadMaterials(String error) {
    showNotificationSnackBar(
      context,
      title: "",
      mensaje: error,
      icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
      secondsDuration: 8,
      colorBarIndicator: Colors.red,
      borde: 8,
    );

    return Center(
        child: Container(
      padding: EdgeInsets.only(top: 30),
      child: Text("Se ha producido un error al buscar la información"),
    ));
  }

  List<SpoolDetalleProteccionDataTable> mergeRow(
      List<SpoolDetalleProteccionModel> lstDetalle) {
    List<SpoolDetalleProteccionDataTable> newDetalle = [];

    lstDetalle.forEach((x) {
      if (!newDetalle.any((element) => element.partida == x.partida)) {
        newDetalle.add(new SpoolDetalleProteccionDataTable(
            partida: x.partida,
            nombreElemento: x.nombreElemento,
            folio: x.folio,
            plataforma: x.plataforma,
            plano: x.plano,
            cantidad: x.cantidad,
            um: x.um,
            descripcion: x.descripcion,
            idTrazabilidad: x.idTrazabilidad));
      } else {
        int index =
            newDetalle.indexWhere((element) => element.partida == x.partida);
        SpoolDetalleProteccionDataTable item =
            newDetalle.firstWhere((element) => element.partida == x.partida);
        newDetalle[index] = new SpoolDetalleProteccionDataTable(
            partida: x.partida,
            nombreElemento: item.nombreElemento,
            folio: item.folio,
            plataforma: item.plataforma,
            plano: item.plano,
            cantidad: item.cantidad + "\n" + x.cantidad,
            um: item.um + "\n" + x.um,
            descripcion: item.descripcion + "\n" + x.descripcion,
            idTrazabilidad: item.idTrazabilidad + "\n" + x.idTrazabilidad);
      }
    });

    /*String nombreElemento = "";
    String folio = "";
    String plataforma = "";
    String plano = "";
    String cantidad = "";
    String um = "";
    String descripcion = "";
    String idTrazabilidad = "";

    lstDetalle.forEach((x) {
      if (currentPartida == -1) {
        currentPartida = x.partida;
        nombreElemento = x.nombreElemento;
        folio = x.folio;
        plataforma = x.plataforma;
        plano = x.plano;
        cantidad = x.cantidad;
        um = x.um;
        descripcion = x.descripcion;
        idTrazabilidad = x.idTrazabilidad;
      } else {
        if (currentPartida == x.partida) {
          // nombreElemento = nombreElemento + "\n" + x.nombreElemento;
          // folio = folio + "\n" + x.folio;
          // plataforma = plataforma + "\n" + x.plataforma;
          // plano = plano + "\n" + x.plano ;
          cantidad = cantidad + "\n" + x.cantidad;
          um = um + "\n" + x.um;
          descripcion = descripcion + "\n" + x.descripcion;
          idTrazabilidad = idTrazabilidad + "\n" + x.idTrazabilidad;
        } else {
          newDetalle.add(new SpoolDetalleProteccionDataTable(
              partida: currentPartida,
              nombreElemento: nombreElemento,
              folio: folio,
              plataforma: plataforma,
              plano: plano,
              cantidad: cantidad,
              um: um,
              descripcion: descripcion,
              idTrazabilidad: idTrazabilidad));
          nombreElemento = x.nombreElemento;
          folio = x.folio;
          plataforma = x.plataforma;
          plano = x.plano;
          cantidad = x.cantidad;
          um = x.um;
          descripcion = x.descripcion;
          idTrazabilidad = x.idTrazabilidad;
          currentPartida = x.partida;
        }
      }
    });*/
    return newDetalle;
  }
}
