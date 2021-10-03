import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/models/work_dropdown_model.dart';
import 'package:mc_app/src/widgets/check.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/widgets/text_field.dart';
import 'package:mc_app/src/widgets/flat_button.dart';
import 'package:mc_app/src/models/contract_dropdown_model.dart';
import 'package:mc_app/src/utils/always_disabled_focus_node.dart';

class AnticorrosiveFilters extends StatefulWidget {
  final TextEditingController registryNumber;
  final TextEditingController place;
  final TextEditingController platform;
  final TextEditingController date;
  final String contractSelection;
  final String workSelection;
  final bool pendingChecked;
  final bool processChecked;
  final bool finishedChecked;
  final Function selectDate;
  final Function clearDate;
  final void Function(dynamic) onChangeContract;
  final void Function(dynamic) onChangeWork;
  final void Function(bool) onChangePendingCheck;
  final void Function(bool) onChangeProcessCheck;
  final void Function(bool) onChangeFinishedCheck;
  final Function search;

  AnticorrosiveFilters({
    Key key,
    this.registryNumber,
    this.place,
    this.platform,
    this.date,
    this.contractSelection,
    this.workSelection,
    this.pendingChecked,
    this.processChecked,
    this.finishedChecked,
    this.onChangeContract,
    this.onChangeWork,
    this.onChangePendingCheck,
    this.onChangeProcessCheck,
    this.onChangeFinishedCheck,
    this.selectDate,
    this.clearDate,
    this.search,
  }) : super(key: key);

  @override
  _AnticorrosiveFiltersState createState() => _AnticorrosiveFiltersState();
}

class _AnticorrosiveFiltersState extends State<AnticorrosiveFilters> {
  bool _isExpanded = true;
  ContractDropdownModel _contract;
  WorkDropDownModel _work;

  @override
  Widget build(BuildContext context) {
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
          body: Container(
            padding:
                EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
            child: Column(
              children: [
                Row(
                  children: [
                    textField(
                      'Registro',
                      'Ingrese el Registro',
                      controller: widget.registryNumber,
                    ),
                    SizedBox(width: 10.0),
                    BlocBuilder<DropDownContractBloc, DropDownContractState>(
                      builder: (context, state) {
                        if (state is SuccessContract) {
                          return Expanded(
                            child: DropdownSearch<ContractDropdownModel>(
                              showSearchBox: true,
                              itemAsString: (ContractDropdownModel u) =>
                                  u.contratoId + ' - ' + u.nombre,
                              mode: Mode.MENU,
                              hint: 'Seleccione un Contrato',
                              label: 'Contrato',
                              showClearButton: true,
                              items: state.contracts,
                              selectedItem: _contract,
                              onChanged: (obj) {
                                if (obj == null) {
                                  setState(() {
                                    _contract = obj;
                                    widget.onChangeContract('');
                                  });
                                } else {
                                  setState(() {
                                    _contract = obj;
                                  });
                                  widget.onChangeContract(obj.contratoId);
                                }
                              },
                            ),
                          );
                        } else if (state is ErrorContract) {
                          return _dropDownSearchError('Contrato',
                              'Seleccione un Contrato', state.message);
                        }

                        return _dropDownSearchError(
                            'Contrato', 'Seleccione un Contrato', '');
                      },
                    ),
                    SizedBox(width: 10.0),
                    BlocBuilder<DropDownWorkBloc, DropDownWorkState>(
                      builder: (context, state) {
                        if (state is SuccessWorks) {
                          return Expanded(
                            child: DropdownSearch<WorkDropDownModel>(
                              showSearchBox: true,
                              itemAsString: (WorkDropDownModel u) => u.oT,
                              mode: Mode.MENU,
                              hint: 'Seleccione una Obra',
                              label: 'Obra',
                              items: state.works,
                              selectedItem: _work,
                              showClearButton: true,
                              onChanged: (obj) {
                                if (obj == null) {
                                  _work = obj;
                                  widget.onChangeWork('');
                                } else {
                                  setState(() {
                                    _work = obj;
                                  });
                                  widget.onChangeWork(obj.obraId);
                                }
                              },
                            ),
                          );
                        } else if (state is ErrorWorks) {
                          return _dropDownSearchError(
                              'Obra', 'Seleccione una Obra', '');
                        } else if (state is InitialDropDownWorkState) {
                          return _dropDownSearchError(
                              'Obra', 'Seleccione una Obra', '');
                        }

                        return _dropDownSearchError(
                            'Obra', 'Seleccione una Obra', '');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                            obscureText: false,
                            focusNode: AlwaysDisabledFocusNode(),
                            enabled: true,
                            controller: widget.date,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(fontSize: 20),
                                labelText: 'Fecha',
                                hintText: 'Seleccione una fecha',
                                alignLabelWithHint: true,
                                suffixIcon: IconButton(
                                    onPressed: widget.clearDate,
                                    icon: Icon(Icons.clear))),
                            onTap: widget.selectDate)),
                    SizedBox(width: 10.0),
                    textField('Instalación', 'Ingrese la Instalación',
                        controller: widget.place),
                    SizedBox(width: 10.0),
                    textField('Plataforma', 'Ingrese la Plataforma',
                        controller: widget.platform),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        check(
                          'Pendiente',
                          widget.pendingChecked,
                          onChangedCheck: widget.onChangePendingCheck,
                        ),
                        check(
                          'Proceso',
                          widget.processChecked,
                          onChangedCheck: widget.onChangeProcessCheck,
                        ),
                        check(
                          'Finalizadas',
                          widget.finishedChecked,
                          onChangedCheck: widget.onChangeFinishedCheck,
                        ),
                      ],
                    ),
                    SizedBox(width: 10.0),
                    flatButton(
                      Colors.blue,
                      Icons.search,
                      'Buscar',
                      Colors.white,
                      widget.search,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropDownSearchError(String title, String hintTitle, String message) {
    return Expanded(
        child: DropdownSearch<String>(
            mode: Mode.MENU,
            hint: hintTitle,
            label: title,
            items: message == "" ? [] : [message]));
  }
}
