import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/bloc/document/document_bloc.dart';
import 'package:mc_app/src/bloc/document/document_event.dart';
import 'package:mc_app/src/bloc/document/document_state.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_bloc.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_event.dart';
import 'package:mc_app/src/models/document_model.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';
import 'package:mc_app/src/models/params/documents_params.dart';
import 'package:mc_app/src/models/params/non_compliant_output_params.dart';
import 'package:mc_app/src/widgets/confirm_modal.dart';
import 'package:mc_app/src/widgets/pdf_viewer.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';
import 'package:path/path.dart' as p;

class UploadFilesSNC extends StatefulWidget {
  final NonCompliantOutputModel sncModel;
  final NonCompliantOutputParams filters;

  UploadFilesSNC({Key key, @required this.sncModel, this.filters})
      : super(key: key);

  @override
  _UploadFilesSNCState createState() => _UploadFilesSNCState();
}

class _UploadFilesSNCState extends State<UploadFilesSNC>
    with SingleTickerProviderStateMixin {
  //Controladores
  TabController tabController;
  final ScrollController controller = ScrollController();

  //Controladores componentes
  List<TextEditingController> controllerDocuments = [];
  List<TextEditingController> controllerDocumento = [];

  //Bloc
  DocumentBloc _documentBloc;
  PaginatorSNCBloc pagBloc;

  //Variables
  bool _pickFileInProgress = false;
  List<DocumentModel> _documents = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setState(() {
      controllerDocuments = [];
      controllerDocumento = [];
    });

    _documentBloc = BlocProvider.of<DocumentBloc>(context);

    tabController = TabController(length: 1, initialIndex: 0, vsync: this);
    tabController.addListener(_handleTabChange);

    _documentBloc.add(GetDocuments(
        params: DocumentsParams(
            identificadorTabla: widget.sncModel.salidaNoConformeId,
            nombreTabla: 'HSEQMC.SalidaNoConforme')));
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
        identificadorTabla: widget.sncModel.salidaNoConformeId,
        nombreTabla: 'HSEQMC.SalidaNoConforme'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:
            AppBar(title: Text('Documentos ${widget.sncModel.consecutivo}')),
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
                                insUpdDocuments();
                              })
                        ],
                      ),
                      DefaultTabController(
                          length: 2,
                          initialIndex: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [_tabBarView()],
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
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
        ));
  }

  _handleTabChange() {}

  BlocListener listenerDocuments() {
    return BlocListener<DocumentBloc, DocumentState>(
      listener: (context, state) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        switch (state.runtimeType) {
          case ErrorDocument:
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

  Widget _tabBarView() {
    return Container(
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
              children: [_filesTab()],
            )));
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

      if (result != null) {
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
      }
    } catch (e) {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje: e.toString(),
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

  Widget _filesTab() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          listenerDocuments(),
        ],
      ),
    );
  }
}
