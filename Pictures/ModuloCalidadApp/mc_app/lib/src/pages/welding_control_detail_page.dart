import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mc_app/src/bloc/existing_element/existing_element_bloc.dart';
import 'package:mc_app/src/bloc/existing_element/existing_element_event.dart';
import 'package:mc_app/src/bloc/existing_element/existing_element_state.dart';
import 'package:mc_app/src/bloc/tab_welding/panel_register_welder/panel_register_welder_bloc.dart';
import 'package:mc_app/src/bloc/tab_welding/panel_register_welder/panel_register_welder_event.dart';
import 'package:mc_app/src/bloc/tab_welding/panel_register_welder/panel_register_welder_state.dart';
import 'package:mc_app/src/bloc/user_rol/user_rol_bloc.dart';
import 'package:mc_app/src/bloc/user_rol/user_rol_event.dart';
import 'package:mc_app/src/bloc/user_rol/user_rol_state.dart';
import 'package:mc_app/src/models/acceptance_criteria_model.dart';
import 'package:mc_app/src/models/employee_model.dart';
import 'package:mc_app/src/models/existing_element_model.dart';
import 'package:mc_app/src/models/initial_data_joint_model.dart';
import 'package:mc_app/src/models/joint_traceability_model.dart';
import 'package:mc_app/src/models/ndt_progress_model.dart';
import 'package:mc_app/src/models/params/add_card_welder_not_valid_params.dart';
import 'package:mc_app/src/models/params/add_card_welder_params.dart';
import 'package:mc_app/src/models/params/forming_cs_params.dart';
import 'package:mc_app/src/models/params/joint_traceability_params.dart';
import 'package:mc_app/src/models/params/photographic_evidence_params_model.dart';
import 'package:mc_app/src/models/params/require_change_material_model.dart';
import 'package:mc_app/src/models/params/update_welding_detail_params.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';
import 'package:mc_app/src/models/pipefitter_model.dart';
import 'package:mc_app/src/models/params/traceability_delete_params_model.dart';
import 'package:mc_app/src/models/params/welding_control_detail_params.dart';
import 'package:mc_app/src/models/traceability_by_joint_model.dart';
import 'package:mc_app/src/models/traceability_model.dart';
import 'package:mc_app/src/models/user_avatar_model.dart';
import 'package:mc_app/src/models/user_permission_model.dart';
import 'package:mc_app/src/models/welding_tab_model.dart';
import 'package:mc_app/src/pages/activities_page.dart';
import 'package:mc_app/src/pages/detail_photographic_screen.dart';
import 'package:mc_app/src/utils/always_disabled_focus_node.dart';
import 'package:mc_app/src/utils/dialogs.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:mc_app/src/widgets/card_change_material.dart';
import 'package:mc_app/src/widgets/card_released_overseer.dart';
import 'package:mc_app/src/widgets/confirm_modal.dart';
import 'package:mc_app/src/widgets/content_modal.dart';
import 'package:mc_app/src/widgets/content_traceability.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/photographic_card.dart';
import 'package:mc_app/src/widgets/row_box.dart';
import 'package:mc_app/src/widgets/show_general_loading.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';
import 'package:mc_app/src/widgets/spinkit.dart';
import 'package:mc_app/src/widgets/welder_expand.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:popover/popover.dart';

class WeldingControlDetailPage extends StatefulWidget {
  final WeldingControlDetailParams params;
  static String id = "Detalle Junta";

  WeldingControlDetailPage({Key key, @required this.params}) : super(key: key);

  @override
  _WeldingControlDetailPage createState() => _WeldingControlDetailPage();
}

