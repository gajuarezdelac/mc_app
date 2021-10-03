// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:mc_app/src/bloc/non_compliant_output/bloc.dart';
// import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_bloc.dart';
// import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_event.dart';
// import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_state.dart';
// import 'package:mc_app/src/models/inspection_plan_model.dart';
// import 'package:mc_app/src/models/non_compliant_output_model.dart';
// import 'package:mc_app/src/models/non_compliant_output_paginator_model.dart';
// import 'package:mc_app/src/models/params/non_compliant_output_params.dart';
// import 'package:mc_app/src/models/plain_detail_dropdown_model.dart';
// import 'package:mc_app/src/models/work_dropdown_model.dart';
// import 'package:mc_app/src/utils/always_disabled_focus_node.dart';
// import 'package:mc_app/src/widgets/dropdown.dart';
// import 'package:mc_app/src/widgets/flat_button.dart';
// import 'package:mc_app/src/widgets/text.dart';
// import 'package:mc_app/src/widgets/text_field.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mc_app/src/bloc/blocs.dart';
// import 'package:mc_app/src/models/contract_model.dart';
// import 'package:mc_app/src/widgets/loading_circular.dart';
// import 'package:mc_app/src/utils/responsive.dart';
// import 'package:mc_app/src/widgets/table_initial_snc.dart';

// class Filters extends StatefulWidget {
//   final Function selectDate;
//   final NonCompliantOutputParams params;

//   const Filters({Key key, this.selectDate, this.params}) : super(key: key);

//   @override
//   _FiltersState createState() => _FiltersState();
// }

// class _FiltersState extends State<Filters> {
//   final prefabricado = false;
//   String workSelection;
//   String contractSelection;
//   String plainDetailSelection;
//   String typeSelection;
//   DTSSalidaNoConforme dtsSNC;
//   PaginatorSNCBloc ipBloc;

  
//   @override
//   void initState() {
//     super.initState();
//     initialData();
//   }

//   void initialData() {
//     // activitiesInspectionPlanBloc =
//     //     BlocProvider.of<ActivitiesInspectionPlanBloc>(context);
//     ipBloc = BlocProvider.of<PaginatorSNCBloc>(context);
//     // activitiesInspectionPlanBloc.add(GetHeaderInspectionPlan(
//     //     noInspectionPlan: widget.params.inspectionPlanCModel.noPlanInspeccion));
//     ipBloc.add(FetchNoCompliantOutputPaginator(bandeja: widget.params.bandeja, ids: widget.params.ids,
//     contratos: widget.params.contratos, obras: widget.params.obras, planos: widget.params.planos,
//     tipos: widget.params.tipos, fichas: widget.params.fichas, aplica: widget.params.aplica,
//     atribuible: widget.params.atribuible, estatus: widget.params.estatus,
//     offset: widget.params.offset, nextrows: widget.params.nextrows));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Responsive responsive = Responsive.of(context);
//     // NonCompliantOutputBloc _ncoBloc;
//     // _ncoBloc = BlocProvider.of<NonCompliantOutputBloc>(context);
//     WorksSNCOutputBloc _ncoWorksBloc;
//     _ncoWorksBloc = BlocProvider.of<WorksSNCOutputBloc>(context);
//     ContractsSNCOutputBloc _ncoContractsBloc;
//     _ncoContractsBloc = BlocProvider.of<ContractsSNCOutputBloc>(context);
//     TypeSNCOutputBloc _ncoTypeBloc;
//     _ncoTypeBloc = BlocProvider.of<TypeSNCOutputBloc>(context);
//     PlainDetailSNCBloc _ncoPlainDetailoc;
//     _ncoPlainDetailoc = BlocProvider.of<PlainDetailSNCBloc>(context);

//     _ncoContractsBloc.add(FetchContractsSNC(
//       bandeja: 1,
//     ));
//     _ncoWorksBloc.add(FetchWorksSNC(
//       bandeja: 1,
//     ));
//     _ncoPlainDetailoc.add(FetchPlainDetailSNC(
//       bandeja: 1,
//     ));
//     _ncoTypeBloc.add(FetchTypeSNC(
//       bandeja: 1,
//     ));


