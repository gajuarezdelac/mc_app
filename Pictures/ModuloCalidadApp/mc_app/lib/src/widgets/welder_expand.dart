import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/bloc/tab_welding/panel_register_welder/panel_register_welder_bloc.dart';
import 'package:mc_app/src/bloc/tab_welding/panel_register_welder/panel_register_welder_event.dart';
import 'package:mc_app/src/bloc/tab_welding/panel_register_welder/panel_register_welder_state.dart';
import 'package:mc_app/src/models/acceptance_criteria_model.dart';
import 'package:mc_app/src/models/params/add_card_welder_params.dart';
import 'package:mc_app/src/models/params/evidence_welder_card_params.dart';
import 'package:mc_app/src/models/params/photographic_evidence_params_model.dart';
import 'package:mc_app/src/models/params/update_welding_detail_params.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';
import 'package:mc_app/src/models/user_avatar_model.dart';
import 'package:mc_app/src/models/user_off_model.dart';
import 'package:mc_app/src/models/user_permission_model.dart';
import 'package:mc_app/src/models/welding_tab_model.dart';
import 'package:mc_app/src/pages/detail_photographic_screen.dart';
import 'package:mc_app/src/utils/always_disabled_focus_node.dart';
import 'package:mc_app/src/utils/dialogs.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:mc_app/src/widgets/card_qa.dart';
import 'package:mc_app/src/widgets/card_soldier.dart';
import 'package:mc_app/src/widgets/card_welding_machine.dart';
import 'package:mc_app/src/widgets/confirm_modal.dart';
import 'package:mc_app/src/widgets/photographic_card.dart';
import 'package:mc_app/src/widgets/show_general_loading.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';
import 'package:mime/mime.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:path/path.dart' as path;
import '../bloc/tab_welding/bloc.dart';
import '../bloc/tab_welding/qualify_cabo_norma/qualify_cabo_norma_state.dart';
import 'content_modal.dart';
import 'loading_circular.dart';

class WelderExpandPage extends StatefulWidget {
  final String tipoJunta;
  final ActividadesSoldaduraModel item;
  final UserAvatarModel user;
  final int weldingReleased;
  final List<String> folioSoldaduras;
  final String folioSoldaduraFN;
  final ScrollController scrollControler;
  final int consecutivoSoldadura;
  final String plainDetailId;
  final int frontId;
  final String state;
  final UserPermissionModel userPermissionModel;
  final List<String> criteriosAC;
  final int index;

  WelderExpandPage(
      {Key key,
      @required this.item,
      @required this.tipoJunta,
      @required this.user,
      @required this.folioSoldaduras,
      @required this.weldingReleased,
      @required this.folioSoldaduraFN,
      @required this.scrollControler,
      @required this.consecutivoSoldadura,
      @required this.plainDetailId,
      @required this.frontId,
      @required this.state,
      @required this.userPermissionModel,
      @required this.criteriosAC,
      @required this.index})
      : super(key: key);

  @override
  WelderExpandPageState createState() => WelderExpandPageState();
}

class WelderExpandPageState extends State<WelderExpandPage> {
  var items;
  TextEditingController _longitudController;
  TextEditingController _observacionesController;
  TextEditingController _elemtoEstructuresController;
  TextEditingController _noSerieController;
  TextEditingController _observacionesFNController;
  TextEditingController addWelderController;
  TextEditingController _date1;
  TextEditingController _date2;
  TextEditingController _hr1;
  TextEditingController _hr2;

  PanelRegisterBloc _panelRegisterBloc;
  QualifyCaboNormBloc _qualifyCaboNormBloc;
  EvidencePhotographicWeldingBloc _evidencePhotographicWeldingBloc;
  EvidenceFNWeldingBloc _evidenceFNWeldingBloc;
  AddWelderBloc _addWelderBloc;
  WeldingListBloc _weldingListBloc;
  MachinesWelderBloc _machinesWelderBloc;

  String initals = "N/A";
  String normaChange = '';
  int aceptVigencia = 0;
  QAWeldingUserModel qaWeldingUserModel;
  List<AcceptanceCriteriaWeldingModel> listCriterosSoldaduraFull = [];
  List<AcceptanceCriteriaWeldingModel> listCriterosSoldaduraViewFN = [];
  List<AcceptanceCriteriaWeldingModel> listACS = [];
  List<String> listaOriginal = [];

  bool showTuberia = false;
  bool showOtro = true;
  bool showEstructura = false;
  UpdateWeldingDetailParams itemUpdate = new UpdateWeldingDetailParams();

  // Etapa
  bool f = false,
      pc = false,
      r1 = false,
      r2 = false,
      r3 = false,
      r4 = false,
      r5 = false,
      r6 = false,
      v = false;

  // Cuadrantes
  bool i = false, ii = false, iii = false, iv = false;

  // zonas
  bool za = false,
      zb = false,
      zc = false,
      zd = false,
      ze = false,
      zf = false,
      zg = false,
      zh = false,
      zv = false;

  bool validatorCheckEtapa = false;
  bool validatorCheckZona = false;
  bool validatorcheckCuadrante = false;

  bool validatorAgregoMaquina = false;

  final formPanelSoldier = new GlobalKey<FormState>();
  final noSerieMaquina = new GlobalKey<FormState>();
  final formOtros = new GlobalKey<FormState>();
  final formFN = new GlobalKey<FormState>();
  final _multiSelectKey = GlobalKey<FormFieldState>();

  String _selectedMachine;
  List<MachineWeldingModel> lst = [];
  int _vigente;
  int _existe;

  @override
  void initState() {
    super.initState();
    _longitudController = TextEditingController();
    _observacionesController = TextEditingController();
    _elemtoEstructuresController = TextEditingController();
    _noSerieController = TextEditingController();
    _observacionesFNController = TextEditingController();
    addWelderController = TextEditingController();
    initialData();
    _panelRegisterBloc = BlocProvider.of<PanelRegisterBloc>(context);
    _evidencePhotographicWeldingBloc =
        BlocProvider.of<EvidencePhotographicWeldingBloc>(context);
    _evidenceFNWeldingBloc = BlocProvider.of<EvidenceFNWeldingBloc>(context);
    _addWelderBloc = BlocProvider.of<AddWelderBloc>(context);
    _qualifyCaboNormBloc = BlocProvider.of<QualifyCaboNormBloc>(context);
    _weldingListBloc = BlocProvider.of<WeldingListBloc>(context);
    _machinesWelderBloc = BlocProvider.of<MachinesWelderBloc>(context);

    loadPhotographicWelding();
  }

  setSelectedMachine(String val, int vigente, int existe) {
    setState(() {
      _selectedMachine = val;
      _vigente = vigente;
      _existe = existe;
    });
  }

