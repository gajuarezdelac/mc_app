import 'package:dropdown_search/dropdown_search.dart';
import 'package:mc_app/src/models/contract_cs_dropdown_model.dart';
import 'package:mc_app/src/models/params/disposition_description_params.dart';
import 'package:mc_app/src/models/params/evaluation_snc_params.dart';
import 'package:mc_app/src/models/plain_detail_dropdown_model.dart';
import 'package:mc_app/src/models/planned_resource_model.dart';
import 'package:mc_app/src/models/work_dropdown_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_bloc.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_event.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_state.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/models/non_compliant_id_model.dart';
import 'package:mc_app/src/models/non_compliant_output_paginator_model.dart';
import 'package:mc_app/src/models/params/non_compliant_output_params.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';
import 'package:mc_app/src/utils/always_disabled_focus_node.dart';
import 'package:mc_app/src/utils/dialogs.dart' as dialog;
import 'package:mc_app/src/utils/text_dialog_widget.dart';
import 'package:mc_app/src/widgets/column_box.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';
import 'package:mc_app/src/widgets/spinkit.dart';
import 'package:mc_app/src/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterSNC extends StatefulWidget {
  final NonCompliantOutputPaginatorModel params;
  final NonCompliantOutputParams filters;

  RegisterSNC({Key key, this.params, this.filters}) : super(key: key);

  static String id = "Registro de Salida No Conforme";

  @override
  _RegisterSNCState createState() => _RegisterSNCState();
}

class _RegisterSNCState extends State<RegisterSNC> {
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
  WorkCSBloc workCSBloc;
  DropDownPlainDetailBloc dropDownPlainDetailBloc;
  PaginatorSNCBloc pagBloc;
  EmployeeBloc employeeBloc;
  PlannedResourcesBloc _plannedResourcesBloc;
  int _selectedAplica;
  int _selectedAtribuible;
  int _selectedConcecion;
  String _selectedResultReinsp = '';
  List<PlannedResourceParams> _resources = [];
  List<PlannedResourceModel> _pnlResourceList = [];

  List<ReporteInspeccionMaterialModel> listReporteIM = [];
  final _descActividadController = TextEditingController();
  final _reqIncumplidoController = TextEditingController();
  final _fallaOIncumpController = TextEditingController();
  final _evidenciaIncumpController = TextEditingController();
  final _concecionNoController = TextEditingController();
  final _otraController = TextEditingController();
  final _fechaController = TextEditingController();
  final _infoSoporteController = TextEditingController();
  TextInputType textType;
  final _fechaCorreccionController = TextEditingController();
  final _fechaRecepcionCierreController = TextEditingController();

  int _ficha;
  String _obraId;
  String _planoId;
  String _contratoId;
  int _fichaRealiza;
  int _fichaAutoriza;
  String _nombreAutoriza = '';
  String _puestoAutoriza = '';
  String _nombreRealiza = '';
  String _puestoRealiza = '';
  String _nombreDetecta = '';
  String _puestoDetecta = '';
  String _fallaTemp = '';
  String _descActTemp = '';
  String _origen = '';

  List<PhotographicEvidenceIPModel> lstPhothosTem = [];
  List<PhotographicEvidenceIPModel> lstPhothosTemEliminados = [];
  List<PhotographicEvidenceIPModel> lstPhothosTemAdd = [];

  List<InformacionadicionalModel> informationAditional = [];
  FetchWelderModel informationWelder;
  ScrollController _controller;