//  return GestureDetector(
//                 child: SingleChildScrollView(
//                     child: MultiBlocListener(
//               listeners: [listenerDates()],
//               child: Container(
//                 width: double.infinity,
//                 height: responsive.height,
//                 child: ListView(
//                   children: <Widget>[
//                     Card(
//       // elevation: 5.0,
//       // shape: RoundedRectangleBorder(
//       //   borderRadius: BorderRadius.circular(5.0),
//       // ),
//       child: Container(
//         padding: EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 textField('SNC:', 'Ingrese el SNC'),
//                 SizedBox(width: 10.0),
//                 BlocBuilder<ContractsSNCOutputBloc, ContractsSNCState>(
//                   builder: (context, state) {
//                     if (state is SuccessContractsSNC) {
//                       return dropDown('Contrato', 'Seleccionar',
//                           value: contractSelection,
//                           items: state.contractModelList
//                               .map((ContractDropdownModelSNC contract) {
//                             return DropdownMenuItem(
//                               value: contract.contratoId,
//                               child: Text(
//                                 '${contract.contratoId} - ${contract.nombre}',
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               //onTap: () => _contract = contract,
//                             );
//                           }).toList(), onChangeEvent: (value) {
//                         setState(() {
//                           contractSelection = value;
//                         });
//                       });
//                     } else if (state is ErrorContractsSNC) {
//                       return dropDown(
//                         'Contrato',
//                         'Seleccionar',
//                       );
//                     }
//                     return loadingCircular();
//                   },
//                 ),
//                 SizedBox(width: 10.0),
//                 BlocBuilder<WorksSNCOutputBloc, WorksSNCState>(
//                   builder: (context, state) {
//                     if (state is SuccessWorksSNC) {
//                       return dropDown('Obra', 'Seleccionar',
//                           value: workSelection,
//                           items: state.works.map((WorkDropDownModelSNC work) {
//                             return DropdownMenuItem(
//                               value: work.obraId,
//                               child: Text(
//                                 '${work.obraId} - ${work.nombre}',
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               //onTap: () => _contract = contract,
//                             );
//                           }).toList(), onChangeEvent: (value) {
//                         setState(() {
//                           workSelection = value;
//                         });
//                       });
//                     } else if (state is ErrorWorksSNC) {
//                       return dropDown(
//                         'Obra',
//                         'Seleccionar',
//                       );
//                     }
//                     return loadingCircular();
//                   },
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.0),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 BlocBuilder<PlainDetailSNCBloc, PlainDetailSNCState>(
//                   builder: (context, state) {
//                     if (state is SuccessPlainDetailSNC) {
//                       return dropDown('Plano Detalle', 'Seleccionar',
//                           value: plainDetailSelection,
//                           items: state.plainDetailDDModelList
//                               .map((PlainDetailDropDownModelSNC plainDetail) {
//                             return DropdownMenuItem(
//                               value: plainDetail.planoDetalleId,
//                               child: Text(
//                                 '${plainDetail.numeroPlano}',
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               //onTap: () => _contract = contract,
//                             );
//                           }).toList(), onChangeEvent: (value) {
//                         setState(() {
//                           plainDetailSelection = value;
//                         });
//                       });
//                     } else if (state is ErrorPlainDetailSNC) {
//                       return dropDown(
//                         'Plano Detalle',
//                         'Seleccionar',
//                       );
//                     }
//                     return loadingCircular();
//                   },
//                 ),
//                 SizedBox(width: 10.0),
//                 BlocBuilder<TypeSNCOutputBloc, TypeSNCState>(
//                   builder: (context, state) {
//                     if (state is SuccessTypeSNC) {
//                       return dropDown('Tipo', 'Seleccionar',
//                           value: typeSelection,
//                           items: state.typeSNCList.map((TypeModelSNC type) {
//                             return DropdownMenuItem(
//                               value: type.tipo,
//                               child: Text(
//                                 '${type.tipo}',
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               //onTap: () => _contract = contract,
//                             );
//                           }).toList(), onChangeEvent: (value) {
//                         setState(() {
//                           typeSelection = value;
//                         });
//                       });
//                     } else if (state is ErrorTypeSNC) {
//                       return dropDown(
//                         'Type',
//                         'Seleccionar',
//                       );
//                     }
//                     return loadingCircular();
//                   },
//                 ),
//                 SizedBox(width: 10.0),
//                 textField(
//                   'Detecta:',
//                   'Seleccione',
//                   focusNode: AlwaysDisabledFocusNode(),
//                   onTapEvent: widget.selectDate,
//                 ),
//               ],
//             ),
//             SizedBox(height: 15.0),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               // mainAxisSize: MainAxisSize.min,
//               children: [
//                 Expanded(
//                     child: Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(
//                           top: 5.0,
//                           left: 5.0,
//                         ),
//                         child: Text("Aplica A:"),
//                       ),
//                       Row(
//                         children: [
//                           Checkbox(
//                             checkColor: Colors.white,
//                             activeColor: Colors.blue,
//                             value: this.prefabricado,
//                             onChanged: (bool value) {
//                               //setState(() {
//                               // this.prefabricado = value;
//                               // validatorCheckEtapa = value;
//                               //});
//                               //changeUpdateParams();
//                             },
//                           ),
//                           Text('PREFABRICADO',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                               )),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Checkbox(
//                             checkColor: Colors.white,
//                             activeColor: Colors.blue,
//                             value: this.prefabricado,
//                             onChanged: (bool value) {
//                               //setState(() {
//                               // this.prefabricado = value;
//                               // validatorCheckEtapa = value;
//                               //});
//                               //changeUpdateParams();
//                             },
//                           ),
//                           Text('INSTALACIÓN',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                               )),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Checkbox(
//                             checkColor: Colors.white,
//                             activeColor: Colors.blue,
//                             value: this.prefabricado,
//                             onChanged: (bool value) {
//                               //setState(() {
//                               // this.prefabricado = value;
//                               // validatorCheckEtapa = value;
//                               //});
//                               //changeUpdateParams();
//                             },
//                           ),
//                           Text('SERVICIO',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                               )),
//                         ],
//                       ),
//                     ],
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(
//                       color: Colors.grey,
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 )),
//                 SizedBox(width: 10.0),
//                 Expanded(
//                     child: Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(
//                           top: 5.0,
//                           left: 5.0,
//                         ),
//                         child: Text("Atribuible A:"),
//                       ),
//                       Row(
//                         children: [
//                           Checkbox(
//                             checkColor: Colors.white,
//                             activeColor: Colors.blue,
//                             value: this.prefabricado,
//                             onChanged: (bool value) {
//                               //setState(() {
//                               // this.prefabricado = value;
//                               // validatorCheckEtapa = value;
//                               //});
//                               //changeUpdateParams();
//                             },
//                           ),
//                           Text('COTEMAR',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                               )),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Checkbox(
//                             checkColor: Colors.white,
//                             activeColor: Colors.blue,
//                             value: this.prefabricado,
//                             onChanged: (bool value) {
//                               //setState(() {
//                               // this.prefabricado = value;
//                               // validatorCheckEtapa = value;
//                               //});
//                               //changeUpdateParams();
//                             },
//                           ),
//                           Text('CLIENTE',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                               )),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Checkbox(
//                             checkColor: Colors.white,
//                             activeColor: Colors.blue,
//                             value: this.prefabricado,
//                             onChanged: (bool value) {
//                               //setState(() {
//                               // this.prefabricado = value;
//                               // validatorCheckEtapa = value;
//                               //});
//                               //changeUpdateParams();
//                             },
//                           ),
//                           Text('SUBCONTRATISTA',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                               )),
//                         ],
//                       ),
//                     ],
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(
//                       color: Colors.grey,
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 )),
//                 SizedBox(width: 10.0),
//                 Expanded(
//                     child: Container(
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           flatButton(
//                             Colors.blue,
//                             Icons.search,
//                             'Buscar',
//                             Colors.white,
//                             () {},
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 )),
//               ],
//             ),
//             SizedBox(height:20.0),
//                                            Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 //Expanded(child:
//                 SizedBox(
//                   height: 40.0,
//                   child: InkWell(
//                     onTap: () {
//                       // _showSnackBar(context, 'CONFORMADO');
//                       // _changeColor(Color(0xFF768591));
//                     }, // Handle your callback
//                     child: _inkDetail(Colors.black38, 'Sin registro'),
//                   ),
//                 ),

