import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/reports/envio_materiales_corrosion.dart';
import 'package:mc_app/src/bloc/materials_corrosion/bloc.dart';
import 'package:mc_app/src/bloc/materials_corrosion/report_send_materials_corrosion/rpt_materials_corrosion_bloc.dart';
import 'package:mc_app/src/bloc/materials_corrosion/report_send_materials_corrosion/rpt_materials_corrosion_event.dart';
import 'package:mc_app/src/bloc/materials_corrosion/report_send_materials_corrosion/rpt_materials_corrosion_state.dart';
import 'package:mc_app/src/bloc/materials_corrosion/spool_detalle_proteccion/spool_detalle_proteccion_bloc.dart';
import 'package:mc_app/src/bloc/materials_corrosion/spool_detalle_proteccion/spool_detalle_proteccion_event.dart';
import 'package:mc_app/src/models/materiales_corrosion_model.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/show_general_loading.dart';

class ListOfMaterials extends StatefulWidget {
  final ScrollController controller;
  final List<MaterialesCorrosionModel> joints;
  final Function(MaterialesCorrosionModel item) navigateToDetails;
  final Orientation orientation;

  const ListOfMaterials({
    Key key,
    this.controller,
    this.orientation,
    this.joints,
    this.navigateToDetails,
  }) : super(key: key);

  @override
  _ListOfMaterialsState createState() => _ListOfMaterialsState();
}

class _ListOfMaterialsState extends State<ListOfMaterials> {
  RptMaterialsCorrosionBloc rptMaterialsCorrosionBloc;
  SpoolDetalleProteccionBloc spoolDetalleProteccionBloc;
  RptMaterialsCorrosionHeader rptMaterialsCorrosionHeader;
  List<SpoolDetalleProteccionModel> lstSpoolDetalleProteccion;

  @override
  void initState() {
    super.initState();
    initialData();
  }

  void initialData() {
    rptMaterialsCorrosionBloc =
        BlocProvider.of<RptMaterialsCorrosionBloc>(context);

    spoolDetalleProteccionBloc =
        BlocProvider.of<SpoolDetalleProteccionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpoolDetalleProteccionBloc,
        SpoolDetalleProteccionState>(
      listener: (context, state) {
        if (state is SuccessGetSpoolDetalleProteccion) {
          Navigator.pop(context);
        } else if (state is IsLoadingSpoolDetalleProteccion) {
          showGeneralLoading(context);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: MultiBlocListener(
            listeners: [
              listenerMaterialCorrosionHeader(),
              listenerMaterialCorrosionList()
            ],
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _jointList(context, widget.joints),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _jointList(
      BuildContext context, List<MaterialesCorrosionModel> joints) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) /
        (widget.orientation == Orientation.portrait || size.width < 800 ? 2.8 : 1);
    final double itemWidth = size.width / 1.9;

    return Container(
        child: GridView.count(
      crossAxisCount:
          widget.orientation == Orientation.portrait || size.width < 800 ? 2 : 3,
      childAspectRatio: (itemWidth / itemHeight),
      shrinkWrap: true,
      controller: widget.controller,
      scrollDirection: Axis.vertical,
      children: List.generate(joints.length, (index) {
        return _jointItem(context, joints[index]);
      }),
    ));
  }

  Widget _jointItem(BuildContext context, MaterialesCorrosionModel item) {
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
            tileColor: Colors.indigo[900],
            child: ListTile(
              title: Text(
                'No. envio: ${item.noEnvio}',
                style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                      Text('No. Registro Insp.: '),
                      Expanded(
                        child: Text(
                          item.noRegistroInspeccion,
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
                      Text('Contrato: '),
                      Expanded(
                        child: Text(
                          item.contrato,
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
                      Text('OT: '),
                      Text(
                        item.obra,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10.0),
                      Text('Destino: '),
                      Expanded(
                        child: Text(
                          item.destino,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
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
                      Text(
                        DateFormat('dd/MM/yy').format(
                            DateFormat("yyyy-MM-dd HH:mm:ss")
                                .parse(item.fecha)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10.0),
                      Text('Depto. Sol: '),
                      Expanded(
                        child: Text(
                          item.deptoSolicitante,
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
                      Text('Observaciones: '),
                      Expanded(
                        child: Text(
                          item.observaciones,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Acciones: "),
                SizedBox(width: 10.0),
                IconButton(
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    size: 30.0,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    widget.navigateToDetails(item);
                  },
                ),
                SizedBox(width: 2.0),
                IconButton(
                    icon: Icon(Icons.print_outlined,
                        size: 30.0, color: Colors.blue),
                    onPressed: () {
                      // registroSalidaNoConforme(context);
                      rptMaterialsCorrosionBloc
                          .add(GetRptMaterialsCorosion(noEnvio: item.noEnvio));
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BlocListener listenerMaterialCorrosionHeader() {
    return BlocListener<RptMaterialsCorrosionBloc, RptMaterialsCorrosionState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingRptMaterialsCorrosion) {
        return loadingCircular();
      } else if (state is SuccessGetRptMaterialsCorrosion) {
        setState(() {
          rptMaterialsCorrosionHeader = state.materials;
        });

        spoolDetalleProteccionBloc.add(GetAllSpoolDetalleProteccion(
            noEnvio: state.materials.noEnvio, isReport: true));
      } else if (state is ErrorRptMaterialsCorrosion) {
        Navigator.pop(context);
      }
    });
  }

  BlocListener listenerMaterialCorrosionList() {
    return BlocListener<SpoolDetalleProteccionBloc,
        SpoolDetalleProteccionState>(listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (state is SuccessGetSpoolDetalleProteccion) {
        setState(() {
          lstSpoolDetalleProteccion = state.lstSpoolDetalleProteccion;
        });

        if (lstSpoolDetalleProteccion.first.isReport) {
          envioMaterialesCorrosion(
              context, rptMaterialsCorrosionHeader, lstSpoolDetalleProteccion);
        }
      } else if (state is ErrorSpoolDetalleProteccion) {
        Navigator.pop(context);
      }
    });
  }
}
