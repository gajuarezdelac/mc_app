import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/models/params/add_welder_parms.dart';
import 'package:mc_app/src/models/params/get_information_welder_Param.dart';
import 'package:mc_app/src/models/params/inspection_plan_params.dart';
import 'package:mc_app/src/models/params/photographic_evidence_params_model.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';
import 'package:mc_app/src/pages/detail_photographic_screen.dart';
import 'package:mc_app/src/utils/dialogs.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:mc_app/src/widgets/column_box.dart';
import 'package:mc_app/src/widgets/content_modal.dart';
import 'package:mc_app/src/widgets/flat_button.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/photographic_card.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';
import 'package:mc_app/src/widgets/spinkit.dart';
import 'package:mime/mime.dart';
import 'package:strings/strings.dart';
import 'package:path/path.dart' as path;

class RegisterInspectionPlan extends StatefulWidget {
  final RegisterInspectionPlanParams params;

  RegisterInspectionPlan({Key key, this.params}) : super(key: key);

  static String id = "Registro de Inspección de Actividades";

  @override
  _RegisterInspectionPlanState createState() => _RegisterInspectionPlanState();
}

class _RegisterInspectionPlanState extends State<RegisterInspectionPlan> {
  ListMaterialsBloc listMaterialsBloc;
  WelderPlanBloc welderPlanBloc;

  List<ReporteInspeccionMaterialModel> listReporteIM = [];
  final _observacionesFNOrDNController = TextEditingController();
  final addWelder = TextEditingController();

  final firtTrazability = TextEditingController();
  final secondTrazability = TextEditingController();
  final threeTrazability = TextEditingController();
  final fortyTrazability = TextEditingController();

  EvidencePhotographicIPBloc _evidencePhotographicIPBloc;

  List<PhotographicEvidenceIPModel> lstPhothosTem = [];
  List<PhotographicEvidenceIPModel> lstPhothosTemEliminados = [];
  List<PhotographicEvidenceIPModel> lstPhothosWEBEliminados = [];
  List<PhotographicEvidenceIPModel> lstPhothosTemAdd = [];

  List<InformacionadicionalModel> informationAditional = [];
  FetchWelderModel informationWelder;
  ScrollController _controller;