  void initialData() {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.S");
    DateFormat outputDateFormat = DateFormat("dd/MM/yyyy");
    DateFormat outputTimeFormat = DateFormat("HH:mm");
    String date1 = '';
    String hr1 = '';
    String date2 = '';
    String hr2 = '';
    setState(() {
      initals = _getInitials(widget.item.nombreSoldador);
      listACS = BlocProvider.of<ACSBloc>(context).state.listACS;
      // Criterios
      items = listACS
          .map((e) => MultiSelectItem<AcceptanceCriteriaWeldingModel>(
              e, '${e.clave}-${e.criterioId}'))
          .toList();

      List<String> criterios = widget.criteriosAC.first.split('|');
      criterios.forEach((element) {
        listACS.forEach((e) {
          if (element == e.criterioAceptacionId) {
            listaOriginal.add('${e.clave}-${e.criterioId}');
          }
        });
      });

      if (widget.item.fechaInicio != null) {
        DateTime firstDate = inputFormat.parse(widget.item.fechaInicio);
        date1 = outputDateFormat.format(firstDate);
        hr1 = outputTimeFormat.format(firstDate);
      }

      if (widget.item.fechaFin != null) {
        DateTime lastDate = inputFormat.parse(widget.item.fechaFin);
        date2 = outputDateFormat.format(lastDate);
        hr2 = outputTimeFormat.format(lastDate);
      }

      _date1 =
          new TextEditingController(text: date1 != '01/01/0001' ? date1 : '');
      _date2 =
          new TextEditingController(text: date2 != '01/01/0001' ? date2 : '');
      _hr1 = new TextEditingController(text: date1 != '01/01/0001' ? hr1 : '');
      _hr2 = new TextEditingController(text: date2 != '01/01/0001' ? hr2 : '');

      //Criterios
    });

    switch (widget.tipoJunta) {
      case 'Estructura':
        setState(() {
          showEstructura = true;
        });
        break;
      case 'Tubería':
        setState(() {
          showTuberia = true;
        });
        break;
      case 'Otro':
        setState(() {
          showOtro = true;
        });
        break;
    }

    //Etapas realizadas
    List<String> etapas = widget.item.etapaRealizada.split(',');

    etapas.forEach((element) {
      switch (element.toLowerCase()) {
        case 'f':
          setState(() {
            f = true;
            validatorCheckEtapa = false;
          });
          break;
        case 'pc':
          setState(() {
            pc = true;
            validatorCheckEtapa = false;
          });
          break;
        case 'r1':
          setState(() {
            r1 = true;
            validatorCheckEtapa = false;
          });
          break;
        case 'r2':
          setState(() {
            r2 = true;
            validatorCheckEtapa = false;
          });
          break;
        case 'r3':
          setState(() {
            r3 = true;
            validatorCheckEtapa = false;
          });
          break;
        case 'r4':
          setState(() {
            r4 = true;
            validatorCheckEtapa = false;
          });
          break;
        case 'r5':
          setState(() {
            r5 = true;
            validatorCheckEtapa = false;
          });
          break;
        case 'r6':
          setState(() {
            r6 = true;
            validatorCheckEtapa = false;
          });
          break;
        case 'v':
          setState(() {
            v = true;
            validatorCheckEtapa = false;
          });
          break;
      }
    });

    //Cuadrantes
    List<String> cuadrantes = widget.item.cuadranteRealizado.split(',');

    cuadrantes.forEach((element) {
      switch (element.toLowerCase()) {
        case 'c1':
          setState(() {
            i = true;
            validatorcheckCuadrante = false;
          });
          break;
        case 'c2':
          setState(() {
            ii = true;
            validatorcheckCuadrante = false;
          });
          break;
        case 'c3':
          setState(() {
            iii = true;
            validatorcheckCuadrante = false;
          });
          break;
        case 'c4':
          setState(() {
            iv = true;
            validatorcheckCuadrante = false;
          });
          break;
      }
    });

    //Zonas
    List<String> zonas = widget.item.zonaRealizada.split(',');
    zonas.forEach((element) {
      switch (element.toLowerCase()) {
        case 'za':
          setState(() {
            za = true;
            validatorCheckZona = false;
          });
          break;
        case 'zb':
          setState(() {
            zb = true;
            validatorCheckZona = false;
          });
          break;
        case 'zc':
          setState(() {
            zc = true;
            validatorCheckZona = false;
          });
          break;
        case 'zd':
          setState(() {
            zd = true;
            validatorCheckZona = false;
          });
          break;
        case 'ze':
          setState(() {
            ze = true;
            validatorCheckZona = false;
          });
          break;
        case 'zf':
          setState(() {
            zf = true;
            validatorCheckZona = false;
          });
          break;
        case 'zg':
          setState(() {
            zf = true;
            validatorCheckZona = false;
          });
          break;
        case 'zh':
          setState(() {
            zf = true;
            validatorCheckZona = false;
          });
          break;
        case 'zv':
          setState(() {
            zv = true;
            validatorCheckZona = true;
          });
          break;
      }
    });

    if (widget.item.observaciones != "" && widget.item.observaciones != null) {
      _observacionesController.text = widget.item.observaciones;
    }

    if (widget.item.otrosElementos != "" &&
        widget.item.otrosElementos != null) {
      _elemtoEstructuresController.text = widget.item.otrosElementos;
    }

    _longitudController.text = widget.item.longitudSoldada == null
        ? ''
        : widget.item.longitudSoldada.toString();

    if (widget.item.idEquipo != null && widget.item.idEquipo != "") {
      validatorAgregoMaquina = true;
    }

    changeUpdateParams();
  }

  // Camera
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

      var photographic = new PhotographicEvidenceWeldingModel(
          content: base64.encode(contentImage).toString(),
          contentType: lookupMimeType(picture.path),
          fechaModificacion: '',
          fotoId: 'FOH99999',
          identificadorTabla: place == 'WELDING'
              ? '${widget.item.soldadorId}|${widget.item.folioSoldadura}'
              : '${widget.item.folioSoldadura}|FN',
          nombre: path.basename(picture.path),
          nombreTabla: 'HSEQMC.Soldador',
          regBorrado: 0,
          siteModificacion: '',
          thumbnail: base64.encode(thumbnailImage).toString());

      place == 'WELDING'
          ? _evidencePhotographicWeldingBloc
              .add(AddEvidencePhotographicWelding(data: photographic))
          : _evidenceFNWeldingBloc
              .add(AddEvidenceFNWelding(data: photographic));
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

      var photographic = new PhotographicEvidenceWeldingModel(
          content: base64.encode(contentImage).toString(),
          contentType: lookupMimeType(picture.path),
          fechaModificacion: '',
          fotoId: 'FOH99999',
          identificadorTabla: place == 'WELDING'
              ? '${widget.item.soldadorId}|${widget.item.folioSoldadura}'
              : '${widget.item.folioSoldadura}|FN',
          nombre: path.basename(picture.path),
          nombreTabla: 'HSEQMC.Soldador',
          regBorrado: 0,
          siteModificacion: '',
          thumbnail: base64.encode(thumbnailImage).toString());

