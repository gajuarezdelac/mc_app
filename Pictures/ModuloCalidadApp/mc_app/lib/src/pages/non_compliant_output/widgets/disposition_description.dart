import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_bloc.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_event.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_state.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';
import 'package:mc_app/src/models/non_compliant_output_paginator_model.dart';
import 'package:mc_app/src/models/params/disposition_description_params.dart';
import 'package:mc_app/src/models/params/non_compliant_output_params.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';
import 'package:mc_app/src/models/planned_resource_model.dart';
import 'package:mc_app/src/utils/always_disabled_focus_node.dart';
import 'package:mc_app/src/widgets/column_box.dart';
import 'package:mc_app/src/widgets/dropdown.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';
import 'package:mc_app/src/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DispositionSNC extends StatefulWidget {
  final NonCompliantOutputPaginatorModel params;
  final NonCompliantOutputParams filters;

  DispositionSNC({Key key, this.params, this.filters}) : super(key: key);

  static String id = "Registro de Salida No Conforme";

  @override
  _DispositionSNCState createState() => _DispositionSNCState();
}

class _DispositionSNCState extends State<DispositionSNC> {
  String contractSelection;
  String workSelection;
  String plainDetailSelection;
  bool prefabricado = false;
  bool instalacion = false;
  bool servicio = false;
  bool cotemar = false;
  bool cliente = false;
  bool subcontratista = false;
  bool rechazado = false;
  bool devueltoCliente = false;
  bool correccion = false;
  NonCompliantOutputIdBloc sncIdBloc;
  NonCompliantOutputBloc sncBloc;

  PaginatorSNCBloc pagBloc;
  EmployeeBloc employeeBloc;

  List<ReporteInspeccionMaterialModel> listReporteIM = [];
  final _descActividadController = TextEditingController();
  final _reqIncumplidoController = TextEditingController();
  final _fallaOIncumpController = TextEditingController();
  final _evidenciaIncumpController = TextEditingController();
  final _concecionNoController = TextEditingController();
  final _otraController = TextEditingController();
  final _accionesController = TextEditingController();
  final _fechaController = TextEditingController();
  final _fechaEjecucionController = TextEditingController();
  final _fichaRealizaNoController = TextEditingController();
  int _ficha;
  String _nombreDetecta = '';
  String _puestoDetecta = '';
  String _nombreAutoriza = '';
  String _puestoAutoriza = '';
  String _nombreRealiza = '';
  String _puestoRealiza = '';
  String _obraId;
  String _planoId;
  String _contratoId;

  List<PhotographicEvidenceIPModel> lstPhothosTem = [];
  List<PhotographicEvidenceIPModel> lstPhothosTemEliminados = [];
  List<PhotographicEvidenceIPModel> lstPhothosTemAdd = [];

  List<InformacionadicionalModel> informationAditional = [];
  FetchWelderModel informationWelder;
  ScrollController _controller;
  List<PlannedResourceModel> _plannedResourseList = [];
  List<TextEditingController> _controllerCantidadList = [];
  List<TextEditingController> _controllerPuestoList = [];
  List<TextEditingController> _controllerHorasPlaneadasList = [];
  int _fichaRealiza;
  int _fichaAutoriza;
  String _descripcionDisposicionId = '';

  bool newWidget = false;
  final txtAcciones = new GlobalKey<FormState>();

