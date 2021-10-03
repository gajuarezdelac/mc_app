import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/models/contract_cs_dropdown_model.dart';
import 'package:mc_app/src/models/front_dropdown_model.dart';
import 'package:mc_app/src/models/joint_wc_model.dart';
import 'package:mc_app/src/models/params/welding_control_detail_params.dart';
import 'package:mc_app/src/models/plain_detail_dropdown_model.dart';
import 'package:mc_app/src/models/work_dropdown_model.dart';
import 'package:mc_app/src/pages/login_page.dart';
import 'package:mc_app/src/pages/welding_control_detail_page.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:mc_app/src/widgets/NavBar.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mc_app/src/utils/globals.dart' as globals;
import 'package:mc_app/src/utils/dialogs.dart';
import 'package:mc_app/src/pages/sincronization_page.dart';

class WeldingControl extends StatefulWidget {
  static String id = "Control de Soldadura";

  @override
  _WeldingControlState createState() => _WeldingControlState();
}

class _WeldingControlState extends State<WeldingControl> {
  //DropDownWorkBloc dropDownWorkBloc;
  WorkCSBloc workCSBloc;
  DropDownPlainDetailBloc dropDownPlainDetailBloc;
  DropDownFrontBloc dropDownFrontBloc;
  WeldingListBloc weldingListBloc;
  WeldingControlDetailParams _params;
  JointWCModel _joint;
  Color _cardColor = Colors.blueAccent;
  String _contractSelection;
  String _workSelection;
  String _plainDetailSelection;
  String _textGeneralProgress = '0%';
  String _stateFiltered = '';
  int _frontSelection;
  double _generalProgress = 0.0;
  ContractCSDropdownModel _contract;
  WorkDropDownModel _work;
  PlainDetailDropDownModel _plainDetail;
  FrontDropdownModel _front;
  bool _mostrarMsjInicio = false;
  bool _isExpanded = true;
  final List<String> items = [];
  ScrollController _controller;
  ACSBloc _acsBloc;
  ACCBloc _accBloc;

  signOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    BlocProvider.of<WeldingListBloc>(context).add(GetJointsWC(
      plainDetailId: '',
      frontId: 0,
      state: '',
      clear: true,
    ));
    await sharedPreferences.clear();