      place == 'WELDING'
          ? _evidencePhotographicWeldingBloc
              .add(AddEvidencePhotographicWelding(data: photographic))
          : _evidenceFNWeldingBloc
              .add(AddEvidenceFNWelding(data: photographic));
    } else {}
  }

  void deletePhotographic(String id) {
    Dialogs.confirm(context,
        title: "¿Esta seguro de eliminar la evidenvia fotografica?",
        description: "El registro sera eliminado y no podra se recuperado",
        onConfirm: () {
      Navigator.pop(context);
      _evidencePhotographicWeldingBloc
          .add(DeleteEvidencePhotographicWelding(id: id));
    });
  }

  void loadEvidenceFN() {
    PhotographicEvidenceWeldingParamsModel loadPhotographicParams =
        PhotographicEvidenceWeldingParamsModel(
      identificadorTabla: widget.folioSoldaduraFN,
      nombreTabla: "HSEQMC.Soldador",
      tipo: "1",
    );

    _evidenceFNWeldingBloc.add(
      GetEvidenceFNWelding(params: loadPhotographicParams),
    );
  }

  void loadPhotographicWelding() {
    EvidenceWelderCardParams loadPhotographicParams = EvidenceWelderCardParams(
      identificadorTabla: widget.folioSoldaduras,
      nombreTabla: "HSEQMC.Soldador",
      tipo: "1",
    );
    _evidencePhotographicWeldingBloc
        .add(GetEvidencePhotographicWelding(params: loadPhotographicParams));
  }

  // Soldadura fuera de norma

  void deletePhotographicFN(String id) {
    Dialogs.confirm(context,
        title: "¿Esta seguro de eliminar la evidenvia fotografica?",
        description: "El registro sera eliminado y no podra se recuperado",
        onConfirm: () {
      Navigator.pop(context);
      _evidenceFNWeldingBloc.add(DeleteEvidenceFNWelding(id: id));
    });
  }

  // Código QR
  void _welderSigatureQR(
    String folioSoldadura,
    String option,
    String registroSoldaduraId,
    String zonaSoldaduraId,
    String cuadranteSoldaduraId,
    dynamic ficha,
    String nombreSoldador,
  ) {
    if (option == 'remove') {
      confirmModal(
        context,
        '¿Está seguro de que desea remover al soldador "$nombreSoldador"?',
        'Aceptar',
        positiveAction: () {
          _panelRegisterBloc.add(RemoveWeldingActivity(
              folioSoldaduraId: folioSoldadura,
              registroSoldaduraId: registroSoldaduraId,
              cuadranteSoldaduraId: cuadranteSoldaduraId,
              zonaSoldaduraId: zonaSoldaduraId));
        },
      );
    } else {
      _escanearQR(folioSoldadura, ficha, registroSoldaduraId,
          cuadranteSoldaduraId, zonaSoldaduraId);
    }
  }

  // Escaner
  Future<void> _escanearQR(
      String folioSoldadura,
      dynamic ficha,
      String registroSoldaduraId,
      String cuadranteSoldaduraId,
      String zonaSoldaduraId) async {
    dynamic barcodeScanRes;

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
        if (barcodeScanRes == ficha.toString()) {
          _panelRegisterBloc.add(
              AddWelderSignature(folioSoldaduraId: widget.item.folioSoldadura));
        } else {
          showNotificationSnackBar(
            context,
            title: "",
            mensaje: 'Los datos no concuerdan!',
            icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
            secondsDuration: 8,
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
        secondsDuration: 8,
        colorBarIndicator: Colors.red,
        borde: 8,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var tipoJunta = widget.tipoJunta;

    String imagenTitle = (tipoJunta == "Estructura")
        ? "estructura.png"
        : (tipoJunta == "Tubería")
            ? "tuberia.png"
            : "otro.png";

    final Responsive responsive = Responsive.of(context);
    return MultiBlocListener(
      listeners: [
        listenerMachineWelding(),
        listenerRemoveWelderActivity(),
        listenerSignatureWelding(),
        listenerGetQA(),
        listenerMachineWeldingV2(),
      ],
      child: Form(
        key: formPanelSoldier,
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: _date1,
                    onTap: () {
                      _selectDate(context, true, widget.index);
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
                  child: TextFormField(
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: _hr1,
                    //enabled: enableInput(),
                    onTap: () {
                      _selectTime(context, true, widget.index);
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
                  child: TextFormField(
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: _date2,
                    //enabled: enableInput(),
                    onTap: () {
                      _selectDate(context, false, widget.index);
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
                  child: TextFormField(
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: _hr2,
                    //enabled: enableInput(),
                    onTap: () {
                      _selectTime(context, false, widget.index);
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
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: CardSoldier(
                    initials: initals,
                    nombre: widget.item.nombreSoldador != null
                        ? widget.item.nombreSoldador
                        : "N/A",
                    ficha: widget.item.ficha.toString(),
                    puestoDescripcion: widget.item.categoria != null
                        ? widget.item.categoria
                        : "Sin puesto por mostrar",
                    firmado: widget.item.firmado,
                    remove: () => _welderSigatureQR(
                      widget.item.folioSoldadura,
                      'remove',
                      widget.item.registroSoldaduraId,
                      widget.item.zonaSoldaduraId,
                      widget.item.cuadranteSoldaduraId,
                      widget.item.ficha,
                      widget.item.nombreSoldador,
                    ),
                    firmar: () {
                      final form = formPanelSoldier.currentState;
                      final formOtros = noSerieMaquina.currentState;

                      if (widget.item.idEquipo != null) {
                        if (form.validate()) {
                          if (validarFormulario() || formOtros.validate()) {
                            _welderSigatureQR(
                              widget.item.folioSoldadura,
                              'signature',
                              widget.item.registroSoldaduraId,
                              widget.item.zonaSoldaduraId,
                              widget.item.cuadranteSoldaduraId,
                              widget.item.ficha,
                              widget.item.nombreSoldador,
                            );
                          } else {
                            camposFaltantes();
                          }
                        } else {
                          camposFaltantes();
                        }
                      } else {
                        showNotificationSnackBar(context,
                            title: "",
                            mensaje:
                                'Es necesario agregar una maquina de soldar!',
                            icon: Icon(
                              Icons.info_outline,
                              size: 28.0,
                              color: Colors.yellow[300],
                            ),
                            secondsDuration: 3,
                            colorBarIndicator: Colors.yellow,
                            borde: 8);
                      }
                    },
                  )),
                  SizedBox(width: 10),
                  BlocBuilder<PanelRegisterBloc, PanelRegisterWelderState>(
                      builder: (context, state) {
                    if (state is IsloadingAddMachineWelding ||
                        state is IsLoadingRemoveMachineWelding ||
                        state is IsloadingFetchMachineWeldingV2) {
                      return Expanded(child: loadingCircular());
                    }
                    return widget.item.idEquipo != null
                        ? Expanded(
                            child: CardWeldingMachine(
                              imagen: 'assets/img/maquina.png',
                              noSerie: widget.item.noSerie,
                              marca: widget.item.marca,
                              descripcion: widget.item.equipoDescripcion,
                              firmado: widget.item.firmado,
                              remove: () {
                                _deleteMahchineWelding(
                                    widget.item.folioSoldadura,
                                    widget.item.noSerie);
                              },
                            ),
                          )
                        : (false)
                            ? loadingCircular()
                            : builderAddMaquina;
                  }),
                ],
              ),
            ),
            SizedBox(height: 10),
            widget.tipoJunta != 'Estructura' && widget.tipoJunta != 'Otro'
                ? listCheckEtapa()
                : Text(''),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(left: 20, right: 15, bottom: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              '* Longitud soldada:',
                              style: TextStyle(
                                fontSize: responsive.dp(1.4),
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          enabled: widget.item.firmado != 1 ? true : false,
                          controller: _longitudController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return '[El dato es obligatorio]';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,4}'),
                            ),
                          ],
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          decoration: InputDecoration(
                            suffixIcon: widget.item.firmado != 1
                                ? Icon(Icons.format_list_numbered)
                                : Icon(Icons.check_circle_sharp,
                                    size: 30.0, color: Colors.green),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: '(Metros)',
                            hintText: '',
                            alignLabelWithHint: true,
                          ),
                          onChanged: (texto) {
                            changeUpdateParams();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/img/$imagenTitle',
                            height: 150,
                          ),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            (showEstructura)
                ? widgetEstructura()
                : (showTuberia)
                    ? listCheckCuadrante()
                    : widgetOtros(),
            Container(
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
                              '* Observaciones:',
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
                              child: TextFormField(
                                enabled:
                                    widget.item.firmado == 1 ? false : true,
                                controller: _observacionesController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '[Es necesario las observaciones]';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.multiline,
                                //minLines: 1, //Normal textInputField will be displayed
                                maxLines: 5,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: 'Observaciones',
                                  hintText: 'Ingrese sus observaciones...',
                                  alignLabelWithHint: true,
                                  suffixIcon: widget.item.firmado == 1
                                      ? Icon(Icons.check_circle_sharp,
                                          size: 30.0, color: Colors.green)
                                      : Icon(Icons.text_format, size: 30.0),
                                ), // when user presses enter it will adapt to it
                                onChanged: (texto) {
                                  changeUpdateParams();
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _builderImagenesLoad(),
            SizedBox(height: 20),
            widget.weldingReleased == 1 &&
                    widget.userPermissionModel
                        .weldingControlDefinirInspecVisSoldadura
                ? Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: widget.item.norma == 'D/N' ||
                            widget.item.norma == 'F/N'
                        ? CardQA(
                            initialsQA:
                                _getInitials(widget.item.inspectorCCANombre),
                            name: widget.item.inspectorCCANombre,
                            category: widget.item.inspectorCCAPuestoDescripcion,
                            normStatus: widget.item.norma,
                            cambioMaterial: widget.item.cambioMaterial,
                            ficha: widget.item.inspectorCCAFicha.toString(),
                            onPressedFN: () {},
                            onpressedDN: () {},
                            onPressedOutNorm: () {
                              _showViewWeldingFN(
                                widget.item.nombreSoldador,
                                widget.item.folioSoldadura,
                                'F/N',
                                widget.item.motivoFN,
                                widget.item.juntaId,
                                widget.item.inspectorCCANombre,
                                widget.item.inspectorCCAPuestoDescripcion,
                                widget.item.ficha,
                              );
                            },
                          )
                        : CardQA(
                            initialsQA: _getInitials(widget.user.nombre),
                            name: widget.user.nombre,
                            category: widget.user.puestoDescripcion,
                            normStatus: widget.item.norma != null
                                ? widget.item.norma
                                : '',
                            ficha: widget.user.ficha,
                            onPressedFN: () => _markAsOutOfNorm('', 'F/N'),
                            onpressedDN: () => _markAsWithinNorm(
                              widget.item.folioSoldadura,
                              int.parse(widget.user.ficha),
                              'D/N',
                              '',
                              widget.item.juntaId,
                            ),
                            onPressedOutNorm: () {},
                          ),
                  )
                : (widget.userPermissionModel
                                .weldingControlDefinirInspecVisSoldadura &&
                            widget.item.norma == 'D/N' ||
                        widget.item.norma == 'F/N')
                    ? Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: CardQA(
                          initialsQA:
                              _getInitials(widget.item.inspectorCCANombre),
                          name: widget.item.inspectorCCANombre,
                          category: widget.item.inspectorCCAPuestoDescripcion,
                          normStatus: widget.item.norma,
                          cambioMaterial: widget.item.cambioMaterial,
                          ficha: widget.item.inspectorCCAFicha.toString(),
                          onPressedFN: () {},
                          onpressedDN: () {},
                          onPressedOutNorm: () {
                            _showViewWeldingFN(
                              widget.item.nombreSoldador,
                              widget.item.folioSoldadura,
                              'F/N',
                              widget.item.motivoFN,
                              widget.item.juntaId,
                              widget.item.inspectorCCANombre,
                              widget.item.inspectorCCAPuestoDescripcion,
                              widget.item.ficha,
                            );
                          },
                        ),
                      )
                    : Container()
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, bool isDateOne, int index) async {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    DateTime date = DateTime.now();

    if (isDateOne) {
      date = _date1.text != '' ? formatter.parse(_date1.text) : DateTime.now();
    } else {
      date = _date2.text != '' ? formatter.parse(_date2.text) : DateTime.now();
    }
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        if (isDateOne) {
          _date1.text = formatter.format(picked);
        } else {
          _date2.text = formatter.format(picked);
        }
      });

      changeUpdateParams();
    }
  }

  Future<Null> _selectTime(
      BuildContext context, bool isTimeOne, int index) async {
    TimeOfDay time = TimeOfDay(hour: 00, minute: 00);

    if (isTimeOne) {
      time = _hr1.text != ''
          ? TimeOfDay(
              hour: int.parse(_hr1.text.split(':')[0]),
              minute: int.tryParse(_hr1.text.split(':')[1]))
          : TimeOfDay(hour: 00, minute: 00);
    } else {
      time = _hr2.text != ''
          ? TimeOfDay(
              hour: int.parse(_hr2.text.split(':')[0]),
              minute: int.parse(_hr2.text.split(':')[1]))
          : TimeOfDay(hour: 00, minute: 00);
    }
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (picked != null)
      setState(() {
        if (isTimeOne) {
          _hr1.text = picked.format(context);
        } else {
          _hr2.text = picked.format(context);
        }
      });

    changeUpdateParams();
  }

  void changeUpdateParams() {
    print('');
    String initialDate;
    String finalDate;

    DateFormat inputFormat = DateFormat("dd/MM/yyyy HH:mm");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.S");
    if (_date1.text != '' || _hr1.text != '') {
      DateTime firstDate = inputFormat.parse(
          '${_date1.text == '' ? '01/01/0001' : _date1.text} ${_hr1.text == '' ? '00:00' : _hr1.text}');
      initialDate = outputFormat.format(firstDate);
    }

    if (_date2.text != '' || _hr2.text != '') {
      DateTime lastDate = inputFormat.parse(
          '${_date2.text == '' ? '01/01/0001' : _date2.text} ${_hr2.text == '' ? '00:00' : _hr2.text}');
      finalDate = outputFormat.format(lastDate);
    }

    itemUpdate = new UpdateWeldingDetailParams(
      registroSoldaduraId: widget.item.registroSoldaduraId,
      fechaInicio: initialDate,
      fechaFin: finalDate,
      fondeo: f,
      pasoCaliente: pc,
      refresco1: r1,
      refresco2: r2,
      refresco3: r3,
      refresco4: r4,
      refresco5: r5,
      refresco6: r6,
      vista: v,
      longitudSoldada: double.parse(_longitudController.text),
      observaciones: _observacionesController.text,
      otrosElementos: _elemtoEstructuresController.text,
      cuadranteSoldaduraId: widget.item.cuadranteSoldaduraId,
      cuadrante1: i,
      cuadrante2: ii,
      cuadrante3: iii,
      cuadrante4: iv,
      zonaSoldaduraId: widget.item.zonaSoldaduraId,
      zonaA: za,
      zonaB: zb,
      zonaC: zc,
      zonaD: zd,
      zonaE: ze,
      zonaF: zf,
      zonaG: zg,
      zonaH: zh,
      zonaV: zv,
    );

    var itemStore = BlocProvider.of<PanelRegisterBloc>(context)
        .state
        .actividadesSoldaduraUpdatearams
        .where((x) => x.registroSoldaduraId == widget.item.registroSoldaduraId)
        .toList();

    if (itemStore.length > 0) {
      //actualizar
      BlocProvider.of<PanelRegisterBloc>(context)
          .state
          .actividadesSoldaduraUpdatearams
          .removeWhere(
              (x) => x.registroSoldaduraId == widget.item.registroSoldaduraId);
      BlocProvider.of<PanelRegisterBloc>(context)
          .state
          .actividadesSoldaduraUpdatearams
          .add(itemUpdate);
    } else {
      //agregar al item al State
      BlocProvider.of<PanelRegisterBloc>(context)
          .state
          .actividadesSoldaduraUpdatearams
          .add(itemUpdate);
    }
  }

  BlocListener listenerMachineWelding() {
    return BlocListener<PanelRegisterBloc, PanelRegisterWelderState>(
        listener: (context, state) {
      if (state is SuccessAddMachineWelding) {
        if (state.machineWeldingModel.actionResult == "success") {
          //se agrego la maquina
          showNotificationSnackBar(context,
              title: "",
              mensaje: state.machineWeldingModel.mensaje,
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.blue[300],
              ),
              secondsDuration: 3,
              colorBarIndicator: Colors.green,
              borde: 8);
          aceptVigencia = 0;
          if (state.machineWeldingModel.maquina.folioSoldaduraId ==
              widget.item.folioSoldadura) {
            setState(() {
              widget.item.idEquipo = state.machineWeldingModel.maquina.idEquipo;
              widget.item.noSerie =
                  state.machineWeldingModel.maquina.equipoNoSerie;
              widget.item.equipoDescripcion =
                  state.machineWeldingModel.maquina.equipoDescripcion;
              widget.item.marca = state.machineWeldingModel.maquina.equipoMarca;
            });
            changeUpdateParams();
          }
        }

        if (state.machineWeldingModel.actionResult == "no-vigente") {
          if (state.machineWeldingModel.maquina.folioSoldaduraId ==
              widget.item.folioSoldadura) {
            _addMachineWeldingInvalidDate(
                _noSerieController.text, aceptVigencia);
          }
        }
      }

      if (state is ErrorAddMachinWelding) {
        if (state.messageError == 'existencia') {
          showNotificationSnackBar(context,
              title: "",
              mensaje: 'No existe la maquina de soldar!',
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.red[300],
              ),
              secondsDuration: 3,
              colorBarIndicator: Colors.red,
              borde: 8);
        }
      }

      // Nos arroja un mensaje al momento de remover maquina de soldar.
      if (state is SuccessRemoveMachineWelding) {
        if (state.removeMachineWeldingResponseModel.actionResult == "success") {
          //se agrego la maquina
          showNotificationSnackBar(context,
              title: "",
              mensaje: state.removeMachineWeldingResponseModel.mensaje,
              icon: Icon(
                Icons.check_circle_outline_rounded,
                size: 28.0,
                color: Colors.green,
              ),
              secondsDuration: 3,
              colorBarIndicator: Colors.green,
              borde: 8);
          if (state.removeMachineWeldingResponseModel.folioSoldaduraId ==
              widget.item.folioSoldadura) {
            setState(() {
              widget.item.idEquipo = null;
              widget.item.noSerie = null;
              widget.item.equipoDescripcion = null;
              widget.item.marca = null;
            });
            changeUpdateParams();
          }
        }
      }
    });
  }

  BlocListener listenerMachineWeldingV2() {
    return BlocListener<MachinesWelderBloc, MachinesWelderState>(
        listener: (context, state) {
      if (state is SuccessFetchMachineWeldingV2) {
        if (state.machineWeldingModel.actionResult == "success") {
          if (state.machineWeldingModel.maquinas == null ||
              state.machineWeldingModel.maquinas.length < 2) {
            if (state.machineWeldingModel.maquinas.length > 0) {
              if (state.machineWeldingModel.maquinas.first.vigente == 1) {
                _machinesWelderBloc.add(AddMachineWeldingV2(
                    idEquipo: state.machineWeldingModel.maquinas.first.idEquipo,
                    folioSoldaduraId: state
                        .machineWeldingModel.maquinas.first.folioSoldaduraId));
              } else {
                //llamar mensaje no vigente
                _addMachineWeldingInvalidDateV2(
                    state.machineWeldingModel.maquinas.first.idEquipo,
                    state.machineWeldingModel.maquinas.first.folioSoldaduraId,
                    false);
              }

              state.machineWeldingModel.maquinas.clear();
            }
          } else {
            lst.clear();
            _selectedMachine = '';
            state.machineWeldingModel.maquinas.forEach((element) {
              lst.add(element);
            });

            _addMachineWeldingMismaSerie(lst);
            state.machineWeldingModel.maquinas.clear();
          }
        } else {
          Dialogs.alert(context,
              title: 'Aviso', description: state.machineWeldingModel.mensaje);
        }
      }

      if (state is SuccessAddMachineWeldingV2) {
        if (state.machineWeldingModel.actionResult == "success") {
          //se agrego la maquina
          showNotificationSnackBar(context,
              title: "",
              mensaje: state.machineWeldingModel.mensaje,
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.blue[300],
              ),
              secondsDuration: 3,
              colorBarIndicator: Colors.green,
              borde: 8);
          aceptVigencia = 0;
          if (state.machineWeldingModel.maquina.folioSoldaduraId ==
              widget.item.folioSoldadura) {
            setState(() {
              widget.item.idEquipo = state.machineWeldingModel.maquina.idEquipo;
              widget.item.noSerie =
                  state.machineWeldingModel.maquina.equipoNoSerie;
              widget.item.equipoDescripcion =
                  state.machineWeldingModel.maquina.equipoDescripcion;
              widget.item.marca = state.machineWeldingModel.maquina.equipoMarca;
            });
            changeUpdateParams();
          }
        }
      }

      if (state is ErrorAddMachinWeldingV2) {
        if (state.messageError == 'existencia') {
          showNotificationSnackBar(context,
              title: "",
              mensaje: 'No existe la maquina de soldar!',
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.red[300],
              ),
              secondsDuration: 3,
              colorBarIndicator: Colors.red,
              borde: 8);
        }
      }
    });
  }

  BlocListener listenerRemoveWelderActivity() {
    return BlocListener<PanelRegisterBloc, PanelRegisterWelderState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (state is IsloadingRemoveWeldingActivity) {
        return loadingCircular();
      }
      // Se pudo remover la actividad correctamente!
      if (state is SuccessRemoveWeldingActivity) {
        if (state.removeWeldingActivityModel.actionResult == "success") {
          showNotificationSnackBar(context,
              title: "",
              mensaje: 'Soldador removido correctamente!',
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.green[500],
              ),
              secondsDuration: 3,
              colorBarIndicator: Colors.green,
              borde: 8);

          _panelRegisterBloc.add(GetPanelWelder(jointId: widget.item.juntaId));
        }
      }
      // Error al remover la maquina de soldar.
      if (state is ErrorRemoveWeldingActivity) {
        Navigator.pop(context);
        showNotificationSnackBar(context,
            title: "",
            mensaje: state.messageError,
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.red[300],
            ),
            secondsDuration: 3,
            colorBarIndicator: Colors.red,
            borde: 8);
      }
    });
  }

  BlocListener listenerGetQA() {
    return BlocListener<QualifyCaboNormBloc, QualifyCaboNormState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is SuccessQualifyNorma) {
        _panelRegisterBloc.add(GetPanelWelder(jointId: widget.item.juntaId));
        if (widget.item.folioSoldadura ==
            state.qualifyNormModel.folioSoldadura) {
          setState(() {
            widget.item.norma = normaChange;
            widget.item.inspectorCCAFicha = state.qualifyNormModel.ficha;
            widget.item.inspectorCCANombre = state.qualifyNormModel.nombre;
            widget.item.inspectorCCAPuestoDescripcion =
                state.qualifyNormModel.puesto;
          });
          changeUpdateParams();
        }
        showNotificationSnackBar(context,
            title: "",
            mensaje:
                'La inspección visual de soldadura se ha llevado a cabo y se encuentra ${state.qualifyNormModel.norma} de norma',
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.green[500],
            ),
            secondsDuration: 3,
            colorBarIndicator: Colors.green,
            borde: 8);

        _weldingListBloc.add(
          GetJointsWC(
            plainDetailId: widget.plainDetailId,
            frontId: widget.frontId,
            state: widget.state,
            clear: false,
          ),
        );
      }

      if (state is ErrorQualifyNorma) {
        showNotificationSnackBar(context,
            title: "",
            mensaje: 'Al parecer hubo un error!',
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.red[500],
            ),
            secondsDuration: 3,
            colorBarIndicator: Colors.red,
            borde: 8);
      }
    });
  }

  BlocListener listenerSignatureWelding() {
    return BlocListener<PanelRegisterBloc, PanelRegisterWelderState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (state is IsLoadingAddWelderSignature) {
        return showGeneralLoading(context);
      }
      // Se pudo remover la actividad correctamente!
      else if (state is SuccessAddWelderSignature) {
        Navigator.pop(context);
        //se agrego la maquina
        showNotificationSnackBar(context,
            title: "",
            mensaje: 'Soldador firmado correctamente!',
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.green[500],
            ),
            secondsDuration: 3,
            colorBarIndicator: Colors.green,
            borde: 8);
        //agregado para actualizar fecha inicio y fin
        String initialDate;
        String finalDate;

        DateFormat inputFormat = DateFormat("dd/MM/yyyy HH:mm");
        DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.S");
        if (_date1.text != '' || _hr1.text != '') {
          DateTime firstDate = inputFormat.parse(
              '${_date1.text == '' ? '01/01/0001' : _date1.text} ${_hr1.text == '' ? '00:00' : _hr1.text}');
          initialDate = outputFormat.format(firstDate);
        }

        if (_date2.text != '' || _hr2.text != '') {
          DateTime lastDate = inputFormat.parse(
              '${_date2.text == '' ? '01/01/0001' : _date2.text} ${_hr2.text == '' ? '00:00' : _hr2.text}');
          finalDate = outputFormat.format(lastDate);
        }

        _panelRegisterBloc.add(UpdateRegisterWelding(params: [
          UpdateWeldingDetailParams(
              registroSoldaduraId: widget.item.registroSoldaduraId,
              fondeo: f,
              pasoCaliente: pc,
              refresco1: r1,
              refresco2: r2,
              refresco3: r3,
              refresco4: r4,
              refresco5: r5,
              refresco6: r6,
              vista: v,
              longitudSoldada: double.parse(_longitudController.text),
              observaciones: _observacionesController.text,
              otrosElementos: _elemtoEstructuresController.text,
              cuadranteSoldaduraId: widget.item.cuadranteSoldaduraId,
              cuadrante1: i,
              cuadrante2: ii,
              cuadrante3: iii,
              cuadrante4: iv,
              zonaSoldaduraId: widget.item.zonaSoldaduraId,
              zonaA: za,
              zonaB: zb,
              zonaC: zc,
              zonaD: zd,
              zonaE: ze,
              zonaF: zf,
              zonaG: zg,
              zonaH: zh,
              zonaV: zv,
              fechaInicio: initialDate,
              fechaFin: finalDate),
        ]));

        _panelRegisterBloc.add(GetPanelWelder(jointId: widget.item.juntaId));
      }
      // Error al remover la maquina de soldar.
      if (state is ErrorAddWelderSignature) {
        Navigator.pop(context);
        showNotificationSnackBar(context,
            title: "",
            mensaje: state.messageError,
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.red[300],
            ),
            secondsDuration: 3,
            colorBarIndicator: Colors.red,
            borde: 8);
      }
    });
  }

  BlocListener listenerInitialDataJoint() {
    return BlocListener<PanelRegisterBloc, PanelRegisterWelderState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is SuccessInitialDataJoint) {
        Navigator.pop(context);
        _panelRegisterBloc.add(GetPanelWelder(jointId: widget.tipoJunta));
      }
    });
  }

  Widget listCheckEtapa() {
    return Container(
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.blue,
                value: this.f,
                onChanged: widget.item.firmado != 1
                    ? (bool value) {
                        setState(() {
                          this.f = value;
                          // validatorCheckEtapa = value;
                        });
                        changeUpdateParams();
                      }
                    : null,
              ),
              Text('F',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.blue,
                value: this.pc,
                onChanged: widget.item.firmado != 1
                    ? (bool value) {
                        setState(() {
                          this.pc = value;
                        });
                        changeUpdateParams();
                      }
                    : null,
              ),
              Text('PC',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.blue,
                value: this.r1,
                onChanged: widget.item.firmado != 1
                    ? (bool value) {
                        setState(() {
                          this.r1 = value;
                          // validatorCheckEtapa = value;
                        });
                        changeUpdateParams();
                      }
                    : null,
              ),
              Text('R1',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.blue,
                value: this.r2,
                onChanged: widget.item.firmado != 1
                    ? (bool value) {
                        setState(() {
                          this.r2 = value;
                          // validatorCheckEtapa = value;
                        });
                        changeUpdateParams();
                      }
                    : null,
              ),
              Text('R2',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.blue,
                value: this.r3,
                onChanged: widget.item.firmado != 1
                    ? (bool value) {
                        setState(() {
                          this.r3 = value;
                          // validatorCheckEtapa = value;
                        });
                        changeUpdateParams();
                      }
                    : null,
              ),
              Text('R3',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              widget.item.firmado != 1 ? Text('') : _signedWelder(),
            ],
          ),
          Row(
            children: <Widget>[
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.blue,
                value: this.r4,
                onChanged: widget.item.firmado != 1
                    ? (bool value) {
                        setState(() {
                          this.r4 = value;
                          // validatorCheckEtapa = value;
                        });
                        changeUpdateParams();
                      }
                    : null,
              ),
              Text('R4',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                value: this.r5,
                checkColor: Colors.white,
                activeColor: Colors.blue,
                onChanged: widget.item.firmado != 1
                    ? (bool value) {
                        setState(() {
                          this.r5 = value;
                          // validatorCheckEtapa = value;
                        });
                        changeUpdateParams();
                      }
                    : null,
              ),
              Text('R5',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              Checkbox(
                checkColor: Colors.white,
                activeColor: Colors.blue,
                value: this.r6,
                onChanged: widget.item.firmado != 1
                    ? (bool value) {
                        setState(() {
                          this.r6 = value;
                          // validatorCheckEtapa = value;
                        });
                        changeUpdateParams();
                      }
                    : null,
              ),
              Text('R6',
                  style:
                      TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
              widget.tipoJunta == 'Tubería'
                  ? Text('')
                  : Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.blue,
                      value: this.v,
                      onChanged: widget.item.firmado != 1
                          ? (bool value) {
                              setState(() {
                                this.v = value;
                                // validatorCheckEtapa = value;
                              });
                              changeUpdateParams();
                            }
                          : null),
              widget.tipoJunta == 'Tubería'
                  ? Text('')
                  : Text('V',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 10),
            alignment: Alignment.bottomLeft,
            child: Text(
                'Marcar segun la etapa marcada F: Fondeo, PC: Paso Caliente, R: Relleno, V: Vista'),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.bottomLeft,
            child: Text(
              validatorCheckEtapa == true
                  ? 'Recuerda seleccionar una opción *'
                  : '',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetOtros() {
    final Responsive responsive = Responsive.of(context);

    return Form(
        key: formOtros,
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
                          '* Otros elementos estructurales:',
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
                          child: TextFormField(
                            enabled: widget.item.firmado == 1 ? false : true,
                            controller: _elemtoEstructuresController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '[Es necesario ingresar información]';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            //minLines: 1, //Normal textInputField will be displayed
                            maxLines: 5,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              labelText: 'Otros elementos estructurales',
                              hintText: 'Ingrese información',
                              alignLabelWithHint: true,
                              suffixIcon: widget.item.firmado != 1
                                  ? Icon(Icons.format_list_numbered)
                                  : Icon(Icons.check_circle_sharp,
                                      size: 30.0, color: Colors.green),
                            ), // when user presses enter it will adapt to it
                            onChanged: (texto) {
                              changeUpdateParams();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget widgetEstructura() {
    return Container(
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
                      '* zona:',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: this.za,
                          onChanged: widget.item.firmado != 1
                              ? (bool value) {
                                  setState(() {
                                    this.za = value;
                                    // validatorcheckCuadrante = value;
                                  });
                                  changeUpdateParams();
                                }
                              : null,
                        ),
                        Text('A',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: this.zb,
                          onChanged: widget.item.firmado != 1
                              ? (bool value) {
                                  setState(() {
                                    this.zb = value;
                                    // validatorcheckCuadrante = value;
                                  });
                                  changeUpdateParams();
                                }
                              : null,
                        ),
                        Text('B',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: this.zc,
                          onChanged: widget.item.firmado != 1
                              ? (bool value) {
                                  setState(() {
                                    this.zc = value;
                                    // validatorcheckCuadrante = value;
                                  });
                                  changeUpdateParams();
                                }
                              : null,
                        ),
                        Text('C',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: this.zd,
                          onChanged: widget.item.firmado != 1
                              ? (bool value) {
                                  setState(() {
                                    this.zd = value;
                                    // validatorcheckCuadrante = value;
                                  });
                                  changeUpdateParams();
                                }
                              : null,
                        ),
                        Text('D',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: this.ze,
                          onChanged: widget.item.firmado != 1
                              ? (bool value) {
                                  setState(() {
                                    this.ze = value;
                                    // validatorcheckCuadrante = value;
                                  });
                                  changeUpdateParams();
                                }
                              : null,
                        ),
                        Text('E',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: this.zf,
                          onChanged: widget.item.firmado != 1
                              ? (bool value) {
                                  setState(() {
                                    this.zf = value;
                                    // validatorcheckCuadrante = value;
                                  });
                                  changeUpdateParams();
                                }
                              : null,
                        ),
                        Text('F',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold)),
                        widget.item.firmado != 1 ? SizedBox() : _signedWelder(),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: this.zg,
                          onChanged: widget.item.firmado != 1
                              ? (bool value) {
                                  setState(() {
                                    this.zg = value;
                                    // validatorcheckCuadrante = value;
                                  });
                                  changeUpdateParams();
                                }
                              : null,
                        ),
                        Text('G',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: this.zh,
                          onChanged: widget.item.firmado != 1
                              ? (bool value) {
                                  setState(() {
                                    this.zh = value;
                                    // validatorcheckCuadrante = value;
                                  });
                                  changeUpdateParams();
                                }
                              : null,
                        ),
                        Text('H',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold)),
                        Checkbox(
                          value: this.zv,
                          onChanged: widget.item.firmado != 1
                              ? (bool value) {
                                  setState(() {
                                    this.zv = value;
                                    // validatorcheckCuadrante = value;
                                  });
                                  changeUpdateParams();
                                }
                              : null,
                        ),
                        Text('V',
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      validatorCheckZona == true
                          ? 'Recuerda seleccionar un cuadrante *'
                          : '',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  void camposFaltantes() {
    showNotificationSnackBar(context,
        title: "",
        mensaje: 'Es necesario llenar todos los campos!',
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.yellow[300],
        ),
        secondsDuration: 3,
        colorBarIndicator: Colors.yellow,
        borde: 8);
  }

  Widget _builderImagenesLoad() {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<EvidencePhotographicWeldingBloc,
        EvidencePhotographicWeldingState>(builder: (context, state) {
      if (state is SuccessCreateEvidencePhotographicsWelding) {
        loadPhotographicWelding();
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

      if (state is SuccessDeleteEvidencePhotographicsWelding) {
        loadPhotographicWelding();
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

      if (state is ErrorEvidencePhotographicWelding) {
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
          widget.item.firmado == 1
              ? Container(width: 0.0, height: 0.0)
              : Container(
                  width: size.width * 0.3,
                  height: 200,
                  child: Column(
                    children: [
                      Text(
                        "Evidencia Fotográfica",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                          onTap: () {
                            selectedPhotographic('WELDING');
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
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[200], width: 1.0),
              ),
              width: widget.item.firmado == 1
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
                  Container(
                      height: 150,
                      child: (state is SuccessGetEvidencePhotographicsWelding)
                          ? (state.lstPhotographics
                                      .where((i) =>
                                          i.identificadorTabla ==
                                          '${widget.item.soldadorId}|${widget.item.folioSoldadura}')
                                      .length >
                                  0)
                              ? ListView.builder(
                                  padding: EdgeInsets.only(left: 16),
                                  itemCount: state.lstPhotographics
                                      .where((i) =>
                                          i.identificadorTabla ==
                                          '${widget.item.soldadorId}|${widget.item.folioSoldadura}')
                                      .length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding:
                                            EdgeInsets.only(right: 4, top: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              child: PhotographicCardWelding(
                                                imagen: state.lstPhotographics
                                                    .where((i) =>
                                                        i.identificadorTabla ==
                                                        '${widget.item.soldadorId}|${widget.item.folioSoldadura}')
                                                    .toList()[index],
                                                delete: deletePhotographic,
                                                preview:
                                                    showPhotographicPreview,
                                                readOnly: widget.item.firmado,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        ));
                                  })
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Aún no se ha agregado ninguna imagen",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "OpenSans",
                                        ))
                                  ],
                                )
                          : loadingCircular())
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  Widget _builderWeldingEvidenceFN(bool isOutOfNorm) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<EvidenceFNWeldingBloc, EvidenceFNWeldingState>(
        builder: (context, state) {
      if (state is SuccessCreateEvidenceFNsWelding) {
        loadEvidenceFN();
      }

      if (state is SuccessDeleteEvidenceFNsWelding) {
        loadEvidenceFN();
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

      if (state is ErrorEvidenceFNWelding) {
        showNotificationSnackBar(
          context,
          title: "Error mensaje",
          mensaje: state.errorMessage,
          icon: Icon(
            Icons.warning,
            size: 28.0,
            color: Colors.blue[300],
          ),
          secondsDuration: 3,
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
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                          onTap: () {
                            selectedPhotographic('WELDINGFN');
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
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[200], width: 1.0),
              ),
              width: isOutOfNorm ? size.width * 0.78 : size.width * 0.58,
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
                  Container(
                      height: 150,
                      child: (state is SuccessGetEvidenceFNsWelding)
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
                                              child: PhotographicCardWelding(
                                                imagen: state
                                                    .lstPhotographics[index],
                                                delete: deletePhotographicFN,
                                                preview:
                                                    showPhotographicPreview,
                                                readOnly: isOutOfNorm ? 1 : 0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        ));
                                  })
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Aún no se ha agregado ninguna imagen",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "OpenSans",
                                        ))
                                  ],
                                )
                          : loadingCircular())
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  Widget listCheckCuadrante() {
    return Container(
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
                      '* Cuadrantes:',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: this.i,
                      onChanged: widget.item.firmado != 1
                          ? (bool value) {
                              setState(() {
                                this.i = value;
                                validatorcheckCuadrante = value;
                              });
                            }
                          : null,
                    ),
                    Text('I',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold)),
                    Checkbox(
                      value: this.ii,
                      onChanged: widget.item.firmado != 1
                          ? (bool value) {
                              setState(() {
                                this.ii = value;
                                validatorcheckCuadrante = value;
                              });
                              changeUpdateParams();
                            }
                          : null,
                    ),
                    Text('II',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold)),
                    Checkbox(
                      value: this.iii,
                      onChanged: (bool value) {
                        setState(() {
                          this.iii = value;
                          validatorcheckCuadrante = value;
                        });
                        changeUpdateParams();
                      },
                    ),
                    Text('III',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold)),
                    Checkbox(
                      value: this.iv,
                      onChanged: widget.item.firmado != 1
                          ? (bool value) {
                              setState(() {
                                this.iv = value;
                                validatorcheckCuadrante = value;
                              });
                              changeUpdateParams();
                            }
                          : null,
                    ),
                    Text('IV',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.bold)),
                    widget.item.firmado != 1 ? Text('') : _signedWelder(),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                      validatorcheckCuadrante == true
                          ? ''
                          : 'Recuerda seleccionar un cuadrante *',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showPhotographicPreview(String content) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DetailScreen(bytes: base64.decode(content));
    }));
  }

  void _deleteMahchineWelding(String folioSoldadura, String idEquipo) {
    confirmModal(
      context,
      '¿Está seguro de que desea remover la máquina soldador "$idEquipo"?',
      'Aceptar',
      positiveAction: () {
        _panelRegisterBloc.add(
            RemoveMachineWelding(folioSoldaduraId: widget.item.folioSoldadura));
      },
    );
  }

  void _addMachineWeldingInvalidDate(String noSerie, int aceptVigencia) {
    confirmModal(
      context,
      'La vigencia del certificado de la máquina de soldar está vencida ¿Desea continuar de todas formas?',
      'Agregar',
      positiveAction: () {
        aceptVigencia = 1;
        _panelRegisterBloc.add(AddMachineWelding(
            noSerie: noSerie,
            folioSoldaduraId: widget.item.folioSoldadura,
            aceptVigencia: aceptVigencia));
      },
    );
  }

  void _addMachineWeldingInvalidDateV2(
      String idEquipo, String folioSoldadura, bool llamadoDesdeModalEquipos) {
    confirmModal(
      context,
      'La vigencia del certificado de la máquina de soldar está vencida ¿Desea continuar de todas formas?',
      'Agregar',
      positiveAction: () {
        if (llamadoDesdeModalEquipos) Navigator.pop(context);
        _machinesWelderBloc.add(AddMachineWeldingV2(
            idEquipo: idEquipo, folioSoldaduraId: folioSoldadura));
      },
    );
  }

  void _selectMachineWelding() {
    Dialogs.alert(context,
        title: 'Aviso', description: 'Debe seleccionar un equipo');
  }

  void _addMachineWeldingMismaSerie(List<MachineWeldingModel> maquinas) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccionar Equipo'),
          content: Container(
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 15.0,
                    columns: [
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('No. Serie')),
                      DataColumn(label: Text('Especificación Equipo')),
                      DataColumn(label: Text('Descripción')),
                      DataColumn(label: Text('Marca')),
                      DataColumn(label: Text('No. Material SAP')),
                    ],
                    rows: resourcesRows(maquinas),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white60,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                            child: Text('Cancelar'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                            child: Text('Aceptar'),
                            onPressed: () {
                              if (_selectedMachine != "") {
                                if (_existe == 1) {
                                  if (_vigente == 1) {
                                    Navigator.pop(context);
                                    _machinesWelderBloc.add(AddMachineWeldingV2(
                                        idEquipo: _selectedMachine,
                                        folioSoldaduraId:
                                            maquinas.first.folioSoldaduraId));
                                  } else {
                                    //llamar mensaje no vigente
                                    _addMachineWeldingInvalidDateV2(
                                        _selectedMachine,
                                        maquinas.first.folioSoldaduraId,
                                        true);
                                  }
                                } else {
                                  Dialogs.alert(context,
                                      title: 'Sin certificado',
                                      description:
                                          'El equipo no tiene certificado');
                                }
                              } else {
                                //llamar mensaje seleccione
                                _selectMachineWelding();
                              }
                            },
                          ),
                        ]))
              ],
            ),
          ),
        );
      },
    );
  }

  List<DataRow> resourcesRows(List<MachineWeldingModel> maquinas) {
    List<DataRow> rowList = [];

    maquinas.forEach((element) {
      rowList.add(DataRow(cells: [
        DataCell(
          Radio(
            value: element.idEquipo,
            groupValue: _selectedMachine,
            activeColor: Colors.blue,
            onChanged: (val) {
              setSelectedMachine(val, element.vigente, element.existe);
              Navigator.pop(context);
              _addMachineWeldingMismaSerie(maquinas);
            },
          ),
        ),
        DataCell(Text(element.equipoNoSerie)),
        DataCell(Container(width: 160.0, child: Text(element.material))),
        DataCell(
          Container(
            width: 200.0,
            child: Text(element.equipoDescripcion,
                overflow: TextOverflow.ellipsis),
          ),
          onTap: () {
            Dialogs.alert(context,
                title: element.material,
                description: element.equipoDescripcion);
          },
        ),
        DataCell(Text(element.equipoMarca)),
        DataCell(Text(element.noMaterialSAP)),
      ]));
    });
    //maquinas.clear();
    return rowList;
  }

  // Se marca fuera de norma
  void _markAsOutOfNorm(String motivoFN, String norma) {
    confirmModal(
      context,
      '¿Desea continuar con el proceso de calificación de inspección visual como fuera de norma?',
      'Aceptar',
      positiveAction: () {
        _showWeldingFNModal(motivoFN, norma);
      },
    );
  }

  void _markAsWithinNorm(
    String folioSoldaduraId,
    int inspectorCCAId,
    String norma,
    String motivoFN,
    String juntaId,
  ) {
    confirmModal(
      context,
      '¿Desea continuar con el proceso de calificación de inspección visual como dentro de norma?',
      'Aceptar',
      positiveAction: () {
        normaChange = norma;
        _qualifyCaboNormBloc.add(QualifyCaboNorm(
            folioSoldadura: folioSoldaduraId,
            inspectorCCAId: inspectorCCAId,
            norma: norma,
            motivoFN: motivoFN,
            juntaId: juntaId,
            listACS: [],
            nombreTabla: 'HSEQMC.EmpleadosSoldadura'));
      },
    );
  }

  void _showWeldingFNModal(String motivoFN, String norma) {
    loadEvidenceFN();
    _observacionesFNController.text =
        widget.item.motivoFN == null ? '' : widget.item.motivoFN;

    contentModal(
      context,
      'Soldador: ${widget.item.nombreSoldador}',
      'Continuar',
      contentBody: _contentFN(),
      positiveAction: () {
        bool hasReasson;
        bool evidence;

        hasReasson = _observacionesFNController.text.isNotEmpty;
        evidence = _evidenceFNWeldingBloc.state.lstPhotographics.isNotEmpty;

        if (hasReasson && evidence && listCriterosSoldaduraFull.isNotEmpty) {
          normaChange = norma;
          _qualifyCaboNormBloc.add(
            QualifyCaboNorm(
                folioSoldadura: widget.item.folioSoldadura,
                inspectorCCAId: int.parse(widget.user.ficha),
                norma: 'F/N',
                motivoFN: _observacionesFNController.text,
                juntaId: widget.item.juntaId,
                listACS: listCriterosSoldaduraFull,
                nombreTabla: 'HSEQMC.EmpleadosSoldadura'),
          );
          Navigator.pop(context);
          widget.scrollControler.animateTo(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        } else {
          showNotificationSnackBar(
            context,
            title: "",
            mensaje: 'Debe completar toda la información.',
            icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
            secondsDuration: 8,
            colorBarIndicator: Colors.red,
            borde: 8,
          );
        }
      },
    );
  }

  Widget _contentFN() {
    Responsive responsive = Responsive(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  MultiSelectBottomSheetField<AcceptanceCriteriaWeldingModel>(
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
                        listCriterosSoldaduraFull = values;
                      });
                      _multiSelectKey.currentState.validate();
                    },
                    chipDisplay: MultiSelectChipDisplay(
                      chipColor: Colors.blueAccent,
                      textStyle: TextStyle(color: Colors.white),
                      onTap: (item) {
                        setState(() {
                          listCriterosSoldaduraFull.remove(item);
                        });
                        _multiSelectKey.currentState.validate();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Motivo:',
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
                          key: formFN,
                          child: TextFormField(
                            controller: _observacionesFNController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '[Es necesario las observaciones]';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                            //minLines: 1, //Normal textInputField will be displayed
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              labelText: 'Motivo: ',
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
                  _builderWeldingEvidenceFN(false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showViewWeldingFN(
    String nombreSoldador,
    String folioSoldaduraId,
    String norma,
    String motivoFN,
    String juntaId,
    String nombreQA,
    String puestoQA,
    dynamic fichaQA,
  ) {
    loadEvidenceFN();

    contentModal(
      context,
      'Soldador: $nombreSoldador',
      'Agregar',
      contentBody: _contentViewFN(motivoFN, nombreQA, fichaQA, puestoQA),
      positiveAction: () {
        bool hasReasson;

        hasReasson = addWelderController.text.isNotEmpty;

        if (hasReasson) {
          if (folioSoldaduraId == widget.item.folioSoldadura) {
            var addWelderModel = new AddCardWelderParams(
              card: addWelderController.text,
              jointId: juntaId,
              consecutiveWelding: widget.consecutivoSoldadura,
              consecutiveWeldingFN: folioSoldaduraId,
            );

            // widget.test = folioSoldaduraId;

            Navigator.pop(context);
            _addWelderBloc
                .add(AddWelderWPSValid(addCardWelder: addWelderModel));
          }
        } else {
          showNotificationSnackBar(
            context,
            title: "",
            mensaje: 'Por favor ingrese un No. de Ficha',
            icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
            secondsDuration: 8,
            colorBarIndicator: Colors.red,
            borde: 6,
          );
        }
      },
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

  //german
  Widget _contentViewFN(
      String motivoFN, String nombreQA, dynamic fichaQA, String puestoQA) {
    Responsive responsive = Responsive(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  Container(
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
                  )),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Motivo:',
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
                          child: TextField(
                            enabled: false,
                            keyboardType: TextInputType.multiline,
                            //minLines: 1, //Normal textInputField will be displayed
                            maxLines: 2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              labelText: '$motivoFN',
                              alignLabelWithHint: true,
                              suffixIcon: Icon(Icons.text_format, size: 30.0),
                            ), // when user presses enter it will adapt to it
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 10, left: 30, right: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Calificado por:',
                              style: TextStyle(
                                fontSize: responsive.dp(1.4),
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        CardQA(
                          initialsQA: _getInitials(nombreQA),
                          name: nombreQA,
                          category: puestoQA,
                          normStatus: 'F/N',
                          ficha: fichaQA.toString(),
                          onPressedFN: () {},
                          onpressedDN: () {},
                          onPressedOutNorm: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  _builderWeldingEvidenceFN(true),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
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
                        TextField(
                          controller: addWelderController,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => addWelderController.clear(),
                              icon: Icon(Icons.clear),
                            ),
                            labelText:
                                'Ingrese el número de ficha del soldador',
                            hintText: 'Número de ficha...',
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signedWelder() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Icon(Icons.check_circle_sharp, size: 30.0, color: Colors.green),
    );
  }

  Widget get builderAddMaquina {
    final Responsive responsive = Responsive.of(context);

    return Expanded(
        child: Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Máquina de soldar (Agregar):',
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
                      child: Column(
                        children: [
                          Form(
                              key: noSerieMaquina,
                              child: TextFormField(
                                controller: _noSerieController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Es necesario el No de serie';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.multiline,
                                //minLines: 1, //Normal textInputField will be displayed
                                maxLines: 1,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () => _noSerieController.clear(),
                                    icon: Icon(Icons.clear),
                                  ),
                                  labelText: 'Ingrese el No. de Serie',
                                  hintText: 'Número de Serie...',
                                  alignLabelWithHint: true,
                                ), // when user presses enter it will adapt to it
                              )),
                          Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                                child: Text('Agregar',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  final formNoSerie =
                                      noSerieMaquina.currentState;
                                  if (formNoSerie.validate()) {
                                    //aqui ir a buscar con mismo num serie
                                    _machinesWelderBloc
                                        .add(FetchMachineWeldingV2(
                                      noSerie: _noSerieController.text,
                                      folioSoldaduraId:
                                          widget.item.folioSoldadura,
                                    ));

                                    // _panelRegisterBloc.add(AddMachineWelding(
                                    //   noSerie: _noSerieController.text,
                                    //   folioSoldaduraId:
                                    //       widget.item.folioSoldadura,
                                    //   aceptVigencia: aceptVigencia,
                                    // ));
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  bool validarFormulario() {
    /*
    Validar si agrego maquina
    validar si agrego  etapas 

    validar  si agrego longitud <-- se resuelve con el  form
    validar si agrego observaciones <-- se resuelve con el  form
    */
    bool isValid = true;

    if (validatorAgregoMaquina) isValid = true;

    if (!(f == true ||
        pc == true ||
        r1 == true ||
        r2 == true ||
        r3 == true ||
        r4 == true ||
        r5 == true ||
        r6 == true ||
        v == true ||
        widget.tipoJunta == "Estructura")) {
      isValid = false;
      setState(() {
        validatorCheckEtapa = true;
      });
    } else {
      setState(() {
        validatorCheckEtapa = false;
      });
    }

    if (showEstructura) {
      //validar si agrego zonas
      if (!(za == true ||
          zb == true ||
          zc == true ||
          zd == true ||
          ze == true ||
          zf == true ||
          zg == true ||
          zh == true ||
          zv == true)) {
        isValid = false;
        setState(() {
          validatorCheckZona = true;
        });
      } else {
        setState(() {
          validatorCheckZona = false;
        });
      }
    } else if (showTuberia) {
      //validar si agrego cuadrantes
      if (!(i == true || ii == true || iii == true || iv == true)) {
        isValid = true;
        setState(() {
          validatorcheckCuadrante = true;
        });
      } else {
        setState(() {
          validatorcheckCuadrante = false;
        });
      }
    } else {
      // validar si agrego valor al campo otros estructurares <--- se resuelve con el form formOtros
      final form = formOtros.currentState;
      if (!form.validate()) isValid = false;
    }

    return isValid;
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
}