class _WeldingControlDetailPage extends State<WeldingControlDetailPage>
    with SingleTickerProviderStateMixin {
  DatesBloc _datesBloc;
  TraceabilityBloc _traceabilityBloc;
  TraceabilityOneBloc _traceabilityOneBloc;
  TraceabilityTwoBloc _traceabilityTwoBloc;
  TraceabilityOneRemoveBloc _traceabilityOneRemoveBloc;
  // ignore: close_sinks
  TraceabilityOneAddBloc _traceabilityOneAddBloc;
  TraceabilityTwoRemoveBloc _traceabilityTwoRemoveBloc;
  // ignore: close_sinks
  TraceabilityTwoAddBloc _traceabilityTwoAddBloc;
  PipefitterBloc _pipefitterBloc;
  PipefitterRemoveBloc _pipefitterRemoveBloc;
  PipefitterAddBloc _pipefitterAddBloc;
  PipefitterSignBloc _pipefitterSignBloc;
  JointActivityBloc _jointActivityBloc;
  InitialDataJointBloc _initialDataJoint;
  NDTProgressBloc _ndtProgressBloc;
  PanelRegisterBloc _panelRegisterBloc;
  InitialDataJointModel initialDataJointModel;
  JointTraceabilityParams params;
  WorkTraceability workTraceability;
  EvidencePhotographicBloc _evidencePhotographicBloc;
  QualifyCaboNormBloc _qualifyCaboNormBloc;
  AddWelderBloc _addWelderBloc;
  OverseerBloc _overseerBloc;
  UserRolBloc _overseerWeldingBloc;
  QABloc _qaBloc;
  EvidenceFNBloc _evidenceFNBloc;
  WeldingListBloc weldingListBloc;
  JointTraceabilityBloc _jointTraceabilityBloc;
  UserAvatarModel user;
  UserPermissionModel userPermissionModel;
  WorkTraceabilityBloc _workTraceabilityBloc;
  ExistingElementBloc _existingElementBloc;

  List<ActividadesSoldaduraModel> lstActividadesSoldadureas = [];
  List<PhotographicEvidenceModel> lstPhothosTem = [];
  List<PhotographicEvidenceModel> lstPhothosTemEliminados = [];
  List<PhotographicEvidenceModel> lstPhothosTemAdd = [];
  List<JointTraceabilityModel> joints = [];
  Flushbar fucture;
  String saveFormingMessage;
  String action;
  String formingNorm;
  String weldingNorm;
  int consecutive = 0;
  int consecutiveWelding = 0;
  bool formingReleased = false;
  int weldingReleased;
  int radioValue = -1;
  var value;
  bool weldingFNNorm = false;
  bool isSaveGeneral = false;

  final ScrollController controller = ScrollController();
  final comments = TextEditingController();
  final reasson = TextEditingController();
  final cuantity = TextEditingController();
  final juntaNo = TextEditingController();
  final dateOne = TextEditingController();
  final dateTwo = TextEditingController();
  final hourOne = TextEditingController();
  final hourTwo = TextEditingController();
  final addPipefitter = TextEditingController();
  final addWelder = TextEditingController();

  // Trazabilidad
  final juntaSearch = TextEditingController();
  final planoSearch = TextEditingController();
  final volumen = TextEditingController();
  final workTrazabilidadSel = TextEditingController();

  DateTime currentDateOne;
  DateTime currentDateTwo;
  TimeOfDay selectedTimeOne;
  TimeOfDay selectedTimeTwo;
  TabController tabController;
  final formPanelSoldier = new GlobalKey<FormState>();
  WelderExpandPage welderExpandPage;
  List<GlobalKey<WelderExpandPageState>> listFormWelderKeys = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();
  var items;
  List<AcceptanceCriteriaconformadoModel> listCriterosConformadoFull = [];
  List<AcceptanceCriteriaconformadoModel> listACC = [];
  List<String> listaOriginal = [];
  ExistingElementModel _existingElement;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    tabController.addListener(_handleTabChange);
    initialData();
  }

  void initialData() {
    _datesBloc = BlocProvider.of<DatesBloc>(context);
    _evidencePhotographicBloc =
        BlocProvider.of<EvidencePhotographicBloc>(context);
    _traceabilityBloc = BlocProvider.of<TraceabilityBloc>(context);
    _traceabilityOneBloc = BlocProvider.of<TraceabilityOneBloc>(context);
    _traceabilityTwoBloc = BlocProvider.of<TraceabilityTwoBloc>(context);
    _traceabilityOneRemoveBloc =
        BlocProvider.of<TraceabilityOneRemoveBloc>(context);
    _traceabilityOneAddBloc = BlocProvider.of<TraceabilityOneAddBloc>(context);
    _traceabilityTwoRemoveBloc =
        BlocProvider.of<TraceabilityTwoRemoveBloc>(context);
    _traceabilityTwoAddBloc = BlocProvider.of<TraceabilityTwoAddBloc>(context);
    _pipefitterBloc = BlocProvider.of<PipefitterBloc>(context);
    _pipefitterRemoveBloc = BlocProvider.of<PipefitterRemoveBloc>(context);
    _pipefitterAddBloc = BlocProvider.of<PipefitterAddBloc>(context);
    _pipefitterSignBloc = BlocProvider.of<PipefitterSignBloc>(context);
    _jointActivityBloc = BlocProvider.of<JointActivityBloc>(context);
    _initialDataJoint = BlocProvider.of<InitialDataJointBloc>(context);
    _ndtProgressBloc = BlocProvider.of<NDTProgressBloc>(context);
    _panelRegisterBloc = BlocProvider.of<PanelRegisterBloc>(context);
    _overseerBloc = BlocProvider.of<OverseerBloc>(context);
    _overseerWeldingBloc = BlocProvider.of<UserRolBloc>(context);
    _qaBloc = BlocProvider.of<QABloc>(context);
    user = BlocProvider.of<AvatarBloc>(context).state.userAvatarModel;
    userPermissionModel =
        BlocProvider.of<UserPermissionBloc>(context).state.permissions;
    _addWelderBloc = BlocProvider.of<AddWelderBloc>(context);
    _evidenceFNBloc = BlocProvider.of<EvidenceFNBloc>(context);
    weldingListBloc = BlocProvider.of<WeldingListBloc>(context);
    _jointTraceabilityBloc = BlocProvider.of<JointTraceabilityBloc>(context);
    _qualifyCaboNormBloc = BlocProvider.of<QualifyCaboNormBloc>(context);
    _workTraceabilityBloc = BlocProvider.of<WorkTraceabilityBloc>(context);
    _existingElementBloc = BlocProvider.of<ExistingElementBloc>(context);

    _traceabilityOneBloc.add(GetTraceabilityOne(
      jointId: widget.params.joint.juntaId,
      isTraceabilityOne: true,
    ));

    _traceabilityTwoBloc.add(GetTraceabilityTwo(
      jointId: widget.params.joint.juntaId,
      isTraceabilityOne: false,
    ));
    _pipefitterBloc.add(GetPipefitters(jointId: widget.params.joint.juntaId));

    _initialDataJoint
        .add(GetInitialDataJoint(juntaId: widget.params.joint.juntaId));

    loadPhotographic();

    setState(() {
      listACC = BlocProvider.of<ACCBloc>(context).state.listACC;
      // Criterios
      items = listACC
          .map((e) => MultiSelectItem<AcceptanceCriteriaconformadoModel>(
              e, '${e.clave}-${e.criterioId}'))
          .toList();
    });
  }

  void addPhotographicGallery(String place) async {
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

      var photographic = new PhotographicEvidenceModel(
        fotoId: formattedDate,
        content: base64.encode(contentImage).toString(),
        contentType: lookupMimeType(picture.path),
        identificadorTabla: place == 'FORMING'
            ? widget.params.joint.conformadoId
            : '${widget.params.joint.conformadoId}|FN',
        nombre: path.basename(picture.path),
        nombreTabla: 'HSEQMC.Conformado',
        thumbnail: base64.encode(thumbnailImage).toString(),
      );

      place == 'FORMING'
          ? _evidencePhotographicBloc
              .add(AddEvidencePhotographic(data: photographic))
          : _evidenceFNBloc.add(AddEvidenceFNTemporal(
              data: photographic, temporales: this.lstPhothosTem));
    } else {}
  }

  void addPhotographicCamera(String place) async {
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

      var photographic = new PhotographicEvidenceModel(
        fotoId: formattedDate,
        content: base64.encode(contentImage).toString(),
        contentType: lookupMimeType(picture.path),
        identificadorTabla: place == 'FORMING'
            ? widget.params.joint.conformadoId
            : '${widget.params.joint.conformadoId}|FN',
        nombre: path.basename(picture.path),
        nombreTabla: 'HSEQMC.Conformado',
        thumbnail: base64.encode(thumbnailImage).toString(),
      );

      place == 'FORMING'
          ? _evidencePhotographicBloc
              .add(AddEvidencePhotographic(data: photographic))
          : _evidenceFNBloc.add(AddEvidenceFNTemporal(data: photographic));
    } else {}
  }

  void deletePhotographic(String id) {
    Dialogs.confirm(context,
        title: "¿Esta seguro de eliminar la evidenvia fotografica?",
        description: "El registro sera eliminado y no podra se recuperado",
        onConfirm: () {
      Navigator.pop(context);
      _evidencePhotographicBloc.add(DeleteEvidencePhotographic(id: id));
    });
  }

  void loadPhotographic() {
    var loadPhotographicParams = new PhotographicEvidenceParamsModel(
        identificadorTabla: widget.params.joint.conformadoId,
        nombreTabla: "HSEQMC.Conformado",
        tipo: "1");
    _evidencePhotographicBloc
        .add(GetEvidencePhotographic(params: loadPhotographicParams));
  }

  void loadPhotographicFN(bool load) {
    var params = new PhotographicEvidenceParamsModel(
      identificadorTabla: '${widget.params.joint.conformadoId}|FN',
      nombreTabla: "HSEQMC.Conformado",
      tipo: "1",
    );
    _evidenceFNBloc.add(GetEvidenceFN(
        params: params, temporales: this.lstPhothosTem, load: load));
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
        this.lstPhothosTemAdd.remove(photo);
      } else {
        var photo = this.lstPhothosTem.firstWhere((p) => p.fotoId == id);
        photo.regBorrado = -1;
        this.lstPhothosTem.remove(photo);
        this.lstPhothosTemEliminados.add(photo);
      }

      loadPhotographicFN(false);

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Junta: ${widget.params.joint.junta}'),
        ),
        body: BlocConsumer<InitialDataJointBloc, InitialDataJointState>(
          listener: (context, state) {
            if (state is SuccessInitialDataJoint) {
              Navigator.pop(context);

              initialDataJointModel = state.initialDataJointModel;
              _setDates();

              setState(() {
                consecutive = initialDataJointModel.consecutivo;
                formingReleased = initialDataJointModel.confomadoLiberado;
                formingNorm = initialDataJointModel.conformadoNorma;
                consecutiveWelding = initialDataJointModel.soldaduraConsecutivo;
                weldingReleased = initialDataJointModel.soldaduraLiberada;
                weldingNorm = initialDataJointModel.soldaduraNorma;
                if (initialDataJointModel.criteriosAceptacionId.isNotEmpty) {
                  List<String> criterios =
                      initialDataJointModel.criteriosAceptacionId.split('|');
                  criterios.forEach((element) {
                    listACC.forEach((e) {
                      if (element == e.criterioAceptacionId) {
                        listaOriginal.add('${e.clave}-${e.criterioId}');
                      }
                    });
                  });
                }
              });

              _jointActivityBloc.add(GetJointActivity(
                siteId: state.initialDataJointModel.siteId,
                propuestaTecnicaId:
                    state.initialDataJointModel.propuestaTecnicaId,
                actividadId: state.initialDataJointModel.actividadId,
                subActividadId: state.initialDataJointModel.subActividadId,
              ));
              _panelRegisterBloc
                  .add(GetPanelWelder(jointId: widget.params.joint.juntaId));
              _overseerBloc.add(
                  GetOverseer(employeeId: state.initialDataJointModel.caboId));
              _overseerWeldingBloc.add(GetInfoUserRol(
                  ficha: state.initialDataJointModel.soldaduraCaboId));

              // _acsBloc.add(GetACS());

              if (state.initialDataJointModel.confomadoLiberado)
                _qaBloc.add(GetQA(
                    employeeId: state.initialDataJointModel.inspectorCCAId));

              if (action == 'REPAIR' || action == 'CHANGEMATERIAL') {
                widget.params.joint.conformadoId =
                    state.initialDataJointModel.conformadoId;

                _traceabilityOneBloc.add(GetTraceabilityOne(
                  jointId: widget.params.joint.juntaId,
                  isTraceabilityOne: true,
                ));

                _traceabilityTwoBloc.add(GetTraceabilityTwo(
                  jointId: widget.params.joint.juntaId,
                  isTraceabilityOne: false,
                ));

                _pipefitterBloc
                    .add(GetPipefitters(jointId: widget.params.joint.juntaId));

                dateOne.text = '';
                hourOne.text = '';
                dateTwo.text = '';
                hourTwo.text = '';

                loadPhotographic();
              }

              if (saveFormingMessage != null && saveFormingMessage != '')
                _messageSuccess(saveFormingMessage);
            } else if (state is IsLoadingInitialDataJoint) {
              showGeneralLoading(context);
            }
          },
          builder: (context, state) {
            if (state is SuccessInitialDataJoint) {
              return _createJointDetail(context, state, orientation);
            }

            return Container(width: 0.0);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: new Icon(Icons.arrow_circle_up_outlined),
          isExtended: true,
          backgroundColor: Color.fromRGBO(3, 157, 252, .9),
          onPressed: () {
            controller.animateTo(0,
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
        ),
      );
    });
  }

  Widget _createJointDetail(
      context, InitialDataJointState state, Orientation orientation) {
    return MultiBlocListener(
      listeners: [
        // getACSListener(),
        listenerDates(),
        listenerGetTraceability(),
        listenerRemoveTraceabilityOne(),
        listenerAddTraceabilityOne(),
        listenerRemoveTraceabilityTwo(),
        listenerAddTraceabilityTwo(),
        listenerRemovePipefitter(),
        listenerAddPipefitter(),
        listenerSignPipefitter(),
        mensajesPanelesSoldadores(),
        listenerAddWelder(),
        listenerQualifyCaboNorm(),
        listenerJointTraceability(),
      ],
      child: SingleChildScrollView(
        controller: controller,
        child: Container(
          padding: EdgeInsets.all(5.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(height: 5.0),
            _jointCardHeader(),
            state.initialDataJointModel.actividadId == null
                ? _cardActivityNA(context)
                : _jointCardActivity(context, state),
            SizedBox(height: 5.0),
            DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _createJointTabBar(context),
                  _createJointTabBarView(state, orientation),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _jointCardHeader() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Container(
        padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RowBox(
                      titlePrincipal: 'Contrato:',
                      information:
                          '${widget.params.contract.contratoId}-${widget.params.contract.nombre}',
                    ),
                    RowBox(
                      titlePrincipal: 'WPS:',
                      information: '${widget.params.joint.claveWPS}',
                    ),
                    RowBox(
                      titlePrincipal: 'Tipo:',
                      information: '${widget.params.joint.tipoJunta}',
                    ),
                    RowBox(
                      titlePrincipal: 'Plano:',
                      information:
                          '${widget.params.plainDetail.numeroPlano} Rev. ${widget.params.plainDetail.revision} Hoja ${widget.params.plainDetail.hoja}',
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    RowBox(
                      titlePrincipal: 'Spool',
                      information: '${widget.params.joint.spoolEstructura}',
                    ),
                    RowBox(
                      titlePrincipal: 'Espesor',
                      information: '${widget.params.joint.espesor}',
                    ),
                    RowBox(
                      titlePrincipal: 'Frente',
                      information: '${widget.params.front.descripcion}',
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

  Widget _jointCardActivity(context, InitialDataJointState stateInitial) {
    return BlocBuilder<JointActivityBloc, ActivityJointState>(
        builder: (context, state) {
      if (state is IsLoadingActivityJoint) {
        return Container(
          height: 100,
          child: Center(child: spinkit),
        );
      }

      if (state is SuccessActivityJoint) {
        return Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              RowBox(
                                titlePrincipal: 'PartidaPU:',
                                information:
                                    state.activityJointModel.partidaPU.isEmpty
                                        ? 'N/A'
                                        : state.activityJointModel.partidaPU,
                              ),
                              RowBox(
                                titlePrincipal: 'Id Primavera:',
                                information:
                                    '${state.activityJointModel.primaveraId}',
                              ),
                              RowBox(
                                titlePrincipal: 'Actividad Cliente:',
                                information:
                                    '${state.activityJointModel.actividadCliente}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              RowBox(
                                titlePrincipal: 'Folio:',
                                information:
                                    '${state.activityJointModel.folio}',
                              ),
                              RowBox(
                                titlePrincipal: 'Partida Int.',
                                information:
                                    '${state.activityJointModel.partidaInterna}',
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
            _buttonActivity(context, stateInitial),
          ],
        );
      }
      return _cardActivityNA(context);
    });
  }

  Widget _buttonActivity(context, InitialDataJointState stateInitial) {
    return (userPermissionModel.weldingControlRelateActivityJoint
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (!stateInitial.initialDataJointModel.confomadoLiberado) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ActivitiesPage(params: widget.params),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                      top: 10, left: 140, right: 140, bottom: 10),
                  child: Text('Actividad',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ))
        : Container(height: 0.0));
  }

  Widget _createJointTabBar(BuildContext context) {
    return Container(
      child: TabBar(
        labelColor: Colors.blueAccent,
        unselectedLabelColor: Colors.black38,
        indicatorColor: Colors.blueAccent,
        controller: tabController,
        tabs: [
          Tab(text: 'Conformado'),
          Tab(text: 'Soldadura'),
          Tab(text: 'PND'),
        ],
      ),
    );
  }

  Widget _createJointTabBarView(
      InitialDataJointState stateInitial, Orientation orientation) {
    return (Container(
      height: 5000, //height of TabBarView
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Colors.blueAccent, width: 0.5))),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: TabBarView(
          controller: tabController,
          children: [
            _tabForming(orientation),
            stateInitial.initialDataJointModel.conformadoNorma == 'D/N'
                ? _tabFormingSoldadura()
                : _tabformingNotRelease(),
            _tabPND(),
          ],
        ),
      ),
    ));
  }

  Widget _tabForming(Orientation orientation) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (orientation == Orientation.portrait ? 220 : 230);
    final double itemWidth = size.width / 1.9;

    return (Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  formingReleased ||
                          !userPermissionModel.weldingControlEditTabConformado
                      ? Container(height: 0.0)
                      : Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(Icons.save_rounded),
                                  color: Colors.black45,
                                  iconSize: 40.0,
                                  onPressed: () => _saveDates(),
                                ),
                              ),
                            ),
                          ],
                        ),
                  Row(
                    children: <Widget>[
                      Expanded(child: Divider(thickness: 2.0)),
                      SizedBox(width: 5.0),
                      Text(
                        'C${consecutive.toString()}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(child: Divider(thickness: 2.0)),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: AlwaysDisabledFocusNode(),
                          controller: dateOne,
                          enabled: enableInput(),
                          onTap: () {
                            _selectDate(context, true);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            labelText: 'Fecha Inicio',
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: TextField(
                          focusNode: AlwaysDisabledFocusNode(),
                          controller: hourOne,
                          enabled: enableInput(),
                          onTap: () {
                            _selectTime(context, true);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            labelText: 'Hora Inicio',
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: TextField(
                          focusNode: AlwaysDisabledFocusNode(),
                          controller: dateTwo,
                          enabled: enableInput(),
                          onTap: () {
                            _selectDate(context, false);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            labelText: 'Fecha Fin',
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: TextField(
                          focusNode: AlwaysDisabledFocusNode(),
                          controller: hourTwo,
                          enabled: enableInput(),
                          onTap: () {
                            _selectTime(context, false);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            labelText: 'Hora Fin',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(child: Divider(thickness: 2.0)),
                      SizedBox(width: 5.0),
                      Text(
                        'Trazabilidades',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(child: Divider(thickness: 2.0)),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _traceabilityOneBlocBuilder()),
                      SizedBox(width: 20.0),
                      Expanded(child: _traceabilityTwoBlocBuilder()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(child: Divider(thickness: 2.0)),
                      SizedBox(width: 5.0),
                      Text(
                        'Tuberos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(child: Divider(thickness: 2.0)),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formingReleased
                          ? Container(height: 0.0)
                          : Expanded(
                              child: TextField(
                                obscureText: false,
                                controller: addPipefitter,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                onSubmitted: (value) =>
                                    _onSubmittedPipefitter(value),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: 'Tuberos',
                                  hintText: 'Ingrese la ficha...',
                                  alignLabelWithHint: true,
                                ),
                              ),
                            ),
                    ],
                  ),
                  formingReleased
                      ? Container(height: 0.0)
                      : SizedBox(height: 20.0),
                  _pipefitterBlocBuilder(itemWidth, itemHeight)
                ],
              ),
            ),
          ),
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(child: Divider(thickness: 2.0)),
                      SizedBox(width: 5.0),
                      Text(
                        'Cabo/Sobrestante',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(child: Divider(thickness: 2.0)),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _overseerBlocBuilder(),
                      ),
                      SizedBox(width: 20.0),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          //minLines: 1, //Normal textInputField will be displayed
                          maxLines: 5,
                          controller: comments,
                          enabled: !formingReleased,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            labelText: 'Observaciones',
                            hintText: 'Ingrese sus observaciones...',
                            alignLabelWithHint: true,
                          ), // when user presses enter it will adapt to it
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.topLeft,
              child: _builderImagenesLoad(),
            ),
          ),
          enableQACard()
              ? Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(child: Divider(thickness: 2.0)),
                            SizedBox(width: 5.0),
                            Text(
                              'Control de Calidad (CCA)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5.0),
                            Expanded(child: Divider(thickness: 2.0)),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _qaBlocBuilder(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Container(height: 0.0),
        ],
      ),
    ));
  }

  Widget _builderImagenesLoad() {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<EvidencePhotographicBloc, EvidencePhotographicState>(
        builder: (context, state) {
      if (state is SuccessCreateEvidencePhotographics) {
        loadPhotographic();
        showNotificationSnackBar(context,
            title: "",
            mensaje: "Se ha agregado una nueva evidencia fotográfica",
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.blue[300],
            ),
            secondsDuration: 3,
            colorBarIndicator: Colors.green,
            borde: 8);
      }

      if (state is SuccessDeleteEvidencePhotographics) {
        loadPhotographic();
        showNotificationSnackBar(context,
            title: "",
            mensaje: "Se ha eliminado la evidencia fotográfica",
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.blue[300],
            ),
            secondsDuration: 3,
            colorBarIndicator: Colors.green,
            borde: 8);
      }

      if (state is ErrorEvidencePhotographic) {
        showNotificationSnackBar(context,
            title: "Error mensaje",
            mensaje: state.errorMessage,
            icon: Icon(
              Icons.warning,
              size: 28.0,
              color: Colors.blue[300],
            ),
            secondsDuration: 3,
            colorBarIndicator: Colors.red,
            borde: 8);
      }

      return Row(
        children: [
          formingReleased ||
                  !userPermissionModel.weldingControlEditTabConformado
              ? Container(width: 0.0, height: 0.0)
              : Container(
                  width: size.width * 0.3,
                  height: 200,
                  child: Column(
                    children: [
                      Text(
                        "Evidencia Fotográfica",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                          onTap: () {
                            selectedPhotographic('FORMING');
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                    color: Colors.blue[300], width: 3.0),
                                borderRadius: BorderRadius.all(Radius.circular(
                                        50) //         <--- border radius here
                                    ),
                              ),
                              width: 100,
                              height: 100,
                              child: Icon(Icons.camera_enhance,
                                  size: 50, color: Colors.white)))
                    ],
                  )),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[200], width: 1.0),
              ),
              width: formingReleased ||
                      !userPermissionModel.weldingControlEditTabConformado
                  ? size.width * 0.92
                  : size.width * 0.62,
              height: 200,
              child: Column(
                children: [
                  Container(
                    color: Colors.blueAccent,
                    width: double.infinity,
                    height: 40,
                    child: Center(
                      child: Text(
                        "Imagenes",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        height: 150,
                        child: (state is SuccessGetEvidencePhotographics)
                            ? (state.lstPhotographics.length > 0)
                                ? ListView.builder(
                                    padding: EdgeInsets.only(left: 16),
                                    itemCount: state.lstPhotographics.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding:
                                              EdgeInsets.only(right: 4, top: 5),
                                          child: Row(
                                            children: [
                                              Container(
                                                child: PhotographicCard(
                                                  imagen: state
                                                      .lstPhotographics[index],
                                                  delete: deletePhotographic,
                                                  preview:
                                                      showPhotographicPreview,
                                                  readOnly: formingReleased ||
                                                      !userPermissionModel
                                                          .weldingControlEditTabConformado,
                                                ),
                                              ),
                                            ],
                                          ));
                                    })
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "Aún no se ha agregado ninguna imagen",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "OpenSans",
                                          ))
                                    ],
                                  )
                            : loadingCircular()),
                  )
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  Widget _tabformingNotRelease() {
    //Responsive responsive = Responsive(context);
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            height: 100,
            child: Container(
              child: Center(
                  child: Text("Es necesario liberar el proceso de conformado",
                      style: TextStyle(
                          fontSize: 23,
                          fontFamily: "OpenSans",
                          fontWeight: FontWeight.bold))),
            ),
          ),
          Container(
            color: Colors.white,
            width: double.infinity,
            height: 120,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  'assets/img/pipeline.png',
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _builderEvidenceFN() {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<EvidenceFNBloc, EvidenceFNState>(
      builder: (context, state) {
        if (state is SuccessCreateEvidenceTemporalFNs) {
          // if(lstPhothosTem.length == 0 ){
          // lstPhothosTem.addAll(_evidenceFNBloc.state.pics);
          // }
          lstPhothosTemAdd.add(new PhotographicEvidenceModel(
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
          lstPhothosTem.add(new PhotographicEvidenceModel(
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
          showNotificationSnackBar(
            context,
            title: "",
            mensaje: "Se ha agregado una nueva evidencia fotográfica",
            icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue[300]),
            secondsDuration: 3,
            colorBarIndicator: Colors.green,
            borde: 8,
          );
        }

        if (state is SuccessDeleteEvidenceFNs) {
          loadPhotographicFN(false);
          showNotificationSnackBar(
            context,
            title: "",
            mensaje: "Se ha eliminado la evidencia fotográfica",
            icon: Icon(Icons.info_outline, size: 28.0, color: Colors.blue[300]),
            secondsDuration: 3,
            colorBarIndicator: Colors.green,
            borde: 8,
          );
        }

        if (state is SuccessGetEvidenceFNs) {
          if (this.lstPhothosTem.length == 0) {
            lstPhothosTem.addAll(state.pics);
          }
        }

        if (state is SuccessCreateAllEvidenceFNs) {
          _visualInspection('F/N');
          // loadPhotographicFN(true);
        }

        if (state is ErrorEvidenceFN) {
          showNotificationSnackBar(
            context,
            title: "Error mensaje",
            mensaje: state.error,
            icon: Icon(Icons.warning, size: 28.0, color: Colors.blue[300]),
            secondsDuration: 3,
            colorBarIndicator: Colors.red,
            borde: 8,
          );
        }

        return Row(
          children: [
            initialDataJointModel.conformadoNorma == 'F/N'
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
                          onTap: () => selectedPhotographic('F/N'),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[200], width: 1.0),
              ),
              width: initialDataJointModel.conformadoNorma == 'F/N'
                  ? size.width * 0.78
                  : size.width * 0.58,
              height: 200,
              child: Column(
                children: [
                  Container(
                    color: Colors.blueAccent,
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
                    child: (state is SuccessGetEvidenceFNs)
                        ? (state.pics.length > 0)
                            ? ListView.builder(
                                padding: EdgeInsets.only(left: 16),
                                itemCount: state.pics.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding:
                                          EdgeInsets.only(right: 4, top: 5),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: PhotographicCard(
                                              imagen: state.pics[index],
                                              delete: deletePhotographicFN,
                                              preview: showPhotographicPreview,
                                              readOnly: initialDataJointModel
                                                          .conformadoNorma ==
                                                      'F/N'
                                                  ? true
                                                  : false,
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

  void selectedPhotographic(String place) {
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
                  addPhotographicGallery(place);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Camera"),
                onTap: () {
                  addPhotographicCamera(place);
                },
              ),
            ],
          );
        });
  }

  void showPhotographicPreview(String content) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DetailScreen(bytes: base64.decode(content));
    }));
  }

  Widget _tabFormingSoldadura() {
    final Responsive responsive = Responsive.of(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            weldingReleased != 1
                ? Card(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 0.0),
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
                                        fontSize: responsive.dp(1.4),
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                  ),
                                  child: TextField(
                                    enabled: userPermissionModel
                                        .weldingControlTabSoldadura,
                                    controller: addWelder,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () => addWelder.clear(),
                                        icon: weldingReleased == 1
                                            ? Icon(Icons.check_outlined)
                                            : Icon(Icons.clear),
                                      ),
                                      labelText:
                                          'Ingrese el número de ficha del soldador',
                                      hintText: 'Número de ficha...',
                                      alignLabelWithHint: true,
                                    ),
                                    onSubmitted: (value) {
                                      var addWelderModel =
                                          new AddCardWelderParams(
                                              card: value,
                                              jointId:
                                                  widget.params.joint.juntaId,
                                              consecutiveWeldingFN: '',
                                              consecutiveWelding:
                                                  initialDataJointModel
                                                      .soldaduraConsecutivo);
                                      _onSubmittedAddWelder(addWelderModel);
                                      value = null;
                                      addWelder.text = '';
                                    },
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
                                iconSize: 40.0,
                                color: Colors.blue,
                                //alignment: Alignment.topCenter,
                                onPressed: () => _saveGeneralInfo(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    child: Row(
                      children: [
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.save_outlined),
                            iconSize: 40.0,
                            color: Colors.blue,
                            //alignment: Alignment.topCenter,
                            onPressed: () => _saveGeneralInfo(),
                          ),
                        ))
                      ],
                    ),
                  ),
            Container(
              child: builderListSoldadores(),
            ),
          ],
        ),
      ),
    );
  }

  Widget builderListSoldadores() {
    final Responsive responsive = Responsive.of(context);

    return Column(
      children: [
        (lstActividadesSoldadureas.length > 0 &&
                initialDataJointModel.conformadoNorma == "D/N")
            ? Column(
                children: [
                  ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        lstActividadesSoldadureas[index].isExpanded =
                            !lstActividadesSoldadureas[index].isExpanded;
                      });
                    },
                    children: lstActividadesSoldadureas.map((item) {
                      return ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      item.nombreSoldador, //nombreSoldador
                                      style: TextStyle(
                                        fontSize: responsive.dp(1.3),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      item.norma == 'D/N'
                                          ? 'D/N'
                                          : (item.norma == 'F/N')
                                              ? 'F/N'
                                              : '',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: item.norma == 'D/N'
                                        ? Colors.green
                                        : (item.norma == 'F/N')
                                            ? Colors.red
                                            : Colors.white,
                                    shadowColor: Colors.grey[60],
                                    padding: EdgeInsets.all(8.0),
                                  ),
                                ],
                              ),
                            );
                          },
                          isExpanded: item.isExpanded,
                          body: WelderExpandPage(
                              user: user,
                              userPermissionModel: userPermissionModel,
                              item: item,
                              tipoJunta: widget.params.joint.tipoJunta,
                              weldingReleased: weldingReleased,
                              consecutivoSoldadura:
                                  initialDataJointModel.soldaduraConsecutivo,
                              criteriosAC: lstActividadesSoldadureas
                                  .map((item) => item.criteriosAceptacion)
                                  .toList(),
                              folioSoldaduras: lstActividadesSoldadureas
                                  .map((item) =>
                                      '${item.soldadorId}|${item.folioSoldadura}')
                                  .toList(),
                              folioSoldaduraFN: '${item.folioSoldadura}|FN',
                              scrollControler: controller,
                              plainDetailId: widget.params.plainDetailSelection,
                              frontId: widget.params.frontSelection,
                              state: widget.params.stateFiltered,
                              index: lstActividadesSoldadureas.indexOf(item)));
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Card(
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Container(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: weldingReleased == 1
                                    ? BlocBuilder<UserRolBloc, UserRolState>(
                                        builder: (context, state) {
                                          if (state is SuccessGetUserRol) {
                                            return CardReleasedOverseer(
                                              name: state.userGeneral.nombre,
                                              initials: _getInitials(
                                                  state.userGeneral.nombre),
                                              category:
                                                  state.userGeneral.puesto,
                                              ficha: state.userGeneral.ficha
                                                  .toString(),
                                              released: () {},
                                              weldingReleased: weldingReleased,
                                            );
                                          }
                                          return Container();
                                        },
                                      )
                                    : CardReleasedOverseer(
                                        name: user.nombre,
                                        initials: _getInitials(user.nombre),
                                        category: user.puestoDescripcion,
                                        ficha: user.ficha,
                                        released: () {
                                          confirmModal(
                                              context,
                                              '¿Desea continuar con el proceso de liberación para inspección visual de soldadura?',
                                              'Liberar',
                                              positiveAction: () =>
                                                  _releaseWelding(
                                                      int.parse(user.ficha),
                                                      initialDataJointModel
                                                          .soldaduraId));
                                        }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      weldingFNNorm &&
                              userPermissionModel.weldingControlChangeMaterials
                          ? CardChangeMaterial(
                              onpressedNotchanged: () => changeMaterial(
                                false,
                                widget.params.joint.juntaId,
                                '¿Está seguro que No requiere cambio de material?',
                                initialDataJointModel.soldaduraId,
                              ),
                              onpressedYesChanged: () => changeMaterial(
                                true,
                                widget.params.joint.juntaId,
                                '¿Está seguro que Si requiere cambio de material?',
                                initialDataJointModel.soldaduraId,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 80,
                    child: Container(
                      child: Center(
                          child: Text("Ningún soldador agregado",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "OpenSans",
                                  fontWeight: FontWeight.bold))),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 120,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.asset(
                          'assets/img/weld.png',
                          color: Colors.black,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: responsive.dp(4)),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Soldadores",
                              style: TextStyle(
                                fontSize: responsive.dp(2.4),
                                color: Colors.white30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
      ],
    );
  }

  Widget _tabPND() {
    return (Container(
      padding: EdgeInsets.all(5.0),
      child: ListView(
        children: [
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: _ndtProgressBlocBuilder(),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _createCardPipefitter(PipefitterModel item) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
              title: Text(item.nombre, style: TextStyle(color: Colors.black)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Text(item.ficha.toString()),
                  SizedBox(height: 5.0),
                  Text(item.puestoDescripcion),
                ],
              ),
            ),
            item.firmado ? _signedPipefitter() : _buttonsPipefitter(item),
          ],
        ),
      ),
    );
  }

  Widget _createCardOverseer(EmployeeModel overseer) {
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
                backgroundColor: Colors.orange,
                child: Text(
                  _getInitials(
                      overseer != null ? overseer.nombre : user.nombre),
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              title: Text(
                overseer != null ? overseer.nombre : user.nombre,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    overseer != null ? overseer.ficha.toString() : user.ficha,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    overseer != null
                        ? overseer.puestoDescripcion
                        : user.puestoDescripcion,
                  ),
                ],
              ),
            ),
            formingReleased
                ? _signedPipefitter()
                : Container(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text('Liberar',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () => confirmModal(
                                context,
                                '¿Desea continuar con el proceso de liberación para inspección visual del conformado?',
                                'Liberar',
                                positiveAction: () => _releaseForming(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _createCardQA(EmployeeModel overseer) {
    return Card(
      margin: EdgeInsets.all(0.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: formingNorm == 'D/N'
          ? Colors.blue[700]
          : formingNorm == 'F/N'
              ? Colors.red[700]
              : Colors.white,
      elevation: 5.0,
      child: GestureDetector(
        onTap: () => formingNorm == 'D/N' ? {} : outOfNormModal(),
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text(
                    _getInitials(
                        overseer != null ? overseer.nombre : user.nombre),
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                title: Text(
                  overseer != null ? overseer.nombre : user.nombre,
                  style: TextStyle(
                      color: formingNorm == 'D/N' || formingNorm == 'F/N'
                          ? Colors.white
                          : Colors.black),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      overseer != null ? overseer.ficha.toString() : user.ficha,
                      style: TextStyle(
                        color: formingNorm == 'D/N' || formingNorm == 'F/N'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      overseer != null
                          ? overseer.puestoDescripcion
                          : user.puestoDescripcion,
                      style: TextStyle(
                        color: formingNorm == 'D/N' || formingNorm == 'F/N'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              formingNorm == 'D/N' || formingNorm == 'F/N'
                  ? Container(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        left: 10.0,
                        right: 10.0,
                        bottom: 20.0,
                      ),
                      child: Text(
                        formingNorm == 'D/N'
                            ? 'D/N (Dentro de Norma)'
                            : 'F/N (Fuera de Norma)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    )
                  : Container(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text('F/N',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  if (userPermissionModel
                                      .weldingControlInspVisualConformado) {
                                    confirmModal(
                                      context,
                                      '¿Desea continuar con el proceso de calificación de inspección visual como fuera de norma?',
                                      'Aceptar',
                                      positiveAction: () => outOfNormModal(),
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Expanded(
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text('D/N',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  if (userPermissionModel
                                      .weldingControlInspVisualConformado) {
                                    confirmModal(
                                      context,
                                      '¿Desea continuar con el proceso de calificación de inspección visual como dentro de norma?',
                                      'Aceptar',
                                      positiveAction: () =>
                                          _visualInspection('D/N'),
                                    );
                                  }
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
      ),
    );
  }

  void outOfNormModal() {
    this.lstPhothosTemAdd = [];
    this.lstPhothosTem = [];
    this.lstPhothosTemEliminados = [];
    loadPhotographicFN(true);
    reasson.text = initialDataJointModel.motivoFN;

    contentModal(
      context,
      'Conformado F/N',
      initialDataJointModel.conformadoNorma == 'F/N' ? 'Reparar' : 'Aceptar',
      contentBody: _outOfNormForm(),
      positiveAction: () => initialDataJointModel.conformadoNorma == 'F/N'
          ? confirmModal(
              context,
              '¿Desea continuar con el proceso de reparación?',
              'Aceptar',
              positiveAction: () => _repair(),
            )
          : _validateFormFN(),
    );
  }

  Widget _outOfNormForm() {
    Responsive responsive = Responsive(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        initialDataJointModel.conformadoNorma == 'F/N'
            ? Container(
                child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      //DecorationImage
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 1,
                      ), //Border.all
                    ), //BoxDecoration
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Motivo(s) de Rechazo',
                      style: TextStyle(
                        fontSize: responsive.dp(1.4),
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      //DecorationImage
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ), //Border.all
                    ), //BoxDecoration
                    alignment: Alignment.bottomLeft,
                    child: chipList(),
                  )
                ],
              ))
            : MultiSelectBottomSheetField<AcceptanceCriteriaconformadoModel>(
                buttonIcon: Icon(Icons.account_tree_outlined),
                searchable: true,
                key: _multiSelectKey,
                initialChildSize: 0.7,
                maxChildSize: 0.75,
                title: Text("Motivo(s) de Rechazo"),
                buttonText: Text("Motivo(s) de Rechazo"),
                items: items,
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return "Es requerido!!";
                  }
                  return null;
                },
                onConfirm: (values) {
                  setState(() {
                    listCriterosConformadoFull = values;
                  });
                  _multiSelectKey.currentState.validate();
                },
                chipDisplay: MultiSelectChipDisplay(
                  chipColor: Colors.blueAccent,
                  textStyle: TextStyle(color: Colors.white),
                  onTap: (item) {
                    setState(() {
                      listCriterosConformadoFull.remove(item);
                    });
                    _multiSelectKey.currentState.validate();
                  },
                ),
              ),
        SizedBox(height: 20.0),
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.multiline,
                //minLines: 1, //Normal textInputField will be displayed
                maxLines: 5,
                controller: reasson,
                enabled: initialDataJointModel.conformadoNorma == 'F/N'
                    ? false
                    : true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  labelText: 'Motivo',
                  hintText: 'Ingrese sus observaciones...',
                  alignLabelWithHint: true,
                ), // when user presses enter it will adapt to it
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        _builderEvidenceFN(),
        SizedBox(height: 10.0),
      ],
    );
  }

  chipList() {
    return Wrap(
        spacing: 6.0,
        runSpacing: 6.0,
        children: listaOriginal.isEmpty
            ? [
                Container(
                  padding: EdgeInsets.all(3),
                  child: Text('Sin criterios!'),
                )
              ]
            : listaOriginal.map((e) => _buildChip(e)).toList());
  }

  Widget _buildChip(String label) {
    return Chip(
      labelPadding: EdgeInsets.all(2.0),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blueAccent,
      elevation: 1.0,
      shadowColor: Colors.grey[60],
      padding: EdgeInsets.all(8.0),
    );
  }

  Widget _createCardTraceability(
      TraceabilityByJointModel item, bool isTraceabilityOne) {
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
                item.idTrazabilidad,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Text('C. SAP: ${item.material}'),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(child: Text('Volumen: ${item.cantidadUsada}')),
                      SizedBox(width: 5.0),
                      Expanded(child: Text('UoM: ${item.uM}')),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text('${item.materialDescrBreve}'),
                ],
              ),
            ),
            formingReleased
                ? _signedPipefitter()
                : Container(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          primary: userPermissionModel
                                  .weldingControlEditTabConformado
                              ? Colors.red
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text('Remover',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (userPermissionModel
                              .weldingControlEditTabConformado) {
                            _deleteTraceability(
                                item.idTrazabilidad, isTraceabilityOne);
                          }
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _handleTabChange() {
    if (tabController.index == 2) {
      _ndtProgressBloc.add(
        GetNDTProgress(jointId: widget.params.joint.juntaId),
      );
    }
  }

  _onSubmittedTraceability(String traceabilityId, bool isTraceabilityOne) {
    //german
    if (traceabilityId.isEmpty) {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje: 'No se ha proporcionado ninguna trazabilidad!',
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
        secondsDuration: 4,
        colorBarIndicator: Colors.red,
        borde: 8,
      );
    } else {
      JointTraceabilityParams params = JointTraceabilityParams(
          traceabilityId: traceabilityId.toUpperCase(),
          isTraceabilityOne: isTraceabilityOne,
          obraId: widget.params.workSelection);

      _jointTraceabilityBloc.add(GetJointTraceability(params: params));
      _traceabilityBloc.add(GetTraceabilityById(
        traceabilityId: traceabilityId.toUpperCase(),
        isTraceabilityOne: isTraceabilityOne,
      ));

      // Recordar llamar el evento que nos recupera las trazabilidades!!
      _workTraceabilityBloc
          .add(GetWorkTR(contratoId: widget.params.contractSelection));
    }
  }

  _onSubmittedAddWelder(AddCardWelderParams addCardWelderParams) {
    if (addCardWelderParams.card.isEmpty) {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje: 'No se ha proporcionado ninguna ficha!',
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
        secondsDuration: 4,
        colorBarIndicator: Colors.red,
        borde: 8,
      );
    } else {
      _addWelderBloc.add(AddWelderWPSValid(addCardWelder: addCardWelderParams));
    }
  }

  BlocListener listenerAddWelder() {
    return BlocListener<AddWelderBloc, AddWelderState>(
        listener: (context, state) {
      if (state is IsLoadingAddWelderWPSValid) {
        return loadingCircular();
      }

      if (state is SuccessAddWelderWPSValid) {
        if (state.addWelderModelResponse.actionResult == 'success') {
          showNotificationSnackBar(context,
              title: "",
              mensaje: state.addWelderModelResponse.message,
              icon: Icon(
                Icons.check_circle_outline_sharp,
                size: 28.0,
                color: Colors.green[300],
              ),
              secondsDuration: 3,
              colorBarIndicator: Colors.green,
              borde: 8);
          setState(() {
            weldingReleased = 0;
          });
          _panelRegisterBloc
              .add(GetPanelWelder(jointId: widget.params.joint.juntaId));
        }

        if (state.addWelderModelResponse.actionResult == 'error') {
          showNotificationSnackBar(context,
              title: "",
              mensaje: state.addWelderModelResponse.message,
              icon: Icon(
                Icons.warning,
                size: 28.0,
                color: Colors.yellow[300],
              ),
              secondsDuration: 3,
              colorBarIndicator: Colors.yellow,
              borde: 8);
        }

        if (state.addWelderModelResponse.actionResult == 'inactivo') {
          var addCardWelderParams = new AddCardWelderParams(
              card: state
                  .addWelderModelResponse.empleadoSoldadorNotValidModel.ficha,
              jointId: widget.params.joint.juntaId,
              consecutiveWeldingFN: state.addWelderModelResponse
                  .empleadoSoldadorNotValidModel.folioSoldaduraFN,
              consecutiveWelding: initialDataJointModel.soldaduraConsecutivo,
              acceptInactiveWelder: true);
          confirmModal(
            context,
            'El soldador con No de Ficha ${state.addWelderModelResponse.empleadoSoldadorNotValidModel.ficha} se encuentra inactivo. ¿Desea ingresar al soldador de todas formas?',
            'Aceptar',
            positiveAction: () {
              _addWelderBloc
                  .add(AddWelderWPSValid(addCardWelder: addCardWelderParams));
            },
          );
        }

        if (state.addWelderModelResponse.actionResult == 'no-vigente') {
          var data = AddCardWelderNotValidParams(
            jointId: widget.params.joint.juntaId,
            welderId: state.addWelderModelResponse.empleadoSoldadorNotValidModel
                .soldadorId,
            weldingId: state.addWelderModelResponse
                .empleadoSoldadorNotValidModel.soldaduraId,
            name: state
                .addWelderModelResponse.empleadoSoldadorNotValidModel.nombre,
            card: state
                .addWelderModelResponse.empleadoSoldadorNotValidModel.ficha,
            category: state
                .addWelderModelResponse.empleadoSoldadorNotValidModel.categoria,
            consecutiveWeldingFN: state.addWelderModelResponse
                .empleadoSoldadorNotValidModel.folioSoldaduraFN,
            consecutiveWelding: state.addWelderModelResponse
                .empleadoSoldadorNotValidModel.consecutivo,
          );
          confirmModal(
            context,
            'El WPS requerido no está vigente para el soldador con No de Ficha ${state.addWelderModelResponse.empleadoSoldadorNotValidModel.ficha} ¿Desea ingresar al soldador de todas formas?',
            'Aceptar',
            positiveAction: () {
              _addWelderBloc
                  .add(AddWelderWPSNotValid(addCardWelderNotValidParams: data));
            },
          );
        }
      }

      if (state is SucessAddWeldingWPSNotValid) {
        showNotificationSnackBar(context,
            title: "",
            mensaje: 'Soldador agregado correctamente!',
            icon: Icon(
              Icons.check_circle_outline_sharp,
              size: 28.0,
              color: Colors.green[300],
            ),
            secondsDuration: 3,
            colorBarIndicator: Colors.green,
            borde: 8);
        setState(() {
          weldingReleased = 0;
        });
        _panelRegisterBloc
            .add(GetPanelWelder(jointId: widget.params.joint.juntaId));
      }

      if (state is ErrorAddWelderWPSValid) {
        showNotificationSnackBar(context,
            title: "",
            mensaje: 'Upps!, al parecer ocurrio un error',
            icon: Icon(
              Icons.warning,
              size: 28.0,
              color: Colors.red[300],
            ),
            secondsDuration: 3,
            colorBarIndicator: Colors.red,
            borde: 8);
      }

      if (state is ErrorAddWeldingWPSNotValid) {
        showNotificationSnackBar(context,
            title: "",
            mensaje: 'Upps!, al parecer ocurrio un error',
            icon: Icon(
              Icons.warning,
              size: 28.0,
              color: Colors.red[300],
            ),
            secondsDuration: 3,
            colorBarIndicator: Colors.red,
            borde: 8);
      }
    });
  }

  Widget _cardActivityNA(context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivitiesPage(params: widget.params),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Container(
              padding:
                  EdgeInsets.only(top: 10, left: 140, right: 140, bottom: 10),
              child: Text('Seleccionar Actividad',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardMessageActivity() {
    //Responsive responsive = Responsive(context);
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            width: double.infinity,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  'assets/img/petition.png',
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BlocBuilder _traceabilityOneBlocBuilder() {
    return BlocBuilder<TraceabilityOneBloc, TraceabilityOneState>(
        builder: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is SuccessTraceabilityOne) {
        return state.traceabilityOne != null
            ? _createCardTraceability(state.traceabilityOne, true)
            : Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: TextField(
                        obscureText: false,
                        enabled:
                            userPermissionModel.weldingControlEditTabConformado,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          labelText: 'Trazabilidad 1',
                          hintText: 'Ingrese la trazabilidad 1...',
                          alignLabelWithHint: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]'),
                          )
                        ],
                        onSubmitted: (value) =>
                            _onSubmittedTraceability(value, true),
                      )),
                  Expanded(
                    child: SizedBox(
                      height: 58,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _existingElement = null;
                          });
                          _existingElementBloc.add(
                              GetExistingElement(idElementoExistente: null));

                          showPopover(
                            context: context,
                            bodyBuilder: (context) => Padding(
                                padding: EdgeInsets.all(8.0),
                                child: _selectEE(true)),
                            direction: PopoverDirection.bottom,
                            width: 400,
                            arrowHeight: 15,
                            arrowWidth: 30,
                          );
                        },
                        child: Text('EE'),
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.blue),
                      ),
                    ),
                  )
                ],
              );
      } else if (state is ErrorTraceabilityOne) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }

      return loadingCircular();
    });
  }

  BlocBuilder _traceabilityTwoBlocBuilder() {
    return BlocBuilder<TraceabilityTwoBloc, TraceabilityTwoState>(
        builder: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is SuccessTraceabilityTwo) {
        return state.traceabilityTwo != null
            ? _createCardTraceability(state.traceabilityTwo, false)
            : Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: TextField(
                        obscureText: false,
                        enabled:
                            userPermissionModel.weldingControlEditTabConformado,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Trazabilidad 2',
                          hintText: 'Ingrese la trazabilidad 2...',
                          alignLabelWithHint: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]'),
                          )
                        ],
                        onSubmitted: (value) =>
                            _onSubmittedTraceability(value, false),
                      )),
                  Expanded(
                    child: SizedBox(
                      height: 58,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _existingElement = null;
                          });
                          _existingElementBloc.add(
                              GetExistingElement(idElementoExistente: null));

                          showPopover(
                            context: context,
                            bodyBuilder: (context) => Padding(
                                padding: EdgeInsets.all(8.0),
                                child: _selectEE(false)),
                            direction: PopoverDirection.bottom,
                            width: 400,
                            arrowHeight: 15,
                            arrowWidth: 30,
                          );
                        },
                        child: Text('EE'),
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.blue),
                      ),
                    ),
                  )
                ],
              );
      } else if (state is ErrorTraceabilityTwo) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }

      return loadingCircular();
    });
  }

  BlocBuilder _selectEE(bool value) {
    return BlocBuilder<ExistingElementBloc, ExistingElementState>(
        builder: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      switch (state.runtimeType) {
        case IsLoadingExistingElement:
          return _dropDownSearch("", "", "");
          break;
        case ErrorExistingElement:
          Navigator.of(context).pop();

          showNotificationSnackBar(
            context,
            title: "",
            mensaje: state.message,
            icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
            secondsDuration: 8,
            colorBarIndicator: Colors.red,
            borde: 8,
          );
          break;
        case SuccessExistingElement:
          return DropdownSearch<ExistingElementModel>(
            showSearchBox: true,
            itemAsString: (ExistingElementModel u) =>
                u.idElementoExistente + ' ' + u.materialDescrBreve,
            mode: Mode.MENU,
            hint: '[Buscar]',
            label: 'Elemento Existente',
            items: state.existingElement,
            selectedItem: _existingElement,
            onChanged: (obj) {
              setState(() {
                _existingElement = obj;
                _onSubmittedTraceability(obj.idElementoExistente, value);
                Navigator.of(context).pop();
              });
            },
            //onFind: (String text) => _filter(text),
          );
          break;
      }

      return _dropDownSearch("Elemento Existente", "[Buscar]", "");
    });
  }

  Widget _dropDownSearch(String title, String hintTitle, String message) {
    return DropdownSearch<String>(
        mode: Mode.MENU,
        hint: hintTitle,
        label: title,
        items: message == "" ? [] : [message]);
  }

  BlocBuilder _pipefitterBlocBuilder(double itemWidth, double height) {
    return BlocBuilder<PipefitterBloc, PipefitterState>(
        builder: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is SuccessPipefitters) {
        return state.pipefitters.isNotEmpty
            ? Container(
                child: GridView.count(
                crossAxisCount:
                    2, //orientation == Orientation.portrait || size.width < 800 ? 2 : 3,
                childAspectRatio: (itemWidth / height),
                // controller: new ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: List.generate(state.pipefitters.length, (index) {
                  return _createCardPipefitter(state.pipefitters[index]);
                }),
              ))
            : Container(height: 0.0);
      } else if (state is ErrorPipefitters) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }

      return loadingCircular();
    });
  }

  BlocBuilder _overseerBlocBuilder() {
    return BlocBuilder<OverseerBloc, OverseerState>(builder: (context, state) {
      if (state is InitialOverseerState) {
        return Container();
      } else if (state is SuccessGetOverseer) {
        return _createCardOverseer(state.overseer);
      } else if (state is ErrorOverseer) {
        return Container(child: Center(child: Text('${state.error}')));
      }

      return loadingCircular();
    });
  }

  BlocBuilder _qaBlocBuilder() {
    return BlocBuilder<QABloc, QAState>(builder: (context, state) {
      if (state is InitialQAState) {
        return Container();
      } else if (state is SuccessGetQA) {
        return _createCardQA(state.qa);
      } else if (state is ErrorQA) {
        return Container(child: Center(child: Text('${state.error}')));
      }

      return loadingCircular();
    });
  }

  BlocBuilder _ndtProgressBlocBuilder() {
    return BlocBuilder<NDTProgressBloc, NDTProgressState>(
        builder: (context, state) {
      if (state is InitialNDTProgressState) {
        return Container();
      } else if (state is SuccessNDTProgress) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: _columnsNDTProgress(),
            rows: _rowsNDTProgress(state.jointNDTProgress),
          ),
        );
      } else if (state is ErrorNDTProgress) {
        return Container(child: Center(child: Text('${state.error}')));
      }

      return loadingCircular();
    });
  }

  List<DataRow> _rowsNDTProgress(List<NDTProgressModel> progress) {
    List<DataRow> rows = [];

    progress.forEach((item) {
      rows.add(
        DataRow(
          cells: [
            DataCell(
              Container(
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: item.folioPND == 'Pendiente' ||
                          item.evaluacion == 'Pendiente'
                      ? Colors.grey
                      : item.evaluacion == 'D/N'
                          ? Colors.green
                          : Colors.red,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(""),
              ),
            ),
            DataCell(Text(item.clave)),
            DataCell(Text(item.folioPND)),
            DataCell(Text(item.fechaPND)),
            DataCell(Text(item.noTarjeta)),
            DataCell(Text(item.nombre)),
            DataCell(Text(item.evaluacion)),
          ],
        ),
      );
    });

    return rows;
  }

  List<DataColumn> _columnsNDTProgress() {
    List<DataColumn> columns = [];
    List<String> labels = [
      '',
      'PND',
      'Folio PND',
      'Fecha PND',
      'Tarjeta',
      'Soldador',
      'Evaluación',
    ];

    labels.forEach((item) => columns.add(DataColumn(label: Text(item))));

    return columns;
  }

  void _deleteTraceability(String traceabilityId, bool isTraceabilityOne) {
    TraceabilityDeleteParamsModel params = TraceabilityDeleteParamsModel(
      juntaId: widget.params.joint.juntaId,
      idTrazabilidad: traceabilityId,
      trazabilidad1: isTraceabilityOne,
    );

    confirmModal(
      context,
      '¿Está seguro de eliminar la trazabilidad ${params.idTrazabilidad}?',
      'Aceptar',
      positiveAction: () => _traceabilityAcept(params),
    );
  }

  void _traceabilityAcept(TraceabilityDeleteParamsModel params) {
    params.trazabilidad1
        ? _traceabilityOneRemoveBloc.add(DeleteTraceabilityOne(params: params))
        : _traceabilityTwoRemoveBloc.add(DeleteTraceabilityTwo(params: params));
  }

  BlocListener listenerDates() {
    return BlocListener<DatesBloc, DatesState>(listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingDates) {
        showGeneralLoading(context);
      } else if (state is SuccessDates) {
        Navigator.pop(context);
        updateJointsWC();
        _initialDataJoint
            .add(GetInitialDataJoint(juntaId: widget.params.joint.juntaId));
        saveFormingMessage = state.message;
        action = state.action;
      } else if (state is ErrorDates) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener listenerRemoveTraceabilityOne() {
    return BlocListener<TraceabilityOneRemoveBloc, TraceabilityOneRemoveState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsDeletingTraceabilityOneRemove) {
        showGeneralLoading(context);
      } else if (state is SuccessTraceabilityOneRemove) {
        Navigator.pop(context);

        _traceabilityOneBloc.add(
          GetTraceabilityOne(
            jointId: widget.params.joint.juntaId,
            isTraceabilityOne: true,
          ),
        );

        _messageSuccess('La trazabilidad fue eliminada con éxito.');
      } else if (state is ErrorTraceabilityOneRemove) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener listenerRemoveTraceabilityTwo() {
    return BlocListener<TraceabilityTwoRemoveBloc, TraceabilityTwoRemoveState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsDeletingTraceabilityTwoRemove) {
        showGeneralLoading(context);
      } else if (state is SuccessTraceabilityTwoRemove) {
        Navigator.pop(context);

        _traceabilityTwoBloc.add(
          GetTraceabilityTwo(
            jointId: widget.params.joint.juntaId,
            isTraceabilityOne: false,
          ),
        );

        _messageSuccess('La trazabilidad fue eliminada con éxito.');
      } else if (state is ErrorTraceabilityTwoRemove) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener listenerGetTraceability() {
    return BlocListener<TraceabilityBloc, TraceabilityState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingTraceabilityById) {
        showGeneralLoading(context);
      } else if (state is SuccessTraceabilityById) {
        Navigator.pop(context);
        _showTraceabilityModal(state.traceability, state.isTraceabilityOne);
      } else if (state is ErrorTraceabilityById) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.errorMessage,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener listenerAddTraceabilityOne() {
    return BlocListener<TraceabilityOneAddBloc, TraceabilityOneAddState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (state is IsAddingTraceabilityOne) {
        showGeneralLoading(context);
      } else if (state is SuccessTraceabilityOneAdd) {
        Navigator.pop(context);
        _traceabilityOneBloc.add(GetTraceabilityOne(
          jointId: widget.params.joint.juntaId,
          isTraceabilityOne: true,
        ));
        _messageSuccess('La trazabilidad fue agregada con éxito.');
      } else if (state is ErrorTraceabilityOneAdd) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener listenerAddTraceabilityTwo() {
    return BlocListener<TraceabilityTwoAddBloc, TraceabilityTwoAddState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (state is IsAddingTraceabilityTwo) {
        showGeneralLoading(context);
      } else if (state is SuccessTraceabilityTwoAdd) {
        Navigator.pop(context);

        _traceabilityTwoBloc.add(GetTraceabilityTwo(
          jointId: widget.params.joint.juntaId,
          isTraceabilityOne: false,
        ));

        _messageSuccess('La trazabilidad fue agregada con éxito.');
      } else if (state is ErrorTraceabilityTwoAdd) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener listenerRemovePipefitter() {
    return BlocListener<PipefitterRemoveBloc, PipefitterRemoveState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (state is IsRemovingPipefitter) {
        showGeneralLoading(context);
      } else if (state is SuccessPipefitterRemove) {
        Navigator.pop(context);

        updateJointsWC();

        _pipefitterBloc.add(
          GetPipefitters(jointId: widget.params.joint.juntaId),
        );

        _messageSuccess('El tubero fue removido con éxito.');
      } else if (state is ErrorPipefitterRemove) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener listenerJointTraceability() {
    return BlocListener<JointTraceabilityBloc, JointTraceabilityState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is ErrorJointTraceability) {
        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener listenerAddPipefitter() {
    return BlocListener<PipefitterAddBloc, PipefitterAddState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (state is IsAddingPipefitter) {
        showGeneralLoading(context);
      } else if (state is SuccessPipefitterAdd) {
        Navigator.pop(context);

        addPipefitter.text = '';
        updateJointsWC();
        _pipefitterBloc
            .add(GetPipefitters(jointId: widget.params.joint.juntaId));
        _messageSuccess('El tubero fue agregado con éxito.');
      } else if (state is ErrorPipefitterAdd) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener listenerSignPipefitter() {
    return BlocListener<PipefitterSignBloc, PipefitterSignState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (state is IsSigningPipefitter) {
        showGeneralLoading(context);
      } else if (state is SuccessPipefitterSign) {
        Navigator.pop(context);

        _pipefitterBloc
            .add(GetPipefitters(jointId: widget.params.joint.juntaId));
        _messageSuccess('La firma fue agregada con éxito.');
      } else if (state is ErrorPipefitterSign) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener mensajesPanelesSoldadores() {
    return BlocListener<PanelRegisterBloc, PanelRegisterWelderState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is SuccessPanelRegisterWelder) {
        var fnList = state.actividadesSoldaduraModel
            .where((item) => item.norma == "F/N");

        var totalNorm = state.actividadesSoldaduraModel
            .where((item) => item.norma == "D/N" || item.norma == 'F/N');

        var totalNoAplica = state.actividadesSoldaduraModel
            .where((item) => item.cambioMaterial == 'PENDIENTE');

        if (totalNorm.length == state.actividadesSoldaduraModel.length) {
          if (fnList.length > 0 && totalNoAplica.length > 0) {
            setState(() {
              weldingFNNorm = true;
            });
          } else {
            weldingFNNorm = false;
          }
        }

        setState(() {
          lstActividadesSoldadureas = state.actividadesSoldaduraModel;
        });

        BlocProvider.of<PanelRegisterBloc>(context)
            .state
            .actividadesSoldaduraUpdatearams = [];

        controller.animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }

      if (state is SuccessUpdateRegisterWelding) {
        if (isSaveGeneral) {
          showNotificationSnackBar(
            context,
            title: "",
            mensaje:
                'La información de los soldadores, se actualizó correctamente',
            icon: Icon(Icons.check_circle_outline,
                size: 28.0, color: Colors.green),
            secondsDuration: 5,
            colorBarIndicator: Colors.green,
            borde: 8,
          );
          isSaveGeneral = false;
        }
      }

      if (state is SuccessReleaseCaboOfWelding) {
        Future.delayed(
            Duration(seconds: 1),
            () => setState(() {
                  _initialDataJoint.add(GetInitialDataJoint(
                      juntaId: widget.params.joint.juntaId));
                }));
        showNotificationSnackBar(
          context,
          title: "",
          mensaje: 'Se ha liberado correctamente el proceso de soldadura!',
          icon:
              Icon(Icons.check_circle_outline, size: 28.0, color: Colors.green),
          secondsDuration: 5,
          colorBarIndicator: Colors.green,
          borde: 8,
        );

        updateJointsWC();
      }

      if (state is ErrorReleaseCaboOfWelding) {
        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.messageError,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener listenerQualifyCaboNorm() {
    return BlocListener<QualifyCaboNormBloc, QualifyCaboNormState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsloadingChangeMaterial) {
        showGeneralLoading(context);
      }

      if (state is SucessChangeMaterial) {
        Navigator.pop(context);
        action = 'CHANGEMATERIAL';
        setState(() {
          widget.params.joint.junta = state.requireChangeMaterialResponse.joint;
        });
        _initialDataJoint
            .add(GetInitialDataJoint(juntaId: widget.params.joint.juntaId));
      }

      if (state is ErrorChangeMaterial) {
        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.messageError,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 4,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  void _showTraceabilityModal(TraceabilityModel item, bool isTraceabilityOne) {
    cuantity.text = '';
    juntaSearch.text = '';
    juntaNo.text = '';
    planoSearch.text = '';
    volumen.text = '';
    workTrazabilidadSel.text = '';
    joints = [];

    contentTraceability(
      joints,
      workTrazabilidadSel,
      widget.params.work,
      workTraceability,
      juntaSearch,
      planoSearch,
      volumen,
      juntaNo,
      context,
      'Trazabilidad ${isTraceabilityOne ? '1' : '2'}',
      cuantity,
      isTraceabilityOne,
      widget.params.joint.juntaId,
      item,
      _traceabilityOneAddBloc,
      _traceabilityTwoAddBloc,
      _jointTraceabilityBloc,
    );
  }

  void _messageSuccess(String message) {
    showNotificationSnackBar(
      context,
      title: "",
      mensaje: message,
      icon: Icon(
        Icons.check_circle_outline_rounded,
        size: 28.0,
        color: Colors.green,
      ),
      secondsDuration: 4,
      colorBarIndicator: Colors.green,
      borde: 8,
    );
  }

  void _pipefitterAcept(int employeeId, String option, int card) {
    if (option == 'remove') {
      _pipefitterRemoveBloc.add(
        PipefitterRemove(
          employeeId: employeeId,
          jointId: widget.params.joint.juntaId,
        ),
      );
    } else {
      _escanearQR(employeeId, card);
    }
  }

  Future<void> _escanearQR(int employeeId, int card) async {
    String barcodeScanRes;

    try {
      //Se obtienen los datos del código de barras
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancelar",
        true,
        ScanMode.BARCODE,
      );

      //Si no ha cancelado la lectura de código de barras se procede a validarla
      //con la del tubero agregado
      if (barcodeScanRes != '-1') {
        int scanedCard = int.parse(barcodeScanRes);

        if (scanedCard == card) {
          _pipefitterSignBloc.add(
            PipefitterSign(
              employeeId: employeeId,
              jointId: widget.params.joint.juntaId,
            ),
          );
        } else {
          showNotificationSnackBar(
            context,
            title: "",
            mensaje:
                'El número de ficha capturado al firmar, no coincide con la información del tubero.',
            icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
            secondsDuration: 4,
            colorBarIndicator: Colors.red,
            borde: 8,
          );
        }
      }
    } catch (_) {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje: 'Ocurrió un detalle al leer el código de barras.',
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
        secondsDuration: 4,
        colorBarIndicator: Colors.red,
        borde: 8,
      );
    }
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

  _onSubmittedPipefitter(String value) {
    if (value.isEmpty) {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje: 'No se ha proporcionado ningún tubero.',
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
        secondsDuration: 4,
        colorBarIndicator: Colors.red,
        borde: 8,
      );
    } else {
      int card = int.parse(value);

      _pipefitterAddBloc.add(PipefitterAdd(
        card: card,
        jointId: widget.params.joint.juntaId,
      ));
    }
  }

  Widget _buttonsPipefitter(PipefitterModel item) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                style: ElevatedButton.styleFrom(
                  primary: userPermissionModel.weldingControlEditTabConformado
                      ? Colors.red
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Remover', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (userPermissionModel.weldingControlEditTabConformado) {
                    confirmModal(
                      context,
                      '¿Está seguro de eliminar el tubero con la ficha ${item.ficha}?',
                      'Aceptar',
                      positiveAction: () => _pipefitterAcept(
                        item.empleadoId,
                        'remove',
                        item.ficha,
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: TextButton(
                style: ElevatedButton.styleFrom(
                  primary: userPermissionModel.weldingControlEditTabConformado
                      ? Colors.blueAccent
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Firmar', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (userPermissionModel.weldingControlEditTabConformado) {
                    confirmModal(
                      context,
                      '¿Está seguro de firmar el tubero con la ficha ${item.ficha}?',
                      'Aceptar',
                      positiveAction: () => _pipefitterAcept(
                        item.empleadoId,
                        'sign',
                        item.ficha,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signedPipefitter() {
    return Container(
      padding: EdgeInsets.only(top: 7.0, left: 7.0, right: 7.0),
      child: Icon(Icons.check_circle_sharp, size: 40.0, color: Colors.green),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isDateOne) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null &&
        picked != (isDateOne ? currentDateOne : currentDateTwo)) {
      setState(() {
        DateFormat formatter = DateFormat('dd/MM/yyyy');

        if (isDateOne) {
          currentDateOne = picked;
          dateOne.text = formatter.format(currentDateOne);
        } else {
          currentDateTwo = picked;
          dateTwo.text = formatter.format(currentDateTwo);
        }
      });
    }
  }

  Future<Null> _selectTime(BuildContext context, bool isTimeOne) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 00, minute: 00),
    );
    if (picked != null)
      setState(() {
        isTimeOne ? selectedTimeOne = picked : selectedTimeTwo = picked;
        isTimeOne
            ? hourOne.text = selectedTimeOne.format(context)
            : hourTwo.text = selectedTimeTwo.format(context);
      });
  }

  void _saveDates() {
    showGeneralLoading(context);

    if (dateOne.text.isEmpty ||
        dateTwo.text.isEmpty ||
        hourOne.text.isEmpty ||
        hourTwo.text.isEmpty) {
      Navigator.pop(context);

      showNotificationSnackBar(
        context,
        title: "",
        mensaje: 'Las fechas de inicio y fin del conformado son requeridas!',
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
        secondsDuration: 4,
        colorBarIndicator: Colors.red,
        borde: 8,
      );
    } else {
      Navigator.pop(context);
      bool isTwentyFourHour = MediaQuery.of(context).alwaysUse24HourFormat;
      DateFormat inputFormat = DateFormat(
          isTwentyFourHour ? "dd/MM/yyyy HH:mm" : "dd/MM/yyyy hh:mm aaa");

      DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.S");
      DateTime firstDate = inputFormat.parse('${dateOne.text} ${hourOne.text}');
      DateTime lastDate = inputFormat.parse('${dateTwo.text} ${hourTwo.text}');
      String initialDate = outputFormat.format(firstDate);
      String finalDate = outputFormat.format(lastDate);

      FormingCSParams params = FormingCSParams(
        jointId: widget.params.joint.juntaId,
        employeeId: user.ficha.isNotEmpty ? int.parse(user.ficha) : 0,
        initialDate: initialDate,
        finalDate: finalDate,
        comments: comments.text,
        reasonFN: '',
        action: 'GUARDAR',
        repair: false,
      );

      _datesBloc.add(SetDates(params: params));
    }
  }

  void _setDates() {
    bool isTwentyFourHour = MediaQuery.of(context).alwaysUse24HourFormat;
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.S");
    DateFormat outputDateFormat = DateFormat("dd/MM/yyyy");
    DateFormat outputTimeFormat =
        DateFormat(isTwentyFourHour ? "HH:mm" : "hh:mm aaa");

    if (initialDataJointModel.fechaInicio != null) {
      DateTime firstDate = inputFormat.parse(initialDataJointModel.fechaInicio);
      String dateOneResult = outputDateFormat.format(firstDate);
      String timeOneResult = outputTimeFormat.format(firstDate);

      dateOne.text = dateOneResult;
      hourOne.text = timeOneResult;
    }

    if (initialDataJointModel.fechaFin != null) {
      DateTime lastDate = inputFormat.parse(initialDataJointModel.fechaFin);
      String dateTwoResult = outputDateFormat.format(lastDate);
      String timeTwoResult = outputTimeFormat.format(lastDate);

      dateTwo.text = dateTwoResult;
      hourTwo.text = timeTwoResult;
    }

    comments.text = initialDataJointModel.observaciones;
  }

  void _releaseForming() {
    bool dates;
    bool traceabilityOne;
    bool traceabilityTwo;
    bool pipefitters = true;
    bool pics;

    dates = (dateOne.text.isNotEmpty &&
        dateTwo.text.isNotEmpty &&
        hourOne.text.isNotEmpty &&
        hourTwo.text.isNotEmpty &&
        comments.text.isNotEmpty);
    traceabilityOne =
        _traceabilityOneBloc.state.traceabilityOne != null ? true : false;
    traceabilityTwo =
        _traceabilityTwoBloc.state.traceabilityTwo != null ? true : false;
    pics = _evidencePhotographicBloc.state.lstPhotographics.isNotEmpty
        ? true
        : false;

    if (_pipefitterBloc.state.pipefitters.isEmpty) {
      pipefitters = false;
    } else {
      _pipefitterBloc.state.pipefitters.forEach((item) {
        if (item.firmado == false) {
          pipefitters = false;

          return;
        }
      });
    }

    if (dates && traceabilityOne && traceabilityTwo && pipefitters && pics) {
      bool isTwentyFourHour = MediaQuery.of(context).alwaysUse24HourFormat;
      DateFormat inputFormat = DateFormat(
          isTwentyFourHour ? "dd/MM/yyyy HH:mm" : "dd/MM/yyyy hh:mm aaa");
      DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.S");
      DateTime firstDate = inputFormat.parse('${dateOne.text} ${hourOne.text}');
      DateTime lastDate = inputFormat.parse('${dateTwo.text} ${hourTwo.text}');
      String initialDate = outputFormat.format(firstDate);
      String finalDate = outputFormat.format(lastDate);

      FormingCSParams params = FormingCSParams(
        jointId: widget.params.joint.juntaId,
        employeeId: user.ficha.isNotEmpty ? int.parse(user.ficha) : 0,
        initialDate: initialDate,
        finalDate: finalDate,
        comments: comments.text,
        reasonFN: '',
        action: 'LIBERAR',
        repair: false,
      );

      _datesBloc.add(SetDates(params: params));
    } else {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje:
            'Debe completar toda la información para la liberación del Conformado.',
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
        secondsDuration: 4,
        colorBarIndicator: Colors.red,
        borde: 8,
      );
    }
  }

  void _releaseWelding(int ficha, String soldaduraId) {
    bool firmado = true;

    print(lstActividadesSoldadureas.map((e) {
      if (e.firmado != 1) {
        firmado = false;
      }
    }));

    if (firmado != true) {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje:
            'Debe completar toda la información para la liberación de la soldadura.',
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.yellow),
        secondsDuration: 4,
        colorBarIndicator: Colors.yellow,
        borde: 8,
      );
    } else {
      _panelRegisterBloc
          .add(ReleaseCaboOfWelding(ficha: ficha, soldaduraId: soldaduraId));
    }
  }

  void changeMaterial(
      bool response, String jointId, String message, String soldaduraId) {
    confirmModal(
      context,
      '$message',
      'Continuar',
      positiveAction: () {
        var params = RequireChangeMaterialModel(
            requiresChangeMaterial: response,
            weldingId: soldaduraId,
            jointId: jointId);

        _qualifyCaboNormBloc.add(ChangeMaterial(params: params));
      },
    );
  }

// Actualiza de manera general lo paneles
  void _saveGeneralInfo() {
    isSaveGeneral = true;
    List<UpdateWeldingDetailParams> params =
        BlocProvider.of<PanelRegisterBloc>(context)
            .state
            .actividadesSoldaduraUpdatearams;

    _panelRegisterBloc.add(UpdateRegisterWelding(params: params));
    _panelRegisterBloc
        .add(GetPanelWelder(jointId: widget.params.joint.juntaId));
  }

  void _visualInspection(String action) {
    bool isTwentyFourHour = MediaQuery.of(context).alwaysUse24HourFormat;
    DateFormat inputFormat = DateFormat(
        isTwentyFourHour ? "dd/MM/yyyy HH:mm" : "dd/MM/yyyy hh:mm aaa");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.S");
    DateTime firstDate = inputFormat.parse('${dateOne.text} ${hourOne.text}');
    DateTime lastDate = inputFormat.parse('${dateTwo.text} ${hourTwo.text}');
    String initialDate = outputFormat.format(firstDate);
    String finalDate = outputFormat.format(lastDate);

    FormingCSParams params = FormingCSParams(
      jointId: widget.params.joint.juntaId,
      employeeId: user.ficha.isNotEmpty ? int.parse(user.ficha) : 0,
      initialDate: initialDate,
      finalDate: finalDate,
      comments: comments.text,
      reasonFN: action == 'F/N' ? reasson.text : '',
      action: action,
      repair: false,
      acceptanceCriteriaId: listCriterosConformadoFull,
    );

    if (action == 'F/N') Navigator.pop(context);

    _datesBloc.add(SetDates(params: params));
  }

  _validateFormFN() {
    bool hasReasson;
    bool evidence;

    hasReasson = reasson.text.isNotEmpty;
    evidence =
        this.lstPhothosTem.isNotEmpty; //_evidenceFNBloc.state.pics.isNotEmpty;

    if (hasReasson && evidence) {
      _evidenceFNBloc.add(AddAllEvidenceAFN(
          data: this.lstPhothosTemAdd,
          deletePhoto: this.lstPhothosTemEliminados));
      // _visualInspection('F/N');
    } else {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje: 'Debe completar toda la información.',
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
        secondsDuration: 4,
        colorBarIndicator: Colors.red,
        borde: 8,
      );
    }
  }

  void _repair() {
    FormingCSParams params = FormingCSParams(
      jointId: widget.params.joint.juntaId,
      action: 'REPAIR',
      repair: true,
    );
    Navigator.pop(context);
    _datesBloc.add(SetDates(params: params));
  }

  void updateJointsWC() {
    weldingListBloc.add(
      GetJointsWC(
        plainDetailId: widget.params.plainDetailSelection,
        frontId: widget.params.frontSelection,
        state: widget.params.stateFiltered,
        clear: false,
      ),
    );
  }

  bool enableInput() {
    bool enable =
        !formingReleased && userPermissionModel.weldingControlEditTabConformado
            ? true
            : false;

    return enable;
  }

  bool enableQACard() {
    bool enable = formingReleased &&
            userPermissionModel.weldingControlInspVisualConformado
        ? true
        : false;

    return enable;
  }
}
