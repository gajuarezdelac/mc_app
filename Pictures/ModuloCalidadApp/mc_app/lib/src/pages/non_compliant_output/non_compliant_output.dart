import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/models/select_dropdown_model.dart';
import 'package:mc_app/src/models/user_permission_model.dart';
import 'package:mc_app/reports/registro_salida_no_conforme.dart';
import 'package:mc_app/src/bloc/non_compliant_output/report_non_compliant_output/rpt_non_compliant_output_bloc.dart';
import 'package:mc_app/src/bloc/non_compliant_output/report_non_compliant_output/rpt_non_compliant_output_event.dart';
import 'package:mc_app/src/bloc/non_compliant_output/report_non_compliant_output/rpt_non_compliant_output_state.dart';
import 'package:mc_app/src/pages/non_compliant_output/widgets/add_output.dart';
import 'package:mc_app/src/pages/non_compliant_output/widgets/upload_files.dart';
import 'package:mc_app/src/pages/non_compliant_output/widgets/disposition_description.dart';
import 'package:mc_app/src/models/params/non_compliant_output_params.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mc_app/src/bloc/non_compliant_output/bloc.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_bloc.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_event.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_state.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';
import 'package:mc_app/src/models/non_compliant_output_paginator_model.dart';
import 'package:mc_app/src/widgets/flat_button.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:mc_app/src/widgets/table_initial_snc.dart';
import 'package:easy_search/easy_search.dart';
import 'package:mc_app/src/repository/non_compliant_output_repository.dart';

class NonCompliantOutput extends StatefulWidget {
  static String id = "Salida No Conforme";

  NonCompliantOutput({Key key}) : super(key: key);

  @override
  _NonCompliantOutput createState() => _NonCompliantOutput();
}

class _NonCompliantOutput extends State<NonCompliantOutput> {
  UserPermissionModel userPermissionModel;
  bool prefabricado = false;
  bool instalacion = false;
  bool servicio = false;
  bool cotemar = false;
  bool cliente = false;
  bool subcontratista = false;
  String workSelection;
  String contractSelection;
  String plainDetailSelection;
  String typeSelection;
  DTSSalidaNoConforme dtsSNC;
  PaginatorSNCBloc ipBloc;
  Color _columnColor = Colors.lightBlue[900];
  Color _columnTextColor = Colors.white;
  List<String> sncIdList = [];
  List<String> sncDetectaList = [];

  NonCompliantOutputParams _params;
  RptNonCompliantOutputModel rptNonCompliantOutput;
  WorksSNCOutputBloc _ncoWorksBloc;
  // ignore: close_sinks
  RptNonCompliantOutputBloc rptNonCompliantOutputBloc;
  ContractsSNCOutputBloc _ncoContractsBloc;
  TypeSNCOutputBloc _ncoTypeBloc;
  ContractDropdownModelSNC _contract;
  WorkDropDownModelSNC _work;
  PlainDetailSNCBloc _ncoPlainDetailoc;
  PlainDetailDropDownModelSNC _plain;
  TypeModelSNC _type;

  @override
  void initState() {
    super.initState();
    initialData();
  }