//                 //),
//                 SizedBox(
//                   height: 40.0,
//                   child: InkWell(
//                     onTap: () {
//                       // _showSnackBar(context, 'REALIZAR_REPARAR');
//                       // _changeColor(Color(0xFF425363));
//                     }, // Handle your callback
//                     child: _inkDetail(Color(0xFF618DB4), 'Pendiente'),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 40.0,
//                   child: InkWell(
//                     onTap: () {
//                       // _showSnackBar(context, 'INSPECCION_SOLDADURA');
//                       // _changeColor(Color(0xFF618DB4));
//                     }, // Handle your callback
//                     child: _inkDetail(Colors.amber, 'Proceso'),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 40.0,
//                   child: InkWell(
//                     onTap: () {
//                       // _showSnackBar(context, 'PND');
//                       // _changeColor(Color(0xFFFF5000));
//                     }, // Handle your callback
//                     child: _inkDetail(Colors.red, 'F/N'),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 40.0,
//                   child: InkWell(
//                     onTap: () {
//                       // _showSnackBar(context, 'LIBERADA');
//                       // _changeColor(Color(0xFF77BC1F));
//                     }, // Handle your callback
//                     child: _inkDetail(Color(0xFF77BC1F), 'D/N'),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 15.0),
//             Padding(
//                               padding: EdgeInsets.only(bottom: 20),
//                               child: BlocBuilder<PaginatorSNCBloc,
//                                   NonCompliantOutputPaginatorState>(
//                                 builder: (context, state) {
//                                   if (state is SuccessNonCompliantOutputPaginator) {
//                                     dtsSNC = DTSSalidaNoConforme(
//                         state.ncoPaginatorModelList,
//                         context,
//                         // _relateJointBloc,
//                         //widget.params,
//                         //_initialDataJoint
//                       );
//                                     // dtsActividadesIP = DTSSalidaNoConforme(
//                                     //     state.inspectionPlanDModel,
//                                     //     context,
//                                     //     inspectionPlanHeaderModel,
//                                     //     widget.params);
//                                     return PaginatedDataTable(
//                                       rowsPerPage: 5,
//                                       showCheckboxColumn: false,
//                                       header: Text('Servicio No Conforme'),
//                                       source: dtsSNC ?? [],
//                                       columns: [
//                                         DataColumn(
//                                             label: Text('',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold))),
//                                         DataColumn(
//                                             label: Text('SNC',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold))),
//                                         DataColumn(
//                                             label: Text('Tipo SNC',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold))),
//                                         DataColumn(
//                                             label: Text('Contrato',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold))),
//                                         DataColumn(
//                                             label: Text('Obra',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold))),
//                                         DataColumn(
//                                             label: Text('Detecta',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold))),
//                                         DataColumn(
//                                             label: Text('Plano Detalle',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold))),
//                                         DataColumn(
//                                             label: Text('Aplica A:',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold))),
//                                         DataColumn(
//                                             label: Text('Atribuible A:',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold))),
//                                         DataColumn(
//                                             label: Text(
//                                                 'Descripción de la actividad',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold))),
//                                         // DataColumn(
//                                         //     label: Text('Acción',
//                                         //         style: TextStyle(
//                                         //             fontWeight:
//                                         //                 FontWeight.bold))),
//                                       ],
//                                     );
//                                   } else if (state
//                                       is IsLoadingNonCompliantOutputPaginatorState) {
//                                     return Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                             padding: EdgeInsets.fromLTRB(
//                                                 0, 50, 0, 0),
//                                             child: Center(
//                                               child: spinkit,
//                                             )),
//                                       ],
//                                     );
//                                   } else if (state is ErrorNonCompliantOutputPaginator) {
//                                     return Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Center(
//                                             child: Text(
//                                                 'Parece que ha ocurrido un error')),
//                                       ],
//                                     );
//                                   }
//                                   return TableInitialSNC();
//                                 },
//                               ),
//                             ),
//           ],
//         ),
//       ),
//     ),
//                   ],
//                 ),
//               ),
//             )));
//   }