    await Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.id, (_) => false);
  }

  @override
  void initState() {
    super.initState();
    _acsBloc = BlocProvider.of<ACSBloc>(context);
    _accBloc = BlocProvider.of<ACCBloc>(context);

    _controller = ScrollController();
    _controller.addListener(_scrollListener); //the listener for up and down.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1));
      if (_mostrarMsjInicio) {
        Dialogs.modalConfirmOkOnly(context,
            title: 'BIENVENIDO',
            description:
                'Nos hemos percatado que aún no tienes datos cargados, dirígete a la sección de Sincronización para que comiences el proceso con el cual obtendrás los datos necesarios para comenzar a usar el Módulo de Calidad de Spectrum Móvil.',
            buttonText: 'Entendido', onConfirm: () {
          _mostrarMsjInicio = false;
          /* setState(() {
                globals.indicacionesEntendidas = true;
              });*/
          Navigator.of(context).pop();
          Navigator.pushNamed(context, SincronizationPage.id);
        });
      }
    });
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
    workCSBloc = BlocProvider.of<WorkCSBloc>(context);
    dropDownPlainDetailBloc = BlocProvider.of<DropDownPlainDetailBloc>(context);
    dropDownFrontBloc = BlocProvider.of<DropDownFrontBloc>(context);
    weldingListBloc = BlocProvider.of<WeldingListBloc>(context);

    return OrientationBuilder(builder: (context, orientation) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(WeldingControl.id),
            actions: <Widget>[
              IconButton(
                onPressed: () => signOut(),
                icon: Icon(Icons.exit_to_app_outlined, size: 34),
                tooltip: 'Salir',
              )
            ],
          ),
          drawer: NavBar(),
          body: BlocListener<WeldingListBloc, WeldingListState>(
              listener: (context, state) {
                if (state is SuccessWeldingList) {
                  bool hasProgress = state.joints.isNotEmpty;
                  double progress =
                      hasProgress ? state.joints[0].progresoGeneral : 0.0;
                  setState(() {
                    _generalProgress = progress /= 100;
                    _textGeneralProgress = hasProgress
                        ? '${state.joints[0].progresoGeneral.toStringAsFixed(0)}%'
                        : '0%';
                  });
                }
              },
              child: SingleChildScrollView(
                controller: _controller,
                child: Container(
                  padding: EdgeInsets.only(
                      left: responsive.wp(0.5), right: responsive.wp(0.5)),
                  width: double.infinity,
                  height: responsive.height,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: [
                          // Seccion para ocultar el filtrado!!!
                          ExpansionPanelList(
                            elevation: 0,
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() => _isExpanded = !isExpanded);
                            },
                            children: [
                              ExpansionPanel(
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return Container();
                                },
                                isExpanded: _isExpanded,
                                body: Container(
                                  color: Colors.grey[50],
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: responsive.hp(1.7),
                                                  left: responsive.wp(0.5),
                                                  right: responsive.wp(0.5)),
                                              alignment: Alignment.centerLeft,
                                              child: BlocBuilder<ContractCSBloc,
                                                  ContractCSState>(
                                                builder: (context, state) {
                                                  if (state
                                                      is SuccessContractCS) {
                                                    return DropdownSearch<
                                                        ContractCSDropdownModel>(
                                                      showSearchBox: true,
                                                      itemAsString:
                                                          (ContractCSDropdownModel
                                                                  u) =>
                                                              u.contratoId +
                                                              ' - ' +
                                                              u.nombre,
                                                      mode: Mode.MENU,
                                                      hint:
                                                          'Seleccione un Contrato',
                                                      label: 'Contrato',
                                                      items: state.contracts,
                                                      selectedItem: _contract,
                                                      onChanged: (obj) {
                                                        setState(() {
                                                          _contract = obj;

                                                          _contractSelection =
                                                              obj.contratoId;
                                                          _workSelection = null;
                                                          _plainDetailSelection =
                                                              null;
                                                          _frontSelection =
                                                              null;
                                                          _cardColor =
                                                              Colors.blueAccent;

                                                          _work = null;
                                                          _plainDetail = null;
                                                          _front = null;
                                                        });

                                                        _stateFiltered = '';

                                                        weldingListBloc.add(
                                                          GetJointsWC(
                                                            plainDetailId:
                                                                _plainDetailSelection,
                                                            frontId:
                                                                _frontSelection,
                                                            state: '',
                                                            clear: true,
                                                          ),
                                                        );

                                                        dropDownFrontBloc.add(
                                                          GetFronts(
                                                            clear: true,
                                                            planDetailId: null,
                                                          ),
                                                        );

                                                        dropDownPlainDetailBloc
                                                            .add(GetPlainDetails(
                                                                workId: obj
                                                                    .contratoId,
                                                                clear: true));

                                                        workCSBloc.add(
                                                          GetWorksCS(
                                                            contractId:
                                                                obj.contratoId,
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else if (state
                                                      is ErrorContractCS) {
                                                    return _dropDownSearchError(
                                                        "Contrato",
                                                        "Seleccione un Contrato",
                                                        state.error);
                                                  }

                                                  return loadingCircular();
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: responsive.hp(1.7),
                                                  left: responsive.wp(0.5),
                                                  right: responsive.wp(0.5)),
                                              alignment: Alignment.centerLeft,
                                              child: BlocBuilder<WorkCSBloc,
                                                  WorkCSState>(
                                                builder: (context, state) {
                                                  if (state is SuccessWorkCS) {
                                                    return DropdownSearch<
                                                        WorkDropDownModel>(
                                                      showSearchBox: true,
                                                      itemAsString:
                                                          (WorkDropDownModel
                                                                  u) =>
                                                              u.oT,
                                                      mode: Mode.MENU,
                                                      hint:
                                                          'Seleccione una Obra',
                                                      label: 'Obra',
                                                      items: state.works,
                                                      selectedItem: _work,
                                                      onChanged: (obj) {
                                                        setState(() {
                                                          _work = obj;

                                                          _workSelection =
                                                              obj.obraId;
                                                          _plainDetailSelection =
                                                              null;
                                                          _frontSelection =
                                                              null;
                                                          _cardColor =
                                                              Colors.blueAccent;

                                                          _plainDetail = null;
                                                          _front = null;
                                                        });

                                                        _stateFiltered = '';

                                                        weldingListBloc.add(
                                                          GetJointsWC(
                                                            plainDetailId:
                                                                _plainDetailSelection,
                                                            frontId:
                                                                _frontSelection,
                                                            state: '',
                                                            clear: true,
                                                          ),
                                                        );
                                                        dropDownFrontBloc.add(
                                                          GetFronts(
                                                            clear: true,
                                                            planDetailId: null,
                                                          ),
                                                        );

                                                        dropDownPlainDetailBloc
                                                            .add(GetPlainDetails(
                                                                workId: obj
                                                                    .obraId));
                                                      },
                                                    );
                                                  } else if (state
                                                      is ErrorWorkCS) {
                                                    return _dropDownSearchError(
                                                        "Obra",
                                                        "Seleccione una Obra",
                                                        state.error);
                                                  } else if (state
                                                      is InitialWorkCSState) {
                                                    return _dropDownSearchError(
                                                        "Obra",
                                                        "Seleccione una Obra",
                                                        "");
                                                  }

                                                  return loadingCircular();
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: responsive.hp(1.7),
                                                  left: responsive.wp(0.5),
                                                  right: responsive.wp(0.5)),
                                              alignment: Alignment.centerLeft,
                                              child: BlocBuilder<
                                                  DropDownPlainDetailBloc,
                                                  DropDownPlainDetailState>(
                                                builder: (context, state) {
                                                  if (state
                                                      is InitialDropDownPlainDetailState) {
                                                    return _dropDownSearchError(
                                                        "Plano detalle",
                                                        "Seleccione un Plano Detalle",
                                                        "");
                                                  } else if (state
                                                      is SuccessPlainDetails) {
                                                    return DropdownSearch<
                                                        PlainDetailDropDownModel>(
                                                      showSearchBox: true,
                                                      selectedItem:
                                                          _plainDetail,
                                                      itemAsString:
                                                          (PlainDetailDropDownModel
                                                                  u) =>
                                                              u.numeroPlano +
                                                              ' Rev. ' +
                                                              u.revision
                                                                  .toString() +
                                                              ' Hoja ' +
                                                              u.hoja.toString(),
                                                      mode: Mode.MENU,
                                                      hint:
                                                          'Seleccione un Plano Detalle',
                                                      label: 'Plano detalle',
                                                      items: state.plainDetails,
                                                      onChanged: (obj) {
                                                        setState(() {
                                                          _plainDetail = obj;

                                                          _plainDetailSelection =
                                                              obj.planoDetalleId;
                                                          _frontSelection =
                                                              null;
                                                          _cardColor =
                                                              Colors.blueAccent;

                                                          _front = null;
                                                        });

                                                        _stateFiltered = '';

                                                        weldingListBloc.add(
                                                          GetJointsWC(
                                                            plainDetailId:
                                                                _plainDetailSelection,
                                                            frontId:
                                                                _frontSelection,
                                                            state: '',
                                                            clear: true,
                                                          ),
                                                        );

                                                        dropDownFrontBloc.add(
                                                          GetFronts(
                                                            clear: false,
                                                            planDetailId:
                                                                _plainDetailSelection,
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else if (state
                                                      is ErrorPlainDetails) {
                                                    return _dropDownSearchError(
                                                        "Obra",
                                                        "Seleccione una Obra",
                                                        state.message);
                                                  }

                                                  return loadingCircular();
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  top: responsive.hp(1.7),
                                                  left: responsive.wp(0.5),
                                                  right: responsive.wp(0.5)),
                                              alignment: Alignment.centerLeft,
                                              child: BlocBuilder<
                                                  DropDownFrontBloc,
                                                  DropDownFrontState>(
                                                builder: (context, state) {
                                                  if (state
                                                      is InitialDropDownFrontState) {
                                                    return _dropDownSearchError(
                                                        "Frente",
                                                        "Seleccione un Frente",
                                                        "");
                                                  } else if (state
                                                      is SuccessFront) {
                                                    return DropdownSearch<
                                                        FrontDropdownModel>(
                                                      showSearchBox: true,
                                                      itemAsString:
                                                          (FrontDropdownModel
                                                                  u) =>
                                                              u.descripcion,
                                                      mode: Mode.MENU,
                                                      hint:
                                                          'Seleccione un Frente',
                                                      label: 'Frente',
                                                      items: state.fronts,
                                                      selectedItem: _front,
                                                      onChanged: (obj) {
                                                        setState(() {
                                                          _front = obj;

                                                          _frontSelection =
                                                              obj.frenteId;
                                                          _cardColor =
                                                              Color(0xFF001D85);
                                                        });

                                                        _stateFiltered = '';

                                                        weldingListBloc.add(
                                                          GetJointsWC(
                                                            plainDetailId:
                                                                _plainDetailSelection,
                                                            frontId:
                                                                _frontSelection,
                                                            state: '',
                                                            clear: false,
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else if (state
                                                      is ErrorFront) {
                                                    return _dropDownSearchError(
                                                        'Frente',
                                                        'Seleccione un Frente',
                                                        state.message);
                                                  }

                                                  return loadingCircular();
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                                child: filtradoJunta(context)),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          // Barra de progreso!!
                          BlocBuilder<SynchronizationBloc,
                              SynchronizationState>(
                            builder: (context, state) {
                              if (state is SuccessLastSynchronization) {
                                if (state.syncs == null) {
                                  if (globals.seHizoCargaInicial == false)
                                    _mostrarMsjInicio = true;
                                } else {
                                  globals.plataformaSeleccionada =
                                      state.syncs.first.nombrePlataforma;
                                  globals.fechaUltSincro = state
                                      .syncs.first.fechaUltimaActualizacion
                                      .split('.')[0];
                                  if (state.syncs.first.estatus == 3 ||
                                      state.syncs.first.regCreadoPor != "00000")
                                    _accBloc.add(GetACC());
                                }
                              }
                              if (state is ErrorLastSynchronization) {
                                return Text(state.message);
                              }
                              return barraProgreso(context);
                            },
                          ),
                          // Seccion para mostrar el listado de juntas
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child:
                                BlocBuilder<WeldingListBloc, WeldingListState>(
                                    builder: (context, state) {
                              if (state is InitialWeldingListState) {
                                return Container();
                              } else if (state is SuccessWeldingList) {
                                return _jointList(
                                    context, state.joints, orientation);
                              } else if (state is ErrorWeldingList) {
                                return Text(state.message);
                              }

                              return loadingCircular();
                            }),
                          ),
                          // Espacio por si acaso!!
                          SizedBox(height: 120),
                        ],
                      )
                    ],
                  ),
                ),
              )),
        ),
      );
    });
  }

  Widget _dropDownSearchError(String title, String hintTitle, String message) {
    return DropdownSearch<String>(
        mode: Mode.MENU,
        hint: hintTitle,
        label: title,
        items: message == "" ? [] : [message]);
  }

  Widget filtradoJunta(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  _showSnackBar(context, 'CONFORMADO');
                  _changeColor(Color(0xFF768591));
                }, // Handle your callback
                child:
                    _inkDetail(Color(0xFF768591), 'Liberación de Conformado'),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  _showSnackBar(context, 'REALIZAR_REPARAR');
                  _changeColor(Color(0xFF425363));
                }, // Handle your callback
                child: _inkDetail(Color(0xFF425363), 'Realizar/Reparar'),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  _showSnackBar(context, 'INSPECCION_SOLDADURA');
                  _changeColor(Color(0xFF618DB4));
                }, // Handle your callback
                child:
                    _inkDetail(Color(0xFF618DB4), 'Inspc. Visual de Soldadura'),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  _showSnackBar(context, 'PND');
                  _changeColor(Color(0xFFFF5000));
                }, // Handle your callback
                child: _inkDetail(Color(0xFFFF5000), 'PND'),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  _showSnackBar(context, 'LIBERADA');
                  _changeColor(Color(0xFF77BC1F));
                }, // Handle your callback
                child: _inkDetail(Color(0xFF77BC1F), 'Liberadas'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget barraProgreso(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 5, right: 10),
      child: SizedBox(
        height: 30,
        child: InkWell(
          onTap: () {
            _showSnackBar(context, '');
            _changeColor(Color(0xFF001D85));
          },
          child: Stack(
            children: <Widget>[
              SizedBox.expand(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _generalProgress,
                    backgroundColor: Colors.white,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                  ),
                ),
              ),
              Center(
                child: Text(
                  _textGeneralProgress,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jointList(BuildContext context, List<JointWCModel> joints,
      Orientation orientation) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) /
        (orientation == Orientation.portrait || size.width < 800 ? 2.8 : 1);
    final double itemWidth = size.width / 1.9;

    return Container(
        child: GridView.count(
      controller: _controller,

      crossAxisCount:
          orientation == Orientation.portrait || size.width < 800 ? 2 : 3,
      childAspectRatio: (itemWidth / itemHeight),
      // controller: new ScrollController(keepScrollOffset: false),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: List.generate(joints.length, (index) {
        return _jointItem(context, joints, index);
      }),
    ));
  }

  Widget _jointItem(
      BuildContext context, List<JointWCModel> joints, int index) {
    double weldingProgress = joints[index].progreso;
    weldingProgress /= 100;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey[300], width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: GestureDetector(
        onTap: () {
          _joint = joints[index];
          _navigateToWeldingDetail();
        },
        child: Column(
          children: [
            ListTileTheme(
              textColor: Colors.white,
              tileColor: _cardColor,
              child: ListTile(
                title: Text(
                  'Junta: ${joints[index].junta}',
                  style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(top: 5, left: 15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("SiteID: "),
                            Text(
                              joints[index].siteId,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Text("Diámetro: "),
                            Expanded(
                                child: Text(
                              joints[index].diametro,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Text("Espesor: "),
                            Expanded(
                                child: Text(
                              joints[index].espesor,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Text("Tipo: "),
                            Expanded(
                                child: Text(
                              joints[index].tipoJunta,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Text("WPS: "),
                            Expanded(
                                child: Text(
                              joints[index].claveWPS,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Text("Spool: "),
                            Expanded(
                                child: Text(
                              joints[index].spoolEstructura,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(top: 0),
                                child: Text("Frente: "),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                child: Text(
                                  joints[index].frente,
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
                Container(
                  margin: EdgeInsets.only(top: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: <Widget>[
                          Text("Tuberos: "),
                          Container(
                            width: 30,
                            padding: const EdgeInsets.only(
                                left: 2.0, top: 1.0, right: 1.0, bottom: 1.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: joints[index].firmaTuberos == true ||
                                      joints[index].tuberos > 0
                                  ? Colors.green
                                  : Colors.white,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text(
                              joints[index].tuberos.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Text("Conformado: "),
                          Container(
                            width: 30,
                            padding: const EdgeInsets.only(
                                left: 2.0, top: 1.0, right: 1.0, bottom: 1.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: joints[index].conformadoLiberado
                                  ? Colors.green
                                  : Colors.white,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text("",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Text("Ins.Vis.Conform.: "),
                          Container(
                            width: 30,
                            padding: const EdgeInsets.only(
                                left: 2.0, top: 1.0, right: 1.0, bottom: 1.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: joints[index].inspecVisConformado == 'D/N'
                                  ? Colors.green
                                  : Colors.white,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text("",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Text("Soldadores: "),
                          Container(
                            width: 30,
                            padding: const EdgeInsets.only(
                                left: 2.0, top: 1.0, right: 1.0, bottom: 1.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: joints[index].firmaSoldadores == true ||
                                      joints[index].soldadores > 0
                                  ? Colors.green
                                  : Colors.white,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text(
                              joints[index].soldadores.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Text("Soldadura: "),
                          Container(
                            width: 30,
                            padding: const EdgeInsets.only(
                                left: 2.0, top: 1.0, right: 1.0, bottom: 1.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: joints[index].soldaduraLiberada
                                  ? Colors.green
                                  : Colors.white,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text("",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Text("Insp. Vis. Soldadura: "),
                          Container(
                            width: 30,
                            padding: const EdgeInsets.only(
                                left: 2.0, top: 1.0, right: 1.0, bottom: 1.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: joints[index].inspecVisSoldadura == 'D/N'
                                  ? Colors.green
                                  : Colors.white,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text("",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Text("Sol. PND: "),
                          Container(
                            width: 30,
                            padding: const EdgeInsets.only(
                                left: 2.0, top: 1.0, right: 1.0, bottom: 1.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _validateStatusJoint(
                                  joints[index].solicitudPNDEnviada),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text("",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(width: 10.0),
                          Text("PND: "),
                          Container(
                            width: 30,
                            padding: const EdgeInsets.only(
                                left: 2.0, top: 1.0, right: 1.0, bottom: 1.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _validateStatusJoint(
                                  joints[index].solicitudPNDTerminada),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text("",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 1.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5, left: 5, right: 5),
              child: Row(
                children: <Widget>[
                  Text("Progreso:"),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: weldingProgress,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  Text('${joints[index].progreso.toStringAsFixed(0)}%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inkDetail(Color color, String text) {
    return Ink(
      height: 100,
      width: 100,
      color: color,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future _navigateToWeldingDetail() {
    _acsBloc.add(GetACS());

    _params = WeldingControlDetailParams(
      contractSelection: _contractSelection,
      workSelection: _workSelection,
      plainDetailSelection: _plainDetailSelection,
      stateFiltered: _stateFiltered,
      frontSelection: _frontSelection,
      joint: _joint,
      contract: _contract,
      work: _work,
      plainDetail: _plainDetail,
      front: _front,
    );

    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeldingControlDetailPage(params: _params),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String state) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (_plainDetailSelection == null || _frontSelection == null) {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje: 'Seleccione todos los filtros de búsqueda!',
        icon: Icon(Icons.warning, size: 28.0, color: Colors.orange),
        secondsDuration: 8,
        colorBarIndicator: Colors.orange,
        borde: 8,
      );
    } else {
      _stateFiltered = state;

      weldingListBloc.add(
        GetJointsWC(
          plainDetailId: _plainDetailSelection,
          frontId: _frontSelection,
          state: state,
          clear: false,
        ),
      );
    }
  }

  Color _validateStatusJoint(String status) {
    switch (status) {
      case 'COMPLETADA':
        return Colors.green;
        break;

      case 'PROCESO':
        return Colors.yellow;
        break;

      case 'PENDIENTE':
        return Colors.grey;
        break;

      case 'N/A':
        return Colors.grey;
        break;

      default:
        return Colors.white;
        break;
    }
  }

  void _changeColor(Color color) {
    setState(() {
      _cardColor = color;
    });
  }
}
