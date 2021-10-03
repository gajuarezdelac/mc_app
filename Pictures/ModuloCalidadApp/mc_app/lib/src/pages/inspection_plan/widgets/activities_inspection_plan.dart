import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mc_app/reports/reporte_inspeccion_actividades.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/bloc/inspection_plan/activities_inspection_plan/activities_inspection_plan_bloc.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/models/params/inspection_plan_params.dart';
import 'package:mc_app/src/pages/inspection_plan/widgets/register_inspection_plan.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:mc_app/src/widgets/column_box.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/src/widgets/flat_button.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/show_general_loading.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';
import 'package:mc_app/src/widgets/table_initial_ip.dart';

class ActivitiesInspectionPlan extends StatefulWidget {
  final InspectionPlanParams params;
  static String id = "Actividades Plan de Inspección";
  ActivitiesInspectionPlan({Key key, this.params}) : super(key: key);

  @override
  _ActivitiesInspectionPlanState createState() =>
      _ActivitiesInspectionPlanState();
}

class _ActivitiesInspectionPlanState extends State<ActivitiesInspectionPlan> {
  // Variables
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('dd/MM/yyyy');

  // Bloc´s
  ActivitiesInspectionPlanBloc activitiesInspectionPlanBloc;
  RptInspectionBloc rptInspectionBloc;
  TableActivitiesIPBloc ipBloc;

  // Etc
  DTSActividadesIP dtsActividadesIP;

  // Models
  InspectionPlanHeaderModel inspectionPlanHeaderModel;
  RptRIAModel riaModel;
  List<InspectionPlanDModel> listActivities;
  List<ActividadesPT> list;

  @override
  void initState() {
    super.initState();
    initialData();
  }