// final spinkit = SpinKitFadingCircle(
//     itemBuilder: (BuildContext context, int index) {
//       return DecoratedBox(
//         decoration: BoxDecoration(color: Colors.black),
//       );
//     },
//   );

//   BlocListener listenerDates() {
//     return BlocListener<ListMaterialsBloc, ListMaterialsState>(
//         listener: (context, state) {
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();

//       if (state is IsLoadingUpdateReporteIP) {
//         return loadingCircular();
//       } else if (state is SuccessUpdateReporteIP) {
//         ipBloc.add(FetchNoCompliantOutputPaginator(bandeja: widget.params.bandeja, ids: widget.params.ids,
//     contratos: widget.params.contratos, obras: widget.params.obras, planos: widget.params.planos,
//     tipos: widget.params.tipos, fichas: widget.params.fichas, aplica: widget.params.aplica,
//     atribuible: widget.params.atribuible, estatus: widget.params.estatus,
//     offset: widget.params.offset, nextrows: widget.params.nextrows));
//       } else if (state is ErrorUpdateReporteIP) {
//         Navigator.pop(context);
//       }
//     });
//   }

//   Widget _inkDetail(Color color, String text) {
//     return Ink(
//       height: 100,
//       width: 100,
//       color: color,
//       child: Center(
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DTSSalidaNoConforme extends DataTableSource {
//   final List<NonCompliantOutputPaginatorModel> _list;
//   BuildContext context;
//   // InspectionPlanHeaderModel inspectionPlanHeaderModel;
//   // InspectionPlanParams inspectionPlanParams;

//   DTSSalidaNoConforme(this._list, this.context);//, this.inspectionPlanHeaderModel,this.inspectionPlanParams

//   @override
//   DataRow getRow(int index) {
//     final element = _list[index];

//     return DataRow.byIndex(
//       //selected: element.selected,
//       // onSelectChanged: (bool selected) {
//       //   element.selected = selected;

//       //   showAlertDialog(context, element);
//       //   element.selected = false;
//       //   notifyListeners();
//       // },
//       index: index,
//       cells: <DataCell>[
//         DataCell(Container(
//           width: 20.0,
//           height: 20.0,
//           decoration: new BoxDecoration(
//             color: element.semaforo == 'gris'
//                 ? Colors.black38
//                 : (element.semaforo == 'azul')
//                     ? Color(0xFF618DB4)
//                     : (element.semaforo == 'amarillo')
//                         ? Colors.amber
//                         : (element.semaforo == 'rojo')
//                             ? Colors.red
//                             : (element.semaforo == 'verde')
//                             ? Color(0xFF77BC1F)
//                             : Colors.white,
//             shape: BoxShape.circle,
//           ),
//         )), //Extracting from Map element the value
//         DataCell(Text(element.salidaNoConformeId)), //Extracting from Map element the value
//         DataCell(Text(element.tipo)),
//         DataCell(Text(element.contrato)),
//         DataCell(Text(element.ot)),
//         DataCell(Text(element.detecta)),
//         DataCell(Text(element.plano)),
//         DataCell(Text(element.aplica)),
//         DataCell(Text(element.atribuible)),
//         DataCell(Text(element.descripcionActividad)),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => _list.length ?? 0;

//   @override
//   int get selectedRowCount => 0;

//   showAlertDialog(
//     BuildContext context,
//     InspectionPlanDModel inspectionPlanDModel,
//   ) {
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       title: flatButton(Colors.white, Icons.auto_awesome_mosaic, 'Acciones',
//           Colors.black, () {}),
//       content: Container(
//         height: 130,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 150, right: 150),
//               child: Text(
//                 "¿Qué acción desea realizar?",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 30),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   RaisedButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5.0)),
//                     color: Colors.orange[700],
//                     child: Row(
//                       children: [
//                         Icon(Icons.dashboard_customize,
//                             color: Colors.white, size: 26.0),
//                         SizedBox(width: 10.0),
//                         Text(
//                           'Rev. Actividades',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     onPressed: () {
//                       //_navigateToWeldingDetail(inspectionPlanDModel);
//                     },
//                   ),
//                   RaisedButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5.0)),
//                     color: Colors.teal,
//                     child: Row(
//                       children: [
//                         Icon(Icons.print_outlined,
//                             color: Colors.white, size: 26.0),
//                         SizedBox(width: 10.0),
//                         Text(
//                           'Generar Reporte',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   // Future _navigateToWeldingDetail(InspectionPlanDModel inspectionPlanDModel) {
//   //   RegisterInspectionPlanParams _params;
//   //   // = RegisterInspectionPlanParams(
//   //   //     inspectionPlanDModel: inspectionPlanDModel,
//   //   //     inspectionPlanHeaderModel: inspectionPlanHeaderModel,
//   //   //     inspectionPlanParams: inspectionPlanParams);

//   //   Navigator.pop(context);
//   //   return Navigator.push(
//   //     context,
//   //     MaterialPageRoute(
//   //       builder: (context) => RegisterInspectionPlan(params: _params),
//   //     ),
//   //   );
//   // }
  

// }
