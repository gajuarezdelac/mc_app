import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mc_app/reports/plan_inspeccion.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/models/params/inspection_plan_params.dart';
import 'package:mc_app/src/models/user_permission_model.dart';
import 'package:mc_app/src/pages/inspection_plan/widgets/activities_inspection_plan.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:mc_app/src/widgets/flat_button.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/show_general_loading.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';

class InspectionPlanPage extends StatefulWidget {
  InspectionPlanPage({Key key}) : super(key: key);

  static String id = "Plan de Inspección";

  @override
  _InspectionPlanPageState createState() => _InspectionPlanPageState();
}

class _InspectionPlanPageState extends State<InspectionPlanPage> {
  final formKey = new GlobalKey<FormState>();

  WorksInspectionPlanBloc worksInspectionPlanBloc;
  ListActivitiesBloc listActivitiesBloc;
  String _contractSelection;
  String _workSelection;
  UserPermissionModel userPermissionModel;

  InspectionPlanParams _params;
  ContractsInspectionPlanModel _contractsInspectionPlanModel;
  InspectionPlanCModel _inspectionPlanCModel;
  WorksInspectionPlanModel _worksInspectionPlanModel;
  RptInspectionBloc rptInspectionBloc;
  ContractsInspectionPlanModel _contract;
  WorksInspectionPlanModel _work;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ListActivitiesBloc>(context)
        .add(GetListActivitiesC(contractId: '', workId: '', clear: true));
    userPermissionModel =
        BlocProvider.of<UserPermissionBloc>(context).state.permissions;
    rptInspectionBloc = BlocProvider.of<RptInspectionBloc>(context);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        //you can do anything here
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        //you can do anything here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    worksInspectionPlanBloc = BlocProvider.of<WorksInspectionPlanBloc>(context);
    listActivitiesBloc = BlocProvider.of<ListActivitiesBloc>(context);