  void initialData() {
    activitiesInspectionPlanBloc =
        BlocProvider.of<ActivitiesInspectionPlanBloc>(context);
    ipBloc = BlocProvider.of<TableActivitiesIPBloc>(context);
    rptInspectionBloc = BlocProvider.of<RptInspectionBloc>(context);
    activitiesInspectionPlanBloc.add(GetHeaderInspectionPlan(
        noInspectionPlan: widget.params.inspectionPlanCModel.noPlanInspeccion));
    ipBloc.add(GetTableInspectionPlan(
        noInspectionPlan: widget.params.inspectionPlanCModel.noPlanInspeccion));
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Actividades Plan de Inspección'),
        ),
        body: BlocConsumer<RptInspectionBloc, RptInspectionState>(
          listener: (context, state) {
            if (state is SuccessRptRIAInspection) {
              setState(() {
                riaModel = state.riaModel;
              });

              Navigator.pop(context);
              rptInspeccionActividades(context, '', riaModel);
            } else if (state is IsLoadingRptRIAInspection) {
              showGeneralLoading(context);
            }
          },
          builder: (context, state) {
            return GestureDetector(
              child: BlocConsumer<ActivitiesInspectionPlanBloc,
                  ActivitiesInspectionPlanState>(listener: (context, state) {
                if (state is SuccessHeaderInspectionPlan) {
                  Navigator.pop(context);
                  inspectionPlanHeaderModel = state.inspectionPlanHeaderModel;
                } else if (state is IsLoadingHeaderInspectionPlan) {
                  showGeneralLoading(context);
                }
              }, builder: (context, state) {
                if (state is SuccessHeaderInspectionPlan) {
                  return GestureDetector(
                      child: SingleChildScrollView(
                          child: MultiBlocListener(
                    listeners: [
                      listenerDates(),
                      listenerGetReport(),
                    ],
                    child: Container(
                      width: double.infinity,
                      height: responsive.height,
                      child: ListView(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                    elevation: 4.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 5.0,
                                          left: 40,
                                          right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            state.inspectionPlanHeaderModel
                                                .riaId,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.print_outlined,
                                            ),
                                            color: state.inspectionPlanHeaderModel
                                                        .semaforo ==
                                                    'blue'
                                                ? Colors.blue
                                                : (state.inspectionPlanHeaderModel
                                                            .semaforo ==
                                                        'green')
                                                    ? Colors.green
                                                    : (state.inspectionPlanHeaderModel
                                                                .semaforo ==
                                                            'red')
                                                        ? Colors.red
                                                        : Colors.black38,
                                            onPressed: () {
                                              state.inspectionPlanHeaderModel
                                                              .actividadesDN ==
                                                          0 &&
                                                      state.inspectionPlanHeaderModel
                                                              .semaforo !=
                                                          'green'
                                                  // ignore: unnecessary_statements
                                                  ? null
                                                  : rptInspectionBloc.add(GetRptId(
                                                      list: listActivities,
                                                      noPlanInspeccion: widget
                                                          .params
                                                          .inspectionPlanCModel
                                                          .noPlanInspeccion,
                                                      tipo: 1));
                                            },
                                            iconSize: 45,
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 10.0, bottom: 20.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(
                                                left: 15, right: 5, top: 5),
                                            child: Column(
                                              children: <Widget>[
                                                ColumnBox(
                                                  titlePrincipal:
                                                      'No. Plan de Inspeccion:',
                                                  information:
                                                      '${widget.params.inspectionPlanCModel.noPlanInspeccion}',
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ColumnBox(
                                                  titlePrincipal: 'Contrato:',
                                                  information:
                                                      '${widget.params.contractsInspectionPlanModel.nombre}(${widget.params.contractsInspectionPlanModel.contratoId})',
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ColumnBox(
                                                  titlePrincipal: 'Obra:',
                                                  information:
                                                      '${widget.params.worksInspectionPlanModel.oT} (${widget.params.worksInspectionPlanModel.obraId})',
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ColumnBox(
                                                  titlePrincipal:
                                                      'Embarcación:',
                                                  information:
                                                      '${state.inspectionPlanHeaderModel.embarcacion}',
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ColumnBox(
                                                  titlePrincipal: 'Fecha:',
                                                  information:
                                                      '${formatter.format(now)}',
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ColumnBox(
                                                  titlePrincipal:
                                                      'Descripción:',
                                                  information:
                                                      '${widget.params.inspectionPlanCModel.descripcion}',
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(
                                                left: 5, right: 10),
                                            child: Column(
                                              children: <Widget>[
                                                ColumnBox(
                                                  titlePrincipal:
                                                      'Instalación:',
                                                  information:
                                                      '${widget.params.inspectionPlanCModel.instalacion}',
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ColumnBox(
                                                  titlePrincipal: 'Elabora:',
                                                  information:
                                                      '${state.inspectionPlanHeaderModel.empleadoElabora}',
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ColumnBox(
                                                  titlePrincipal: 'Revisa:',
                                                  information:
                                                      '${state.inspectionPlanHeaderModel.empleadoRevisa}',
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                ColumnBox(
                                                  titlePrincipal: 'Aprueba:',
                                                  information:
                                                      '${state.inspectionPlanHeaderModel.empleadoAprueba}',
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: BlocBuilder<TableActivitiesIPBloc,
                                        TableActivitiesIPState>(
                                      builder: (context, state) {
                                        if (state is SuccessTableActivitiesIP) {
                                          dtsActividadesIP = DTSActividadesIP(
                                              state.inspectionPlanDModel,
                                              context,
                                              inspectionPlanHeaderModel,
                                              widget.params,
                                              riaModel,
                                              rptInspectionBloc,
                                              listActivities);

                                          listActivities =
                                              state.inspectionPlanDModel;

                                          return PaginatedDataTable(
                                            rowsPerPage: 5,
                                            showCheckboxColumn: false,
                                            header: Text('Actividades'),
                                            source: dtsActividadesIP ?? [],
                                            columns: [
                                              DataColumn(
                                                  label: Text('',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Partida',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Anexo',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('PartidaPU',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Id Primavera',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text(
                                                      'Actividad Cliente',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Folio',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Reprogramación',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Plano',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text(
                                                      'Descripción de actividad',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Especialidad',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Sistema',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Del:	',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Al:',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('Estatus:	',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              DataColumn(
                                                  label: Text('%Avance:',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold))),
                                            ],
                                          );
                                        } else if (state
                                            is IsLoadingTableActivitiesIP) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 50, 0, 0),
                                                  child: Center(
                                                    child: spinkit,
                                                  )),
                                            ],
                                          );
                                        } else if (state
                                            is ErrorTableActivitiesIP) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: Text(
                                                      'Parece que ha ocurrido un error')),
                                            ],
                                          );
                                        }
                                        return TableInitialIP();
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  )));
                }
                return Container();
              }),
            );
          },
        ));
  }

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(color: Colors.black),
      );
    },
  );

  BlocListener listenerGetReport() {
    return BlocListener<RptInspectionBloc, RptInspectionState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is SuccessInsRptRIA) {
        rptInspectionBloc.add(CreateRptRIA(riaId: state.riaId));
      }
    });
  }

  BlocListener listenerDates() {
    return BlocListener<ListMaterialsBloc, ListMaterialsState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingUpdateReporteIP) {
        return loadingCircular();
      } else if (state is SuccessUpdateReporteIP) {
        ipBloc.add(GetTableInspectionPlan(
            noInspectionPlan:
                widget.params.inspectionPlanCModel.noPlanInspeccion));
      } else if (state is ErrorUpdateReporteIP) {
        Navigator.pop(context);
      }
    });
  }
}