  bool newWidget = false;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener); //the listener for up and down.
    super.initState();
    initialData();
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
    listMaterialsBloc = BlocProvider.of<ListMaterialsBloc>(context);
    welderPlanBloc = BlocProvider.of<WelderPlanBloc>(context);
    listMaterialsBloc.add(GetTableMaterials(
      noPlanInspeccion: widget
          .params.inspectionPlanParams.inspectionPlanCModel.noPlanInspeccion,
      siteId: widget.params.inspectionPlanDModel.siteId,
      propuestaTecnicaId: widget.params.inspectionPlanDModel.propuestaTecnicaId,
      actividadId: widget.params.inspectionPlanDModel.actividadId,
      subActividadId: widget.params.inspectionPlanDModel.subActividadId,
      reprogramacionOTId: widget.params.inspectionPlanDModel.reprogramacionOTId,
    ));
    _evidencePhotographicIPBloc =
        BlocProvider.of<EvidencePhotographicIPBloc>(context);

    loadPhotographicFN(true);

    welderPlanBloc.add(GetInformacionadicionalEvent(
        params: GetInformationWelderParam(
            noPlanInspeccion: widget.params.inspectionPlanParams
                .inspectionPlanCModel.noPlanInspeccion,
            actividadId: widget.params.inspectionPlanDModel.actividadId,
            propuestaTecnicaId:
                widget.params.inspectionPlanDModel.propuestaTecnicaId,
            reprogramacionOTId:
                widget.params.inspectionPlanDModel.reprogramacionOTId,
            siteId: widget.params.inspectionPlanDModel.siteId,
            subActividadId:
                widget.params.inspectionPlanDModel.subActividadId)));
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Inspección de Actividades"),
      ),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: BlocConsumer<ListMaterialsBloc, ListMaterialsState>(
            listener: (context, state) {
              if (state is SuccessListMaterials) {
                listReporteIM = state.list;
              } else if (state is IsLoadingListMaterials) {
                return loadingCircular();
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: responsive.height,
                  child: ListView(
                    children: <Widget>[
                      contentRegister(),
                      SizedBox(height: 200)
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget contentRegister() {
    return MultiBlocListener(
        listeners: [listenerDates(), welderPlanBlocListernet()],
        child: Column(
          children: <Widget>[
            informationActivity(),
            headerPrincipal(),
            tableMaterials(),
            sectionInformationAditional(),
          ],
        ));
  }

  // Información de la actividad(Description)
  Widget informationActivity() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 2),
      child: Card(
          elevation: 4.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Container(
            alignment: Alignment.centerRight,
            padding:
                EdgeInsets.only(top: 8.0, bottom: 8.0, left: 20, right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: Column(children: <Widget>[
                      ColumnBox(
                        titlePrincipal: 'Descripción de la actividad:',
                        information:
                            '${widget.params.inspectionPlanDModel.descripcionActividad}',
                      )
                    ])),
              ],
            ),
          )),
    );
  }

  Widget headerPrincipal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: headerInformationActivity()),
        Expanded(child: headerProcedimiento()),
      ],
    );
  }

  // Seccion información general
  Widget headerInformationActivity() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 8),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          alignment: Alignment.centerLeft,
          padding:
              EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20, right: 25),
          child: Column(
            children: <Widget>[
              ColumnBox(
                titlePrincipal: 'Folio:',
                information:
                    '${widget.params.inspectionPlanParams.worksInspectionPlanModel.oT}',
              ),
              SizedBox(
                height: 5,
              ),
              ColumnBox(
                titlePrincipal: 'Frente:',
                information: '${widget.params.inspectionPlanDModel.frente}',
              ),
              SizedBox(
                height: 5,
              ),
              ColumnBox(
                titlePrincipal: 'Especialidad:',
                information: camelize(
                    '${widget.params.inspectionPlanDModel.especialidad}'),
              ),
              SizedBox(
                height: 5,
              ),
              ColumnBox(
                titlePrincipal: 'Sistema:',
                information:
                    camelize('${widget.params.inspectionPlanDModel.sistema}'),
              ),
              SizedBox(
                height: 5,
              ),
              ColumnBox(
                titlePrincipal: 'Plano',
                information:
                    camelize('${widget.params.inspectionPlanDModel.plano}'),
              ),
              SizedBox(
                height: 5,
              ),
              ColumnBox(
                titlePrincipal: 'Procedimiento o Documento Referencia:',
                information:
                    '${widget.params.inspectionPlanDModel.procedimientos}',
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Seccion informativa detallada
  Widget headerProcedimiento() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 1, right: 8, bottom: 8),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20, right: 5, top: 10, bottom: 10),
          child: Column(
            children: <Widget>[
              ColumnBox(
                titlePrincipal: 'Instalación: ',
                information:
                    '${widget.params.inspectionPlanHeaderModel.instalacion}',
              ),
              SizedBox(
                height: 5,
              ),
              ColumnBox(
                titlePrincipal: 'Embarcación:',
                information:
                    '${widget.params.inspectionPlanHeaderModel.embarcacion}',
              ),
              SizedBox(
                height: 5,
              ),
              ColumnBox(
                titlePrincipal: 'No. de Plan:',
                information:
                    '${widget.params.inspectionPlanParams.inspectionPlanCModel.noPlanInspeccion}',
              ),
              SizedBox(
                height: 5,
              ),
              ColumnBox(
                titlePrincipal: 'Contrato:',
                information:
                    '${widget.params.inspectionPlanParams.contractSelection}',
              ),
              SizedBox(
                height: 5,
              ),
              ColumnBox(
                titlePrincipal: 'Obra:',
                information:
                    '${widget.params.inspectionPlanParams.worksInspectionPlanModel.oT} (${widget.params.inspectionPlanParams.worksInspectionPlanModel.obraId})',
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tableMaterials() {
    return BlocBuilder<ListMaterialsBloc, ListMaterialsState>(
        builder: (context, state) {
      if (state is SuccessListMaterials) {
        return Padding(
          padding: const EdgeInsets.only(top: 6, left: 8, right: 10, bottom: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Container(
                child: DataTable(
                  rows:
                      listReporteIM // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((element) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(element
                                        .materialId)), //Extracting from Map element the value
                                    DataCell(Text(element.descripcion)),
                                    DataCell(Text(element.idTrazabilidad)),
                                    DataCell(Text(element
                                        .uM)), //Extracting from Map element the value
                                    DataCell(Text(
                                        element.cantidad.toStringAsFixed(2))),
                                    DataCell(
                                      element.resultado == 1
                                          ? Container(
                                              width: 150,
                                              child: InkWell(
                                                  onTap: () {
                                                    _showWeldingFNOrDNModal(
                                                        'DN',
                                                        1,
                                                        true,
                                                        element.observaciones,
                                                        '${widget.params.inspectionPlanParams.inspectionPlanCModel.noPlanInspeccion}',
                                                        element.siteId,
                                                        widget
                                                            .params
                                                            .inspectionPlanDModel
                                                            .propuestaTecnicaId,
                                                        widget
                                                            .params
                                                            .inspectionPlanDModel
                                                            .actividadId,
                                                        widget
                                                            .params
                                                            .inspectionPlanDModel
                                                            .subActividadId,
                                                        widget
                                                            .params
                                                            .inspectionPlanDModel
                                                            .reprogramacionOTId,
                                                        element.materialId,
                                                        element.idTrazabilidad,
                                                        1,
                                                        element.incluirReporte,
                                                        element.observaciones);
                                                  },
                                                  child: Ink(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5,
                                                        bottom: 5,
                                                      ),
                                                      color: Colors.green,
                                                      child: Text('DN',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          )))))
                                          : (element.resultado == 0)
                                              ? Container(
                                                  width: 150,
                                                  child: InkWell(
                                                      onTap: () {
                                                        _showWeldingFNOrDNModal(
                                                            'FN',
                                                            0,
                                                            true,
                                                            element
                                                                .observaciones,
                                                            '${widget.params.inspectionPlanParams.inspectionPlanCModel.noPlanInspeccion}',
                                                            element.siteId,
                                                            widget
                                                                .params
                                                                .inspectionPlanDModel
                                                                .propuestaTecnicaId,
                                                            widget
                                                                .params
                                                                .inspectionPlanDModel
                                                                .actividadId,
                                                            widget
                                                                .params
                                                                .inspectionPlanDModel
                                                                .subActividadId,
                                                            widget
                                                                .params
                                                                .inspectionPlanDModel
                                                                .reprogramacionOTId,
                                                            element.materialId,
                                                            element
                                                                .idTrazabilidad,
                                                            null,
                                                            element
                                                                .incluirReporte,
                                                            element
                                                                .observaciones);
                                                      },
                                                      child: Ink(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 5,
                                                            bottom: 5,
                                                          ),
                                                          color: Colors.red,
                                                          child: Text('FN',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              )))),
                                                )
                                              : Container(
                                                  width: 300,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: <Widget>[
                                                      InkWell(
                                                          onTap: () {
                                                            _showWeldingFNOrDNModal(
                                                                'ESPERA',
                                                                1,
                                                                false,
                                                                element
                                                                    .observaciones,
                                                                '${widget.params.inspectionPlanParams.inspectionPlanCModel.noPlanInspeccion}',
                                                                element.siteId,
                                                                widget
                                                                    .params
                                                                    .inspectionPlanDModel
                                                                    .propuestaTecnicaId,
                                                                widget
                                                                    .params
                                                                    .inspectionPlanDModel
                                                                    .actividadId,
                                                                widget
                                                                    .params
                                                                    .inspectionPlanDModel
                                                                    .subActividadId,
                                                                widget
                                                                    .params
                                                                    .inspectionPlanDModel
                                                                    .reprogramacionOTId,
                                                                element
                                                                    .materialId,
                                                                element
                                                                    .idTrazabilidad,
                                                                1,
                                                                element
                                                                    .incluirReporte,
                                                                element
                                                                    .observaciones);
                                                          },
                                                          child: Ink(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 30,
                                                                right: 30,
                                                                top: 5,
                                                                bottom: 5,
                                                              ),
                                                              color:
                                                                  Colors.green,
                                                              child: Text('DN',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  )))),
                                                      InkWell(
                                                          onTap: () {
                                                            _showWeldingFNOrDNModal(
                                                                'ESPERA',
                                                                0,
                                                                false,
                                                                element
                                                                    .observaciones,
                                                                '${widget.params.inspectionPlanParams.inspectionPlanCModel.noPlanInspeccion}',
                                                                element.siteId,
                                                                widget
                                                                    .params
                                                                    .inspectionPlanDModel
                                                                    .propuestaTecnicaId,
                                                                widget
                                                                    .params
                                                                    .inspectionPlanDModel
                                                                    .actividadId,
                                                                widget
                                                                    .params
                                                                    .inspectionPlanDModel
                                                                    .subActividadId,
                                                                widget
                                                                    .params
                                                                    .inspectionPlanDModel
                                                                    .reprogramacionOTId,
                                                                element
                                                                    .materialId,
                                                                element
                                                                    .idTrazabilidad,
                                                                0,
                                                                element
                                                                    .incluirReporte,
                                                                element
                                                                    .observaciones);
                                                          },
                                                          child: Ink(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 30,
                                                                right: 30,
                                                                top: 5,
                                                                bottom: 5,
                                                              ),
                                                              color: Colors.red,
                                                              child: Text('FN',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white))))
                                                    ],
                                                  ),
                                                ),
                                    ),
                                    DataCell(Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: Colors.blue,
                                        value: element.selected,
                                        onChanged: (bool value) {
                                          setState(() {
                                            element.selected = value;
                                          });
                                          includeReport(
                                              '${widget.params.inspectionPlanParams.inspectionPlanCModel.noPlanInspeccion}',
                                              element.siteId,
                                              widget.params.inspectionPlanDModel
                                                  .propuestaTecnicaId,
                                              widget.params.inspectionPlanDModel
                                                  .actividadId,
                                              widget.params.inspectionPlanDModel
                                                  .subActividadId,
                                              widget.params.inspectionPlanDModel
                                                  .reprogramacionOTId,
                                              element.materialId,
                                              element.idTrazabilidad,
                                              element.resultado,
                                              value ? 1 : 0,
                                              element.observaciones);
                                        })),
                                    DataCell(Text(
                                        element.fechaInspeccion.isEmpty
                                            ? "N/A"
                                            : DateFormat.yMd().add_jm().format(
                                                DateTime.parse(
                                                    element.fechaInspeccion)))),
                                  ],
                                )),
                          )
                          .toList(),
                  columns: const <DataColumn>[
                    DataColumn(
                        label: Text('C.SAP',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Descripción',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Trazabilidad	',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('UM',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Cant. Reportada',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Expanded(
                      child: Text('Resultado de inspección',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    )),
                    DataColumn(
                        label: Text('No incluir en RIA',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Fecha de inspección',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      if (state is IsLoadingListMaterials) {
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
      if (state is ErrorListMaterials) {
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

  void includeReport(
    String noPlanInspection,
    String siteId,
    dynamic propuestaTecnicaId,
    dynamic actividadId,
    dynamic subActividadId,
    dynamic reprogramacionOTId,
    String materialId,
    String idTrazabilidad,
    int resultado,
    int incluirReporte,
    String comentarios,
  ) {
    listMaterialsBloc.add(UpdateReporteIP(
        noPlanInspection: noPlanInspection,
        siteId: siteId,
        propuestaTecnicaId: propuestaTecnicaId,
        actividadId: actividadId,
        subActividadId: subActividadId,
        reprogramacionOTId: reprogramacionOTId,
        materialId: materialId,
        idTrazabilidad: idTrazabilidad,
        resultado: resultado,
        incluirReporte: incluirReporte,
        comentarios: comentarios));
  }

  void assignDNOrFN(
    String norm,
    bool isOutNorm,
    String comments,
    String noPlanInspection,
    String siteId,
    dynamic propuestaTecnicaId,
    dynamic actividadId,
    dynamic subActividadId,
    dynamic reprogramacionOTId,
    String materialId,
    String idTrazabilidad,
    int resultado,
    int incluirReporte,
    String comentarios,
  ) {
    bool hasReasson;

    hasReasson = _observacionesFNOrDNController.text.isNotEmpty;

    if (hasReasson) {
      // Restablecer -- Borrar todas las imagenes
      if (resultado == null) {
        listMaterialsBloc.add(UpdateReporteIP(
            noPlanInspection: noPlanInspection,
            siteId: siteId,
            propuestaTecnicaId: propuestaTecnicaId,
            actividadId: actividadId,
            subActividadId: subActividadId,
            reprogramacionOTId: reprogramacionOTId,
            materialId: materialId,
            idTrazabilidad: idTrazabilidad,
            resultado: resultado,
            incluirReporte: incluirReporte,
            comentarios: ''));

        _evidencePhotographicIPBloc.add(AddAllEvidenceAFNOrDN(
            data: this.lstPhothosTemAdd,
            deletePhoto: this.lstPhothosTemEliminados));
      } else {
        // Marcar una norma (D/N  O F/N)
        _evidencePhotographicIPBloc.add(AddAllEvidenceAFNOrDN(
            data: this.lstPhothosTemAdd, deletePhoto: lstPhothosWEBEliminados));

        listMaterialsBloc.add(UpdateReporteIP(
            noPlanInspection: noPlanInspection,
            siteId: siteId,
            propuestaTecnicaId: propuestaTecnicaId,
            actividadId: actividadId,
            subActividadId: subActividadId,
            reprogramacionOTId: reprogramacionOTId,
            materialId: materialId,
            idTrazabilidad: idTrazabilidad,
            resultado: resultado,
            incluirReporte: incluirReporte,
            comentarios: _observacionesFNOrDNController.text));
      }

      Navigator.pop(context);
      // widget.scrollControler.animateTo(0,
      //     duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje: 'Debe completar toda la información.',
        icon:
            Icon(Icons.info_outline_rounded, size: 28.0, color: Colors.yellow),
        secondsDuration: 2,
        colorBarIndicator: Colors.yellow,
        borde: 8,
      );
    }
  }

  void _showWeldingFNOrDNModal(
    String norm,
    int normTitle,
    bool isOutNorm,
    String comments,
    String noPlanInspection,
    String siteId,
    dynamic propuestaTecnicaId,
    dynamic actividadId,
    dynamic subActividadId,
    dynamic reprogramacionOTId,
    String materialId,
    String idTrazabilidad,
    int resultado,
    int incluirReporte,
    String comentarios,
  ) {
    this.lstPhothosTemAdd = [];
    this.lstPhothosTem = [];
    this.lstPhothosTemEliminados = [];
    loadPhotographicFN(true);

    _observacionesFNOrDNController.text = comments == null ? '' : comments;

    contentModal(
      context,
      normTitle == 1
          ? 'Actividad D/N'
          : (normTitle == 0)
              ? 'Actividad F/N'
              : 'ACTIVIDAD F/N',
      'Aceptar',
      backgroundIcon: norm == 'FN'
          ? Colors.red
          : (norm == 'DN')
              ? Colors.green
              : Colors.grey,
      colorBase: norm == 'FN'
          ? Colors.red
          : (norm == 'DN')
              ? Colors.green
              : Colors.grey,
      contentBody: _contentFN(
          norm,
          isOutNorm,
          comments,
          noPlanInspection,
          siteId,
          propuestaTecnicaId,
          actividadId,
          subActividadId,
          reprogramacionOTId,
          materialId,
          idTrazabilidad,
          resultado,
          incluirReporte,
          comentarios),
      showButtons: false,
    );
  }

  Widget _contentFN(
    String norm,
    bool isOutNorm,
    String comments,
    String noPlanInspection,
    String siteId,
    dynamic propuestaTecnicaId,
    dynamic actividadId,
    dynamic subActividadId,
    dynamic reprogramacionOTId,
    String materialId,
    String idTrazabilidad,
    int resultado,
    int incluirReporte,
    String comentarios,
  ) {
    Responsive responsive = Responsive(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Comentarios:',
                        style: TextStyle(
                          fontSize: responsive.dp(1.4),
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Form(
                          // key: formFN,
                          child: TextFormField(
                            controller: _observacionesFNOrDNController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '[Es necesario este campo]';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            enabled: norm == 'ESPERA' ? true : false,
                            //minLines: 1, //Normal textInputField will be displayed
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText: 'Describa el motivo....',
                              alignLabelWithHint: true,
                              suffixIcon: Icon(Icons.text_format, size: 30.0),
                            ), // when user presses enter it will adapt to it
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _builderEvidenceFN(
                      norm,
                      isOutNorm,
                      noPlanInspection,
                      siteId,
                      propuestaTecnicaId,
                      actividadId,
                      subActividadId,
                      reprogramacionOTId,
                      materialId,
                      idTrazabilidad,
                      resultado,
                      incluirReporte,
                      comentarios),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      norm == 'DN'
                          ? Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red[700],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.cancel,
                                            color: Colors.white, size: 26.0),
                                        SizedBox(width: 10.0),
                                        Text(
                                          'Cerrar ventana',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red[700],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.cancel,
                                            color: Colors.white, size: 26.0),
                                        SizedBox(width: 10.0),
                                        Text(
                                          'Cancelar',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  SizedBox(width: 70),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              color: Colors.white,
                                              size: 26.0),
                                          SizedBox(width: 10.0),
                                          Text(
                                            norm == 'FN'
                                                ? 'Restablecer'
                                                : 'Aceptar',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () => assignDNOrFN(
                                          norm,
                                          isOutNorm,
                                          comments,
                                          noPlanInspection,
                                          siteId,
                                          propuestaTecnicaId,
                                          actividadId,
                                          subActividadId,
                                          reprogramacionOTId,
                                          materialId,
                                          idTrazabilidad,
                                          resultado,
                                          incluirReporte,
                                          comentarios)),
                                ],
                              ),
                            )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sección de evidencia fotografica

  void loadPhotographicFN(bool load) {
    var params = new PhotographicEvidenceIPParamsModel(
      identificadorTabla:
          '${widget.params.inspectionPlanParams.contractSelection}',
      nombreTabla: "HSEQMC.ReporteInspeccionActividad",
      tipo: "1",
    );
    _evidencePhotographicIPBloc.add(GetEvidenceFNOrDN(
        params: params, temporales: this.lstPhothosTem, load: load));
  }

  void selectedPhotographic(
    String place,
    String noPlanInspection,
    String siteId,
    dynamic propuestaTecnicaId,
    dynamic actividadId,
    dynamic subActividadId,
    dynamic reprogramacionOTId,
    String materialId,
    String idTrazabilidad,
    int resultado,
    int incluirReporte,
    String comentarios,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Galeria"),
                onTap: () {
                  addPhotographicGallery(
                      place,
                      noPlanInspection,
                      siteId,
                      propuestaTecnicaId,
                      actividadId,
                      subActividadId,
                      reprogramacionOTId,
                      materialId,
                      idTrazabilidad,
                      resultado,
                      incluirReporte,
                      comentarios);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Camera"),
                onTap: () {
                  addPhotographicCamera(
                      place,
                      noPlanInspection,
                      siteId,
                      propuestaTecnicaId,
                      actividadId,
                      subActividadId,
                      reprogramacionOTId,
                      materialId,
                      idTrazabilidad,
                      resultado,
                      incluirReporte,
                      comentarios);
                },
              ),
            ],
          );
        });
  }

  void addPhotographicGallery(
    String place,
    String noPlanInspection,
    String siteId,
    dynamic propuestaTecnicaId,
    dynamic actividadId,
    dynamic subActividadId,
    dynamic reprogramacionOTId,
    String materialId,
    String idTrazabilidad,
    int resultado,
    int incluirReporte,
    String comentarios,
  ) async {
    Navigator.pop(context);
    PickedFile picture =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (picture != null) {
      var contentImage = await FlutterImageCompress.compressWithFile(
        picture.path,
        minWidth: 990,
        minHeight: 540,
        quality: 65,
      );

      var thumbnailImage = await FlutterImageCompress.compressWithFile(
        picture.path,
        minWidth: 210,
        minHeight: 118,
        quality: 65,
      );

      DateTime now = DateTime.now();
      String formattedDate =
          DateFormat('dd-MM-yyyy_kk:mm:ss').format(now) + "|Temp";

      var photographic = new PhotographicEvidenceIPModel(
        fotoId: formattedDate,
        content: base64.encode(contentImage).toString(),
        contentType: lookupMimeType(picture.path),
        identificadorTabla:
            '$noPlanInspection|${widget.params.inspectionPlanDModel.partidaInterna}|$materialId|$idTrazabilidad',
        nombre: path.basename(picture.path),
        nombreTabla: 'HSEQMC.ReporteInspeccionActividad',
        thumbnail: base64.encode(thumbnailImage).toString(),
      );

      _evidencePhotographicIPBloc.add(AddEvidenceFNOrDNTemporal(
          data: photographic, temporales: this.lstPhothosTem));
    } else {}
  }

  void addPhotographicCamera(
    String place,
    String noPlanInspection,
    String siteId,
    dynamic propuestaTecnicaId,
    dynamic actividadId,
    dynamic subActividadId,
    dynamic reprogramacionOTId,
    String materialId,
    String idTrazabilidad,
    int resultado,
    int incluirReporte,
    String comentarios,
  ) async {
    Navigator.pop(context);
    PickedFile picture =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (picture != null) {
      var contentImage = await FlutterImageCompress.compressWithFile(
        picture.path,
        minWidth: 990,
        minHeight: 540,
        quality: 65,
      );

      var thumbnailImage = await FlutterImageCompress.compressWithFile(
        picture.path,
        minWidth: 210,
        minHeight: 118,
        quality: 65,
      );

      DateTime now = DateTime.now();
      String formattedDate =
          DateFormat('dd-MM-yyyy_kk:mm:ss').format(now) + "|Temp";

      var photographic = new PhotographicEvidenceIPModel(
        fotoId: formattedDate,
        content: base64.encode(contentImage).toString(),
        contentType: lookupMimeType(picture.path),
        identificadorTabla:
            '$noPlanInspection|${widget.params.inspectionPlanDModel.partidaInterna}|$materialId|$idTrazabilidad',
        nombre: path.basename(picture.path),
        nombreTabla: 'HSEQMC.ReporteInspeccionActividad',
        thumbnail: base64.encode(thumbnailImage).toString(),
      );

      _evidencePhotographicIPBloc
          .add(AddEvidenceFNOrDNTemporal(data: photographic));
    } else {}
  }

  void deletePhotographicFN(String id) {
    Dialogs.confirm(context,
        title: "¿Esta seguro de eliminar la evidenvia fotografica?",
        description: "El registro sera eliminado y no podra se recuperado",
        onConfirm: () {
      var idSplit = id.split('|');
      var temporal = idSplit.where((x) => x == 'Temp').toList();
      var photo = this.lstPhothosTem.firstWhere((p) => p.fotoId == id);
      if (temporal.length > 0) {
        this.lstPhothosTem.remove(photo);
        this.lstPhothosTemAdd.removeWhere((x) => x.fotoId == id);
      } else {
        var photo = this.lstPhothosTem.firstWhere((p) => p.fotoId == id);
        photo.regBorrado = -1;
        this.lstPhothosTem.remove(photo);
        this.lstPhothosWEBEliminados.add(photo);
      }

      loadPhotographicFN(false);

      Navigator.pop(context);
    });
  }

  void showPhotographicPreview(String content) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DetailScreen(bytes: base64.decode(content));
    }));
  }

  Widget _builderEvidenceFN(
    String norm,
    bool isOutOfNorm,
    String noPlanInspection,
    String siteId,
    dynamic propuestaTecnicaId,
    dynamic actividadId,
    dynamic subActividadId,
    dynamic reprogramacionOTId,
    String materialId,
    String idTrazabilidad,
    int resultado,
    int incluirReporte,
    String comentarios,
  ) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<EvidencePhotographicIPBloc, EvidencePhotographicIPState>(
      builder: (context, state) {
        if (state is SuccessCreateEvidenceTemporalFNsOrDNs) {
          lstPhothosTemAdd.add(new PhotographicEvidenceIPModel(
              fotoId: state.data.fotoId,
              content: state.data.content,
              contentType: state.data.contentType,
              nombre: state.data.nombre,
              nombreTabla: state.data.nombreTabla,
              identificadorTabla: state.data.identificadorTabla,
              siteModificacion: state.data.siteModificacion,
              regBorrado: state.data.regBorrado,
              thumbnail: state.data.thumbnail,
              fechaModificacion: state.data.fechaModificacion));
          lstPhothosTem.add(new PhotographicEvidenceIPModel(
              fotoId: state.data.fotoId,
              content: state.data.content,
              contentType: state.data.contentType,
              nombre: state.data.nombre,
              nombreTabla: state.data.nombreTabla,
              identificadorTabla: state.data.identificadorTabla,
              siteModificacion: state.data.siteModificacion,
              regBorrado: state.data.regBorrado,
              thumbnail: state.data.thumbnail,
              fechaModificacion: state.data.fechaModificacion));
          loadPhotographicFN(false);
        }

        if (state is SuccessDeleteEvidenceFNsOrDNs) {
          loadPhotographicFN(false);
          showNotificationSnackBar(
            context,
            title: "",
            mensaje: "Se ha eliminado la evidencia fotográfica",
            icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue[300]),
            secondsDuration: 2,
            colorBarIndicator: Colors.green,
            borde: 8,
          );
        }

        if (state is SuccessGetEvidenceFNsOrDNs) {
          if (this.lstPhothosTem.length == 0) {
            lstPhothosTem.addAll(state.pics);
          }
          lstPhothosTemEliminados.addAll(state.pics.where((i) =>
              i.identificadorTabla ==
              '$noPlanInspection|${widget.params.inspectionPlanDModel.partidaInterna}|$materialId|$idTrazabilidad'));
        }

        if (state is SuccessCreateAllEvidenceFNsOrDNs) {
          loadPhotographicFN(true);
        }

        if (state is ErrorEvidenceFNOrDN) {
          showNotificationSnackBar(
            context,
            title: "Error mensaje",
            mensaje: state.error,
            icon: Icon(Icons.warning, size: 28.0, color: Colors.blue[300]),
            secondsDuration: 2,
            colorBarIndicator: Colors.red,
            borde: 8,
          );
        }

        return Row(
          children: [
            isOutOfNorm
                ? Container(width: 0.0, height: 0.0)
                : Container(
                    width: size.width * 0.2,
                    height: 200,
                    child: Column(
                      children: [
                        Text(
                          "Evidencia Fotográfica",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => selectedPhotographic(
                              'place',
                              noPlanInspection,
                              siteId,
                              propuestaTecnicaId,
                              actividadId,
                              subActividadId,
                              reprogramacionOTId,
                              materialId,
                              idTrazabilidad,
                              resultado,
                              incluirReporte,
                              comentarios),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              border: Border.all(
                                  color: Colors.blue[300], width: 3.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            width: 100,
                            height: 100,
                            child: Icon(Icons.camera_enhance,
                                size: 50, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[200], width: 1.0),
              ),
              width: isOutOfNorm ? size.width * 0.80 : size.width * 0.60,
              height: 200,
              child: Column(
                children: [
                  Container(
                    color: norm == 'FN'
                        ? Colors.red
                        : (norm == 'DN')
                            ? Colors.green
                            : Colors.blueAccent,
                    width: double.infinity,
                    height: 40,
                    child: Center(
                      child: Text(
                        "Imagenes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    child: (state is SuccessGetEvidenceFNsOrDNs)
                        ? (state.pics
                                    .where((i) =>
                                        i.identificadorTabla ==
                                        '$noPlanInspection|${widget.params.inspectionPlanDModel.partidaInterna}|$materialId|$idTrazabilidad')
                                    .length >
                                0)
                            ? ListView.builder(
                                padding: EdgeInsets.only(left: 16),
                                itemCount: state.pics
                                    .where((i) =>
                                        i.identificadorTabla ==
                                        '$noPlanInspection|${widget.params.inspectionPlanDModel.partidaInterna}|$materialId|$idTrazabilidad')
                                    .length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding:
                                          EdgeInsets.only(right: 4, top: 5),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: PhotographicCardIP(
                                              imagen: state.pics
                                                  .where((i) =>
                                                      i.identificadorTabla ==
                                                      '$noPlanInspection|${widget.params.inspectionPlanDModel.partidaInterna}|$materialId|$idTrazabilidad')
                                                  .toList()[index],
                                              delete: deletePhotographicFN,
                                              preview: showPhotographicPreview,
                                              readOnly:
                                                  isOutOfNorm ? true : false,
                                            ),
                                          ),
                                          SizedBox(width: 10)
                                        ],
                                      ));
                                })
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Aún no se ha agregado ninguna imagen",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "OpenSans",
                                    ),
                                  )
                                ],
                              )
                        : loadingCircular(),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  BlocListener listenerDates() {
    return BlocListener<ListMaterialsBloc, ListMaterialsState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingUpdateReporteIP) {
        loadingCircular();
      } else if (state is SuccessUpdateReporteIP) {
        initialData();
        // showNotificationSnackBar(
        //   context,
        //   title: "",
        //   mensaje: 'Actualizado correctamente!!',
        //   icon: Icon(Icons.check_circle_outline_rounded,
        //       size: 28.0, color: Colors.green),
        //   secondsDuration: 2,
        //   colorBarIndicator: Colors.green,
        //   borde: 8,
        // );

      } else if (state is ErrorUpdateReporteIP) {
        Navigator.pop(context);
        showNotificationSnackBar(
          context,
          title: "",
          mensaje: 'Hubo un error',
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 2,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  // ---------------------------
  // ----------------------------
  // ----------------------------
  // Seccion de información adicional

  void saveGeneral() {
    bool complete = true;
    List<String> listSoldaodores = [];

    informationAditional.forEach((element) {
      listSoldaodores.add(element.soldadorId);
    });

    if (informationAditional.length == 0) {
      welderPlanBloc.add(AddWelderPlanEvent(
          params: AddWelderParams(
              noPlanInspeccion: widget.params.inspectionPlanParams
                  .inspectionPlanCModel.noPlanInspeccion,
              siteId: widget.params.inspectionPlanDModel.siteId,
              propuestaTecnicaId:
                  widget.params.inspectionPlanDModel.propuestaTecnicaId,
              actividadId: widget.params.inspectionPlanDModel.actividadId,
              subActividadId: widget.params.inspectionPlanDModel.subActividadId,
              reprogramacionOTId:
                  widget.params.inspectionPlanDModel.reprogramacionOTId,
              soldadores: listSoldaodores)));
    } else {
      var soldadores = informationAditional
          .where((x) =>
              x.trazabilidadGrupo1.trazabilida1 == null ||
              x.trazabilidadGrupo1.trazabilida2 == null)
          .length;

      var trazabilidadVacia = informationAditional
          .where(
              (x) => x.trazabilidadGrupo2.trazabilida1 == null && x.newWidget)
          .length;

      if (soldadores > 0) {
        complete = false;
      }

      if (trazabilidadVacia > 0) {
        complete = false;
      }

      if (complete) {
        welderPlanBloc.add(AddWelderPlanEvent(
            params: AddWelderParams(
                noPlanInspeccion: widget.params.inspectionPlanParams
                    .inspectionPlanCModel.noPlanInspeccion,
                siteId: widget.params.inspectionPlanDModel.siteId,
                propuestaTecnicaId:
                    widget.params.inspectionPlanDModel.propuestaTecnicaId,
                actividadId: widget.params.inspectionPlanDModel.actividadId,
                subActividadId:
                    widget.params.inspectionPlanDModel.subActividadId,
                reprogramacionOTId:
                    widget.params.inspectionPlanDModel.reprogramacionOTId,
                soldadores: listSoldaodores)));
      } else {
        mensajeAdvertencia('Debe completar la información requerida');
      }
    }
  }

  void addWelderPlan(dynamic noFicha) {
    var ficha = addWelder.text;

    var exist = informationAditional
        .where((element) => element.ficha.toString() == noFicha)
        .length;

    if (ficha != "" && exist == 0) {
      welderPlanBloc.add(GetWelderPlanEvent(params: addWelder.text));
    } else {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje: 'El soldador agregado ya existe',
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.yellow),
        secondsDuration: 2,
        colorBarIndicator: Colors.yellow,
        borde: 8,
      );
    }
    addWelder.text = "";
  }

  Widget sectionInformationAditional() {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 8, right: 10, bottom: 8),
      child: Card(
          elevation: 4.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
            child: Column(
              children: <Widget>[
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
                                'Soldador (Agregar): ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 110),
                            child: TextField(
                              controller: addWelder,
                              obscureText: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText:
                                    'Ingrese el número de ficha del soldador',
                                hintText: 'Número de ficha...',
                                alignLabelWithHint: true,
                              ),
                              onSubmitted: (value) => addWelderPlan(value),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      // color: Colors.red,
                      //padding: EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(Icons.save_outlined),
                          iconSize: 50.0,
                          color: Colors.blue,
                          //alignment: Alignment.topCenter,
                          onPressed: () {
                            saveGeneral();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ListView.builder(
                  controller: _controller, //new line
                  itemCount: informationAditional.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Column(
                    children: [
                      SizedBox(height: 30),
                      containerSoldierAndtraceability(
                          informationAditional[index], index)
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  void removeOneTrazability(int noTrazabilidad, int noGrupo, int index) {
    if (noGrupo == 1) {
      if (noTrazabilidad == 1) {
        setState(() {
          informationAditional[index].trazabilidadGrupo1.trazabilida1 = null;
        });
      } else {
        setState(() {
          informationAditional[index].trazabilidadGrupo1.trazabilida2 = null;
        });
      }
    } else {
      if (noTrazabilidad == 1) {
        setState(() {
          informationAditional[index].trazabilidadGrupo2.trazabilida1 = null;
        });
      } else {
        setState(() {
          informationAditional[index].trazabilidadGrupo2.trazabilida2 = null;
        });
      }
    }
  }

  void addTrazabilidad(String trazabilidadId, String soldadorId,
      int noTrazabilidad, int noGrupo, int index) {
    if (trazabilidadId == "") {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje: "Debe ingresar una trazabilidad",
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
        secondsDuration: 2,
        colorBarIndicator: Colors.red,
        borde: 8,
      );
    } else {
      var trazabilidad = listReporteIM
          .where((x) => x.idTrazabilidad == trazabilidadId)
          .toList();
      if (trazabilidad.length == 0) {
        showNotificationSnackBar(
          context,
          title: "",
          mensaje:
              "La trazabilidad ingresada no corresponde a alguna de las de las reportadas y validadas en campo para esta actividad",
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 8,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      } else {
        var _trazabilidad =
            listReporteIM.firstWhere((x) => x.idTrazabilidad == trazabilidadId);

        TrazabilidadModel _newtrazabilidad = TrazabilidadModel(
            idTrazabilidad: trazabilidadId,
            soldadorId: soldadorId,
            descripcion: _trazabilidad.descripcion,
            materialId: _trazabilidad.materialId,
            um: _trazabilidad.uM,
            volumen: 0.100);

        if (noGrupo == 1) {
          if (noTrazabilidad == 1) {
            setState(() {
              informationAditional[index].trazabilidadGrupo1.trazabilida1 =
                  _newtrazabilidad;
            });
          } else {
            setState(() {
              informationAditional[index].trazabilidadGrupo1.trazabilida2 =
                  _newtrazabilidad;
            });
          }
        } else {
          if (noTrazabilidad == 1) {
            setState(() {
              informationAditional[index].trazabilidadGrupo2.trazabilida1 =
                  _newtrazabilidad;
            });
          } else {
            setState(() {
              informationAditional[index].trazabilidadGrupo2.trazabilida2 =
                  _newtrazabilidad;
            });
          }
        }
      }
    }
  }

  void addVolumenTrazability(
      int noTrazabilidad, double volumen, int noGrupo, int index) {
    if (noGrupo == 1) {
      if (noTrazabilidad == 1) {
        informationAditional[index].trazabilidadGrupo1.trazabilida1.volumen =
            volumen;
      } else {
        informationAditional[index].trazabilidadGrupo1.trazabilida2.volumen =
            volumen;
      }
    } else {
      if (noTrazabilidad == 1) {
        informationAditional[index].trazabilidadGrupo2.trazabilida1.volumen =
            volumen;
      } else {
        informationAditional[index].trazabilidadGrupo2.trazabilida2.volumen =
            volumen;
      }
    }
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
        secondsDuration: 2,
        colorBarIndicator: Colors.green,
        borde: 8);
  }

  void mensajeAdvertencia(String mensaje) {
    showNotificationSnackBar(context,
        title: "",
        mensaje: mensaje,
        icon: Icon(
          Icons.info_outline_rounded,
          size: 28.0,
          color: Colors.yellow[700],
        ),
        secondsDuration: 2,
        colorBarIndicator: Colors.yellow,
        borde: 8);
  }

  void mensajeError(String mensaje) {
    showNotificationSnackBar(context,
        title: "",
        mensaje: mensaje,
        icon: Icon(
          Icons.info_outline_rounded,
          size: 28.0,
          color: Colors.red[700],
        ),
        secondsDuration: 2,
        colorBarIndicator: Colors.red,
        borde: 8);
  }

  Widget containerSoldierAndtraceability(
      InformacionadicionalModel item, int index) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              // SizedBox(width: 10),
              Expanded(flex: 2, child: cardSoldier(item)),
              // SizedBox(width: 10),
              item.trazabilidadGrupo2.trazabilida1 == null && !item.newWidget
                  ? Expanded(
                      child: Container(
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: flatButton(
                            Colors.blue, Icons.add, 'Agregar', Colors.white,
                            () {
                          setState(() {
                            item.newWidget = true;
                          });
                        }),
                      )),
                    ))
                  : Expanded(
                      child: Container(),
                    )
            ],
          ),
          SizedBox(height: 20),
          containerCardTrazability(
              item.trazabilidadGrupo1, item.soldadorId, 1, index),
          SizedBox(height: 20),
          item.trazabilidadGrupo2.trazabilida1 != null || item.newWidget
              ? containerCardTrazability(
                  item.trazabilidadGrupo2, item.soldadorId, 2, index)
              : Container(),
        ],
      ),
    );
  }

  Widget containerCardTrazability(
      TrazabilidadGroup item, String soldadorId, int grupo, int index) {
    TrazabilidadModel trazabilidad1 = item.trazabilida1;
    TrazabilidadModel trazabilidad2 = item.trazabilida2;

    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 20, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          'TRAZABILIDADES*',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20),
                        child: IconButton(
                          icon: Icon(
                            Icons.cleaning_services_rounded,
                            size: 40.0,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              item.trazabilida1 = null;
                              item.trazabilida2 = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 35, top: 5, left: 15, right: 15),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          children: [
                            trazabilidad1 != null
                                ? cardTrazability(
                                    trazabilidad1, 1, grupo, index)
                                : TextField(
                                    // controller: addWelder,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      labelText: 'Ingrese la trazabilidad',
                                      hintText: 'Trazabilidad...',
                                      alignLabelWithHint: true,
                                    ),
                                    onSubmitted: (value) {
                                      addTrazabilidad(
                                          value, soldadorId, 1, grupo, index);
                                    },
                                  ),
                            SizedBox(height: 20),
                            trazabilidad2 != null
                                ? cardTrazability(
                                    trazabilidad2, 2, grupo, index)
                                : Container(
                                    child: TextField(
                                      // controller: addWelder,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'Ingrese la trazabilidad',
                                        hintText: 'Trazabilidad....',
                                        alignLabelWithHint: true,
                                      ),
                                      onSubmitted: (value) {
                                        addTrazabilidad(
                                            value, soldadorId, 2, grupo, index);
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            trazabilidad1 != null
                                ? Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 50),
                                      child: TextFormField(
                                        // controller: firtTrazability,
                                        initialValue: trazabilidad1.volumen ==
                                                null
                                            ? ''
                                            : trazabilidad1.volumen.toString(),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,4}'),
                                          ),
                                        ],
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true, signed: false),

                                        onChanged: (value) {
                                          addVolumenTrazability(
                                              1,
                                              double.parse(value),
                                              grupo,
                                              index);
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          labelText: 'Ingrese la cantidad',
                                          hintText: 'Cantidad: Ejemp: 0.1',
                                          alignLabelWithHint: true,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: 20),
                            trazabilidad2 != null
                                ? Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 50),
                                      child: TextFormField(
                                        initialValue: trazabilidad2.volumen ==
                                                null
                                            ? ''
                                            : trazabilidad2.volumen.toString(),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,4}'),
                                          ),
                                        ],
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true, signed: false),
                                        onChanged: (value) {
                                          addVolumenTrazability(
                                              2,
                                              double.parse(value),
                                              grupo,
                                              index);
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.clear),
                                          ),
                                          labelText: 'Ingrese la cantidad',
                                          hintText: 'Cantidad: Ejemp: 0.1',
                                          alignLabelWithHint: true,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
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

  Widget cardSoldier(InformacionadicionalModel item) {
    return Card(
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
                  _getInitials(item.nombre),
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              title: Text(
                item.nombre,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text('${item.ficha.toString()}'),
                      Text(' - '),
                      Text(item.soldadorId.toString()),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Text(item.puesto),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        child: Text('Remover',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            var result = informationAditional.remove(item);
                            if (result) {
                              mensajeExito('Soldador removido con éxito');
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cardTrazability(TrazabilidadModel trazabilidadModel, int trazabilidad,
      int grupo, int index) {
    return Card(
      margin: EdgeInsets.all(0.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ListTile(
              isThreeLine: true,
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/img/avatarjunta.png'),
              ),
              title: Text(
                '${trazabilidadModel.idTrazabilidad}',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Text('C. SAP: ${trazabilidadModel.materialId}'),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Expanded(child: Text('UoM: ${trazabilidadModel.um}')),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text('${trazabilidadModel.descripcion}'),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('Remover', style: TextStyle(color: Colors.white)),
                  onPressed: () =>
                      removeOneTrazability(trazabilidad, grupo, index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List of listeners
  // BlocListener listenerDates() {
  //   return BlocListener<DatesBloc, DatesState>(listener: (context, state) {
  //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //   });
  // }

  BlocListener welderPlanBlocListernet() {
    return BlocListener<WelderPlanBloc, WelderState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is SuccessGetInformacionadicional) {
        setState(() {
          informationAditional = state.informationWelder;
        });
      }

      if (state is SuccessGetWelderPlan) {
        var newWelder = new InformacionadicionalModel(
            ficha: state.welder.ficha,
            nombre: state.welder.nombre,
            puesto: state.welder.puesto,
            soldadorId: state.welder.soldadorId,
            trazabilidadGrupo1: TrazabilidadGroup(),
            trazabilidadGrupo2: TrazabilidadGroup());

        setState(() {
          informationAditional.add(newWelder);
        });
      }
      // Save Genral welders
      if (state is SuccessAddWelder) {
        List<SoldadorTrazabilidadRIA> trazabilidadesTemp = [];
        informationAditional.forEach((element) {
          trazabilidadesTemp.add(
            SoldadorTrazabilidadRIA(
                idTrazabilidad:
                    element.trazabilidadGrupo1.trazabilida1.idTrazabilidad,
                soldadorId: element.soldadorId,
                volumen: element.trazabilidadGrupo1.trazabilida1.volumen,
                soldadorActividadId: state.success
                    .where((x) => x.soldadorId == element.soldadorId)
                    .first
                    .soldadorActividadId,
                numero: 1),
          );
          trazabilidadesTemp.add(
            SoldadorTrazabilidadRIA(
                idTrazabilidad:
                    element.trazabilidadGrupo1.trazabilida2.idTrazabilidad,
                soldadorId: element.soldadorId,
                volumen: element.trazabilidadGrupo1.trazabilida2.volumen,
                soldadorActividadId: state.success
                    .where((x) => x.soldadorId == element.soldadorId)
                    .first
                    .soldadorActividadId,
                numero: 2),
          );
          if (element.trazabilidadGrupo2.trazabilida1 != null) {
            trazabilidadesTemp.add(
              SoldadorTrazabilidadRIA(
                  idTrazabilidad:
                      element.trazabilidadGrupo2.trazabilida1.idTrazabilidad,
                  soldadorId: element.soldadorId,
                  volumen: element.trazabilidadGrupo2.trazabilida1.volumen,
                  soldadorActividadId: state.success
                      .where((x) => x.soldadorId == element.soldadorId)
                      .first
                      .soldadorActividadId,
                  numero: 3),
            );
            trazabilidadesTemp.add(
              SoldadorTrazabilidadRIA(
                  idTrazabilidad:
                      element.trazabilidadGrupo2.trazabilida2.idTrazabilidad,
                  soldadorId: element.soldadorId,
                  volumen: element.trazabilidadGrupo2.trazabilida2.volumen,
                  soldadorActividadId: state.success
                      .where((x) => x.soldadorId == element.soldadorId)
                      .first
                      .soldadorActividadId,
                  numero: 4),
            );
          }
        });

        print(trazabilidadesTemp);

        welderPlanBloc.add(AddTrazabilidadEvent(params: trazabilidadesTemp));
      }

      if (state is ErrorGetWelderPlan) {
        mensajeError(state.message);
      }

      if (state is ErrorWelder) {
        mensajeAdvertencia(state.message);
      }

      if (state is SuccessAddTrazabilidad) {
        showNotificationSnackBar(
          context,
          title: "",
          mensaje: 'Información adicional guardada con éxito',
          icon: Icon(Icons.check_circle_outline_rounded,
              size: 28.0, color: Colors.green),
          secondsDuration: 2,
          colorBarIndicator: Colors.green,
          borde: 8,
        );
      }
    });
  }
}