    return OrientationBuilder(builder: (context, orientation) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Plan de Inspección'),
          ),
          body: BlocConsumer<RptInspectionBloc, RptInspectionState>(
            listener: (context, state) {
              if (state is SuccessRptIP) {
                Navigator.pop(context);
                planInspeccion(context, '', state.rptInspectionPlanModel);
              } else if (state is IsLoadingRptIP) {
                showGeneralLoading(context);
              }
            },
            builder: (context, state) {
              return GestureDetector(
                child: BlocListener<ListActivitiesBloc, ListActivitiesState>(
                  listener: (context, state) {
                    if (state is SuccessWeldingList) {}
                  },
                  child: Builder(
                    builder: (context) => Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: responsive.dp(1),
                              left: responsive.dp(0.5),
                              bottom: responsive.dp(1),
                              right: responsive.dp(0.5),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: responsive.dp(.1),
                                    top: responsive.dp(.1),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: Colors.grey[50],
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: responsive.dp(.3),
                                                    top: responsive.dp(.3)),
                                                child: Row(children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: responsive
                                                              .dp(0.2),
                                                          right: responsive
                                                              .dp(0.2)),
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: BlocBuilder<
                                                            ContractsInspectionPlanBloc,
                                                            ContractsInspectionPlanState>(
                                                          builder:
                                                              (context, state) {
                                                            if (state
                                                                is SuccessContractInspectionPlan) {
                                                              return DropdownSearch<
                                                                  ContractsInspectionPlanModel>(
                                                                showSearchBox:
                                                                    true,
                                                                itemAsString:
                                                                    (ContractsInspectionPlanModel
                                                                            u) =>
                                                                        u.contratoId +
                                                                        ' - ' +
                                                                        u.nombre,
                                                                mode: Mode.MENU,
                                                                hint:
                                                                    'Seleccione un Contrato',
                                                                label:
                                                                    'Contrato',
                                                                items: state
                                                                    .listContractsInspectionPlan,
                                                                selectedItem:
                                                                    _contract,
                                                                onChanged:
                                                                    (obj) {
                                                                  setState(() {
                                                                    _contractsInspectionPlanModel =
                                                                        obj;
                                                                    _contractSelection =
                                                                        obj.contratoId;
                                                                    _workSelection =
                                                                        null;
                                                                    _work =
                                                                        null;
                                                                  });

                                                                  listActivitiesBloc.add(GetListActivitiesC(
                                                                      contractId:
                                                                          _contractSelection,
                                                                      workId:
                                                                          _workSelection,
                                                                      clear:
                                                                          true));

                                                                  worksInspectionPlanBloc.add(
                                                                      GetWorksByIdInspectionPlan(
                                                                          contractId:
                                                                              obj.contratoId));
                                                                },
                                                              );
                                                            } else if (state
                                                                is ErrorContractInspectionPlan) {
                                                              return _dropDownSearchError(
                                                                'Contrato',
                                                                'Seleccione un Contrato',
                                                                state.message,
                                                              );
                                                            }
                                                            return _dropDownSearchError(
                                                              'Contrato',
                                                              'Cargando...',
                                                              'Cargando...',
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5,
                                                                right: 10),
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: BlocBuilder<
                                                              WorksInspectionPlanBloc,
                                                              WorksInspectionPlanState>(
                                                            builder: (context,
                                                                state) {
                                                              if (state
                                                                  is SuccessWorksInspectionPlan) {
                                                                return DropdownSearch<
                                                                    WorksInspectionPlanModel>(
                                                                  showSearchBox:
                                                                      true,
                                                                  itemAsString:
                                                                      (WorksInspectionPlanModel
                                                                              u) =>
                                                                          u.oT,
                                                                  mode:
                                                                      Mode.MENU,
                                                                  hint:
                                                                      'Seleccione una Obra',
                                                                  label: 'Obra',
                                                                  items: state
                                                                      .listWorksInspectionPlan,
                                                                  selectedItem:
                                                                      _work,
                                                                  onChanged:
                                                                      (obj) {
                                                                    setState(
                                                                        () {
                                                                      _worksInspectionPlanModel =
                                                                          obj;
                                                                      _workSelection =
                                                                          obj.obraId;
                                                                      _work =
                                                                          obj;
                                                                    });
                                                                    listActivitiesBloc.add(GetListActivitiesC(
                                                                        contractId:
                                                                            '',
                                                                        workId:
                                                                            '',
                                                                        clear:
                                                                            true));
                                                                  },
                                                                );
                                                              } else if (state
                                                                  is ErrorWorks) {
                                                                return _dropDownSearchError(
                                                                  'Obra',
                                                                  'Seleccione una Obra',
                                                                  state.message,
                                                                );
                                                              } else if (state
                                                                  is InitialWorksInspectionPlanState) {
                                                                return _dropDownSearchError(
                                                                  'Obra',
                                                                  'Seleccione una Obra',
                                                                  'Seleccione una Obra',
                                                                );
                                                              }

                                                              return loadingCircular();
                                                            },
                                                          ),
                                                        ),
                                                      )),
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      flatButton(
                                        Colors.blue,
                                        Icons.search,
                                        'Buscar',
                                        Colors.white,
                                        () {
                                          if (_contractSelection != null &&
                                              _workSelection != null) {
                                            listActivitiesBloc.add(
                                                GetListActivitiesC(
                                                    contractId:
                                                        _contractSelection,
                                                    workId: _workSelection,
                                                    clear: false));
                                          } else {
                                            showNotificationSnackBar(context,
                                                title: "",
                                                mensaje:
                                                    'Seleccione ambos filtros',
                                                icon: Icon(
                                                  Icons.info,
                                                  size: 28.0,
                                                  color: Colors.yellow[300],
                                                ),
                                                secondsDuration: 3,
                                                colorBarIndicator:
                                                    Colors.yellow,
                                                borde: 8);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: BlocBuilder<ListActivitiesBloc,
                                ListActivitiesState>(builder: (context, state) {
                              if (state is InitialListActivitiesState) {
                                return Container();
                              } else if (state is SuccessListActivities) {
                                if (state.list.isEmpty && !state.clear) {
                                  return viewPrincipal(
                                      'No se encontro ningún Plan De Inspección');
                                }
                                if (state.list.isEmpty && state.clear) {
                                  return viewPrincipal(
                                      'Es necesario realizar una busqueda');
                                }
                                return _list(context, state.list, orientation);
                              } else if (state is IsLoadingListActivities) {
                                return spinkit;
                              } else if (state is ErrorListActivities) {
                                return Text(state.message);
                              }

                              return loadingCircular();
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(color: Colors.black),
      );
    },
  );

  void mensajeRol() {
    showNotificationSnackBar(context,
        title: "",
        mensaje: 'No es posible continuar con esta operación',
        icon: Icon(
          Icons.info,
          size: 28.0,
          color: Colors.yellow[300],
        ),
        secondsDuration: 3,
        colorBarIndicator: Colors.yellow,
        borde: 8);
  }

  Widget _dropDownSearchError(String title, String hintTitle, String message) {
    return DropdownSearch<String>(
        mode: Mode.MENU,
        hint: hintTitle,
        label: title,
        items: message == "" ? [] : [message]);
  }

  Widget _list(BuildContext context, List<InspectionPlanCModel> list,
      Orientation orientation) {
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
      scrollDirection: Axis.vertical,
      children: List.generate(list.length, (index) {
        return _item(context, list, index);
      }),
    ));
  }

  // Widget _list(BuildContext context, List<InspectionPlanCModel> list) {
  //   final Responsive responsive = Responsive.of(context);

  //   return OrientationBuilder(
  //     builder: (context, orientation) {
  //       return Container(
  //           child: GridView.count(
  //         crossAxisCount:
  //             orientation == Orientation.portrait || responsive.width < 800
  //                 ? 2
  //                 : 3,
  //         childAspectRatio: (responsive.wp(75) / responsive.wp(55)),
  //         // controller: new ScrollController(keepScrollOffset: false),
  //         shrinkWrap: true,
  //         scrollDirection: Axis.vertical,
  //         children: List.generate(list.length, (index) {
  //           return _item(context, list, index);
  //         }),
  //       ));
  //     },
  //   );
  // }

  Widget _item(
      BuildContext context, List<InspectionPlanCModel> list, int index) {
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
            tileColor:
                list[index].semaforo == 1 ? Colors.green : Colors.black45,
            child: ListTile(
              title: Text(
                'No. Plan Insp.: ${list[index].noPlanInspeccion}',
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
                      Text('Contrato: '),
                      Expanded(
                        child: Text(
                          list[index].contrato,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Text('Actividades: '),
                      Expanded(
                        child: Text(
                          list[index].actividades.toString(),
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
                      Text('OT: '),
                      Expanded(
                        child: Text(
                          '${list[index].obra}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('DN: '),
                      Expanded(
                        child: Text(
                          "${list[index].dn}",
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
                          '${list[index].instalacion}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('FN: '),
                      Expanded(
                        child: Text(
                          '${list[index].fn}',
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
                      Text('Fecha Creación: '),
                      Expanded(
                        child: Text(
                          '${list[index].fechaCreacion.substring(0, 11)}',
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
                          child: Text('Descripción: '),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          child: Text(
                            '${list[index].descripcion}',
                            maxLines: 1,
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
                  icon: Icon(Icons.remove_red_eye, size: 30.0),
                  onPressed: () {
                    _inspectionPlanCModel = list[index];
                    userPermissionModel.inspectionPlanBtnView
                        ? _navigateToWeldingDetail()
                        : mensajeRol();
                  },
                ),
                SizedBox(width: 20.0),
                IconButton(
                  icon: Icon(Icons.print, size: 30.0),
                  onPressed: () {
                    userPermissionModel.inspectionPlanBtnPrint &&
                            list[index].semaforo == 1
                        ? rptInspectionBloc.add(CreateRptIP(
                            noPlanInspeccion: list[index].noPlanInspeccion))
                        : mensajeRol();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget viewPrincipal(String title) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            child: Container(
              child: Center(
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 23,
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.bold))),
            ),
          ),
          Container(
            width: double.infinity,
            height: 220,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  'assets/img/file.png',
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _navigateToWeldingDetail() {
    _params = InspectionPlanParams(
      userPermissionModel: userPermissionModel,
      contractSelection: _contractSelection,
      workSelection: _workSelection,
      inspectionPlanCModel: _inspectionPlanCModel,
      contractsInspectionPlanModel: _contractsInspectionPlanModel,
      worksInspectionPlanModel: _worksInspectionPlanModel,
    );

    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivitiesInspectionPlan(params: _params),
      ),
    );
  }
}