  void initialData() {
    userPermissionModel =
        BlocProvider.of<UserPermissionBloc>(context).state.permissions;
    _params = NonCompliantOutputParams(
      bandeja: userPermissionModel.nonCompliantOutPutTrayFilters ? 1 : 2,
      ids: "",
      contratos: "", //648235806
      obras: "", //OB00703
      planos: "",
      tipos: "", //
      fichas: "",
      aplica: "",
      atribuible: "",
      estatus: "",
      offset: 0,
      nextrows: 10,
    );
    ipBloc = BlocProvider.of<PaginatorSNCBloc>(context);
    ipBloc.add(FetchNoCompliantOutputPaginator(
        bandeja: _params.bandeja,
        ids: _params.ids,
        contratos: _params.contratos,
        obras: _params.obras,
        planos: _params.planos,
        tipos: _params.tipos,
        fichas: _params.fichas,
        aplica: _params.aplica,
        atribuible: _params.atribuible,
        estatus: _params.estatus,
        offset: _params.offset,
        nextrows: _params.nextrows));

    rptNonCompliantOutputBloc =
        BlocProvider.of<RptNonCompliantOutputBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    _ncoWorksBloc = BlocProvider.of<WorksSNCOutputBloc>(context);

    _ncoContractsBloc = BlocProvider.of<ContractsSNCOutputBloc>(context);
    _ncoTypeBloc = BlocProvider.of<TypeSNCOutputBloc>(context);

    _ncoPlainDetailoc = BlocProvider.of<PlainDetailSNCBloc>(context);

    _ncoContractsBloc.add(FetchContractsSNC(
      bandeja: userPermissionModel.nonCompliantOutPutTrayFilters ? 1 : 2,
    ));
    _ncoWorksBloc.add(FetchWorksSNC(
      bandeja: userPermissionModel.nonCompliantOutPutTrayFilters ? 1 : 2,
    ));
    _ncoPlainDetailoc.add(FetchPlainDetailSNC(
      bandeja: userPermissionModel.nonCompliantOutPutTrayFilters ? 1 : 2,
    ));
    _ncoTypeBloc.add(FetchTypeSNC(
      bandeja: userPermissionModel.nonCompliantOutPutTrayFilters ? 1 : 2,
    ));

    Widget _dropDownSearchError(
        String title, String hintTitle, String message) {
      return Expanded(
        child: DropdownSearch<String>(
            mode: Mode.MENU,
            hint: hintTitle,
            label: title,
            items: message == "" ? [] : [message]),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(NonCompliantOutput.id)),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: GestureDetector(
              child: SingleChildScrollView(
                  child: MultiBlocListener(
            listeners: [listenerRptSNC()],
            child: Container(
              width: double.infinity,
              height: responsive.height,
              child: ListView(
                children: <Widget>[
                  Card(
                    // elevation: 5.0,
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(5.0),
                    // ),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          EasySearch(
                            multipleSelect: true,
                            onSearch: (text) {
                              print('Filter Query: $text');
                              return getSNCIds(name: text);
                            },
                            onChange: (list) {
                              if (list == null) {
                                setState(() {
                                  sncIdList = [];
                                });
                              } else {
                                List<String> lst = [];
                                list.forEach((element) {
                                  lst.add(element.key);
                                });
                                setState(() {
                                  sncIdList = lst;
                                });
                              }
                            },
                            searchResultSettings: SearchResultSettings(
                              padding: EdgeInsets.only(
                                  left: 8.0, top: 8.0, right: 8.0),
                              label: LabelSettings.searchLabel(value: 'SNC:'),
                            ),
                            customItemBuilder: (BuildContext context,
                                SelectDropDownModel item, bool isSelected) {
                              return Container(
                                decoration: !isSelected
                                    ? null
                                    : BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.white,
                                      ),
                                child: ListTile(
                                  selected: isSelected,
                                  title: Text(item.value),
                                  subtitle: Text(item.key),
                                  leading: Icon(Icons.people),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // textField('SNC:', 'Ingrese el SNC'),

                              BlocBuilder<ContractsSNCOutputBloc,
                                  ContractsSNCState>(
                                builder: (context, state) {
                                  if (state is SuccessContractsSNC) {
                                    return Expanded(
                                      child: DropdownSearch<
                                          ContractDropdownModelSNC>(
                                        showSearchBox: true,
                                        itemAsString:
                                            (ContractDropdownModelSNC u) =>
                                                u.contratoId + ' - ' + u.nombre,
                                        mode: Mode.MENU,
                                        hint: 'Seleccione un Contrato',
                                        label: 'Contrato',
                                        items: state.contractModelList,
                                        selectedItem: _contract,
                                        showClearButton: true,
                                        onChanged: (obj) {
                                          setState(() {
                                            _contract = obj;
                                            contractSelection = obj == null
                                                ? ''
                                                : obj.contratoId;
                                          });
                                        },
                                      ),
                                    );
                                  } else if (state is ErrorContractsSNC) {
                                    return _dropDownSearchError(
                                        'Contrato', 'Seleccionar', state.error);
                                  }
                                  return loadingCircular();
                                },
                              ),
                              SizedBox(width: 10.0),
                              BlocBuilder<WorksSNCOutputBloc, WorksSNCState>(
                                builder: (context, state) {
                                  if (state is SuccessWorksSNC) {
                                    return Expanded(
                                      child:
                                          DropdownSearch<WorkDropDownModelSNC>(
                                        showSearchBox: true,
                                        itemAsString:
                                            (WorkDropDownModelSNC u) => u.oT,
                                        mode: Mode.MENU,
                                        hint: 'Seleccione una Obra',
                                        label: 'Obra',
                                        items: state.works,
                                        selectedItem: _work,
                                        showClearButton: true,
                                        onChanged: (obj) {
                                          setState(() {
                                            _work = obj;
                                            workSelection =
                                                obj == null ? '' : obj.obraId;
                                          });
                                        },
                                      ),
                                    );
                                  } else if (state is ErrorWorksSNC) {
                                    return _dropDownSearchError(
                                        'Obra', 'Seleccionar', state.error);
                                  }
                                  return loadingCircular();
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BlocBuilder<PlainDetailSNCBloc,
                                  PlainDetailSNCState>(
                                builder: (context, state) {
                                  if (state is SuccessPlainDetailSNC) {
                                    return Expanded(
                                      child: DropdownSearch<
                                          PlainDetailDropDownModelSNC>(
                                        showSearchBox: true,
                                        itemAsString:
                                            (PlainDetailDropDownModelSNC u) =>
                                                u.numeroPlano +
                                                ' Rev. ' +
                                                u.revision.toString() +
                                                ' Hoja ' +
                                                u.hoja.toString(),
                                        mode: Mode.MENU,
                                        hint: 'Seleccione un plano',
                                        label: 'Plano Detalle',
                                        items: state.plainDetailDDModelList,
                                        selectedItem: _plain,
                                        showClearButton: true,
                                        onChanged: (obj) {
                                          _plain = obj;
                                          plainDetailSelection = obj == null
                                              ? ''
                                              : obj.planoDetalleId;
                                        },
                                      ),
                                    );
                                  } else if (state is ErrorPlainDetailSNC) {
                                    return _dropDownSearchError('Plano Detalle',
                                        'Seleccionar', state.error);
                                  }
                                  return loadingCircular();
                                },
                              ),
                              SizedBox(width: 10.0),
                              BlocBuilder<TypeSNCOutputBloc, TypeSNCState>(
                                builder: (context, state) {
                                  if (state is SuccessTypeSNC) {
                                    return Expanded(
                                      child: DropdownSearch<TypeModelSNC>(
                                        showSearchBox: true,
                                        itemAsString: (TypeModelSNC u) =>
                                            u.tipo,
                                        mode: Mode.MENU,
                                        hint: 'Seleccione un tipo',
                                        label: 'Tipo',
                                        items: state.typeSNCList,
                                        selectedItem: _type,
                                        showClearButton: true,
                                        onChanged: (obj) {
                                          setState(() {
                                            _type = obj;
                                            typeSelection =
                                                obj == null ? '' : obj.tipo;
                                          });
                                        },
                                      ),
                                    );
                                  } else if (state is ErrorTypeSNC) {
                                    return _dropDownSearchError('Tipo',
                                        'Seleccionar tipo', state.error);
                                  }
                                  return loadingCircular();
                                },
                              ),
                            ],
                          ),
                          EasySearch(
                            multipleSelect: true,
                            onSearch: (text) {
                              print('Filter Query: $text');
                              return getSNCDetecta(name: text);
                            },
                            onChange: (list) {
                              if (list == null) {
                                setState(() {
                                  sncDetectaList = [];
                                });
                              } else {
                                List<String> lst = [];
                                list.forEach((element) {
                                  lst.add(element.key);
                                });
                                setState(() {
                                  sncDetectaList = lst;
                                });
                              }
                            },
                            searchResultSettings: SearchResultSettings(
                              padding: EdgeInsets.only(
                                  left: 8.0, top: 8.0, right: 8.0),
                              label:
                                  LabelSettings.searchLabel(value: 'Detecta:'),
                            ),
                            customItemBuilder: (BuildContext context,
                                SelectDropDownModel item, bool isSelected) {
                              return Container(
                                decoration: !isSelected
                                    ? null
                                    : BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.white,
                                      ),
                                child: ListTile(
                                  selected: isSelected,
                                  title: Text(item.value),
                                  subtitle: Text(item.key),
                                  leading: Icon(Icons.people),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 5.0,
                                        left: 5.0,
                                      ),
                                      child: Text("Aplica A:"),
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: Colors.blue,
                                          value: this.prefabricado,
                                          onChanged: (bool value) {
                                            setState(() {
                                              this.prefabricado = value;
                                              //validatorCheckEtapa = value;
                                            });
                                            //changeUpdateParams();
                                          },
                                        ),
                                        Text('PREFABRICADO',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: Colors.blue,
                                          value: this.instalacion,
                                          onChanged: (bool value) {
                                            setState(() {
                                              this.instalacion = value;
                                              //validatorCheckEtapa = value;
                                            });
                                            //changeUpdateParams();
                                          },
                                        ),
                                        Text('INSTALACIÓN',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: Colors.blue,
                                          value: this.servicio,
                                          onChanged: (bool value) {
                                            setState(() {
                                              this.servicio = value;
                                              //validatorCheckEtapa = value;
                                            });
                                            //changeUpdateParams();
                                          },
                                        ),
                                        Text('SERVICIO',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              )),
                              SizedBox(width: 10.0),
                              Expanded(
                                  child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 5.0,
                                        left: 5.0,
                                      ),
                                      child: Text("Atribuible A:"),
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: Colors.blue,
                                          value: this.cotemar,
                                          onChanged: (bool value) {
                                            setState(() {
                                              this.cotemar = value;
                                              //validatorCheckEtapa = value;
                                            });
                                            //changeUpdateParams();
                                          },
                                        ),
                                        Text('COTEMAR',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: Colors.blue,
                                          value: this.cliente,
                                          onChanged: (bool value) {
                                            setState(() {
                                              this.cliente = value;
                                              //validatorCheckEtapa = value;
                                            });
                                            //changeUpdateParams();
                                          },
                                        ),
                                        Text('CLIENTE',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: Colors.blue,
                                          value: this.subcontratista,
                                          onChanged: (bool value) {
                                            setState(() {
                                              this.subcontratista = value;
                                              //validatorCheckEtapa = value;
                                            });
                                            //changeUpdateParams();
                                          },
                                        ),
                                        Text('SUBCONTRATISTA',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              )),
                              SizedBox(width: 10.0),
                              Expanded(
                                  child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        flatButton(
                                          Colors.blue,
                                          Icons.search,
                                          'Buscar',
                                          Colors.white,
                                          () {
                                            _sncList('');
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          _rowEstatus(
                              userPermissionModel.nonCompliantOutPutTrayFilters
                                  ? 1
                                  : 2),
                          SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              flatButton(
                                Colors.blue,
                                Icons.add,
                                'SNC Manual',
                                Colors.white,
                                () {
                                  NonCompliantOutputPaginatorModel _model =
                                      NonCompliantOutputPaginatorModel(
                                          totalCount: 0,
                                          salidaNoConformeId: '',
                                          semaforo: 'gris',
                                          consecutivo: '',
                                          tipo: 'Manual',
                                          contrato: '',
                                          ot: '',
                                          detecta: '',
                                          plano: '',
                                          aplica: '',
                                          atribuible: '',
                                          descripcionActividad: '',
                                          estatus: 'Sin Registro',
                                          totalDocumentos: 0,
                                          selected: true);
                                  _navigateToWeldingDetail(
                                      _model, _params, false);
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: BlocBuilder<PaginatorSNCBloc,
                                NonCompliantOutputPaginatorState>(
                              builder: (context, state) {
                                if (state
                                    is SuccessNonCompliantOutputPaginator) {
                                  dtsSNC = DTSSalidaNoConforme(
                                      state.ncoPaginatorModelList,
                                      context,
                                      _params,
                                      userPermissionModel,
                                      rptNonCompliantOutputBloc);
                                  return PaginatedDataTable(
                                    rowsPerPage: 10,
                                    showCheckboxColumn: false,
                                    columnSpacing: 0.0,
                                    headingRowHeight: 35.0,
                                    // header: Text('Servicio No Conforme'),
                                    source: dtsSNC ?? [],
                                    columns: [
                                      DataColumn(
                                        label: Expanded(
                                          child: Container(
                                            color: _columnColor,
                                            child: Center(
                                              child: Text('',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: _columnTextColor,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Container(
                                            color: _columnColor,
                                            child: Center(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20.0),
                                                  child: Text('SNC',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _columnTextColor,
                                                      ))),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Container(
                                            color: _columnColor,
                                            child: Center(
                                                child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 20.0),
                                              child: Text('Tipo SNC',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: _columnTextColor,
                                                  )),
                                            )),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Container(
                                            color: _columnColor,
                                            child: Center(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20.0),
                                                  child: Text('Contrato',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _columnTextColor,
                                                      ))),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Container(
                                            color: _columnColor,
                                            child: Center(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20.0),
                                                  child: Text('Obra',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _columnTextColor,
                                                      ))),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Container(
                                            color: _columnColor,
                                            child: Center(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20.0),
                                                  child: Text('Detecta',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _columnTextColor,
                                                      ))),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Container(
                                            color: _columnColor,
                                            child: Center(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20.0),
                                                  child: Text('Plano Detalle',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _columnTextColor,
                                                      ))),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Container(
                                            color: _columnColor,
                                            child: Center(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20.0),
                                                  child: Text('Aplica A:',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _columnTextColor,
                                                      ))),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Container(
                                            color: _columnColor,
                                            child: Center(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20.0),
                                                  child: Text('Atribuible A:',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _columnTextColor,
                                                      ))),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Container(
                                            color: _columnColor,
                                            child: Center(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20.0),
                                                  child: Text(
                                                      'Descripción de la Actividad',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _columnTextColor,
                                                      ))),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (state
                                    is IsLoadingNonCompliantOutputPaginatorState) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 50, 0, 0),
                                          child: Center(
                                            child: spinkit,
                                          )),
                                    ],
                                  );
                                } else if (state
                                    is ErrorNonCompliantOutputPaginator) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Text(
                                              'Parece que ha ocurrido un error')),
                                    ],
                                  );
                                }
                                return TableInitialSNC();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))),
        ),
      ),
    );
  }

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(color: Colors.black),
      );
    },
  );

  // BlocListener listenerDates() {
  //   return BlocListener<ListMaterialsBloc, ListMaterialsState>(
  //       listener: (context, state) {
  //     ScaffoldMessenger.of(context).hideCurrentSnackBar();

  //     if (state is IsLoadingUpdateReporteIP) {
  //       return loadingCircular();
  //     } else if (state is SuccessUpdateReporteIP) {
  //       ipBloc.add(FetchNoCompliantOutputPaginator(
  //           bandeja: _params.bandeja,
  //           ids: _params.ids,
  //           contratos: _params.contratos,
  //           obras: _params.obras,
  //           planos: _params.planos,
  //           tipos: _params.tipos,
  //           fichas: _params.fichas,
  //           aplica: _params.aplica,
  //           atribuible: _params.atribuible,
  //           estatus: _params.estatus,
  //           offset: _params.offset,
  //           nextrows: _params.nextrows));
  //     } else if (state is ErrorUpdateReporteIP) {
  //       Navigator.pop(context);
  //     }
  //   });
  // }

  BlocListener listenerRptSNC() {
    return BlocListener<RptNonCompliantOutputBloc, RptNonCompliantOutputState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingRptNonCompliantOutput) {
        return loadingCircular();
      } else if (state is SuccessGetRptNonCompliantOutput) {
        setState(() {
          rptNonCompliantOutput = state.rptNonCompliantOutput;
        });

        registroSalidaNoConforme(context, rptNonCompliantOutput);
      } else if (state is ErrorRptNonCompliantOutput) {
        Navigator.pop(context);
      }
    });
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

  /* Funciones de la ventana de Envío de Materiales a Corrosión */

  //Método para mostrar el calendario para la campo de Fecha

  Future _navigateToWeldingDetail(
      NonCompliantOutputPaginatorModel inspectionPlanDModel,
      NonCompliantOutputParams filters,
      bool closeModal) {
    if (closeModal) Navigator.pop(context);

    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterSNC(
          params: inspectionPlanDModel,
          filters: filters,
        ),
      ),
    );
  }

  Widget _rowEstatus(int bandeja) {
    if (bandeja == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Expanded(child:
          SizedBox(
            height: 40.0,
            child: userPermissionModel.nonCompliantOutPutTrayFilters
                ? InkWell(
                    onTap: () {
                      // _showSnackBar(context, 'CONFORMADO');
                      // _changeColor(Color(0xFF768591));
                      _sncList('Sin Registro');
                    }, // Handle your callback
                    child: _inkDetail(Colors.black38, 'Sin registro'),
                  )
                : Text(""),
          ),

          //),
          SizedBox(
            height: 40.0,
            child: InkWell(
              onTap: () {
                // _showSnackBar(context, 'REALIZAR_REPARAR');
                // _changeColor(Color(0xFF425363));
                _sncList('Pendiente');
              }, // Handle your callback
              child: _inkDetail(Color(0xFF618DB4), 'Pendiente'),
            ),
          ),
          SizedBox(
            height: 40.0,
            child: InkWell(
              onTap: () {
                // _showSnackBar(context, 'INSPECCION_SOLDADURA');
                // _changeColor(Color(0xFF618DB4));
                _sncList('Proceso');
              }, // Handle your callback
              child: _inkDetail(Colors.amber, 'Proceso'),
            ),
          ),
          SizedBox(
            height: 40.0,
            child: userPermissionModel.nonCompliantOutPutTrayFilters
                ? InkWell(
                    onTap: () {
                      // _showSnackBar(context, 'PND');
                      // _changeColor(Color(0xFFFF5000));
                      _sncList('F/N');
                    }, // Handle your callback
                    child: _inkDetail(Colors.red, 'F/N'),
                  )
                : Text(""),
          ),
          SizedBox(
            height: 40.0,
            child: userPermissionModel.nonCompliantOutPutTrayFilters
                ? InkWell(
                    onTap: () {
                      // _showSnackBar(context, 'LIBERADA');
                      // _changeColor(Color(0xFF77BC1F));
                      _sncList('D/N');
                    }, // Handle your callback
                    child: _inkDetail(Color(0xFF77BC1F), 'D/N'),
                  )
                : Text(""),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40.0,
            child: InkWell(
              onTap: () {
                // _showSnackBar(context, 'REALIZAR_REPARAR');
                // _changeColor(Color(0xFF425363));
                _sncList('Pendiente');
              }, // Handle your callback
              child: _inkDetail(Color(0xFF618DB4), 'Pendiente'),
            ),
          ),
          SizedBox(
            height: 40.0,
            child: InkWell(
              onTap: () {
                // _showSnackBar(context, 'INSPECCION_SOLDADURA');
                // _changeColor(Color(0xFF618DB4));
                _sncList('Proceso');
              }, // Handle your callback
              child: _inkDetail(Colors.amber, 'Proceso'),
            ),
          ),
        ],
      );
    }
  }

  void _sncList(String status) {
    switch (status) {
      case 'Sin Registro':
        setState(() {
          _columnTextColor = Colors.black;
          _columnColor = Colors.black38;
        });
        break;
      case 'Pendiente':
        setState(() {
          _columnTextColor = Colors.white;
          _columnColor = Color(0xFF618DB4);
        });
        break;
      case 'Proceso':
        setState(() {
          _columnTextColor = Colors.white;
          _columnColor = Colors.amber;
        });
        break;
      case 'F/N':
        setState(() {
          _columnTextColor = Colors.white;
          _columnColor = Colors.red;
        });
        break;
      case 'D/N':
        setState(() {
          _columnTextColor = Colors.white;
          _columnColor = Color(0xFF77BC1F);
        });
        break;
      default:
        setState(() {
          _columnTextColor = Colors.white;
          _columnColor = Colors.lightBlue[900];
        });
        break;
    }
    if (status == 'Sin Registro') {
      setState(() {
        _columnTextColor = Colors.black;
        _columnColor = Colors.black38;
      });
    }
//     _contractSelection="648235806";
//     _workSelection="OB00703";
//     _inspectionPlanCModel=new InspectionPlanCModel();
//     _inspectionPlanCModel.actividades=2;
//     _inspectionPlanCModel.contrato="NEPTUNO 806";
//     _inspectionPlanCModel.descripcion="---------------";
//     _inspectionPlanCModel.dn=0;
//     _inspectionPlanCModel.fechaCreacion="2020-12-22 10:40:49.000";
//     _inspectionPlanCModel.fn=0;
//     _inspectionPlanCModel.instalacion="Abkatun-D perforación";
//     _inspectionPlanCModel.noPlanInspeccion="648235806/OT-11/20/002";
//     _inspectionPlanCModel.obra="OT-11";
//     _inspectionPlanCModel.plataforma="648235806/OT-11/20/002";
//     _inspectionPlanCModel.semaforo=1;
//     _contractsInspectionPlanModel=new ContractsInspectionPlanModel();
//     _contractsInspectionPlanModel.contratoId="648235806";
//     _contractsInspectionPlanModel.nombre="NEPTUNO 806";
//     _worksInspectionPlanModel=new WorksInspectionPlanModel();
// _worksInspectionPlanModel.nombre="PTE-S043";
// _worksInspectionPlanModel.oT="OT-11";
// _worksInspectionPlanModel.obraId="OB00703";

//      _params = InspectionPlanParams(
//       contractSelection: _contractSelection,
//       workSelection: _workSelection,
//       inspectionPlanCModel: _inspectionPlanCModel,
//       contractsInspectionPlanModel: _contractsInspectionPlanModel,
//       worksInspectionPlanModel: _worksInspectionPlanModel,
//     );
    String _aplica = ((prefabricado ? '|1' : '') +
        (instalacion ? '|2' : '') +
        (servicio ? '|3' : ''));
    String _atribuible = ((cotemar ? '|1' : '') +
        (cliente ? '|2' : '') +
        (subcontratista ? '|3' : ''));
    String _ids = sncIdList.join("|");
    String _detecta = sncDetectaList.join("|");

    _params = NonCompliantOutputParams(
      bandeja: userPermissionModel.nonCompliantOutPutTrayFilters ? 1 : 2,
      ids: _ids,
      contratos: contractSelection == null ? '' : contractSelection,
      obras: workSelection == null ? '' : workSelection,
      planos: plainDetailSelection == null ? '' : plainDetailSelection,
      tipos: typeSelection == null ? '' : typeSelection,
      fichas: _detecta,
      aplica: _aplica == '' ? '' : _aplica.substring(1),
      atribuible: _atribuible == '' ? '' : _atribuible.substring(1),
      estatus: status,
      offset: 0,
      nextrows: 10,
    );
    ipBloc.add(FetchNoCompliantOutputPaginator(
        bandeja: _params.bandeja,
        ids: _params.ids,
        contratos: _params.contratos,
        obras: _params.obras,
        planos: _params.planos,
        tipos: _params.tipos,
        fichas: _params.fichas,
        aplica: _params.aplica,
        atribuible: _params.atribuible,
        estatus: _params.estatus,
        offset: _params.offset,
        nextrows: _params.nextrows));
    // return ListOfOutputs(
    //           params: _params,
    //         );
  }

  Future<List<SelectDropDownModel>> getSNCIds({name}) async {
    final _ncoRepository = NonCompliantOutputRepository();
    List<SelectDropDownModel> list = await _ncoRepository.fetchConsecutiveSNC(
        bandeja: userPermissionModel.nonCompliantOutPutTrayFilters ? 1 : 2,
        id: name);

    return list;
  }

  Future<List<SelectDropDownModel>> getSNCDetecta({name}) async {
    final _ncoRepository = NonCompliantOutputRepository();
    List<SelectDropDownModel> list = await _ncoRepository.fetchDetecsSNC(
        bandeja: userPermissionModel.nonCompliantOutPutTrayFilters ? 1 : 2,
        nombre: name);

    return list;
  }
}