class DTSActividadesIP extends DataTableSource {
  final List<InspectionPlanDModel> _list;
  BuildContext context;
  InspectionPlanHeaderModel inspectionPlanHeaderModel;
  InspectionPlanParams inspectionPlanParams;
  RptRIAModel riaModel;
  RptInspectionBloc rptInspectionBloc;
  List<InspectionPlanDModel> list;

  DTSActividadesIP(
      this._list,
      this.context,
      this.inspectionPlanHeaderModel,
      this.inspectionPlanParams,
      this.riaModel,
      this.rptInspectionBloc,
      this.list);

  @override
  DataRow getRow(int index) {
    final element = _list[index];

    return DataRow.byIndex(
      selected: element.selected,
      onSelectChanged: (bool selected) {
        element.selected = selected;

        showAlertDialog(context, element);
        element.selected = false;
        notifyListeners();
      },
      index: index,
      cells: <DataCell>[
        DataCell(Container(
          width: 20.0,
          height: 20.0,
          decoration: new BoxDecoration(
            color: element.semaforo == 'black'
                ? Colors.black
                : (element.semaforo == 'red')
                    ? Colors.red
                    : (element.semaforo == 'green')
                        ? Colors.green
                        : (element.semaforo == 'black')
                            ? Colors.black
                            : Colors.black38,
            shape: BoxShape.circle,
          ),
        )), //Extracting from Map element the value
        DataCell(Text(element.partidaInterna == null
            ? 'Sin partida'
            : element.partidaInterna)),
        DataCell(Text(element.anexo)),
        DataCell(Text(element.partidaPU)),
        DataCell(Text(element.primaveraId)),
        DataCell(Text(element.actividadCliente)),
        DataCell(Text(element.folio)),
        DataCell(Text(element.reprogramacionOT)),
        DataCell(Text(element.plano)),
        DataCell(Text(element.descripcionActividad)),
        DataCell(Text(element.especialidad)),
        DataCell(Text(element.sistema)),
        DataCell(Text(element.fechaInicio)),
        DataCell(Text(element.fechaFin)),
        DataCell(Text(element.estatus)),
        DataCell(Text(element.avance.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _list.length ?? 0;

  @override
  int get selectedRowCount => 0;

  showAlertDialog(
    BuildContext context,
    InspectionPlanDModel element,
  ) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: flatButton(Colors.white, Icons.auto_awesome_mosaic, 'Acciones',
          Colors.black, () {}),
      content: Container(
        height: 130,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 150, right: 150),
              child: Text(
                "¿Qué acción desea realizar?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.dashboard_customize,
                            color: Colors.white, size: 26.0),
                        SizedBox(width: 10.0),
                        Text(
                          'Rev. Actividades',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      inspectionPlanParams.userPermissionModel
                              .inspectionPlanActivityInspectionLog
                          ? _navigateToWeldingDetail(element)
                          : mensajeRol();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: element.semaforo != 'green'
                          ? Colors.black38
                          : (element.riaID == null || element.riaID == '')
                              ? Colors.blue
                              : Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.print_outlined,
                            color: Colors.white, size: 26.0),
                        SizedBox(width: 10.0),
                        Text(
                          'Generar Reporte',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      element.semaforo == 'green'
                          ? rptInspectionBloc.add(GetRptId(
                              list: _list
                                  .where((e) =>
                                      e.partidaInterna ==
                                      element.partidaInterna)
                                  .toList(),
                              noPlanInspeccion: inspectionPlanParams
                                  .inspectionPlanCModel.noPlanInspeccion,
                              tipo: 2))
                          // ignore: unnecessary_statements
                          : null;
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void mensajeRol() {
    showNotificationSnackBar(context,
        title: "",
        mensaje: 'No tienes el rol para continuar!!',
        icon: Icon(
          Icons.check_circle_outline_sharp,
          size: 28.0,
          color: Colors.yellow[300],
        ),
        secondsDuration: 3,
        colorBarIndicator: Colors.yellow,
        borde: 8);
  }

  Future _navigateToWeldingDetail(InspectionPlanDModel inspectionPlanDModel) {
    RegisterInspectionPlanParams _params = RegisterInspectionPlanParams(
        inspectionPlanDModel: inspectionPlanDModel,
        inspectionPlanHeaderModel: inspectionPlanHeaderModel,
        inspectionPlanParams: inspectionPlanParams);

    Navigator.pop(context);
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterInspectionPlan(params: _params),
      ),
    );
  }
}
