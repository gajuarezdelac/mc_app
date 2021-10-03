// import 'package:commons/commons.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/models/contract_dropdown_model.dart';
import 'package:mc_app/src/models/params/get_materials_corrosion_params.dart';
import 'package:mc_app/src/models/work_dropdown_model.dart';
import 'package:mc_app/src/utils/always_disabled_focus_node.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:mc_app/src/widgets/flat_button.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/text_field.dart';

class Filters extends StatefulWidget {
  final Function selectDate;
  final Function(GetMaterialsCorrisionParamsModel params) shearch;

  const Filters({Key key, this.selectDate, this.shearch}) : super(key: key);

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  DropDownWorkBloc dropDownWorkBloc;
  String _contractSelection;
  String _workSelection;
  ContractDropdownModel _contract;
  WorkDropDownModel _work;
  bool _isExpanded = true;
  TextEditingController _noEnvioController = TextEditingController();
  TextEditingController _destinoController = TextEditingController();
  TextEditingController _fechaInitController = TextEditingController();
  TextEditingController _fechaFinishController = TextEditingController();
  TextEditingController _depSolicitante = TextEditingController();
  TextEditingController _registroInspeccion = TextEditingController();

  @override
  void initState() {
    super.initState();
    dropDownWorkBloc = BlocProvider.of<DropDownWorkBloc>(context);
  }

  void _shearch() {
    GetMaterialsCorrisionParamsModel request =
        new GetMaterialsCorrisionParamsModel(
      contratoId: _contractSelection != null ? _contractSelection : "",
      deptoSolicitante: _depSolicitante.text,
      destino: _destinoController.text,
      fechaFin: _fechaInitController.text,
      fechaInicio: _fechaFinishController.text,
      noEnvio: _noEnvioController.text,
      noRegistroInspeccion: _registroInspeccion.text,
      obraId: _workSelection != null ? _workSelection : "",
      observaciones: '',
    );

    widget.shearch(request);
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return ExpansionPanelList(
        elevation: 0,
        expansionCallback: (int index, bool isExpanded) {
          setState(() => _isExpanded = !isExpanded);
        },
        children: [
          ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Container();
              },
              isExpanded: _isExpanded,
              body: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: responsive.dp(0.2),
                                  right: responsive.dp(0.2)),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: BlocBuilder<DropDownContractBloc,
                                    DropDownContractState>(
                                  builder: (context, state) {
                                    if (state is SuccessContract) {
                                      return DropdownSearch<
                                          ContractDropdownModel>(
                                        showSearchBox: true,
                                        itemAsString:
                                            (ContractDropdownModel u) =>
                                                u.contratoId + ' - ' + u.nombre,
                                        mode: Mode.MENU,
                                        hint: 'Seleccione un Contrato',
                                        label: 'Contrato',
                                        items: state.contracts,
                                        showClearButton: true,
                                        selectedItem: _contract,
                                        onChanged: (obj) {
                                          if (obj == null) {
                                            setState(() {
                                              _work = null;
                                              _contract = obj;
                                              _contractSelection = '';
                                              _workSelection = '';
                                            });

                                            dropDownWorkBloc.add(
                                                GetWorksById(contractId: ''));
                                          } else {
                                            setState(() {
                                              _contract = obj;
                                              _contractSelection =
                                                  obj.contratoId;
                                              _work = null;
                                            });

                                            dropDownWorkBloc.add(GetWorksById(
                                                contractId: obj.contratoId));
                                          }
                                        },
                                      );
                                    } else if (state is ErrorContract) {
                                      return _dropDownSearchError(
                                        'Contrato',
                                        'Seleccione un Contrato',
                                        state.message,
                                      );
                                    }
                                    return loadingCircular();
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: responsive.dp(0.2),
                                  right: responsive.dp(0.2)),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: BlocBuilder<DropDownWorkBloc,
                                    DropDownWorkState>(
                                  builder: (context, state) {
                                    if (state is SuccessWorks) {
                                      return DropdownSearch<WorkDropDownModel>(
                                        showSearchBox: true,
                                        itemAsString: (WorkDropDownModel u) =>
                                            u.oT,
                                        mode: Mode.MENU,
                                        hint: 'Seleccione una Obra',
                                        label: 'Obra',
                                        items: state.works,
                                        selectedItem: _work,
                                        showClearButton: true,
                                        onChanged: (obj) {
                                          if (obj == null) {
                                            setState(() {
                                              _workSelection = '';
                                              _work = obj;
                                            });
                                          } else {
                                            setState(() {
                                              _work = obj;
                                              _workSelection = obj.obraId;
                                            });
                                          }
                                        },
                                      );
                                    } else if (state is ErrorContract) {
                                      return _dropDownSearchError(
                                        'Obra',
                                        'Seleccione una obra',
                                        state.message,
                                      );
                                    }
                                    return _dropDownSearchError(
                                      'Obra',
                                      'Seleccione una obra',
                                      "",
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          textField('No. Envío:', 'Ingrese el no. envío',
                              controller: _noEnvioController),
                          SizedBox(width: 10.0),
                          textField('No. de Registro de Inspección:',
                              'Ingrese No. de Registro de Inspección:',
                              controller: _registroInspeccion),
                          SizedBox(width: 10.0),
                          textField('Destino:', 'Ingrese destino::',
                              controller: _destinoController),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          textField('Depto. Solicitante:',
                              'Ingrese depto. solicitante:',
                              controller: _depSolicitante),
                          SizedBox(width: 10.0),
                          textField(
                            'Fecha Inicio:',
                            'Seleccione una fecha',
                            controller: _fechaInitController,
                            focusNode: AlwaysDisabledFocusNode(),
                            onTapEvent: _selectDateInit,
                          ),
                          SizedBox(width: 10.0),
                          textField('Fecha Fin:', 'Seleccione una fecha',
                              controller: _fechaFinishController,
                              focusNode: AlwaysDisabledFocusNode(),
                              onTapEvent: _selectDateFinish),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          flatButton(Colors.blue, Icons.search, 'Buscar',
                              Colors.white, _shearch),
                        ],
                      ),
                    ],
                  ),
                ),
              ))
        ]);
  }

  Widget _dropDownSearchError(String title, String hintTitle, String message) {
    return DropdownSearch<String>(
        mode: Mode.MENU,
        hint: hintTitle,
        label: title,
        items: message == "" ? [] : [message]);
  }

  Future<void> _selectDateInit() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      DateFormat formatter = DateFormat('dd/MM/yyyy');
      _fechaInitController.text = formatter.format(picked);
    }
  }

  Future<void> _selectDateFinish() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      DateFormat formatter = DateFormat('dd/MM/yyyy');
      _fechaFinishController.text = formatter.format(picked);
    }
  }
}
