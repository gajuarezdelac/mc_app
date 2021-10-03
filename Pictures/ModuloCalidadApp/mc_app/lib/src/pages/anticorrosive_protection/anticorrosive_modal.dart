import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/bloc/document/document_bloc.dart';
import 'package:mc_app/src/bloc/document/document_event.dart';
import 'package:mc_app/src/bloc/document/document_state.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/anticorrosive_ipa/anticorrosive_ipa_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/anticorrosive_ipa/anticorrosive_ipa_event.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/coating_aplication/coating_aplication_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/coating_aplication/coating_aplication_event.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/coating_aplication/coating_aplication_state.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/coating_system/coating_system_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/coating_system/coating_system_event.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/equipment/equipment_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/equipment/equipment_event.dart';
import 'package:mc_app/src/models/anticorrosive_ipa_model.dart';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';
import 'package:mc_app/src/models/coating_aplication_model.dart';
import 'package:mc_app/src/models/coating_system_model.dart';
import 'package:mc_app/src/models/document_model.dart';
import 'package:mc_app/src/models/equipment_model.dart';
import 'package:mc_app/src/models/material_stages_d_ipa_model.dart';
import 'package:mc_app/src/models/materials_table_ipa_model.dart';
import 'package:mc_app/src/models/params/documents_params.dart';
import 'package:mc_app/src/models/params/environmental_conditions_params.dart';
import 'package:mc_app/src/models/params/photographic_evidence_params_model.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';
import 'package:mc_app/src/models/stage_materials_ipa_model.dart';
import 'package:mc_app/src/pages/anticorrosive_protection/widgets/modal_evaluation.dart';
import 'package:mc_app/src/pages/detail_photographic_screen.dart';
import 'package:mc_app/src/utils/always_disabled_focus_node.dart';
import 'package:mc_app/src/utils/dialogs.dart';
import 'package:mc_app/src/widgets/confirm_modal.dart';
import 'package:mc_app/src/widgets/flat_button.dart';
import 'package:mc_app/src/widgets/pdf_viewer.dart';
import 'package:mc_app/src/widgets/photographic_card.dart';
import 'package:mc_app/src/widgets/row_box.dart';
import 'package:mc_app/src/widgets/show_general_loading.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

class AnticorrosiveModal extends StatefulWidget {
  final AnticorrosiveProtectionModel anticorrosiveProtectionModel;
  final Function search;

  AnticorrosiveModal({Key key, @required this.anticorrosiveProtectionModel, this.search})
      : super(key: key);

  @override
  _AnticorrosiveModalState createState() => _AnticorrosiveModalState();
}