  // ignore: close_sinks
  PlannedResourcesBloc pnlResBloc;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener); //the listener for up and down.
    super.initState();
    initialData();
  }

  buscarEmployeeLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String _user = sharedPreferences.get("user");
    setState(() {
      _fichaAutoriza = int.parse(_user);
    });
    employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    employeeBloc.add(GetEmployeeAuthByFicha(
      ficha: int.parse(_user),
    ));
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

  void initialData() {
    sncBloc = BlocProvider.of<NonCompliantOutputBloc>(context);
    pnlResBloc = BlocProvider.of<PlannedResourcesBloc>(context);
    sncIdBloc = BlocProvider.of<NonCompliantOutputIdBloc>(context);

    if (widget.params.salidaNoConformeId != "") {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      _fechaEjecucionController.text = formatter.format(DateTime.now());
      buscarEmployeeLogin();
      sncIdBloc.add(FetchNonCompliantOutputId(
        nonCompliantOutputId: widget.params.salidaNoConformeId,
      ));

      sncBloc.add(FetchDispositionDescription(
        nonCompliantOutputId: widget.params.salidaNoConformeId,
      ));
    } else {
      buscarEmployeeLogin();
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      _fechaEjecucionController.text = formatter.format(DateTime.now());
    }

    _descActividadController.text = widget.params.descripcionActividad;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Salida No Conforme (${widget.params.tipo})"),
      ),
      body: SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.vertical,
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  contentRegister(),
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        child: new Icon(Icons.arrow_circle_up_outlined),
        isExtended: true,
        backgroundColor: Color.fromRGBO(3, 157, 252, .9),
        onPressed: () {
          _controller.animateTo(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        },
      ),
    );
  }

  Widget contentRegister() {
    return MultiBlocListener(
        listeners: [
          sncBlocListernet(),
          insUpdSncBlocListerner(),
          employeeBlocListernet(),
        ],
        child: Column(
          children: <Widget>[
            seccionDetecta(),
            headerPrincipal(),
            sectionDisposicion(),
            SizedBox(height: 50),
          ],
        ));
  }

  // Información de la actividad(Description)
  Widget seccionDetecta() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: headerUserInformation()),
        headerSave(),
      ],
    );
  }

  Widget headerPrincipal() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 10, right: 8, bottom: 8),
      child: Card(
        margin: EdgeInsets.all(0.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 4.0,
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10.0),
                ColumnBox(
                  titlePrincipal: 'Departamento:',
                  information: ' Control de Calidad',
                ),
                SizedBox(width: 30.0),
                ColumnBox(
                  titlePrincipal: 'Fecha:',
                  information: _fechaController.text,
                ),
                SizedBox(width: 30.0),
                ColumnBox(
                  titlePrincipal: 'Consecutivo:',
                  information: widget.params.consecutivo == null
                      ? ''
                      : widget.params.consecutivo,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 5.0),
                ColumnBox(
                  titlePrincipal: 'Contrato:',
                  information: widget.params.contrato,
                ),
                SizedBox(width: 30.0),
                ColumnBox(
                  titlePrincipal: 'Obra:',
                  information: widget.params.ot,
                ),
                SizedBox(width: 30.0),
                ColumnBox(
                  titlePrincipal: 'Plano/Isométrico/DTI:',
                  information: widget.params.plano,
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    children: [
                      ColumnBox(
                        titlePrincipal: 'Descripción de la actividad',
                        information: widget.params.descripcionActividad,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
              ],
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget contratoControl() {
    bool _enabled = false;
    if (widget.params.tipo == 'Manual') {
      _enabled = true;
    }
    return BlocBuilder<ContractsSNCOutputBloc, ContractsSNCState>(
      builder: (context, state) {
        if (state is SuccessContractsSNC) {
          return dropDown('Contrato', 'Seleccionar',
              value: _contratoId,
              items: state.contractModelList
                  .map((ContractDropdownModelSNC contract) {
                return DropdownMenuItem(
                  value: contract.contratoId,
                  child: Text(
                    '${contract.contratoId} - ${contract.nombre}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChangeEvent: _enabled
                  ? (value) {
                      setState(() {
                        _contratoId = value;
                      });
                    }
                  : null);
        } else if (state is ErrorContractsSNC) {
          return dropDown(
            'Contrato',
            'Seleccionar',
          );
        }
        return loadingCircular();
      },
    );
  }

  Widget obraControl() {
    bool _enabled = false;
    if (widget.params.tipo == 'Manual') {
      _enabled = true;
    }
    return BlocBuilder<WorksSNCOutputBloc, WorksSNCState>(
      builder: (context, state) {
        if (state is SuccessWorksSNC) {
          return dropDown('Obra', 'Seleccionar',
              value: _obraId,
              items: state.works.map((WorkDropDownModelSNC work) {
                return DropdownMenuItem(
                  value: work.obraId,
                  child: Text(
                    '${work.obraId} - ${work.nombre}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChangeEvent: _enabled
                  ? (value) {
                      setState(() {
                        _obraId = value;
                      });
                    }
                  : null);
        } else if (state is ErrorWorksSNC) {
          return dropDown(
            'Obra',
            'Seleccionar',
          );
        }
        return loadingCircular();
      },
    );
  }

  Widget planoControl() {
    bool _enabled = false;
    if (widget.params.tipo == 'Manual') {
      _enabled = true;
    }
    return BlocBuilder<PlainDetailSNCBloc, PlainDetailSNCState>(
      builder: (context, state) {
        if (state is SuccessPlainDetailSNC) {
          return dropDown('Plano Detalle', 'Seleccionar',
              value: _planoId,
              items: state.plainDetailDDModelList
                  .map((PlainDetailDropDownModelSNC plainDetail) {
                return DropdownMenuItem(
                  value: plainDetail.planoDetalleId,
                  child: Text(
                    '${plainDetail.numeroPlano}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChangeEvent: _enabled
                  ? (value) {
                      setState(() {
                        _planoId = value;
                      });
                    }
                  : null);
        } else if (state is ErrorPlainDetailSNC) {
          return dropDown(
            'Plano Detalle',
            'Seleccionar',
          );
        }
        return loadingCircular();
      },
    );
  }

  Widget fechaControl() {
    return textField(
      '',
      'Seleccione una fecha',
      controller: _fechaEjecucionController,
      focusNode: AlwaysDisabledFocusNode(),
      onTapEvent: _selectDate,
      enabled: widget.params.estatus == 'Pendiente' ||
              widget.params.estatus == 'Proceso'
          ? true
          : false,
    );
  }

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      _fechaEjecucionController.text = formatter.format(picked);
    }
  }

  // Seccion información general
  Widget headerUserInformation() {
    // return BlocBuilder<EmployeeBloc, EmployeeState>(builder: (context, state) {
    //   if (state is SuccessEmployee && state.employee.ficha == _ficha) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 2),
      child: Card(
        margin: EdgeInsets.all(0.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5.0,
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    _getInitials(_nombreDetecta),
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                title: Text(
                  _nombreDetecta,
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5.0),
                    Text(_ficha.toString()),
                    SizedBox(height: 5.0),
                    Text(_puestoDetecta),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          child: Text('DETECTA',
                              style: TextStyle(color: Colors.grey)),
                          onPressed: () {},
                        ),
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
    //   }
    //   if (state is IsLoadingEmployee) {
    //     return Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Container(
    //             padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
    //             child: Center(
    //               child: spinkit,
    //             )),
    //       ],
    //     );
    //   }
    //   if (state is ErrorEmployee) {
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Center(child: Text('Parece que ha ocurrido un error')),
    //       ],
    //     );
    //   }
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Container(
    //           padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
    //           child: Center(
    //             child: spinkit,
    //           )),
    //     ],
    //   );
    // });
  }

  // Seccion informativa detallada
  Widget headerSave() {
    return Container(
      width: 100,
      child: Align(
        alignment: Alignment.center,
        child: IconButton(
          icon: Icon(Icons.save_outlined),
          iconSize: 50.0,
          color: Colors.blue,
          onPressed: () {
            saveGeneral(_descripcionDisposicionId);
          },
        ),
      ),
    );
  }

  Widget userAuthInformation() {
    // return BlocBuilder<EmployeeBloc, EmployeeState>(builder: (context, state) {
    //   if (state is SuccessEmployee && state.employee.ficha == _fichaAutoriza) {
    return Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 2),
        child: Column(children: [
          Text(
            "Autoriza Disposición:",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.0),
          Card(
            margin: EdgeInsets.all(0.0),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 5.0,
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    isThreeLine: true,
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        _getInitials(_nombreAutoriza),
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                    title: Text(
                      _nombreAutoriza,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5.0),
                        Text(_fichaAutoriza.toString()),
                        SizedBox(height: 5.0),
                        Text(_puestoAutoriza),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: Text('DETECTA',
                                  style: TextStyle(color: Colors.grey)),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
    //   }
    //   if (state is IsLoadingEmployee) {
    //     return Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Container(
    //             padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
    //             child: Center(
    //               child: spinkit,
    //             )),
    //       ],
    //     );
    //   }
    //   if (state is ErrorEmployee) {
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Center(child: Text('Parece que ha ocurrido un error')),
    //       ],
    //     );
    //   }
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Container(
    //           padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
    //           child: Center(
    //             child: spinkit,
    //           )),
    //     ],
    //   );
    // });
  }

  Widget userMakesInformation() {
    // return BlocBuilder<EmployeeBloc, EmployeeState>(builder: (context, state) {
    //   if (state is SuccessEmployee && state.employee.ficha == _fichaRealiza) {
    if (_fichaRealiza != null && _fichaRealiza > 0) {
      return Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 2),
          child: Column(children: [
            Text(
              "Realiza Disposición:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5.0),
            Card(
              margin: EdgeInsets.all(0.0),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5.0,
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      isThreeLine: true,
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Text(
                          _getInitials(_nombreRealiza),
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                      title: Text(
                        _nombreRealiza,
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.0),
                          Text(_fichaRealiza.toString()),
                          SizedBox(height: 5.0),
                          Text(_puestoRealiza),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                child: Text('DETECTA',
                                    style: TextStyle(color: Colors.grey)),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]));
    } else {
      return Padding(
          padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 2),
          child: Column(children: [
            Text("Realiza Disposición:"),
            SizedBox(height: 5.0),
          ]));
    }
    //   }
    //   if (state is IsLoadingEmployee) {
    //     return Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Container(
    //             padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
    //             child: Center(
    //               child: spinkit,
    //             )),
    //       ],
    //     );
    //   }
    //   if (state is ErrorEmployee) {
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Center(child: Text('Parece que ha ocurrido un error')),
    //       ],
    //     );
    //   }

    //   return Padding(
    //       padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 2),
    //       child: Column(children: [
    //         Text("Realiza Disposición:"),
    //         SizedBox(height: 5.0),
    //       ]));
    // });
  }

  String _getInitials(String name) {
    String alias;

    if (name.isNotEmpty && name != null) {
      List<String> splited = name.split(' ');

      alias = splited.length > 1
          ? '${splited[0].substring(0, 1)}${splited[1].substring(0, 1)}'
          : splited[0].substring(0, 1);
    } else {
      alias = '';
    }

    return alias;
  }

  Widget sectionRequisitoIncumplido() {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 8, right: 10, bottom: 8),
      child: Card(
          elevation: 4.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 20),
            child: Column(children: <Widget>[
              ListTileTheme(
                textColor: Colors.black,
                tileColor: Colors.white,
                child: ListTile(
                  title: new Center(
                      child: new Text(
                    "Detalle de la No Conformidad",
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'REQUISITO INCUMPLIDO: ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Form(
                          child: TextFormField(
                            controller: _reqIncumplidoController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '[Es necesario este campo]';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            enabled: true,
                            maxLines: 2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText:
                                  '(Cláusula, Norma, Código, Procedimiento, Especificación del Cliente, Requisito Legal, Otro.)....',
                              alignLabelWithHint: true,
                              suffixIcon: Icon(Icons.text_format, size: 30.0),
                            ), // when user presses enter it will adapt to it
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'FALLA O INCUMPLIMIENTO: ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Form(
                          child: TextFormField(
                            controller: _fallaOIncumpController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '[Es necesario este campo]';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            enabled: true,
                            maxLines: 2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText:
                                  '(Acción realizada contraria al requisito)...',
                              alignLabelWithHint: true,
                              suffixIcon: Icon(Icons.text_format, size: 30.0),
                            ), // when user presses enter it will adapt to it
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'EVIDENCIA DE INCUMPLIMIENTO: ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Form(
                          child: TextFormField(
                            controller: _evidenciaIncumpController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '[Es necesario este campo]';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            enabled: true,
                            maxLines: 2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText:
                                  '(Cualquier documento o hecho que demuestre la falta de cumplimiento al requisito)...',
                              alignLabelWithHint: true,
                              suffixIcon: Icon(Icons.text_format, size: 30.0),
                            ), // when user presses enter it will adapt to it
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          )),
    );
  }

  Widget sectionDisposicion() {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 8, right: 10, bottom: 8),
      child: Card(
          elevation: 4.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 20),
            child: Column(children: <Widget>[
              ListTileTheme(
                textColor: Colors.black,
                tileColor: Colors.white,
                child: ListTile(
                  title: new Center(
                      child: new Text(
                    "Descripción de la Disposición:",
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ),
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: userAuthInformation()),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Acciones: ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: txtAcciones,
                        child: TextFormField(
                          controller: _accionesController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Campo obligatorio';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.multiline,
                          enabled: widget.params.estatus == "Pendiente" ||
                                  widget.params.estatus == "Proceso"
                              ? true
                              : false,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Describir...',
                            alignLabelWithHint: true,
                            suffixIcon: Icon(Icons.text_format, size: 30.0),
                          ), // when user presses enter it will adapt to it
                          onChanged: (value) {
                            txtAcciones.currentState.validate();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: userMakesInformation()),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Responsable: ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 0, right: 0),
                          child: TextField(
                            enabled: widget.params.estatus == 'Pendiente' ||
                                    widget.params.estatus == 'Proceso'
                                ? true
                                : false,
                            controller: _fichaRealizaNoController,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.clear),
                              ),
                              hintText: 'Ficha...',
                              alignLabelWithHint: true,
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                _fichaRealiza = int.parse(value);
                              });

                              employeeBloc =
                                  BlocProvider.of<EmployeeBloc>(context);
                              employeeBloc.add(GetEmployeeMakesByFicha(
                                ficha: int.parse(value),
                              ));

                              _fichaRealizaNoController.text = '';
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Fecha: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ]),
                        Row(
                          children: [fechaControl()],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ListTileTheme(
                textColor: Colors.black,
                tileColor: Colors.white,
                child: ListTile(
                  title: new Center(
                      child: new Text(
                    "Recursos Planeados/Utilizados:",
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ),
              ),
              _resourceList(),
              SizedBox(height: 20),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                iconSize: 40.0,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _plannedResourseList.add(PlannedResourceModel(
                      orden: (_plannedResourseList.length + 1).toString(),
                      cantidad: 0,
                      puesto: '',
                      hrPlaneadas: '',
                    ));
                  });
                },
              ),
            ]),
          )),
    );
  }

  Widget _resourceList() {
    return Column(
      children: _plannedResourseList.map((PlannedResourceModel model) {
        return _resourceRow(context, model);
      }).toList(),
    );
  }

  Widget _resourceRow(BuildContext context, PlannedResourceModel pnlResList) {
    if (int.parse(pnlResList.orden) > _controllerCantidadList.length) {
      _controllerCantidadList.add(new TextEditingController());
      _controllerPuestoList.add(new TextEditingController());
      _controllerHorasPlaneadasList.add(new TextEditingController());
    }
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            textField(
              '* Cantidad',
              'Ingrese una cantidad',
              controller:
                  _controllerCantidadList[int.parse(pnlResList.orden) - 1],
              onSubmittedEvent: (value) {
                _controllerCantidadList[int.parse(pnlResList.orden) - 1].text =
                    value;
              },
            ),
            SizedBox(
              width: 10.0,
            ),
            textField(
              '* Puesto',
              'Ingrese el puesto',
              controller:
                  _controllerPuestoList[int.parse(pnlResList.orden) - 1],
              onSubmittedEvent: (value) {
                _controllerPuestoList[int.parse(pnlResList.orden) - 1].text =
                    value;
              },
            ),
            SizedBox(
              width: 10.0,
            ),
            textField(
              'H.H. Planeadas',
              'Ingrese las horas planeadas',
              controller: _controllerHorasPlaneadasList[
                  int.parse(pnlResList.orden) - 1],
              onSubmittedEvent: (value) {
                _controllerHorasPlaneadasList[int.parse(pnlResList.orden) - 1]
                    .text = value;
              },
            ),
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              iconSize: 40.0,
              color: Colors.red,
              onPressed: () {
                List<PlannedResourceModel> _tempList = [];
                int _orden = 1;
                _plannedResourseList.forEach((element) {
                  if (element.orden != pnlResList.orden) {
                    _tempList.add(PlannedResourceModel(
                      orden: _orden.toString(),
                      cantidad: element.cantidad,
                      puesto: element.puesto,
                      hrPlaneadas: element.hrPlaneadas,
                      hrReales: element.hrReales,
                      acciones: element.acciones,
                      responsable: element.responsable,
                      fechaEjecucion: element.fechaEjecucion,
                      fichaRealiza: element.fichaRealiza,
                      fichaAutoriza: element.fichaAutoriza,
                    ));
                    _orden = _orden + 1;
                  }
                });

                setState(() {
                  _plannedResourseList = _tempList;
                  _controllerCantidadList[int.parse(pnlResList.orden) - 1]
                      .text = '';
                  _controllerCantidadList
                      .removeAt(int.parse(pnlResList.orden) - 1);
                  _controllerPuestoList[int.parse(pnlResList.orden) - 1].text =
                      '';
                  _controllerPuestoList
                      .removeAt(int.parse(pnlResList.orden) - 1);
                  _controllerHorasPlaneadasList[int.parse(pnlResList.orden) - 1]
                      .text = '';
                  _controllerHorasPlaneadasList
                      .removeAt(int.parse(pnlResList.orden) - 1);
                });
              },
            ),
          ]),
    );
  }

  void saveGeneral(String dispDescId) {
    if (_validate()) {
      List<PlannedResourceParams> resourceList = [];

      for (int i = 0; i < _plannedResourseList.length; i++) {
        resourceList.add(PlannedResourceParams(
          orden: (i + 1).toString(),
          cantidad: int.parse(_controllerCantidadList[i].text),
          puesto: _controllerPuestoList[i].text,
          hrPlaneadas: _controllerHorasPlaneadasList[i].text,
          hrReales: '',
        ));
      }

      sncBloc.add(InsUpdDispositionDescription(
          params: DispositionDescriptionParams(
        dispositionDescriptionId: dispDescId,
        nonCompliantOutputId: widget.params.salidaNoConformeId,
        actions: _accionesController.text, //_fecha
        executionDate: DateTime.parse(_fechaEjecucionController.text),
        employeeMakes: _fichaRealiza,
        employeeAuth: _fichaAutoriza,
        resources: resourceList,
      )));
    }
  }

  bool _validate() {
    bool result = true;
    if (!txtAcciones.currentState.validate()) result = false;
    if (!_txtResponsableValidate()) result = false;
    if (!_listRecursosValidate()) result = false;

    return result;
  }

  bool _txtResponsableValidate() {
    if (_fichaRealiza != null && _fichaRealiza > 0) {
      return true;
    } else {
      mensajeError("Debe agregar al usuario quien realiza la disposición");
      return false;
    }
  }

  bool _listRecursosValidate() {
    if (_controllerCantidadList.length > 0) {
      bool notEmpty = true;
      _controllerCantidadList.forEach((element) {
        if (element.text.isEmpty) notEmpty = false;
      });
      _controllerPuestoList.forEach((element) {
        if (element.text.isEmpty) notEmpty = false;
      });
      if (notEmpty == false)
        mensajeError(
            "Cantidad/Puesto son campos obligatorios. Verifique los Recursos");
      return notEmpty;
    } else {
      mensajeError("Debe agregar al menos un Recurso");
      return false;
    }
  }

  void mensajeError(String mensaje) {
    showNotificationSnackBar(context,
        title: "",
        mensaje: mensaje,
        icon: Icon(
          Icons.error_outlined,
          size: 28.0,
          color: Colors.orange[700],
        ),
        secondsDuration: 3,
        colorBarIndicator: Colors.orange,
        borde: 8);
  }

  void mensajeExito(String mensaje) {
    showNotificationSnackBar(context,
        title: "",
        mensaje: mensaje,
        icon: Icon(
          Icons.check_circle_outlined,
          size: 28.0,
          color: Colors.green[700],
        ),
        secondsDuration: 3,
        colorBarIndicator: Colors.green,
        borde: 8);
  }

  BlocListener sncBlocListernet() {
    return BlocListener<NonCompliantOutputIdBloc, NonCompliantOutputIdState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingNonCompliantOutputId) {
        loadingCircular();
      }

      if (state is SuccessNonCompliantOutputId) {
        _reqIncumplidoController.text = state.ncoIdModelList.first.requisito;
        _fallaOIncumpController.text = state.ncoIdModelList.first.falla;
        _evidenciaIncumpController.text = state.ncoIdModelList.first.evidencia;

        _concecionNoController.text = state.ncoIdModelList.first.noConcesion;
        _otraController.text = state.ncoIdModelList.first.otra;
        _fechaController.text = state.ncoIdModelList.first.fecha;

        setState(() {
          _ficha = state.ncoIdModelList.first.ficha;
          _obraId = state.ncoIdModelList.first.obraId;
          _contratoId = state.ncoIdModelList.first.contratoId;
          _planoId = state.ncoIdModelList.first.planoDetalleId;
        });

        employeeBloc = BlocProvider.of<EmployeeBloc>(context);
        employeeBloc.add(GetEmployeeByFicha(
          ficha: state.ncoIdModelList.first.ficha,
        ));
      }

      if (state is ErrorNonCompliantOutputId) {
        showNotificationSnackBar(
          context,
          title: "",
          mensaje: 'Ocurrió un error al carga la información.',
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 8,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener employeeBlocListernet() {
    return BlocListener<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingNonCompliantOutputId) {
        loadingCircular();
      }

      if (state is SuccessEmployee && state.employee != null) {
        setState(() {
          _nombreDetecta = state.employee.nombre;
          _ficha = state.employee.ficha;
          _puestoDetecta = state.employee.puestoDescripcion;
        });
      }

      if (state is SuccessEmployeeAuth && state.employee != null) {
        setState(() {
          _nombreAutoriza = state.employee.nombre;
          _fichaAutoriza = state.employee.ficha;
          _puestoAutoriza = state.employee.puestoDescripcion;
        });
      }

      if (state is SuccessEmployeeMakes && state.employee != null) {
        setState(() {
          _nombreRealiza = state.employee.nombre;
          _fichaRealiza = state.employee.ficha;
          _puestoRealiza = state.employee.puestoDescripcion;
        });
      }

      if (state is ErrorEmployee) {
        showNotificationSnackBar(
          context,
          title: "",
          mensaje: 'Ocurrió un error al carga la información.',
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 8,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener plannedResourceBlocListerner() {
    return BlocListener<PlannedResourcesBloc, PlannedResourcesState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingPlannedResourceState) {
        loadingCircular();
      }

      if (state is SuccessPlannedResourceState) {
        if (state.plannedResourceModelList.length < 1) {
          setState(() {
            _plannedResourseList.add(PlannedResourceModel(
              orden: '1',
              cantidad: 0,
              puesto: '',
              hrPlaneadas: '',
            ));
          });
        } else {
          setState(() {
            _plannedResourseList = state.plannedResourceModelList;
          });
        }
      }

      if (state is ErrorNonCompliantOutputId) {
        showNotificationSnackBar(
          context,
          title: "",
          mensaje: 'Ocurrió un error al carga la información.',
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 8,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener insUpdSncBlocListerner() {
    return BlocListener<NonCompliantOutputBloc, NonCompliantOutputState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingNonCompliantOutput) {
        loadingCircular();
      }

      if (state is SuccessInsUpdDispositionDescription) {
        Navigator.pop(context);

        pagBloc = BlocProvider.of<PaginatorSNCBloc>(context);
        pagBloc.add(FetchNoCompliantOutputPaginator(
            bandeja: widget.filters.bandeja,
            ids: widget.filters.ids,
            contratos: widget.filters.contratos,
            obras: widget.filters.obras,
            planos: widget.filters.planos,
            tipos: widget.filters.tipos,
            fichas: widget.filters.fichas,
            aplica: widget.filters.aplica,
            atribuible: widget.filters.atribuible,
            estatus: widget.filters.estatus,
            offset: widget.filters.offset,
            nextrows: widget.filters.nextrows));

        mensajeExito("Se guardaron los datos satisfactoriamente");
      }

      if (state is SuccessDispositionDescription) {
        if (state.dispositionDescriptionModel != null) {
          sncBloc.add(FetchPlannedResources(
              dispositionDescriptionId:
                  state.dispositionDescriptionModel.dispositionDescriptionId));

          _accionesController.text = state.dispositionDescriptionModel.actions;
          DateFormat formatter = DateFormat('yyyy-MM-dd');
          _fechaEjecucionController.text = formatter.format(
              DateTime.parse(state.dispositionDescriptionModel.executionDate));

          setState(() {
            _fichaRealiza = state.dispositionDescriptionModel.employeMakes;
            _fichaAutoriza = state.dispositionDescriptionModel.employeeAuth;
            _descripcionDisposicionId =
                state.dispositionDescriptionModel.dispositionDescriptionId;
          });

          employeeBloc = BlocProvider.of<EmployeeBloc>(context);
          employeeBloc.add(GetEmployeeAuthByFicha(
            ficha: _fichaAutoriza,
          ));
          employeeBloc = BlocProvider.of<EmployeeBloc>(context);
          employeeBloc.add(GetEmployeeMakesByFicha(
            ficha: _fichaRealiza,
          ));
        } else {
          _controllerCantidadList.clear();
          _controllerPuestoList.clear();
          _controllerHorasPlaneadasList.clear();
          _controllerCantidadList.add(new TextEditingController());
          _controllerPuestoList.add(new TextEditingController());
          _controllerHorasPlaneadasList.add(new TextEditingController());
          setState(() {
            _plannedResourseList.add(PlannedResourceModel(
              orden: '1',
              cantidad: 0,
              puesto: '',
              hrPlaneadas: '',
            ));
          });
        }
      }

      if (state is SuccessPlannedResources) {
        if (state.plannedResourceList.length < 1) {
          _controllerCantidadList.clear();
          _controllerPuestoList.clear();
          _controllerHorasPlaneadasList.clear();
          _controllerCantidadList.add(new TextEditingController());
          _controllerPuestoList.add(new TextEditingController());
          _controllerHorasPlaneadasList.add(new TextEditingController());
          setState(() {
            _plannedResourseList.add(PlannedResourceModel(
              orden: '1',
              cantidad: 0,
              puesto: '',
              hrPlaneadas: '',
            ));
          });
        } else {
          setState(() {
            _controllerCantidadList.clear();
            _controllerPuestoList.clear();
            _controllerHorasPlaneadasList.clear();
            state.plannedResourceList.forEach((element) {
              _controllerCantidadList.add(new TextEditingController());
              _controllerCantidadList[_controllerCantidadList.length - 1].text =
                  element.cantidad.toString();
              _controllerPuestoList.add(new TextEditingController());
              _controllerPuestoList[_controllerPuestoList.length - 1].text =
                  element.puesto;
              _controllerHorasPlaneadasList.add(new TextEditingController());
              _controllerHorasPlaneadasList[
                      _controllerHorasPlaneadasList.length - 1]
                  .text = element.hrPlaneadas;
            });
            _plannedResourseList = state.plannedResourceList;
          });
        }
      }

      if (state is ErrorNonCompliantOutput) {
        showNotificationSnackBar(
          context,
          title: "",
          mensaje: 'Ocurrió un error al guardar los datos.',
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 8,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }
}