class ModelExample {
  String name;
  int age;

  ModelExample({
    this.name,
    this.age,
  });

  factory ModelExample.fromJson(Map<String, dynamic> json) => ModelExample(
        name: json["Name"],
        age: json["Age"],
      );

  //Parse a WeldingControlModel object into a POJO object
  Map<String, dynamic> toJson() => {
        "Name": name,
        "Age": age,
      };
}

class DTSSalidaNoConforme extends DataTableSource {
  RptNonCompliantOutputBloc rptNonCompliantOutputBloc;
  UserPermissionModel _userPermissionModel;
  final List<NonCompliantOutputPaginatorModel> _list;
  BuildContext context;
  NonCompliantOutputParams params;

  DTSSalidaNoConforme(
      this._list,
      this.context,
      this.params,
      this._userPermissionModel,
      this.rptNonCompliantOutputBloc); //, this.inspectionPlanHeaderModel,this.inspectionPlanParams

  @override
  DataRow getRow(int index) {
    final element = _list[index];

    return DataRow.byIndex(
      selected: element.selected,
      onSelectChanged: (bool selected) {
        element.selected = selected;

        showAlertDialog(
          context,
          element,
          params,
        );
        element.selected = false;
        notifyListeners();
      },
      index: index,
      cells: <DataCell>[
        DataCell(Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Container(
              width: 20.0,
              height: 20.0,
              decoration: new BoxDecoration(
                color: element.semaforo == 'gris'
                    ? Colors.black38
                    : (element.semaforo == 'azul')
                        ? Color(0xFF618DB4)
                        : (element.semaforo == 'amarillo')
                            ? Colors.amber
                            : (element.semaforo == 'rojo')
                                ? Colors.red
                                : (element.semaforo == 'verde')
                                    ? Color(0xFF77BC1F)
                                    : Colors.white,
                shape: BoxShape.circle,
              ),
            ))), //Extracting from Map element the value
        DataCell(
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Text(element.consecutivo == null ? '' : element.consecutivo),
          ),
        ), //Extracting from Map element the value
        DataCell(Padding(
            padding: EdgeInsets.only(right: 20.0), child: Text(element.tipo))),
        DataCell(Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Text(element.contrato),
        )),
        DataCell(Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Text(element.ot),
        )),
        DataCell(Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Text(element.detecta),
        )),
        DataCell(Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Text(element.plano),
        )),
        DataCell(Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Text(element.aplica),
        )),
        DataCell(Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Text(element.atribuible),
        )),
        DataCell(Tooltip(
          child: Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Text(element.descripcionActividad),
          ),
          message: element.descripcionActividad,
        )),
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
    NonCompliantOutputPaginatorModel inspectionPlanDModel,
    NonCompliantOutputParams params,
  ) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: flatButton(Colors.white, Icons.auto_awesome_mosaic, 'Acciones',
          Colors.black, () {}),
      content: Container(
        height: 130,
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(left: 150, right: 150),
            //   child: Text(
            //     "¿Qué acción desea realizar?",
            //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   ),
            // ),
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _actions(inspectionPlanDModel),
                ))
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

  List<Widget> _actions(NonCompliantOutputPaginatorModel inspectionPlanDModel) {
    List<Widget> _acciones = [];
    if (_userPermissionModel.nonCompliantOutPutSNC) {
      _acciones.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.orange[700],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
          child: Row(
            children: [
              Icon(Icons.remove_red_eye_outlined,
                  color: Colors.white, size: 26.0),
            ],
          ),
          onPressed: () {
            _navigateToWeldingDetail(inspectionPlanDModel, params, true);
          },
        ),
      );
    }

    if (_userPermissionModel.nonCompliantOutPutDD) {
      if (_acciones.length > 0)
        _acciones.add(
          SizedBox(width: 10.0),
        );

      _acciones.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.orange[700],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
          child: Row(
            children: [
              Icon(Icons.picture_in_picture_outlined,
                  color: Colors.white, size: 26.0),
            ],
          ),
          onPressed: () {
            _navigateToDisposition(inspectionPlanDModel, params);
          },
        ),
      );
    }

    if (_userPermissionModel.nonCompliantOutPutPrint &&
        (inspectionPlanDModel.estatus == 'D/N' ||
            inspectionPlanDModel.estatus == 'F/N' ||
            inspectionPlanDModel.estatus == 'N/A')) {
      if (_acciones.length > 0)
        _acciones.add(
          SizedBox(width: 10.0),
        );

      _acciones.add(
       ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.teal,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
          child: Row(
            children: [
              Icon(Icons.print_outlined, color: Colors.white, size: 26.0),
            ],
          ),
          onPressed: () {
            Navigator.pop(context);
            rptNonCompliantOutputBloc.add(GetRptNonCompliantOutput(
                salidaNoConformeId: inspectionPlanDModel.salidaNoConformeId));
          },
        ),
      );
    }

    if (_userPermissionModel.nonCompliantOutPutUpload &&
        (inspectionPlanDModel.estatus == 'D/N' ||
            inspectionPlanDModel.estatus == 'F/N' ||
            inspectionPlanDModel.estatus == 'N/A')) {
      if (_acciones.length > 0)
        _acciones.add(
          SizedBox(width: 10.0),
        );

      _acciones.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.teal,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
          child: Row(
            children: [
              Icon(Icons.upload_file, color: Colors.white, size: 26.0),
              Text(inspectionPlanDModel.totalDocumentos.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          onPressed: () {
            NonCompliantOutputModel sncModel = NonCompliantOutputModel(
                salidaNoConformeId: inspectionPlanDModel.salidaNoConformeId,
                consecutivo: inspectionPlanDModel.consecutivo);
            Navigator.pop(context);
            _navigateToDetails(sncModel, params);
          },
        ),
      );
    }

    return _acciones;
  }

  Future _navigateToDetails(
      NonCompliantOutputModel sncModel, NonCompliantOutputParams filters) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadFilesSNC(
          sncModel: sncModel,
          filters: filters,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Future _navigateToWeldingDetail(
      NonCompliantOutputPaginatorModel inspectionPlanDModel,
      NonCompliantOutputParams filters,
      bool closeModal) {
    if (closeModal) Navigator.pop(context);

    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterSNC(
          params: inspectionPlanDModel,
          filters: filters,
        ),
      ),
    );
  }

  Future _navigateToDisposition(
      NonCompliantOutputPaginatorModel inspectionPlanDModel,
      NonCompliantOutputParams filters) {
    Navigator.pop(context);
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DispositionSNC(
          params: inspectionPlanDModel,
          filters: filters,
        ),
      ),
    );
  }
}