class _AnticorrosiveModalState extends State<AnticorrosiveModal>
    with SingleTickerProviderStateMixin {
  //Controladores
  TabController tabController;
  final ScrollController controller = ScrollController();

  //Controladores componentes
  List<TextEditingController> controllerTA = [];
  List<TextEditingController> controllerTS = [];
  List<TextEditingController> controllerHR = [];
  List<TextEditingController> controllerDocuments = [];
  TextEditingController _observacionRF = new TextEditingController();
  TextEditingController _sustrato = new TextEditingController();
  TextEditingController _abrasivo = new TextEditingController();
  TextEditingController _anclaje = new TextEditingController();
  TextEditingController _limpieza = new TextEditingController();
  TextEditingController _observaciones = new TextEditingController();
  bool _incluirEvidencias = false;
  List<TextEditingController> controllerObsRF = [];
  List<TextEditingController> controllerLote = [];
  List<TextEditingController> controllerFCaducidad = [];
  List<TextEditingController> controllerMetodo = [];
  List<TextEditingController> controllerTipo = [];
  List<TextEditingController> controllerMezcla = [];
  List<TextEditingController> controllerEspesor = [];
  List<TextEditingController> controllerSecado = [];
  List<TextEditingController> controllerSolvente = [];
  List<TextEditingController> controllerPruebaC = [];
  List<TextEditingController> controllerPruebaA = [];
  List<TextEditingController> controllerDocumento = [];
  List<TextEditingController> controllerComentarioC = [];
  List<TextEditingController> controllerComentarioA = [];
  List<TextEditingController> controllerNoPruebas = [];
  List<TextEditingController> controllerEquipos = [];
  List<TextEditingController> controllerDatesStages = [];
  TextEditingController controllerReleaseDate = new TextEditingController();
  List<TextEditingController> controllerPercentage = [];
  List<TextEditingController> controllerLocation = [];
  TextEditingController controllerLocationTemp = new TextEditingController();
  List<TextEditingController> controllerRelease = [];

  //Bloc
  CoatingSystemBloc _coatingSystemBloc;
  InfoGeneralBloc _infoGeneralBloc;
  EquipmentBloc _equipmentBloc;
  EnvironmentalConditionsBloc _environmentalConditionsBloc;
  CoatingAplicationBloc _coatingAplicationBloc;
  DocumentBloc _documentBloc;
  EvidencePhotographicBloc _evidencePhotographicBloc;
  StageMaterialIPABloc _stageMaterialIPABloc;
  MaterialsIPABloc _materialsIPABloc;
  MaterialStagesDIPABloc _materialStagesDIPABloc;

  //Variables
  List<CoatingSystemModel> _listCoatingSystem = [];
  bool _pickFileInProgress = false;
  List<DocumentModel> _documents = [];
  List<PhotographicEvidenceModel> _lstPhotographics = [];
  List<EquipmentModel> _lstEquipment = [];
  List<StageMaterialsIPAModel> _lstStageMaterials = [];
  bool clean = false;
  List<MaterialsTableIPAModel> _lstMaterialsIPA = [];
  List<MaterialsTableIPAModel> _lstMaterialsIPAV2 = [];
  List<DateTime> datesRelease = [];
  List<DateTime> datesReportRelease = [];
  DateTime dateReportRelease = new DateTime.now();
  List<MaterialStagesDIPAModel> _lstMaterialStagesDIPA = [];
  String norma = '';
  bool isLoadingTab1 = false;
  bool isLoadingTab2 = false;
  int numberRequest = 0;
  int indexTab = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setState(() {
      controllerDocuments = [];
      controllerTA = [];
      controllerTS = [];
      controllerHR = [];
      controllerObsRF = [];
      controllerLote = [];
      controllerFCaducidad = [];
      controllerMetodo = [];
      controllerTipo = [];
      controllerMezcla = [];
      controllerEspesor = [];
      controllerSecado = [];
      controllerSolvente = [];
      controllerPruebaC = [];
      controllerPruebaA = [];
      controllerDocumento = [];
      controllerComentarioC = [];
      controllerComentarioA = [];
      controllerNoPruebas = [];
      controllerEquipos = [];
      controllerDatesStages = [];
      controllerLocation = [];
      controllerRelease = [];
      datesRelease = [];
    });

    _coatingSystemBloc = BlocProvider.of<CoatingSystemBloc>(context);
    _infoGeneralBloc = BlocProvider.of<InfoGeneralBloc>(context);
    _equipmentBloc = BlocProvider.of<EquipmentBloc>(context);
    _environmentalConditionsBloc =
        BlocProvider.of<EnvironmentalConditionsBloc>(context);
    _coatingAplicationBloc = BlocProvider.of<CoatingAplicationBloc>(context);
    _documentBloc = BlocProvider.of<DocumentBloc>(context);
    _evidencePhotographicBloc =
        BlocProvider.of<EvidencePhotographicBloc>(context);
    _stageMaterialIPABloc = BlocProvider.of<StageMaterialIPABloc>(context);
    _materialsIPABloc = BlocProvider.of<MaterialsIPABloc>(context);
    _materialStagesDIPABloc = BlocProvider.of<MaterialStagesDIPABloc>(context);

    tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    tabController.addListener(_handleTabChange);

    //Recupera las etapas del sistema vinculado a la protección anticorrosiva.
    _coatingSystemBloc.add(GetStagesCoatingSystem(
        noRegistro: widget.anticorrosiveProtectionModel.noRegistro));

    //Comprueba si ya existe información general del registro
      _infoGeneralBloc.add(GetInfoGeneral(
          noRegistro: widget.anticorrosiveProtectionModel.noRegistro));

    //Comprueba si ya existe equipos agregados
      _equipmentBloc.add(GetEquipment(
          noRegistro: widget.anticorrosiveProtectionModel.noRegistro));

    //Comprueba si ya existe condiciones ambientales
      _environmentalConditionsBloc.add(GetEnvironmentalConditions(
          noRegistro: widget.anticorrosiveProtectionModel.noRegistro));

    //Comprueba si ya existe aplicación de recubrimiento
      _coatingAplicationBloc.add(GetCoatingAplication(
          noRegistro: widget.anticorrosiveProtectionModel.noRegistro));

    _documentBloc.add(GetDocuments(
        params: DocumentsParams(
            identificadorTabla: widget.anticorrosiveProtectionModel.noRegistro,
            nombreTabla: 'HSEQMC.ProteccionAnticorrosiva')));

    var loadPhotographicParams = new PhotographicEvidenceParamsModel(
        identificadorTabla:
            widget.anticorrosiveProtectionModel.noRegistro + '%',
        nombreTabla: "HSEQMC.ProteccionAnticorrosiva",
        tipo: "1");
    _evidencePhotographicBloc
        .add(GetEvidencePhotographicV2(params: loadPhotographicParams));

    //------- SECCIÓN TAB MATERIALES -------
    //Carga de información del Tab Materiales
    _stageMaterialIPABloc.add(GetStageMaterialIPA(
        noRegistro: widget.anticorrosiveProtectionModel.noRegistro));

    _materialsIPABloc.add(GetMaterialsIPA(
        noRegistro: widget.anticorrosiveProtectionModel.noRegistro));

    _materialStagesDIPABloc.add(GetMaterialStagesDIPA(
        noRegistro: widget.anticorrosiveProtectionModel.noRegistro));
  }

  void insUpdEnvironmentalConditions() {
    List<EnvironmentalConditionsParams> param = [];

    for (var item in _listCoatingSystem) {
      param.add(new EnvironmentalConditionsParams(
          orden: item.orden,
          temperaturaAmbiente:
              controllerTA[_listCoatingSystem.indexOf(item)].text,
          temperaturaSustrato:
              controllerTS[_listCoatingSystem.indexOf(item)].text,
          humedadRelativa:
              controllerHR[_listCoatingSystem.indexOf(item)].text));
    }

    _environmentalConditionsBloc.add(InsUpdEnvironmentalConditions(
        noRegistro: widget.anticorrosiveProtectionModel.noRegistro,
        param: param));
  }

  bool validateForm() {
    bool valid = true;
    if (
      controllerDocuments.where((element) => element.text == '').length > 0
    ) {
      valid = false;
    }

    return valid;
  }

  void insUpdDocuments() {
    List<DocumentModel> _params = [];
    for (var i = 0; i < _documents.length; i++) {
      _params.add(new DocumentModel(
          id: _documents[i].id,
          nombre: controllerDocuments[i].text,
          name: _documents[i].name,
          content: _documents[i].content,
          contentType: _documents[i].contentType));
    }

    _documentBloc.add(InsUpdDocument(
        params: _params,
        identificadorTabla: widget.anticorrosiveProtectionModel.noRegistro,
        nombreTabla: 'HSEQMC.ProteccionAnticorrosiva'));
  }

  void insUpdInfoGeneral() {
    var anticorrosiveIPAModel = new AnticorrosiveIPAModel(
        observacionesRF: _observacionRF.text,
        sustrato: _sustrato.text,
        abrasivo: _abrasivo.text,
        anclaje: _anclaje.text,
        limpieza: _limpieza.text,
        incluirEvidencias: _incluirEvidencias,
        observaciones: _observaciones.text);

    _infoGeneralBloc.add(InsUpdInfoGeneral(
        anticorrosiveIPAModel: anticorrosiveIPAModel,
        noRegistro: widget.anticorrosiveProtectionModel.noRegistro));
  }

  void insUpdEvidencePhotographicV2() {
    _evidencePhotographicBloc.add(InsUpdEvidencePhotographicV2(
        params: _lstPhotographics,
        identificadorComun:
            widget.anticorrosiveProtectionModel.noRegistro + '%',
        tablaComun: 'HSEQMC.ProteccionAnticorrosiva'));
  }

  void insUpdCoatingApplication() {
    List<CoatingAplicationModel> params = [];
    for (var item
        in _listCoatingSystem.where((element) => element.recubrimiento == 1)) {
      params.add(new CoatingAplicationModel(
          orden: item.orden,
          observacion: controllerObsRF[_listCoatingSystem
                  .where((element) => element.recubrimiento == 1)
                  .toList()
                  .indexOf(item)]
              .text,
          noLote: controllerLote[_listCoatingSystem
                  .where((element) => element.recubrimiento == 1)
                  .toList()
                  .indexOf(item)]
              .text,
          fechaCaducidad: controllerFCaducidad[_listCoatingSystem
                  .where((element) => element.recubrimiento == 1)
                  .toList()
                  .indexOf(item)]
              .text,
          metodoAplicacion: controllerMetodo[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text,
          tipoRecubrimiento: controllerTipo[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text,
          mezcla: controllerMezcla[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text,
          espesorSecoPromedio: controllerEspesor[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text,
          tiempoSecado: controllerSecado[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text,
          tipoEnvolvente: controllerSolvente[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text,
          pruebaContinuidad: item.continuidad == 1 ? controllerPruebaC[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text : null,
          pruebaAdherencia: item.adherencia == 1 ? controllerPruebaA[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text : null,
          documentoAplicable: item.adherencia == 1 ? controllerDocumento[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text : null,
          comentariosContinuidad: item.continuidad == 1 ? controllerComentarioC[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text : null,
          comentariosAdherencia: item.adherencia == 1 ? controllerComentarioA[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text : null,
          numeroPruebas: item.adherencia == 1 ? int.tryParse(controllerNoPruebas[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text) : 0));
    }

    _coatingAplicationBloc.add(InsUpdCoatingAplication(
        noRegistro: widget.anticorrosiveProtectionModel.noRegistro,
        params: params));
  }

  Future<void> showModalRelease(BuildContext context, int materialIdIPA) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: datesRelease[_lstMaterialsIPA.indexOf(_lstMaterialsIPA
            .firstWhere((element) => element.materialIdIPA == materialIdIPA))],
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        DateFormat formatter = DateFormat('dd/MM/yyyy');

        setState(() {
          controllerRelease[_lstMaterialsIPA.indexOf(
                  _lstMaterialsIPA.firstWhere(
                      (element) => element.materialIdIPA == materialIdIPA))]
              .text = formatter.format(picked);
          datesRelease[_lstMaterialsIPA.indexOf(_lstMaterialsIPA.firstWhere(
              (element) => element.materialIdIPA == materialIdIPA))] = picked;
          _lstMaterialsIPA
              .firstWhere((element) => element.materialIdIPA == materialIdIPA)
              .fechaLiberacion = formatter.format(picked);
        });
      });
    }
  }

  showModalLocation(int materialIdIPA) {
    AlertDialog alert = AlertDialog(
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: 'Guardar',
          onPressed: () {
            setState(() {
              controllerLocation[_lstMaterialsIPAV2.indexOf(
                      _lstMaterialsIPAV2.firstWhere(
                          (element) => element.materialIdIPA == materialIdIPA))]
                  .text = controllerLocationTemp.text;
              _lstMaterialsIPAV2
                  .firstWhere(
                      (element) => element.materialIdIPA == materialIdIPA)
                  .localizacion = controllerLocationTemp.text;
            });
            Navigator.of(context).pop();
          },
        )
      ],
      title: Text('Evaluación LOCALIZACIÓN/ESTRUCTURA/PLATAFORMA'),
      content: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Nombre del elemento',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                )),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        'Localización',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ))
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    _lstMaterialsIPAV2
                        .firstWhere(
                            (element) => element.materialIdIPA == materialIdIPA)
                        .nombreElemento,
                    textAlign: TextAlign.left,
                  ),
                )),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                          controller: controllerLocationTemp,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText: 'Localización')),
                    ))
              ],
            )
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void insUpdEquipment() {
    List<EquipmentModel> params = [];

    for (var item in _lstEquipment) {
      var index = _lstEquipment.indexOf(item);
      params.add(new EquipmentModel(
          nombre: controllerEquipos[index].text, orden: index + 1));
    }

    _equipmentBloc.add(InsUpdEquipment(
        noRegistro: widget.anticorrosiveProtectionModel.noRegistro,
        params: params));
  }

  void insUpdMaterialsIPA() {
    List<MaterialsTableIPAModel> params = [];

    bool isTwentyFourHour = MediaQuery.of(context).alwaysUse24HourFormat;
    DateFormat inputFormat = DateFormat(
        isTwentyFourHour ? "dd/MM/yyyy HH:mm" : "dd/MM/yyyy hh:mm aaa");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.S");

    String hour = isTwentyFourHour ? '00:00' : '00:00 AM';

    for (var item in _lstMaterialsIPA) {

      String releaseDate = '0001-01-01 00:00:00.000';
      int index = _lstMaterialsIPA.indexOf(item);

      if (controllerRelease[index].text != "") {
        DateTime _releaseDate = inputFormat.parse(
            '${controllerRelease[index].text} $hour');
        releaseDate = outputFormat.format(_releaseDate);
      }

      params.add(new MaterialsTableIPAModel(
        materialIdIPA: item.materialIdIPA,
        nombreElemento: item.nombreElemento,
        localizacion: controllerLocation[_lstMaterialsIPAV2.indexWhere((element) => element.nombreElemento == item.nombreElemento)].text,
        trazabilidadId: item.trazabilidadId,
        planoDetalle: item.planoDetalle,
        um: item.um,
        tipoMaterial: item.tipoMaterial,
        cantidadUsada: item.cantidadUsada,
        fechaLiberacion: releaseDate
      ));
    }

    _materialsIPABloc.add(InsUpdMaterialsIPA(noRegistro: widget.anticorrosiveProtectionModel.noRegistro, params: params));
  }

  void insUpdMaterialsStageDIPA() {
    List<MaterialStagesDIPAModel> params = [];

    bool isTwentyFourHour = MediaQuery.of(context).alwaysUse24HourFormat;
    DateFormat inputFormat = DateFormat(
        isTwentyFourHour ? "dd/MM/yyyy HH:mm" : "dd/MM/yyyy hh:mm aaa");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.S");

    String hour = isTwentyFourHour ? '00:00' : '00:00 AM';

    for (var item in _listCoatingSystem.where((element) => element.recubrimiento == 1)){
      for (var obj in _lstMaterialsIPA) {
        String evaluationDate = '0001-01-01 00:00:00.000';
        String proposedDate = '0001-01-01 00:00:00.000';

        bool exists = _lstMaterialStagesDIPA.any((element) => element.orden == item.orden && element.materialIdIPA == obj.materialIdIPA);

        if(exists && _lstMaterialStagesDIPA.firstWhere((element) => element.orden == item.orden && element.materialIdIPA == obj.materialIdIPA).fechaEvaluacion != null && _lstMaterialStagesDIPA.firstWhere((element) => element.orden == item.orden && element.materialIdIPA == obj.materialIdIPA).fechaEvaluacion != "") {
          DateTime _evaluationDate = inputFormat.parse('${_lstMaterialStagesDIPA.firstWhere((element) => element.orden == item.orden && element.materialIdIPA == obj.materialIdIPA).fechaEvaluacion} $hour');
          evaluationDate = outputFormat.format(_evaluationDate);
        }

        if(exists && _lstMaterialStagesDIPA.firstWhere((element) => element.orden == item.orden && element.materialIdIPA == obj.materialIdIPA).fechaPropuesta != null && _lstMaterialStagesDIPA.firstWhere((element) => element.orden == item.orden && element.materialIdIPA == obj.materialIdIPA).fechaPropuesta != "") {
          DateTime _proposedDate = inputFormat.parse('${_lstMaterialStagesDIPA.firstWhere((element) => element.orden == item.orden && element.materialIdIPA == obj.materialIdIPA).fechaPropuesta} $hour');
          proposedDate = outputFormat.format(_proposedDate);
        }

        params.add(new MaterialStagesDIPAModel(
          noRegistro: widget.anticorrosiveProtectionModel.noRegistro,
          materialIdIPA: obj.materialIdIPA,
          orden: item.orden,
          fechaEvaluacion: evaluationDate,
          fechaPropuesta: proposedDate,
          norma: exists ? _lstMaterialStagesDIPA.firstWhere((element) => element.orden == item.orden && element.materialIdIPA == obj.materialIdIPA).norma : '',
          espesor: exists ? _lstMaterialStagesDIPA.firstWhere((element) => element.orden == item.orden && element.materialIdIPA == obj.materialIdIPA).espesor : 0,
          completado: exists ? _lstMaterialStagesDIPA.firstWhere((element) => element.orden == item.orden && element.materialIdIPA == obj.materialIdIPA).completado : 0,
        ));
      }
    }

    _materialStagesDIPABloc.add(InsUpdMaterialStagesDIPA(params: params));
  }

  void insUpdDatesStages() {
    List<StageMaterialsIPAModel> params = [];
    bool isTwentyFourHour = MediaQuery.of(context).alwaysUse24HourFormat;
    DateFormat inputFormat = DateFormat(
        isTwentyFourHour ? "dd/MM/yyyy HH:mm" : "dd/MM/yyyy hh:mm aaa");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.S");

    String hour = isTwentyFourHour ? '00:00' : '00:00 AM';

    for (var item
        in _listCoatingSystem.where((element) => element.recubrimiento == 1)) {
      String reportDate = '0001-01-01 00:00:00.000';
      String releaseDate = '0001-01-01 00:00:00.000';
      if (controllerDatesStages[_listCoatingSystem
                  .where((element) => element.recubrimiento == 1)
                  .toList()
                  .indexOf(item)]
              .text !=
          "") {
        DateTime _reportDate = inputFormat.parse(
            '${controllerDatesStages[_listCoatingSystem.where((element) => element.recubrimiento == 1).toList().indexOf(item)].text} $hour');
        reportDate = outputFormat.format(_reportDate);
      }

      if (controllerReleaseDate.text != "") {
        DateTime _releaseDate =
            inputFormat.parse('${controllerReleaseDate.text} $hour');
        releaseDate = outputFormat.format(_releaseDate);
      }

      params.add(new StageMaterialsIPAModel(
          noRegistro: widget.anticorrosiveProtectionModel.noRegistro,
          orden: item.orden,
          etapa: item.etapa,
          porcentajeInspeccion: int.parse(controllerPercentage[_listCoatingSystem
                  .where((element) => element.recubrimiento == 1)
                  .toList()
                  .indexOf(item)]
              .text),
          fechaReporte: reportDate,
          fechaLiberacion: releaseDate));
    }

    _stageMaterialIPABloc.add(InsUpdStageMaterialIPA(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Inspección Protección Anticorrosiva'),
            leading: new IconButton(
              icon: new Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
                widget.search();
              },
            ),
          ),
          body: SingleChildScrollView(
            controller: controller,
            child: Container(
                padding: EdgeInsets.all(5.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 5.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                                icon: const Icon(Icons.save),
                                tooltip: 'Guardar',
                                color: Colors.blue,
                                onPressed: () {
                                  if(_formKey.currentState.validate()) {
                                    insUpdEnvironmentalConditions();
                                    insUpdDocuments();
                                    insUpdInfoGeneral();
                                    insUpdEvidencePhotographicV2();
                                    insUpdCoatingApplication();
                                    insUpdEquipment();
                                    insUpdDatesStages();
                                    insUpdMaterialsIPA();
                                    insUpdMaterialsStageDIPA();                                    
                                  }
                                })
                          ],
                        ),
                        _header(),
                        DefaultTabController(
                            length: 2,
                            initialIndex: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [_tabBar(), _tabBarView(orientation, context)],
                            ))
                      ],
                    ))),
          ),
          floatingActionButton: FloatingActionButton(
            child: new Icon(Icons.arrow_circle_up_outlined),
            isExtended: true,
            backgroundColor: Color.fromRGBO(3, 157, 252, .9),
            onPressed: () {
              controller.animateTo(0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
          ));
    });
  }

  _handleTabChange() {
    setState(() {
      indexTab = tabController.index;
    });
  }

  BlocListener listenerCoatingApplication() {
    return BlocListener<CoatingAplicationBloc, CoatingAplicationState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        switch (state.runtimeType) {
          case IsLoadingCoatingAplication:
            showGeneralLoading(context);
            break;
          case ErrorCoatingAplication:
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
          case SuccessCoatingAplication:
            Navigator.of(context).pop();
            setState(() {
              for (var item in state.data) {
                var stage = _listCoatingSystem
                    .where((element) => element.orden == item.orden)
                    .first;

                controllerObsRF[state.data.indexOf(item)].text =
                    item.observacion;
                controllerLote[state.data.indexOf(item)].text = item.noLote;
                controllerFCaducidad[state.data.indexOf(item)].text =
                    item.fechaCaducidad;
                controllerMetodo[state.data.indexOf(item)].text =
                    item.metodoAplicacion;
                controllerTipo[state.data.indexOf(item)].text =
                    item.tipoRecubrimiento;
                controllerMezcla[state.data.indexOf(item)].text = item.mezcla;
                controllerEspesor[state.data.indexOf(item)].text =
                    item.espesorSecoPromedio;
                controllerSecado[state.data.indexOf(item)].text =
                    item.tiempoSecado;
                controllerSolvente[state.data.indexOf(item)].text =
                    item.tipoEnvolvente;
                controllerPruebaC[state.data.indexOf(item)].text =
                    stage.continuidad == 1 ? item.pruebaContinuidad : '----';
                controllerPruebaA[state.data.indexOf(item)].text =
                    stage.adherencia == 1 ? item.pruebaAdherencia : '----';
                controllerDocumento[state.data.indexOf(item)].text =
                    item.documentoAplicable;
                controllerComentarioC[state.data.indexOf(item)].text =
                    item.comentariosContinuidad;
                controllerComentarioA[state.data.indexOf(item)].text =
                    item.comentariosAdherencia;
                controllerNoPruebas[state.data.indexOf(item)].text =
                    (item.numeroPruebas == 0 || item.numeroPruebas == null) ? '' : item.numeroPruebas.toString();
              }
            });
            break;
          case SuccessInsUpdCoatingAplication:
            Navigator.of(context).pop();

            break;
        }
      },
    );
  }

  BlocListener listenerCoatingSystem() {
    return BlocListener<CoatingSystemBloc, CoatingSystemState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      switch (state.runtimeType) {
        case IsLoadingCoatingSystem:
          showGeneralLoading(context);
          break;
        case SuccessCoatingSystem:
          Navigator.of(context).pop();
          
          setState(() {
            _listCoatingSystem = state.data;
            for (var i = 0; i < state.data.length; i++) {
              controllerTA.add(new TextEditingController());
              controllerTS.add(new TextEditingController());
              controllerHR.add(new TextEditingController());
            }

            for (var item in state.data.where((element) => element.recubrimiento == 1)) {
              controllerObsRF.add(new TextEditingController());
              controllerLote.add(new TextEditingController());
              controllerFCaducidad.add(new TextEditingController());
              controllerMetodo.add(new TextEditingController());
              controllerTipo.add(new TextEditingController());
              controllerMezcla.add(new TextEditingController());
              controllerEspesor.add(new TextEditingController());
              controllerSecado.add(new TextEditingController());
              controllerSolvente.add(new TextEditingController());
              controllerPruebaC.add(new TextEditingController(text: item.continuidad == 1 ? '' : '----'));
              controllerPruebaA.add(new TextEditingController(text: item.adherencia == 1 ? '' : '----'));
              controllerDocumento.add(new TextEditingController());
              controllerComentarioC.add(new TextEditingController());
              controllerComentarioA.add(new TextEditingController());
              controllerNoPruebas.add(new TextEditingController());
              controllerDatesStages.add(new TextEditingController());
              controllerPercentage.add(new TextEditingController());
              datesReportRelease.add(new DateTime.now());
            }
          });
          break;
        case ErrorCoatingSystem:
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
      }
    });
  }

  BlocListener listenerEvidencePhotographic() {
    return BlocListener<EvidencePhotographicBloc, EvidencePhotographicState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      switch (state.runtimeType) {
        case IsLoadingEvidencePhotographic:
          showGeneralLoading(context);
          break;
        case ErrorEvidencePhotographic:
          Navigator.of(context).pop();

          showNotificationSnackBar(
            context,
            title: "",
            mensaje: state.errorMessage,
            icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
            secondsDuration: 8,
            colorBarIndicator: Colors.red,
            borde: 8,
          );
          break;
        case SuccessGetEvidencePhotographicsV2:
          Navigator.of(context).pop();

          setState(() {
            _lstPhotographics = state.lstPhotographicsV2;
          });
          break;
        case SuccessInsUpdEvidencePhotographicsV2:
          Navigator.of(context).pop();

          setState(() {
            for (var item in state.updateIds) {
              int _index = _lstPhotographics
                  .indexWhere((element) => element.fotoId == item.id);

              var photographic = _lstPhotographics[_index];

              _lstPhotographics[_index] = new PhotographicEvidenceModel(
                  fotoId: item.consecutivo,
                  content: photographic.content,
                  thumbnail: photographic.thumbnail,
                  contentType: photographic.contentType,
                  identificadorTabla: photographic.identificadorTabla,
                  nombre: photographic.nombre,
                  nombreTabla: photographic.nombreTabla,
                  siteModificacion: photographic.siteModificacion,
                  fechaModificacion: photographic.fechaModificacion,
                  regBorrado: photographic.regBorrado);
            }
          });
          break;
      }
    });
  }

  BlocListener listenerSurfacePreparation() {
    return BlocListener<InfoGeneralBloc, InfoGeneralState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      switch (state.runtimeType) {
        case IsLoadingInfoGeneral:
          showGeneralLoading(context);
          break;
        case SuccessInfoGeneral:
          Navigator.of(context).pop();

          setState(() {
            _observacionRF.text = state.anticorrosiveIPAModel.observacionesRF;
            _sustrato.text = state.anticorrosiveIPAModel.sustrato;
            _abrasivo.text = state.anticorrosiveIPAModel.abrasivo;
            _anclaje.text = state.anticorrosiveIPAModel.anclaje;
            _limpieza.text = state.anticorrosiveIPAModel.limpieza;
            _incluirEvidencias = state.anticorrosiveIPAModel.incluirEvidencias;
            _observaciones.text = state.anticorrosiveIPAModel.observaciones;
          });

          break;
        case ErrorInfoGeneral:
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
        case SuccessInsUpdInfoGeneral:
          Navigator.of(context).pop();

          break;
      }
    });
  }

  BlocListener listenerEnvironmentalConditions() {
    return BlocListener<EnvironmentalConditionsBloc,
        EnvironmentalConditionsState>(listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      switch (state.runtimeType) {
        case IsLoadingEnvironmentalConditions:
          showGeneralLoading(context);
          break;
        case SuccessGetEnvironmentalConditions:
          Navigator.of(context).pop();

          setState(() {
            for (var item in state.data) {
              if (controllerTA.length > 0) {
                controllerTA[state.data.indexOf(item)].text =
                    item.temperaturaAmbiente;
              }
              if (controllerTS.length > 0) {
                controllerTS[state.data.indexOf(item)].text =
                    item.temperaturaSustrato;
              }
              if (controllerHR.length > 0) {
                controllerHR[state.data.indexOf(item)].text =
                    item.humedadRelativa;
              }
            }
          });
          break;
        case ErrorEnvironmentalConditions:
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
        case SuccessInsUpdEnvironmentalConditions:
          Navigator.of(context).pop();
          break;
      }
    });
  }

  BlocListener listenerMaterialStagesDIPA(BuildContext ctx) {
    return BlocListener<MaterialStagesDIPABloc, MaterialStagesDIPAState>(
        listener: (context, state) {
      switch (state.runtimeType) {
        case IsLoadingMaterialStagesDIPA:
          showGeneralLoading(ctx);
          break;
        case ErrorMaterialStagesDIPAState:
          Navigator.of(ctx).pop();

          showNotificationSnackBar(
            ctx,
            title: "",
            mensaje: state.message,
            icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
            secondsDuration: 8,
            colorBarIndicator: Colors.red,
            borde: 8,
          );
          break;
        case SuccessGetMaterialStagesDIPA:
          Navigator.of(ctx).pop();

          setState(() {
            _lstMaterialStagesDIPA = state.data;
          });
          break;
        case SuccessInsUpdMaterialStagesDIPA:
          Navigator.of(ctx).pop();
          
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Información guardada correctamente')));
          break;
      }
    });
  }

  BlocListener listenerMaterialsIPA(BuildContext ctx) {
    return BlocListener<MaterialsIPABloc, MaterialsIPAState>(
        listener: (context, state) {
      switch (state.runtimeType) {
        case IsLoadingMaterialsIPA:
          showGeneralLoading(ctx);
          break;
        case ErrorMaterialsIPAState:
          Navigator.of(ctx).pop();

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
        case SuccessGetMaterialsIPA:
          Navigator.of(ctx).pop();

          setState(() {
            _lstMaterialsIPA = state.data;
            for (var item in state.data) {
              if (!_lstMaterialsIPAV2.any(
                  (element) => element.nombreElemento == item.nombreElemento)) {
                _lstMaterialsIPAV2.add(item);
                controllerLocation
                    .add(new TextEditingController(text: item.localizacion));
              }
              controllerRelease
                  .add(new TextEditingController(text: item.fechaLiberacion));
              var date;
              if (item.fechaLiberacion == null) {
                date = new DateTime.now();
              } else {
                date = new DateTime(
                    int.parse(item.fechaLiberacion.split('/')[2]),
                    int.parse(item.fechaLiberacion.split('/')[1]),
                    int.parse(item.fechaLiberacion.split('/')[0]),
                    0,
                    0);
              }
              datesRelease.add(date);
            }
          });
          break;
        case SuccessInsUpdMaterialsIPA:
          Navigator.of(ctx).pop();

          break;
      }
    });
  }

  showAlertDialog(bool exist, CoatingSystemModel obj, MaterialsTableIPAModel item, MaterialStagesDIPAModel model) {
    AlertDialog alert = AlertDialog(
      title: flatButton(Colors.white, Icons.auto_awesome_mosaic, 'Acciones',
          Colors.black, () {}),
      content: Container(
        height: 130,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 150, right: 150),
              child: Text(
                "¿Qué acción desea realizar?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      
                      showDialog(
                        context: context, 
                        builder: (_) {
                          return ModalEvaluation(
                            updateData: updateData,
                            existModel: exist,
                            coatingSystemModel: obj,
                            materialsTableIPAModel: item,
                            norma: model.norma,
                            espesor: model.espesor,
                            completado: model.completado,
                            noRegistro: model.noRegistro,
                            orden: model.orden,
                            materialIdIPA: model.materialIdIPA,
                            listPhotographicThickness: _lstPhotographics.where((element) => element.identificadorTabla == '${model.noRegistro}|Espesor|${model.orden}|${model.materialIdIPA}').toList(),
                            listPhotographicContinuity: _lstPhotographics.where((element) => element.identificadorTabla == '${model.noRegistro}|Continuidad|${model.orden}|${model.materialIdIPA}').toList(),
                            listPhotographicAdherence: _lstPhotographics.where((element) => element.identificadorTabla == '${model.noRegistro}|Adherencia|${model.orden}|${model.materialIdIPA}').toList(),
                          );
                        }
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.notes_sharp, color: Colors.white, size: 26.0),
                        SizedBox(width: 10.0),
                        Text(
                          'Evaluación',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
                    onPressed: () {
                      Navigator.of(context).pop();

                      _selectProposedDate(context, obj.orden, item.materialIdIPA);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.date_range_outlined, color: Colors.white, size: 26.0),
                        SizedBox(width: 10.0),
                        Text(
                          'Fecha Reporte',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  BlocListener listenerDatesStages(BuildContext ctx) {
    return BlocListener<StageMaterialIPABloc, StageMaterialIPAState>(
        listener: (context, state) {
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();

      switch (state.runtimeType) {
        case IsLoadingStageMaterialIPA:
          showGeneralLoading(ctx);
          break;
        case ErrorStageMaterialIPA:
          Navigator.of(ctx).pop();

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
        case SuccessGetStageMaterialIPA:
          Navigator.of(ctx).pop();

          setState(() {
            _lstStageMaterials = state.data;
            if (state.data.length > 0) {
              controllerReleaseDate.text = state.data[0].fechaLiberacion;
              if (state.data[0].fechaLiberacion != null) {
                dateReportRelease = new DateTime(
                    int.parse(state.data[0].fechaLiberacion.split('/')[2]),
                    int.parse(state.data[0].fechaLiberacion.split('/')[1]),
                    int.parse(state.data[0].fechaLiberacion.split('/')[0]),
                    0,
                    0);
              }
            }

            for (var i = 0; i < state.data.length; i++) {
              var date;
              controllerDatesStages[i].text = state.data[i].fechaReporte;
              if (state.data[i].fechaReporte == null) {
                date = new DateTime.now();
              } else {
                date = new DateTime(
                    int.parse(state.data[i].fechaReporte.split('/')[2]),
                    int.parse(state.data[i].fechaReporte.split('/')[1]),
                    int.parse(state.data[i].fechaReporte.split('/')[0]),
                    0,
                    0);
              }

              datesReportRelease[i] = date;
              controllerPercentage[i].text =
                  state.data[i].porcentajeInspeccion.toString();
            }
          });
          break;
        case SuccessInsUpdStageMaterialIPA:
          Navigator.of(ctx).pop();

          break;
      }
    });
  }

  Future<void> _selectProposedDate(BuildContext context, int orden, int materialIdIPA) async {
    String proposedDate = _lstMaterialStagesDIPA.firstWhere((element) => element.orden == orden && element.materialIdIPA == materialIdIPA).fechaPropuesta;
    DateTime date = new DateTime.now();
    if (proposedDate != null) {
      date = new DateTime(
        int.parse(proposedDate.split('/')[2]),
        int.parse(proposedDate.split('/')[1]),
        int.parse(proposedDate.split('/')[0]),
      );
    }

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        DateFormat formatter = DateFormat('dd/MM/yyyy');
        
        _lstMaterialStagesDIPA.firstWhere((element) => element.orden == orden && element.materialIdIPA == materialIdIPA).fechaPropuesta = formatter.format(picked);
      });
    }
  }

  Future<void> _selectDate(
      BuildContext context, int index, bool release) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: release ? dateReportRelease : datesReportRelease[index],
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        DateFormat formatter = DateFormat('dd/MM/yyyy');

        if (release) {
          controllerReleaseDate.text = formatter.format(picked);
          dateReportRelease = picked;
        } else {
          controllerDatesStages[index].text = formatter.format(picked);
          datesReportRelease[index] = picked;
        }
      });
    }
  }

  //Vertical
  Widget _datesPortrait() {
    return Column(
      children: [
        Row(
          children: [
            for (var item in _lstStageMaterials)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(item.etapa,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ),
              ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                'LIBERACIÓN',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ))
          ],
        ),
        Row(
          children: [
            for (var item in _lstStageMaterials)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    focusNode: AlwaysDisabledFocusNode(),
                    controller:
                        controllerDatesStages[_lstStageMaterials.indexOf(item)],
                    //enabled: enableInput(),
                    onTap: () {
                      if (!clean) {
                        _selectDate(
                            context, _lstStageMaterials.indexOf(item), false);
                      }
                      setState(() {
                        clean = false;
                      });
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      suffixIcon: IconButton(
                          onPressed: () => {
                                controllerDatesStages[
                                        _lstStageMaterials.indexOf(item)]
                                    .clear(),
                                clean = true
                              },
                          icon: Icon(Icons.clear)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Fecha Reporte',
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  focusNode: AlwaysDisabledFocusNode(),
                  controller: controllerReleaseDate,
                  onTap: () {
                    if (!clean) {
                      _selectDate(context, 0, true);
                    }
                    setState(() {
                      clean = false;
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    suffixIcon: IconButton(
                        onPressed: () =>
                            {controllerReleaseDate.clear(), clean = true},
                        icon: Icon(Icons.clear)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Fecha Liberación',
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _textEvaluation(int orden, int materialIdIPA) {
    final bool exist = _lstMaterialStagesDIPA.any((element) =>
        element.orden == orden && element.materialIdIPA == materialIdIPA);
    String text = 'Evaluación';
    var color = Colors.blue;

    if (exist) {
      MaterialStagesDIPAModel model = _lstMaterialStagesDIPA.firstWhere(
          (element) =>
              element.orden == orden && element.materialIdIPA == materialIdIPA);

      if (model.fechaEvaluacion != null) {
        text = model.fechaEvaluacion;

        if (model.completado == 0 || model.norma == '') {
          text = text + '*';
        }

        if (model.norma == 'D/N') {
          color = Colors.green;
        } else if (model.norma == 'F/N') {
          color = Colors.red;
        } else {
          color = null;
        }
      }
    }

    return Text(
      text,
      style: TextStyle(color: color),
      textAlign: TextAlign.center,
    );
  }

  Widget _materialsTable() {
    return MultiBlocListener(
        listeners: [listenerMaterialsIPA(context), listenerMaterialStagesDIPA(context)],
        child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dataRowHeight: 90,
                columns: [
                  DataColumn(
                      label: Container(
                    width: 100,
                    child: Text('Nombre del Elemento',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center),
                  )),
                  DataColumn(
                      label: Container(
                    width: 150,
                    child: Text('Plano de Localización/Isométrico',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center),
                  )),
                  DataColumn(
                      label: Container(
                    width: 100,
                    child: Text('Localización',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center),
                  )),
                  DataColumn(
                      label: Container(
                    width: 140,
                    child: Text('Trazabilidad',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center),
                  )),
                  DataColumn(
                      label: Container(
                    width: 100,
                    child: Text('Cantidad',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center),
                  )),
                  DataColumn(
                      label: Container(
                    width: 100,
                    child: Text('UM',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center),
                  )),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    DataColumn(
                        label: Container(
                      width: 130,
                      child: Text(
                          item.etapa +
                              ' % Inspección ' +
                              controllerPercentage[_listCoatingSystem
                                      .where((element) =>
                                          element.recubrimiento == 1)
                                      .toList()
                                      .indexOf(item)]
                                  .text,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center),
                    )),
                  DataColumn(
                      label: Container(
                    width: 120,
                    child: Text('Liberación',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center),
                  ))
                ],
                rows: [
                  for (var item in _lstMaterialsIPAV2)
                    DataRow(cells: [
                      DataCell(Container(
                          width: 100,
                          child: Text(item.nombreElemento,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center))),
                      DataCell(Container(
                          width: 150,
                          child: Text(item.planoDetalle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                              textAlign: TextAlign.center))),
                      DataCell(Container(
                        width: 100,
                        child: TextButton(
                          child: Text(
                              item.localizacion == ''
                                  ? 'Localización'
                                  : item.localizacion,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.center),
                          onPressed: () {
                            setState(() {
                              controllerLocationTemp.text = controllerLocation[
                                      _lstMaterialsIPAV2.indexOf(item)]
                                  .text;
                            });
                            showModalLocation(item.materialIdIPA);
                          },
                        ),
                      )),
                      DataCell(Column(
                        children: [
                          for (var i = 0;
                              i <
                                  _lstMaterialsIPA
                                      .where((element) =>
                                          element.nombreElemento ==
                                          item.nombreElemento)
                                      .length;
                              i++)
                            Container(
                                alignment: Alignment.center,
                                height: _lstMaterialsIPA
                                            .where((element) =>
                                                element.nombreElemento ==
                                                item.nombreElemento)
                                            .length ==
                                        1
                                    ? 90
                                    : 45,
                                width: 140,
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: i ==
                                                    _lstMaterialsIPA
                                                            .where((element) =>
                                                                element
                                                                    .nombreElemento ==
                                                                item.nombreElemento)
                                                            .length -
                                                        1
                                                ? Colors.white
                                                : Colors.grey[300]))),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        _lstMaterialsIPA
                                            .where((element) =>
                                                element.nombreElemento ==
                                                item.nombreElemento)
                                            .toList()[i]
                                            .trazabilidadId,
                                        textAlign: TextAlign.center,
                                      ))
                                    ],
                                  ),
                                )),
                        ],
                      )),
                      DataCell(Column(
                        children: [
                          for (var i = 0;
                              i <
                                  _lstMaterialsIPA
                                      .where((element) =>
                                          element.nombreElemento ==
                                          item.nombreElemento)
                                      .length;
                              i++)
                            Container(
                                alignment: Alignment.center,
                                height: _lstMaterialsIPA
                                            .where((element) =>
                                                element.nombreElemento ==
                                                item.nombreElemento)
                                            .length ==
                                        1
                                    ? 90
                                    : 45,
                                width: 100,
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: i ==
                                                    _lstMaterialsIPA
                                                            .where((element) =>
                                                                element
                                                                    .nombreElemento ==
                                                                item.nombreElemento)
                                                            .length -
                                                        1
                                                ? Colors.white
                                                : Colors.grey[300]))),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        _lstMaterialsIPA
                                            .where((element) =>
                                                element.nombreElemento ==
                                                item.nombreElemento)
                                            .toList()[i]
                                            .cantidadUsada
                                            .toString(),
                                        textAlign: TextAlign.center,
                                      ))
                                    ],
                                  ),
                                )),
                        ],
                      )),
                      DataCell(Column(
                        children: [
                          for (var i = 0;
                              i <
                                  _lstMaterialsIPA
                                      .where((element) =>
                                          element.nombreElemento ==
                                          item.nombreElemento)
                                      .length;
                              i++)
                            Container(
                                alignment: Alignment.center,
                                height: _lstMaterialsIPA
                                            .where((element) =>
                                                element.nombreElemento ==
                                                item.nombreElemento)
                                            .length ==
                                        1
                                    ? 90
                                    : 45,
                                width: 100,
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: i ==
                                                    _lstMaterialsIPA
                                                            .where((element) =>
                                                                element
                                                                    .nombreElemento ==
                                                                item.nombreElemento)
                                                            .length -
                                                        1
                                                ? Colors.white
                                                : Colors.grey[300]))),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        _lstMaterialsIPA
                                            .where((element) =>
                                                element.nombreElemento ==
                                                item.nombreElemento)
                                            .toList()[i]
                                            .um,
                                        textAlign: TextAlign.center,
                                      ))
                                    ],
                                  ),
                                )),
                        ],
                      )),
                      for (var obj in _listCoatingSystem
                          .where((element) => element.recubrimiento == 1))
                        DataCell(Column(
                          children: [
                            for (var i = 0;
                                i <
                                    _lstMaterialsIPA
                                        .where((element) =>
                                            element.nombreElemento ==
                                            item.nombreElemento)
                                        .length;
                                i++)
                              Container(
                                  alignment: Alignment.center,
                                  height: _lstMaterialsIPA
                                              .where((element) =>
                                                  element.nombreElemento ==
                                                  item.nombreElemento)
                                              .length ==
                                          1
                                      ? 90
                                      : 45,
                                  width: 130,
                                  padding: EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: i ==
                                                      _lstMaterialsIPA
                                                              .where((element) =>
                                                                  element
                                                                      .nombreElemento ==
                                                                  item.nombreElemento)
                                                              .length -
                                                          1
                                                  ? Colors.white
                                                  : Colors.grey[300]))),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: new GestureDetector(
                                                onTap: () {
                                                  bool exist = _lstMaterialStagesDIPA.any((element) => element.orden == obj.orden && element.materialIdIPA == _lstMaterialsIPA.where((element) => element.nombreElemento == item.nombreElemento).toList()[i].materialIdIPA);
                                                  MaterialStagesDIPAModel _model;
                                                  if(exist) {
                                                    _model = _lstMaterialStagesDIPA.firstWhere((element) => element.orden == obj.orden && element.materialIdIPA == _lstMaterialsIPA.where((element) => element.nombreElemento == item.nombreElemento).toList()[i].materialIdIPA);
                                                  } else {
                                                    _model = new MaterialStagesDIPAModel(
                                                      noRegistro: widget.anticorrosiveProtectionModel.noRegistro,
                                                      materialIdIPA: _lstMaterialsIPA.where((element) => element.nombreElemento == item.nombreElemento).toList()[i].materialIdIPA,
                                                      orden: obj.orden,
                                                      fechaEvaluacion: null,
                                                      fechaPropuesta: null,
                                                      norma: '',
                                                      espesor: 0.00,
                                                      completado: 0
                                                    );
                                                  }

                                                  if(_model.fechaEvaluacion != null) {
                                                    showAlertDialog(exist, obj, item, _model);
                                                  } else {
                                                    showDialog(
                                                      context: context, 
                                                      builder: (_) {
                                                        return ModalEvaluation(
                                                          updateData: updateData,
                                                          existModel: exist,
                                                          coatingSystemModel: obj,
                                                          materialsTableIPAModel: item,
                                                          norma: _model.norma,
                                                          espesor: _model.espesor,
                                                          completado: _model.completado,
                                                          noRegistro: _model.noRegistro,
                                                          orden: _model.orden,
                                                          materialIdIPA: _model.materialIdIPA,
                                                          listPhotographicThickness: _lstPhotographics.where((element) => element.identificadorTabla == '${_model.noRegistro}|Espesor|${_model.orden}|${_model.materialIdIPA}').toList(),
                                                          listPhotographicContinuity: _lstPhotographics.where((element) => element.identificadorTabla == '${_model.noRegistro}|Continuidad|${_model.orden}|${_model.materialIdIPA}').toList(),
                                                          listPhotographicAdherence: _lstPhotographics.where((element) => element.identificadorTabla == '${_model.noRegistro}|Adherencia|${_model.orden}|${_model.materialIdIPA}').toList(),
                                                        );
                                                      }
                                                    );
                                                  }
                                                },
                                                child: _textEvaluation(
                                                    obj.orden,
                                                    _lstMaterialsIPA
                                                        .where((element) =>
                                                            element
                                                                .nombreElemento ==
                                                            item.nombreElemento)
                                                        .toList()[i]
                                                        .materialIdIPA)))
                                      ],
                                    ),
                                  ))
                          ],
                        )),
                      DataCell(Column(
                        children: [
                          for (var i = 0;
                              i <
                                  _lstMaterialsIPA
                                      .where((element) =>
                                          element.nombreElemento ==
                                          item.nombreElemento)
                                      .length;
                              i++)
                            Container(
                                alignment: Alignment.center,
                                height: _lstMaterialsIPA
                                            .where((element) =>
                                                element.nombreElemento ==
                                                item.nombreElemento)
                                            .length ==
                                        1
                                    ? 90
                                    : 45,
                                width: 120,
                                padding: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: i ==
                                                    _lstMaterialsIPA
                                                            .where((element) =>
                                                                element
                                                                    .nombreElemento ==
                                                                item.nombreElemento)
                                                            .length -
                                                        1
                                                ? Colors.white
                                                : Colors.grey[300]))),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: new GestureDetector(
                                        onTap: () {
                                          showModalRelease(
                                              context,
                                              _lstMaterialsIPA
                                                  .where((element) =>
                                                      element.nombreElemento ==
                                                      item.nombreElemento)
                                                  .toList()[i]
                                                  .materialIdIPA);
                                        },
                                        child: Text(
                                          _lstMaterialsIPA
                                                      .where((element) =>
                                                          element
                                                              .nombreElemento ==
                                                          item.nombreElemento)
                                                      .toList()[i]
                                                      .fechaLiberacion ==
                                                  null
                                              ? '---'
                                              : _lstMaterialsIPA
                                                  .where((element) =>
                                                      element.nombreElemento ==
                                                      item.nombreElemento)
                                                  .toList()[i]
                                                  .fechaLiberacion,
                                          style: TextStyle(color: Colors.blue),
                                          textAlign: TextAlign.center,
                                        ),
                                      ))
                                    ],
                                  ),
                                ))
                        ],
                      ))
                    ]),
                ],
              ),
            )));
  }

  void updateData(
    int orden, 
    int materialIdIPA, 
    String norma, 
    double espesor, 
    List<PhotographicEvidenceModel> listPhotographicThickness,
    List<PhotographicEvidenceModel> listPhotographicContinuity,
    List<PhotographicEvidenceModel> listPhotographicAdherence,
    bool existModel,
    List<String> keys
  ) {
    DateTime dateEvaluation = new DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    int completado = 0;

    if(
        norma != '' && 
        espesor != null && 
        espesor != 0 && 
        listPhotographicThickness.length > 0 &&
        (_listCoatingSystem.firstWhere((element) => element.orden == orden).continuidad == 0 || listPhotographicContinuity.length > 0) &&
        (_listCoatingSystem.firstWhere((element) => element.orden == orden).adherencia == 0 || listPhotographicAdherence.length > 0)
      ) {
      completado = 1;
    }

    if (existModel) {
      int index = _lstMaterialStagesDIPA.indexWhere((element) => element.orden == orden && element.materialIdIPA == materialIdIPA);
      String fechaPropuesta = _lstMaterialStagesDIPA[index].fechaPropuesta;
      
      setState(() {
          _lstMaterialStagesDIPA[index] = new MaterialStagesDIPAModel(
            noRegistro: widget.anticorrosiveProtectionModel.noRegistro,
            materialIdIPA: materialIdIPA,
            orden: orden,
            fechaEvaluacion: 
              (norma != '' || (espesor != null && espesor != 0) || listPhotographicThickness.length > 0 || listPhotographicContinuity.length > 0 || listPhotographicAdherence.length > 0) ? 
                formatter.format(dateEvaluation) : null,
            fechaPropuesta: fechaPropuesta,
            norma: norma,
            espesor: espesor == null ? 0 : espesor,
            completado: completado
          );
      });
    } else {
      setState(() {
        _lstMaterialStagesDIPA.add(new MaterialStagesDIPAModel(
          noRegistro: widget.anticorrosiveProtectionModel.noRegistro,
          materialIdIPA: materialIdIPA,
          orden: orden,
          fechaEvaluacion: 
          (norma != '' || (espesor != null && espesor != 0) || listPhotographicThickness.length > 0 || listPhotographicContinuity.length > 0 || listPhotographicAdherence.length > 0) ? 
          formatter.format(dateEvaluation) : null,
          fechaPropuesta: null,
          norma: norma,
          espesor: espesor == null ? 0 : espesor,
          completado: completado
        ));
      });
    }

    for (var key in keys) {
      _lstPhotographics.removeWhere((element) => element.identificadorTabla == key);
    }
    
    if (listPhotographicThickness.length > 0) {
      _lstPhotographics.addAll(listPhotographicThickness);
    }

    if (listPhotographicContinuity.length > 0) {
      _lstPhotographics.addAll(listPhotographicContinuity);
    }

    if (listPhotographicAdherence.length > 0) {
      _lstPhotographics.addAll(listPhotographicAdherence);
    }

    /**INICIA. Sección de promedio espesor. Evaluación Continuidad Adherencia */
        List<CoatingSystemModel> list = _listCoatingSystem.where((element) => element.recubrimiento == 1).toList();
        int _index = list.indexWhere((element) => element.orden == orden);

        //Espesor
        List<double> thicknesses = _lstMaterialStagesDIPA.where((element) => element.orden == orden && element.espesor != 0).map((e) => e.espesor).toList();
        double resultThicknesses;
        if(thicknesses.length > 0) 
          resultThicknesses = thicknesses.reduce((a, b) => a + b) / thicknesses.length;
        
        controllerEspesor[_index].text = thicknesses.length > 0 ? resultThicknesses.toString() : '';

        //Continuidad
        if (list[_index].continuidad == 1) {
          List<String> continuity = _lstMaterialStagesDIPA.where((element) => element.orden == orden && element.norma != '').map((e) => e.norma).toList();
          String resultContinuity = '';

          if (continuity.length > 0) {
            if (continuity.where((element) => element == 'F/N').length == 0) {
              resultContinuity = 'D/N';
            }
            else {
              resultContinuity = 'F/N';
            }
          }

          controllerPruebaC[_index].text = resultContinuity;
        }

        //Adherencia
        if (list[_index].adherencia == 1) {
          List<String> adherence = _lstMaterialStagesDIPA.where((element) => element.orden == orden && element.norma != '').map((e) => e.norma).toList();
          String resultAdherence = '';

          if (adherence.length > 0) {
            if (adherence.where((element) => element == 'F/N').length == 0) {
              resultAdherence = 'D/N';
            }
            else {
              resultAdherence = 'F/N';
            }
          }

          controllerPruebaA[_index].text = resultAdherence;
        }
      /**FIN. Sección de promedio espesor. Evaluación Continuidad Adherencia */

      /**INICIA. Sección porcentaje de inspección */
      int total = _lstMaterialsIPA.length;

      int totalCompleted = _lstMaterialStagesDIPA.where((element) => element.orden == orden && element.norma != '').length;

      int percentage = ((totalCompleted * 100) / total).round();

      controllerPercentage[_index].text = percentage.toString();
      /**FIN. Sección porcentaje de inspección */
  }

  Widget _datesLandscape() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(''),
                )),
            for (var item in _lstStageMaterials)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(item.etapa,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ),
              ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text('LIBERACIÓN',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Fecha P/Reporte',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ))),
            for (var item in _lstStageMaterials)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    focusNode: AlwaysDisabledFocusNode(),
                    controller:
                        controllerDatesStages[_lstStageMaterials.indexOf(item)],
                    //enabled: enableInput(),
                    onTap: () {
                      if (!clean) {
                        _selectDate(
                            context, _lstStageMaterials.indexOf(item), false);
                      }
                      setState(() {
                        clean = false;
                      });
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      suffixIcon: IconButton(
                          onPressed: () => {
                                controllerDatesStages[
                                        _lstStageMaterials.indexOf(item)]
                                    .clear(),
                                clean = true
                              },
                          icon: Icon(Icons.clear)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: 'Fecha Reporte',
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  focusNode: AlwaysDisabledFocusNode(),
                  controller: controllerReleaseDate,
                  onTap: () {
                    if (!clean) {
                      _selectDate(context, 0, true);
                    }
                    setState(() {
                      clean = false;
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    suffixIcon: IconButton(
                        onPressed: () =>
                            {controllerReleaseDate.clear(), clean = true},
                        icon: Icon(Icons.clear)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Fecha Liberación',
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _datesStages(Orientation orientation, BuildContext ctx) {
    return MultiBlocListener(
      listeners: [listenerDatesStages(ctx)],
      child: Card(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Container(
              padding: EdgeInsets.all(15.0),
              child: orientation == Orientation.portrait
                  ? _datesPortrait()
                  : _datesLandscape())),
    );
  }

  BlocListener _equipment() {
    return BlocListener<EquipmentBloc, EquipmentState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        switch (state.runtimeType) {
          case IsLoadingEquipment:
            showGeneralLoading(context);
            break;
          case ErrorEquipment:
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
          case SuccessEquipment:
            Navigator.of(context).pop();

            setState(() {
              _lstEquipment = state.data;
              for (var item in state.data) {
                controllerEquipos
                    .add(new TextEditingController(text: item.nombre));
              }
            });

            break;
          case SuccessInsUpdEquipment:
            Navigator.of(context).pop();

            break;
        }
      },
      child: Card(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(child: Divider(thickness: 2.0)),
                      SizedBox(width: 5.0),
                      Text(
                        'Equipos de I. M. y P. Utilizados',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(child: Divider(thickness: 2.0)),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Container(
                      height: 150,
                      child: SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            children: [
                              for (var item in _lstEquipment)
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: TextFormField(
                                              validator: (value) {
                                                if(value == null || value.isEmpty) {
                                                  return 'Ingresar nombre equipo';
                                                }
                                                return null;
                                              },
                                              controller: controllerEquipos[
                                                  _lstEquipment.indexOf(item)],
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  isDense: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  hintText: 'Equipo'))),
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Container(
                                            width: 5,
                                            child: IconButton(
                                              color: Colors.red,
                                              icon: Icon(
                                                  Icons.remove_circle_outline),
                                              onPressed: () {
                                                setState(() {
                                                  controllerEquipos.removeWhere(
                                                      (element) =>
                                                          controllerEquipos
                                                              .indexOf(
                                                                  element) ==
                                                          _lstEquipment
                                                              .indexOf(item));
                                                  _lstEquipment.removeWhere(
                                                      (element) =>
                                                          _lstEquipment.indexOf(
                                                              element) ==
                                                          _lstEquipment
                                                              .indexOf(item));
                                                });
                                              },
                                            ),
                                          )),
                                    )
                                  ],
                                )
                            ],
                          ))),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        controllerEquipos
                            .add(new TextEditingController(text: ''));
                        _lstEquipment.add(new EquipmentModel(
                            orden: _lstEquipment.length + 1, nombre: ''));
                      });
                    },
                  )
                ],
              ))),
    );
  }

  BlocListener listenerDocuments() {
    return BlocListener<DocumentBloc, DocumentState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        switch (state.runtimeType) {
          case IsLoadingDocument:
            showGeneralLoading(context);
            break;
          case ErrorDocument:
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
          case SuccessGetDocuments:
            Navigator.of(context).pop();

            setState(() {
              controllerDocuments = [];
              for (var i = 0; i < state.data.length; i++) {
                controllerDocuments
                    .add(new TextEditingController(text: state.data[i].nombre));
              }

              _documents = state.data;
            });

            break;
          case SuccessInsUpdDocuments:
            Navigator.of(context).pop();
            
            setState(() {
              for (var item in state.list) {
                int _index =
                    _documents.indexWhere((element) => element.id == item.id);

                var document = _documents[_index];

                _documents[_index] = new DocumentModel(
                    id: item.consecutivo,
                    name: document.name,
                    nombre: document.nombre,
                    contentType: document.contentType,
                    content: document.content);
              }
            });
            break;
        }
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(child: Divider(thickness: 2.0)),
                  SizedBox(width: 5.0),
                  Text(
                    'Anexos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5.0),
                  Expanded(child: Divider(thickness: 2.0)),
                ],
              ),
              SizedBox(height: 5.0),
              Container(
                height: 100,
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      for (var item in _documents)
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  width: 5,
                                  child: IconButton(
                                      color: Colors.red,
                                      icon: Icon(Icons.remove_circle_outline),
                                      onPressed: () {
                                        String name = controllerDocuments[
                                                        _documents
                                                            .indexOf(item)]
                                                    .text !=
                                                ''
                                            ? controllerDocuments[
                                                    _documents.indexOf(item)]
                                                .text
                                            : item.name;

                                        confirmModal(
                                            context,
                                            '¿Está seguro de proceder a remover el documento: $name?',
                                            'Aceptar', positiveAction: () {
                                          setState(() {
                                            controllerDocuments.removeWhere(
                                                (element) =>
                                                    controllerDocuments
                                                        .indexOf(element) ==
                                                    _documents.indexOf(item));
                                            _documents.removeWhere((element) =>
                                                element.id == item.id);
                                          });
                                        });
                                      }),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  validator: (value) {
                                    if(value == null || value.isEmpty) {
                                      return 'Ingresar nombre anexo';
                                    }

                                    return null;
                                  },
                                  controller: controllerDocuments[
                                      _documents.indexOf(item)],
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      hintText: 'Nombre anexo'),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextButton(
                                  child: Text(item.name),
                                  onPressed: () {
                                    Future<Uint8List> pdf =
                                        _getPdf(item.content);

                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => PDFViewer(
                                                path: pdf,
                                                titlePDF: item.name,
                                                canChangeOrientation: false,
                                              )),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.upload_file),
                  onPressed: _pickFileInProgress ? null : _pickDocument)
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 5.0,
              right: 5.0,
              bottom: 5.0,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
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
                              information: widget
                                  .anticorrosiveProtectionModel.contratoId,
                            ),
                            RowBox(
                              titlePrincipal: 'Obra:',
                              information:
                                  widget.anticorrosiveProtectionModel.oT,
                            ),
                            RowBox(
                              titlePrincipal: 'Sistema Aplicado:',
                              information:
                                  widget.anticorrosiveProtectionModel.sistema,
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
                              titlePrincipal: 'Instalación:',
                              information: widget
                                  .anticorrosiveProtectionModel.instalacion,
                            ),
                            RowBox(
                              titlePrincipal: 'Plataforma:',
                              information: widget
                                  .anticorrosiveProtectionModel.plataforma,
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
        ),
      ],
    );
  }

  Widget _tabBar() {
    return Container(
      child: TabBar(
        labelColor: Colors.blueAccent,
        unselectedLabelColor: Colors.black38,
        indicatorColor: Colors.blueAccent,
        controller: tabController,
        tabs: [Tab(text: 'Anticorrosivo'), Tab(text: 'Materiales')],
      ),
    );
  }

  Widget _tabBarView(Orientation orientation, BuildContext ctx) {
    return Container(
        height: 5000, //height of TabBarView
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(color: Colors.blueAccent, width: 0.5))),
        child: GestureDetector(
            onTap: () {
              FocusScope.of(ctx).unfocus();
            },
            child: TabBarView(
              controller: tabController,
              children: [_anticorrosiveTab(ctx), _materialTab(orientation)],
            )));
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
        identificadorTabla: widget.anticorrosiveProtectionModel.noRegistro,
        nombre: p.basename(picture.path),
        nombreTabla: 'HSEQMC.ProteccionAnticorrosiva',
        thumbnail: base64.encode(thumbnailImage).toString(),
      );

      setState(() {
        _lstPhotographics.add(photographic);
      });
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
        identificadorTabla: widget.anticorrosiveProtectionModel.noRegistro,
        nombre: p.basename(picture.path),
        nombreTabla: 'HSEQMC.ProteccionAnticorrosiva',
        thumbnail: base64.encode(thumbnailImage).toString(),
      );

      setState(() {
        _lstPhotographics.add(photographic);
      });
    } else {}
  }

  void selectedPhotographic(String place) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
            )
          ]);
        });
  }

  void deletePhotographic(String id) {
    Dialogs.confirm(context,
        title: "¿Esta seguro de eliminar la evidenvia fotografica?",
        description: "El registro sera eliminado y no podra se recuperado",
        onConfirm: () {
      Navigator.pop(context);
      setState(() {
        _lstPhotographics.removeWhere((element) => element.fotoId == id);
      });
    });
  }

  void showPhotographicPreview(String content) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DetailScreen(bytes: base64.decode(content));
    }));
  }

  /*Widget _genericObject() {
    return MultiBlocListener(
      listeners: [listenerDatesStages()],
    );
  }*/

  Widget _coatingApplication(BuildContext ctx) {
    return MultiBlocListener(
      listeners: [
        listenerCoatingApplication(),
        listenerDatesStages(ctx),
        listenerMaterialsIPA(ctx),
        listenerMaterialStagesDIPA(context)
      ],
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(child: Divider(thickness: 2.0)),
                  SizedBox(width: 5.0),
                  Text(
                    'Aplicación del Recubrimiento',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5.0),
                  Expanded(child: Divider(thickness: 2.0)),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Expanded(child: Text('')),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        item.etapa,
                        textAlign: TextAlign.center,
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                        Text('Observaciones:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right),
                        Text('(para registro fotográfico)',
                            textAlign: TextAlign.right),
                      ])),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerObsRF[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Observaciones'),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('No. de Lote:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerLote[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'No. de Lote'),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('Fecha de Caducidad:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerFCaducidad[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Fecha de Caducidad'),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('Método de Aplicación:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerMetodo[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Método de Aplicación'),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('')),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        item.actividadRecubrimiento,
                        textAlign: TextAlign.center,
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('Tipo de Recubrimiento:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerTipo[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Tipo de Recubrimiento'),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('% de Mezcla:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerMezcla[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: '% de Mezcla'),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('Espesor Seco Promedio:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerEspesor[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[300],
                            enabled: false,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Espesor Seco Promedio'),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('Tiempo Seco Promedio:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerSecado[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Tiempo Seco Promedio'),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('Tipo de Solvente o Adelgazador:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerSolvente[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Tiempo Seco Promedio'),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('Prueba de Continuidad:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerPruebaC[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[300],
                            enabled: false,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Prueba de Continuidad'),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('Prueba de Adherencia:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right)),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerPruebaA[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[300],
                            enabled: false,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Prueba de Adherencia'),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                        Text('Documento Aplicable:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right),
                        Text('(Prueba de Adherencia)',
                            textAlign: TextAlign.right),
                      ])),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerDocumento[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: item.adherencia != 1,
                            fillColor: Colors.grey[300],
                            enabled: item.adherencia == 1,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: item.adherencia == 1
                                ? 'Documento Aplicable'
                                : ''),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                        Text('Comentarios:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right),
                        Text('(Prueba de Continuidad)',
                            textAlign: TextAlign.right),
                      ])),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerComentarioC[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: item.continuidad != 1,
                            fillColor: Colors.grey[300],
                            enabled: item.continuidad == 1,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText:
                                item.continuidad == 1 ? 'Comentarios' : ''),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                        Text('Comentarios:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right),
                        Text('(Prueba de Adherencia)',
                            textAlign: TextAlign.right),
                      ])),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerComentarioA[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            filled: item.adherencia != 1,
                            fillColor: Colors.grey[300],
                            enabled: item.adherencia == 1,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText:
                                item.adherencia == 1 ? 'Comentarios' : ''),
                      ),
                    ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                        Text('Número de Pruebas:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right),
                        Text('(Prueba de Adherencia)',
                            textAlign: TextAlign.right),
                      ])),
                  for (var item in _listCoatingSystem
                      .where((element) => element.recubrimiento == 1))
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        controller: controllerNoPruebas[_listCoatingSystem
                            .where((element) => element.recubrimiento == 1)
                            .toList()
                            .indexOf(item)],
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            filled: item.adherencia != 1,
                            fillColor: Colors.grey[300],
                            enabled: item.adherencia == 1,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: item.adherencia == 1
                                ? 'Número de Pruebas'
                                : ''),
                      ),
                    ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _observations() {
    return MultiBlocListener(
      listeners: [listenerSurfacePreparation()],
      child: Card(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(child: Divider(thickness: 2.0)),
                      SizedBox(width: 5.0),
                      Text(
                        'Observaciones',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(child: Divider(thickness: 2.0)),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: TextFormField(
                                  validator: (value) {
                                    if(value == null || value.isEmpty) {
                                      return 'Ingresar las observaciones';
                                    }
                                    return null;
                                  },
                                  controller: _observaciones,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      hintText: 'Observación'))))
                    ],
                  )
                ],
              ))),
    );
  }

  Widget _surfacePreparation() {
    return MultiBlocListener(
      listeners: [listenerSurfacePreparation(), listenerEvidencePhotographic()],
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(child: Divider(thickness: 2.0)),
                  SizedBox(width: 5.0),
                  Text(
                    'Preparación de Superficie',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5.0),
                  Expanded(child: Divider(thickness: 2.0)),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Observación',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right),
                          Text(
                            '(para registro fotográfico)',
                            textAlign: TextAlign.right,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'Ingresar observación';
                          }
                          return null;
                        },
                        controller: _observacionRF,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Observación'),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text('Condiciones del Sustrato',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'Ingresar condiciones del sustrato';
                          }
                          return null;
                        },
                        controller: _sustrato,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Condiciones del Sustrato'),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text('Tipo de Abrasivo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'Ingresar tipo abrasivo';
                          }
                          return null;
                        },
                        controller: _abrasivo,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Tipo de Abrasivo'),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text('Perfil de Anclaje Promedio',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'Ingresar perfil de anclaje';
                          }
                          return null;
                        },
                        controller: _anclaje,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Perfil de Anclaje Promedio'),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text('Estándar de Limpieza',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TextFormField(
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'Ingresar estándar de limpieza';
                          }
                          return null;
                        },
                        controller: _limpieza,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: 'Estándar de Limpieza'),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[Expanded(child: Divider(thickness: 2.0))],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Incluir en el Reporte',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                            Text('(Evidencias)', textAlign: TextAlign.center),
                            Checkbox(
                                value: _incluirEvidencias,
                                activeColor: Colors.blue,
                                onChanged: (bool value) {
                                  setState(() {
                                    _incluirEvidencias = value;
                                  });
                                })
                          ]),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Evidencia Fotográfica",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "OpenSans",
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    selectedPhotographic('INFOGENERAL');
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        border: Border.all(
                                            color: Colors.blue[300],
                                            width: 3.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                      ),
                                      width: 100,
                                      height: 100,
                                      child: Icon(Icons.camera_enhance,
                                          size: 50, color: Colors.white)),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(
                                    color: Colors.grey[200], width: 1.0),
                              ),
                              height: 200,
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.blueAccent,
                                    width: double.infinity,
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        "Imágenes",
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
                                      child: _lstPhotographics
                                                  .where((element) =>
                                                      element
                                                          .identificadorTabla ==
                                                      widget
                                                          .anticorrosiveProtectionModel
                                                          .noRegistro)
                                                  .length >
                                              0
                                          ? ListView.builder(
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              itemCount: _lstPhotographics
                                                  .where((element) =>
                                                      element
                                                          .identificadorTabla ==
                                                      widget
                                                          .anticorrosiveProtectionModel
                                                          .noRegistro)
                                                  .length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 4, top: 5),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          child:
                                                              PhotographicCard(
                                                            imagen: _lstPhotographics
                                                                .where((element) =>
                                                                    element
                                                                        .identificadorTabla ==
                                                                    widget
                                                                        .anticorrosiveProtectionModel
                                                                        .noRegistro)
                                                                .toList()[index],
                                                            delete:
                                                                deletePhotographic,
                                                            preview:
                                                                showPhotographicPreview,
                                                            readOnly: false,
                                                          ),
                                                        ),
                                                      ],
                                                    ));
                                              })
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Aún no se ha agregado ninguna imagen",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "OpenSans",
                                                  ),
                                                )
                                              ],
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              ),
              Row(
                children: [Container()],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _environmentalConditions() {
    return MultiBlocListener(
        listeners: [listenerCoatingSystem(), listenerEnvironmentalConditions()],
        child: Card(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(child: Divider(thickness: 2.0)),
                    SizedBox(width: 5.0),
                    Text(
                      'Condiciones Ambientales',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(child: Divider(thickness: 2.0)),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(child: Text('')),
                    for (var item in _listCoatingSystem)
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          item.etapa,
                          textAlign: TextAlign.center,
                        ),
                      ))
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Temperatura Ambiente',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    for (var item in _listCoatingSystem)
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextFormField(
                          controller:
                              controllerTA[_listCoatingSystem.indexOf(item)],
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText: 'Temperatura Ambiente'),
                        ),
                      ))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Temperatura Del Sustrato',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    for (var item in _listCoatingSystem)
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextFormField(
                          controller:
                              controllerTS[_listCoatingSystem.indexOf(item)],
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText: 'Temperatura Del Sustrato'),
                        ),
                      ))
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Humedad Relativa',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    for (var item in _listCoatingSystem)
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextFormField(
                          controller:
                              controllerHR[_listCoatingSystem.indexOf(item)],
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText: 'Humedad Relativa'),
                        ),
                      ))
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Future<Uint8List> _getPdf(String content) async {
    return base64Decode(content);
  }

  _pickDocument() async {
    String result;
    try {
      setState(() {
        //_path = '-';
        _pickFileInProgress = true;
      });

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: ['pdf'],
        allowedMimeTypes: ['application/pdf'],
      );

      result = await FlutterDocumentPicker.openDocument(params: params);

      File file = File(result);
      List<int> bytes = file.readAsBytesSync();
      String base64 = base64Encode(bytes);

      //Añadimos el nuevo controlador
      controllerDocuments.add(new TextEditingController(text: ''));

      //Añadimos el objeto
      _documents.add(new DocumentModel(
          id: (_documents.length + 1).toString(),
          nombre: '',
          name: p.basename(file.path),
          content: base64,
          contentType: 'application/pdf'));
    } catch (e) {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje: e,
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
        secondsDuration: 8,
        colorBarIndicator: Colors.red,
        borde: 8,
      );
    } finally {
      setState(() {
        _pickFileInProgress = false;
      });
    }
  }

  Widget _anticorrosiveTab(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          _environmentalConditions(),
          listenerDocuments(),
          _surfacePreparation(),
          _coatingApplication(ctx),
          _equipment(),
          _observations()
        ],
      ),
    );
  }

  Widget _materialTab(Orientation orientation) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: [_datesStages(orientation, context), _materialsTable()],
      ),
    );
  }
}