  bool newWidget = false;
  bool _disabledControls = false;
  final txtInfoSoporte = new GlobalKey<FormState>();
  final txtDescActividad = new GlobalKey<FormState>();
  final txtReqIncumplido = new GlobalKey<FormState>();
  final txtFallaIncump = new GlobalKey<FormState>();
  final txtEvidenciaIncump = new GlobalKey<FormState>();
  bool _isExpandedNoCompliant = true;
  bool _isExpandedDisposition = true;
  ContractCSDropdownModel _contract;
  WorkDropDownModel _work;
  PlainDetailDropDownModel _plain;

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
      _ficha = int.parse(_user);
    });
    employeeBloc = BlocProvider.of<EmployeeBloc>(context);
    employeeBloc.add(GetEmployeeByFicha(
      ficha: int.parse(_user),
    ));
  }

  setSelectedAplica(int val) {
    setState(() {
      _selectedAplica = val;
    });
  }

  setSelectedAtribuible(int val) {
    setState(() {
      _selectedAtribuible = val;
    });
  }

  setSelectedConcecion(int val) {
    setState(() {
      _selectedConcecion = val;
    });
  }

  setSelectedResultReinsp(String val) {
    setState(() {
      _selectedResultReinsp = val;
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

  void initialData() {
    if (widget.params.estatus != 'Sin Registro' &&
        widget.params.estatus != 'Pendiente') _disabledControls = true;
    sncBloc = BlocProvider.of<NonCompliantOutputBloc>(context);
    workCSBloc = BlocProvider.of<WorkCSBloc>(context);
    dropDownPlainDetailBloc = BlocProvider.of<DropDownPlainDetailBloc>(context);
    sncIdBloc = BlocProvider.of<NonCompliantOutputIdBloc>(context);
    _plannedResourcesBloc = BlocProvider.of<PlannedResourcesBloc>(context);

    if (widget.params.estatus != "Sin Registro" &&
        widget.params.estatus != "Pendiente") {
      sncBloc.add(FetchDispositionDescription(
        nonCompliantOutputId: widget.params.salidaNoConformeId,
      ));
      _plannedResourcesBloc.add(FetchPlannedResourcesBySNCId(
        nonCompliantOutputId: widget.params.salidaNoConformeId,
      ));
    }

    if (widget.params.salidaNoConformeId != "") {
      sncIdBloc.add(FetchNonCompliantOutputId(
        nonCompliantOutputId: widget.params.salidaNoConformeId,
      ));
    } else {
      buscarEmployeeLogin();
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      _fechaController.text = formatter.format(DateTime.now());
      _fechaCorreccionController.text = formatter.format(DateTime.now());
      _fechaRecepcionCierreController.text = formatter.format(DateTime.now());
    }

    _descActividadController.text = widget.params.descripcionActividad;
    _descActTemp = widget.params.descripcionActividad;
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
            ),
          )),
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
          plannedRecourceBlocListerner(),
          employeeBlocListernet(),
        ],
        child: widget.params.estatus == 'Sin Registro' ||
                widget.params.estatus == 'Pendiente'
            ? Column(
                children: <Widget>[
                  seccionDetecta(),
                  widget.params.tipo == 'SNC-A'
                      ? Text('SNC-Origen: $_origen',
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0))
                      : Text(''),
                  headerPrincipal(),
                  sectionRequisitoIncumplido(),
                  sectionDisposicion(),
                  sectionDispositionDescription(),
                  SizedBox(height: 50),
                ],
              )
            : Column(
                children: <Widget>[
                  seccionDetecta(),
                  headerPrincipal(),
                  ExpansionPanelList(
                    elevation: 0,
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        if (index == 0)
                          _isExpandedNoCompliant = !isExpanded;
                        else
                          _isExpandedDisposition = !isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Container();
                        },
                        isExpanded: _isExpandedNoCompliant,
                        body: sectionRequisitoIncumplido(),
                      ),
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return Container();
                        },
                        isExpanded: _isExpandedDisposition,
                        body: sectionDisposicion(),
                      )
                    ],
                  ),
                  sectionDispositionDescription(),
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
                fechaControl(),
                SizedBox(width: 30.0),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ColumnBox(
                    titlePrincipal: 'Consecutivo:',
                    information: widget.params.consecutivo == null
                        ? ''
                        : widget.params.consecutivo,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 5.0),
                contratoControl(),
                SizedBox(width: 5.0),
                obraControl(),
                SizedBox(width: 5.0),
                planoControl(),
                SizedBox(width: 5.0),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              children: [
                                Text(
                                  'Descripción de la Actividad: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                widget.params.tipo == 'SNC-A' ||
                                        _disabledControls
                                    ? Text('')
                                    : IconButton(
                                        icon: Icon(Icons.refresh_outlined),
                                        iconSize: 18.0,
                                        color: Colors.blue,
                                        onPressed: () {
                                          _descActividadController.text =
                                              _descActTemp;
                                        },
                                      ),
                              ],
                            )),
                      ),
                      Form(
                        key: txtDescActividad,
                        child: TextFormField(
                          controller: _descActividadController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Es necesario este campo';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            txtDescActividad.currentState.validate();
                          },
                          keyboardType: TextInputType.multiline,
                          enabled:
                              widget.params.tipo == 'SNC-A' || _disabledControls
                                  ? false
                                  : true,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Descripción....',
                            alignLabelWithHint: true,
                            suffixIcon: Icon(Icons.text_format, size: 30.0),
                          ), // when user presses enter it will adapt to it
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Aplica A: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        )),
                    Radio(
                      value: 1,
                      groupValue: _selectedAplica,
                      activeColor: Colors.blue,
                      onChanged:
                          widget.params.tipo == 'SNC-A' || _disabledControls
                              ? null
                              : (val) {
                                  setSelectedAplica(val);
                                },
                    ),
                    Text('PREFABRICADO',
                        style: TextStyle(
                          fontSize: 14.0,
                        )),
                    SizedBox(
                      width: 10.0,
                    ),
                    Radio(
                      value: 2,
                      groupValue: _selectedAplica,
                      activeColor: Colors.blue,
                      onChanged:
                          widget.params.tipo == 'SNC-A' || _disabledControls
                              ? null
                              : (val) {
                                  setSelectedAplica(val);
                                },
                    ),
                    Text('INSTALACIÓN',
                        style: TextStyle(
                          fontSize: 14.0,
                        )),
                    SizedBox(
                      width: 10.0,
                    ),
                    Radio(
                      value: 3,
                      groupValue: _selectedAplica,
                      activeColor: Colors.blue,
                      onChanged:
                          widget.params.tipo == 'SNC-A' || _disabledControls
                              ? null
                              : (val) {
                                  setSelectedAplica(val);
                                },
                    ),
                    Text('SERVICIO',
                        style: TextStyle(
                          fontSize: 14.0,
                        )),
                  ],
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Atribuible A: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        )),
                    Radio(
                      value: 1,
                      groupValue: _selectedAtribuible,
                      activeColor: Colors.blue,
                      onChanged:
                          widget.params.tipo == 'SNC-A' || _disabledControls
                              ? null
                              : (val) {
                                  setSelectedAtribuible(val);
                                },
                    ),
                    Text('COTEMAR',
                        style: TextStyle(
                          fontSize: 14.0,
                        )),
                    SizedBox(
                      width: 10.0,
                    ),
                    Radio(
                      value: 2,
                      groupValue: _selectedAtribuible,
                      activeColor: Colors.blue,
                      onChanged:
                          widget.params.tipo == 'SNC-A' || _disabledControls
                              ? null
                              : (val) {
                                  setSelectedAtribuible(val);
                                },
                    ),
                    Text('CLIENTE',
                        style: TextStyle(
                          fontSize: 14.0,
                        )),
                    SizedBox(
                      width: 10.0,
                    ),
                    Radio(
                      value: 3,
                      groupValue: _selectedAtribuible,
                      activeColor: Colors.blue,
                      onChanged:
                          widget.params.tipo == 'SNC-A' || _disabledControls
                              ? null
                              : (val) {
                                  setSelectedAtribuible(val);
                                },
                    ),
                    Text('SUBCONTRATISTA',
                        style: TextStyle(
                          fontSize: 14.0,
                        )),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget contratoControl() {
    return BlocBuilder<ContractCSBloc, ContractCSState>(
      builder: (context, state) {
        if (state is SuccessContractCS) {
          if (_contratoId != null) {
            _contract = state.contracts
                .firstWhere((element) => element.contratoId == _contratoId);
          }

          return Expanded(
            child: DropdownSearch<ContractCSDropdownModel>(
              showSearchBox: true,
              enabled: !_disabledControls,
              itemAsString: (ContractCSDropdownModel u) =>
                  u.contratoId + ' - ' + u.nombre,
              mode: Mode.MENU,
              hint: 'Seleccione un Contrato',
              label: 'Contrato',
              items: state.contracts,
              selectedItem: _contract,
              onChanged: (obj) {
                if (widget.params.tipo != 'Manual' || _disabledControls) {
                } else {
                  setState(() {
                    _contratoId = obj.contratoId;
                    _obraId = null;
                    _planoId = null;
                    _contract = obj;
                    _work = null;
                    _plain = null;
                  });

                  dropDownPlainDetailBloc
                      .add(GetPlainDetails(workId: '', clear: true));

                  workCSBloc.add(
                    GetWorksCS(contractId: obj.contratoId),
                  );
                }
              },
            ),
          );
        } else if (state is ErrorContractCS) {
          return _dropDownSearchError(
              'Contrato', 'Seleccionar un Contrato', '');
        }
        return loadingCircular();
      },
    );
  }

  Widget _dropDownSearchError(String title, String hintTitle, String message) {
    return Expanded(
      child: DropdownSearch<String>(
          mode: Mode.MENU,
          hint: hintTitle,
          label: title,
          items: message == "" ? [] : [message]),
    );
  }

  Widget obraControl() {
    return BlocBuilder<WorkCSBloc, WorkCSState>(
      builder: (context, state) {
        if (state is SuccessWorkCS) {
          if (_obraId != null) {
            _work =
                state.works.firstWhere((element) => element.obraId == _obraId);
          }

          return Expanded(
            child: DropdownSearch<WorkDropDownModel>(
              showSearchBox: true,
              enabled: !_disabledControls,
              itemAsString: (WorkDropDownModel u) => u.oT,
              mode: Mode.MENU,
              hint: 'Seleccione una Obra',
              label: 'Obra',
              items: state.works,
              selectedItem: _work,
              onChanged: (obj) {
                if (widget.params.tipo != 'Manual' || _disabledControls) {
                } else {
                  setState(() {
                    _obraId = obj.obraId;
                    _planoId = null;
                    _work = obj;
                    _plain = null;
                  });

                  dropDownPlainDetailBloc
                      .add(GetPlainDetails(workId: obj.obraId));
                }
              },
            ),
          );
        } else if (state is ErrorWorkCS) {
          return _dropDownSearchError('Obra', 'Seleccionar una Obra', '');
        } else if (state is InitialWorkCSState) {
          return _dropDownSearchError('Obra', 'Seleccionar una Obra', '');
        }

        return loadingCircular();
      },
    );
  }

  Widget planoControl() {
    return BlocBuilder<DropDownPlainDetailBloc, DropDownPlainDetailState>(
      builder: (context, state) {
        if (state is SuccessPlainDetails) {
          if (_planoId != null) {
            _plain = state.plainDetails
                .firstWhere((element) => element.planoDetalleId == _planoId);
          }

          return Expanded(
            child: DropdownSearch<PlainDetailDropDownModel>(
              showSearchBox: true,
              itemAsString: (PlainDetailDropDownModel u) =>
                  u.numeroPlano +
                  ' Rev. ' +
                  u.revision.toString() +
                  ' Hoja ' +
                  u.hoja.toString(),
              mode: Mode.MENU,
              enabled: !_disabledControls,
              hint: 'Plano Detalle',
              label: 'Seleccione un Plano Detalle',
              items: state.plainDetails,
              selectedItem: _plain,
              onChanged: (obj) {
                if (widget.params.tipo != 'Manual' || _disabledControls) {
                } else {
                  setState(() {
                    _plain = obj;
                    _planoId = obj.planoDetalleId;
                  });
                }
              },
            ),
          );
        } else if (state is ErrorPlainDetails) {
          return _dropDownSearchError(
              'Plano Detalle', 'Seleccione un Plano Detalle', '');
        } else if (state is InitialDropDownPlainDetailState) {
          return _dropDownSearchError(
              'Plano Detalle', 'Seleccione un Plano Detalle', '');
        }
        return loadingCircular();
      },
    );
  }

  Widget fechaControl() {
    if (widget.params.tipo != 'Manual' || _disabledControls) {
      return ColumnBox(
        titlePrincipal: 'Fecha:',
        information: _fechaController.text,
      );
    } else {
      return textField(
        'Fecha',
        'Seleccione una fecha',
        controller: _fechaController,
        focusNode: AlwaysDisabledFocusNode(),
        onTapEvent: _selectDate,
      );
    }
  }

  Widget fechaCorreccion() {
    if (_fechaCorreccionController.text == null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      _fechaCorreccionController.text = formatter.format(DateTime.now());
    }
    return textField(
      '',
      'Seleccione una fecha',
      controller: _fechaCorreccionController,
      focusNode: AlwaysDisabledFocusNode(),
      onTapEvent: _selectDateCorreccion,
      enabled: widget.params.estatus != 'Proceso' ? false : true,
    );
  }

  Widget fechaRecepcionCierre() {
    if (_fechaRecepcionCierreController.text == null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      _fechaRecepcionCierreController.text = formatter.format(DateTime.now());
    }
    return textField(
      '',
      'Seleccione una fecha',
      controller: _fechaRecepcionCierreController,
      focusNode: AlwaysDisabledFocusNode(),
      onTapEvent: _selectDateRecepcionCierre,
      enabled: widget.params.estatus != 'Proceso' ? false : true,
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
      _fechaController.text = formatter.format(picked);
    }
  }

  Future<void> _selectDateCorreccion() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      _fechaCorreccionController.text = formatter.format(picked);
    }
  }

  Future<void> _selectDateRecepcionCierre() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      _fechaRecepcionCierreController.text = formatter.format(picked);
    }
  }

  // Seccion información general
  Widget headerUserInformation() {
    return BlocBuilder<EmployeeBloc, EmployeeState>(builder: (context, state) {
      if (state is SuccessEmployee) {
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
      }
      if (state is IsLoadingEmployee) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Center(
                  child: spinkit,
                )),
          ],
        );
      }
      if (state is ErrorEmployee) {
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('Parece que ha ocurrido un error')),
          ],
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Center(
                child: spinkit,
              )),
        ],
      );
    });
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
          disabledColor: Colors.grey,
          onPressed: widget.params.estatus == 'F/N' ||
                  widget.params.estatus == 'D/N' ||
                  widget.params.estatus == 'N/A'
              ? null
              : () {
                  saveGeneral();
                },
        ),
      ),
    );
  }

  Widget userAuthInformation() {
    return Padding(
        padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 2),
        child: Column(children: [
          Text("Autoriza Disposición:"),
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
  }

  Widget userMakesInformation() {
    return Padding(
        padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 2),
        child: Column(children: [
          Text("Realiza Disposición:"),
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
                          key: txtReqIncumplido,
                          child: TextFormField(
                            controller: _reqIncumplidoController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Es necesario este campo';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              txtReqIncumplido.currentState.validate();
                            },
                            keyboardType: TextInputType.multiline,
                            enabled: widget.params.tipo == 'SNC-A' ||
                                    _disabledControls
                                ? false
                                : true,
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
                              child: Row(
                                children: [
                                  Text(
                                    'FALLA O INCUMPLIMIENTO: ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  widget.params.tipo == 'SNC-A' ||
                                          _disabledControls
                                      ? Text('')
                                      : IconButton(
                                          icon: Icon(Icons.refresh_outlined),
                                          iconSize: 18.0,
                                          color: Colors.blue,
                                          onPressed: () {
                                            _fallaOIncumpController.text =
                                                _fallaTemp;
                                          },
                                        ),
                                ],
                              )),
                        ),
                        Form(
                          key: txtFallaIncump,
                          child: TextFormField(
                            controller: _fallaOIncumpController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '[Es necesario este campo]';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              txtFallaIncump.currentState.validate();
                            },
                            keyboardType: TextInputType.multiline,
                            enabled: widget.params.tipo == 'SNC-A' ||
                                    _disabledControls
                                ? false
                                : true,
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
                          key: txtEvidenciaIncump,
                          child: TextFormField(
                            controller: _evidenciaIncumpController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Es necesario este campo';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              txtEvidenciaIncump.currentState.validate();
                            },
                            keyboardType: TextInputType.multiline,
                            enabled: widget.params.tipo == 'SNC-A' ||
                                    _disabledControls
                                ? false
                                : true,
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
                    "Disposición:",
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
                              '1.- CONCESIÓN No.: ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5, right: 110),
                          child: TextField(
                            controller: _concecionNoController,
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.clear),
                              ),
                              hintText: 'Concesión...',
                              alignLabelWithHint: true,
                            ),
                            enabled: _disabledControls ? false : true,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _otraController.text = '';
                                setState(() {
                                  _selectedConcecion = 0;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 2,
                        groupValue: _selectedConcecion,
                        activeColor: Colors.blue,
                        onChanged: _disabledControls
                            ? null
                            : (val) {
                                setSelectedConcecion(val);
                                _concecionNoController.text = '';
                                _otraController.text = '';
                              },
                      ),
                      Text('2.-RECHAZADO',
                          style: TextStyle(
                            fontSize: 14.0,
                          )),
                      Radio(
                        value: 3,
                        groupValue: _selectedConcecion,
                        activeColor: Colors.blue,
                        onChanged: _disabledControls
                            ? null
                            : (val) {
                                _concecionNoController.text = '';
                                _otraController.text = '';
                                setSelectedConcecion(val);
                              },
                      ),
                      Text('DEVUELTO AL CLIENTE',
                          style: TextStyle(
                            fontSize: 14.0,
                          )),
                      Radio(
                        value: 4,
                        groupValue: _selectedConcecion,
                        activeColor: Colors.blue,
                        onChanged: _disabledControls
                            ? null
                            : (val) {
                                _concecionNoController.text = '';
                                _otraController.text = '';
                                setSelectedConcecion(val);
                              },
                      ),
                      Text('4.-CORRECCIÓN',
                          style: TextStyle(
                            fontSize: 14.0,
                          )),
                    ],
                  )
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
                              'OTRA (DESCRIBIR): ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Form(
                          child: TextFormField(
                            controller: _otraController,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _concecionNoController.text = '';
                                setState(() {
                                  _selectedConcecion = 0;
                                });
                              }
                            },
                            keyboardType: TextInputType.multiline,
                            enabled: _disabledControls ? false : true,
                            maxLines: 2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText: 'Describir...',
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

  Widget sectionDispositionDescription() {
    if (widget.params.estatus == 'Proceso' ||
        widget.params.estatus == 'F/N' ||
        widget.params.estatus == 'D/N' ||
        widget.params.estatus == 'N/A') {
      return Padding(
        padding: const EdgeInsets.only(top: 2, left: 8, right: 10, bottom: 8),
        child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
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
                Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DataTable(
                                columns: [
                                  DataColumn(label: Text('Acciones:')),
                                  DataColumn(label: Text('Responsable:')),
                                  DataColumn(label: Text('Fecha de Ejecución')),
                                ],
                                rows: resourcesRowsSpan(),
                              ),
                              DataTable(
                                columns: [
                                  DataColumn(label: Text('Cantidad')),
                                  DataColumn(label: Text('Puesto')),
                                  DataColumn(label: Text('H.H. Planeadas:')),
                                  DataColumn(
                                    label: Text('H.H. Reales:'),
                                    numeric: true,
                                  )
                                ],
                                rows: resourcesRows(),
                              ),
                            ],
                          ),
                        ))),
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(child: userMakesInformation()),
                  Expanded(child: userAuthInformation()),
                ]),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Resultado de la inspección: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            )),
                        Radio(
                          value: 'D/N',
                          groupValue: _selectedResultReinsp,
                          activeColor: Colors.blue,
                          onChanged: widget.params.estatus == 'Proceso'
                              ? (val) {
                                  setSelectedResultReinsp(val);
                                }
                              : null,
                        ),
                        Text('D/N',
                            style: TextStyle(
                              fontSize: 14.0,
                            )),
                        SizedBox(
                          width: 10.0,
                        ),
                        Radio(
                          value: 'F/N',
                          groupValue: _selectedResultReinsp,
                          activeColor: Colors.blue,
                          onChanged: widget.params.estatus == 'Proceso'
                              ? (val) {
                                  setSelectedResultReinsp(val);
                                }
                              : null,
                        ),
                        Text('F/N',
                            style: TextStyle(
                              fontSize: 14.0,
                            )),
                        SizedBox(
                          width: 10.0,
                        ),
                        Radio(
                          value: 'N/A',
                          groupValue: _selectedResultReinsp,
                          activeColor: Colors.blue,
                          onChanged: widget.params.estatus == 'Proceso'
                              ? (val) {
                                  setSelectedResultReinsp(val);
                                }
                              : null,
                        ),
                        Text('N/A',
                            style: TextStyle(
                              fontSize: 14.0,
                            )),
                      ],
                    )
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
                                'Evidencia de la Corrección/Información Soporte: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Form(
                            key: txtInfoSoporte,
                            child: TextFormField(
                              controller: _infoSoporteController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Es necesario este campo';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.multiline,
                              enabled: widget.params.estatus == 'Proceso'
                                  ? true
                                  : false,
                              maxLines: 2,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                hintText: 'Describir...',
                                alignLabelWithHint: true,
                                suffixIcon: Icon(Icons.text_format, size: 30.0),
                              ), // when user presses enter it will adapt to it
                              onChanged: (value) {
                                txtInfoSoporte.currentState.validate();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                      child: Text(
                    "Fecha de Corrección:",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  )),
                  SizedBox(width: 20),
                  Expanded(
                      child: Text(
                    "Fecha de Recepción del Cierre:",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  )),
                ]),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  fechaCorreccion(),
                  SizedBox(width: 20),
                  fechaRecepcionCierre(),
                ]),
              ]),
            )),
      );
    } else {
      return Text("");
    }
  }

  List<DataRow> resourcesRowsPrincipal() {
    List<DataRow> rowList = [];

    rowList.add(DataRow(cells: [
      DataCell(
        DataTable(
          columns: [
            DataColumn(label: Text('Acciones:')),
            DataColumn(label: Text('Responsable:')),
            DataColumn(label: Text('Fecha de Ejecución')),
          ],
          rows: resourcesRowsSpan(),
        ),
      ),
      DataCell(
        DataTable(
          columns: [
            DataColumn(label: Text('Cantidad')),
            DataColumn(label: Text('Puesto')),
            DataColumn(label: Text('H.H. Planeadas:')),
            DataColumn(
              label: Text('H.H. Reales:'),
              numeric: true,
            )
          ],
          rows: resourcesRows(),
        ),
      ),
    ]));

    return rowList;
  }

  List<DataRow> resourcesRowsSpan() {
    List<DataRow> rowList = [];
    if (_pnlResourceList.length > 0) {
      PlannedResourceModel element = _pnlResourceList.first;

      rowList.add(DataRow(cells: [
        DataCell(Text(element.acciones)),
        DataCell(Text(element.responsable)),
        DataCell(Text(DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(element.fechaEjecucion)))),
      ]));
    }
    return rowList;
  }

  List<DataRow> resourcesRows() {
    List<DataRow> rowList = [];

    _pnlResourceList.forEach((element) {
      rowList.add(DataRow(cells: [
        DataCell(Text(element.cantidad.toString())),
        DataCell(Text(element.puesto)),
        DataCell(Text(element.hrPlaneadas)),
        DataCell(
          Text(element.hrReales),
          showEditIcon:
              widget.params.estatus == 'F/N' || widget.params.estatus == 'D/N'
                  ? false
                  : true,
          onTap:
              widget.params.estatus == 'F/N' || widget.params.estatus == 'D/N'
                  ? null
                  : () {
                      editHHReales(element);
                    },
        ),
      ]));
    });

    return rowList;
  }

  Future editHHReales(PlannedResourceModel plannedResource) async {
    final hh = await showTextDialog(context,
        title: 'Horas Reales', value: plannedResource.hrReales);
    if (hh != null) {
      setState(() => _pnlResourceList = _pnlResourceList.map((res) {
            final isEditeHH = res.orden == plannedResource.orden;
            return isEditeHH
                ? PlannedResourceModel(
                    orden: res.orden,
                    cantidad: res.cantidad,
                    puesto: res.puesto,
                    hrPlaneadas: res.hrPlaneadas,
                    hrReales: hh,
                    acciones: res.acciones,
                    responsable: res.responsable,
                    fechaEjecucion: res.fechaEjecucion,
                    fichaRealiza: res.fichaRealiza,
                    fichaAutoriza: res.fichaAutoriza,
                  )
                : res;
          }).toList());
    }
  }

  void saveGeneral() {
    if (_validate()) {
      if (widget.params.estatus != 'Proceso') {
        sncBloc.add(InsUpdSNC(
            nonCompliantOutput: NonCompliantOutputIdModel(
          salidaNoConformeId: widget.params.salidaNoConformeId,
          ficha: _ficha,
          fecha: _fechaController.text,
          consecutivo: '',
          contratoId: _contratoId,
          obraId: _obraId,
          planoDetalleId: _planoId,
          descripcionActividad: _descActividadController.text,
          aplica: _selectedAplica,
          atribuible: _selectedAtribuible,
          requisito: _reqIncumplidoController.text,
          falla: _fallaOIncumpController.text,
          evidencia: _evidenciaIncumpController.text,
          noConcesion: _concecionNoController.text,
          disposicion: _selectedConcecion,
          otra: _otraController.text,
          tipo: widget.params.tipo,
          estatus: widget.params.estatus,
        )));
      } else {
        _resources.clear();
        _pnlResourceList.forEach((element) {
          _resources.add(PlannedResourceParams(
            orden: element.orden,
            hrReales: element.hrReales,
          ));
        });
        sncBloc.add(UpdEvaluateSNC(
            params: EvaluationSNCParams(
          nonCompliantOutputId: widget.params.salidaNoConformeId,
          estatus: _selectedResultReinsp.isEmpty
              ? widget.params.estatus
              : _selectedResultReinsp,
          informacionSoporte: _infoSoporteController.text,
          resources: _resources,
          fechaCorreccion: _fechaCorreccionController.text,
          fechaRecepcionCierre: _fechaRecepcionCierreController.text,
        )));
        if (_selectedResultReinsp == 'F/N' &&
            _selectedResultReinsp != widget.params.estatus) {
          sncBloc.add(InsSNCFN(
            nonCompliantOutputId: widget.params.salidaNoConformeId,
          ));
        }
      }
    }
  }

  bool _validate() {
    bool result = true;
    if (widget.params.estatus == 'Proceso') {
      if (!txtInfoSoporte.currentState.validate()) result = false;
      if (!_listHorasValidate()) result = false;
      if (!_fechaCorreccionValidate()) result = false;
      if (!_fechaRecepcionCierreValidate()) result = false;
    }
    if (!txtDescActividad.currentState.validate()) result = false;
    if (!txtReqIncumplido.currentState.validate()) result = false;
    if (!txtFallaIncump.currentState.validate()) result = false;
    if (!txtEvidenciaIncump.currentState.validate()) result = false;
    if (!_contratoValidate()) return false;
    if (!_obraValidate()) return false;
    if (!_planoValidate()) return false;
    if (!_aplicaValidate()) return false;
    if (!_atribuibleValidate()) return false;
    if (!_concesionValidate()) return false;

    return result;
  }

  bool _contratoValidate() {
    if (_contratoId != null && _contratoId.isNotEmpty) {
      return true;
    } else {
      mensajeError("Debe seleccionar el contrato");
      return false;
    }
  }

  bool _obraValidate() {
    if (_obraId != null && _obraId.isNotEmpty) {
      return true;
    } else {
      mensajeError("Debe seleccionar la obra");
      return false;
    }
  }

  bool _planoValidate() {
    if (_planoId != null && _planoId.isNotEmpty) {
      return true;
    } else {
      mensajeError("Debe seleccionar el Plano");
      return false;
    }
  }

  bool _aplicaValidate() {
    if (_selectedAplica != null && _selectedAplica > 0) {
      return true;
    } else {
      mensajeError("Debe seleccionar una opción en Aplica A:");
      return false;
    }
  }

  bool _atribuibleValidate() {
    if (_selectedAtribuible != null && _selectedAtribuible > 0) {
      return true;
    } else {
      mensajeError("Debe seleccionar una opción en Atribuble A:");
      return false;
    }
  }

  bool _concesionValidate() {
    if (_concecionNoController.text.isNotEmpty ||
        _otraController.text.isNotEmpty ||
        (_selectedConcecion != null && _selectedConcecion > 0)) {
      return true;
    } else {
      mensajeError("Debe completar la sección de Disposición");
      return false;
    }
  }

  bool _listHorasValidate() {
    bool valid = true;
    _pnlResourceList.forEach((element) {
      if (element.hrReales.isEmpty && element.hrPlaneadas.isNotEmpty)
        valid = false;
    });
    if (!valid) {
      mensajeError("Debe completar las Horas Reales");
    }
    return valid;
  }

  bool _fechaCorreccionValidate() {
    if (_fechaCorreccionController.text != null &&
        _fechaCorreccionController.text.isNotEmpty) {
      return true;
    } else {
      mensajeError("Debe seleccionar la Fecha de Corrección");
      return false;
    }
  }

  bool _fechaRecepcionCierreValidate() {
    if (_fechaRecepcionCierreController.text != null &&
        _fechaRecepcionCierreController.text.isNotEmpty) {
      return true;
    } else {
      mensajeError("Debe seleccionar la Fecha de Recepción Cierre");
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
        _infoSoporteController.text =
            state.ncoIdModelList.first.informacionSoporte;
        _concecionNoController.text = state.ncoIdModelList.first.noConcesion;
        _otraController.text = state.ncoIdModelList.first.otra;
        _fechaController.text = state.ncoIdModelList.first.fecha;
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        if (state.ncoIdModelList.first.fechaCorreccion != null) {
          _fechaCorreccionController.text = formatter.format(
              DateTime.parse(state.ncoIdModelList.first.fechaCorreccion));
        }
        if (state.ncoIdModelList.first.fechaRecepcionCierre != null) {
          _fechaRecepcionCierreController.text = formatter.format(
              DateTime.parse(state.ncoIdModelList.first.fechaRecepcionCierre));
        }

        setState(() {
          _ficha = state.ncoIdModelList.first.ficha;
          _obraId = state.ncoIdModelList.first.obraId;
          _contratoId = state.ncoIdModelList.first.contratoId;
          _planoId = state.ncoIdModelList.first.planoDetalleId;
          _selectedConcecion = state.ncoIdModelList.first.disposicion;
          _selectedAplica = state.ncoIdModelList.first.aplica;
          _selectedAtribuible = state.ncoIdModelList.first.atribuible;
          _selectedResultReinsp = state.ncoIdModelList.first.estatus;
          _fallaTemp = state.ncoIdModelList.first.falla;
          _origen = state.ncoIdModelList.first.origen == null
              ? ''
              : state.ncoIdModelList.first.origen;
        });

        employeeBloc = BlocProvider.of<EmployeeBloc>(context);
        employeeBloc.add(GetEmployeeByFicha(
          ficha: state.ncoIdModelList.first.ficha,
        ));

        workCSBloc.add(
          GetWorksCS(
            contractId: _contratoId,
          ),
        );
        dropDownPlainDetailBloc.add(GetPlainDetails(workId: _obraId));
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

  BlocListener insUpdSncBlocListerner() {
    return BlocListener<NonCompliantOutputBloc, NonCompliantOutputState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingNonCompliantOutput) {
        loadingCircular();
      }

      if (state is SuccessInsUpdSNC ||
          state is SuccessEvaluateSNC ||
          state is SuccessInsSNCFN) {
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
        if (state is SuccessInsSNCFN) {
          dialog.Dialogs.alert(context,
              title: "Importante",
              description:
                  "Se ha generado un registro de SNC, favor de consultar y dar continuidad al proceso en la bandeja correspondiente.");
        }
      }

      if (state is SuccessDispositionDescription) {
        setState(() {
          _fichaRealiza = state.dispositionDescriptionModel.employeMakes;
          _fichaAutoriza = state.dispositionDescriptionModel.employeeAuth;
        });
        employeeBloc = BlocProvider.of<EmployeeBloc>(context);
        employeeBloc.add(GetEmployeeAuthByFicha(
          ficha: _fichaAutoriza,
        ));
        employeeBloc.add(GetEmployeeMakesByFicha(
          ficha: _fichaRealiza,
        ));
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

  BlocListener plannedRecourceBlocListerner() {
    return BlocListener<PlannedResourcesBloc, PlannedResourcesState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingPlannedResourceState) {
        loadingCircular();
      }

      if (state is SuccessPlannedResourceState) {
        _pnlResourceList = state.plannedResourceModelList;
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
}
