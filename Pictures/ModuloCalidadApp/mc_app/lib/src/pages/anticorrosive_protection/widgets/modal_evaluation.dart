import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/src/models/coating_system_model.dart';
import 'package:mc_app/src/models/materials_table_ipa_model.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';
import 'package:mc_app/src/pages/detail_photographic_screen.dart';
import 'package:mc_app/src/utils/dialogs.dart';
import 'package:mc_app/src/widgets/photographic_card.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

class ModalEvaluation extends StatefulWidget {
  final Function updateData;
  final bool existModel;
  final CoatingSystemModel coatingSystemModel;
  final MaterialsTableIPAModel materialsTableIPAModel;
  final String norma;
  final double espesor;
  final int completado;
  final String noRegistro;
  final int orden;
  final int materialIdIPA;
  final List<PhotographicEvidenceModel> listPhotographicThickness;
  final List<PhotographicEvidenceModel> listPhotographicContinuity;
  final List<PhotographicEvidenceModel> listPhotographicAdherence;

  ModalEvaluation(
      {Key key,
      this.updateData,
      this.existModel,
      this.coatingSystemModel,
      this.materialsTableIPAModel,
      this.norma,
      this.espesor,
      this.completado,
      this.noRegistro,
      this.orden,
      this.materialIdIPA,
      this.listPhotographicThickness,
      this.listPhotographicContinuity,
      this.listPhotographicAdherence})
      : super(key: key);

  @override
  _ModalEvaluationState createState() => _ModalEvaluationState();
}

class _ModalEvaluationState extends State<ModalEvaluation> {
  final ScrollController controller = ScrollController();
  String norma = '';
  int completado = 0;
  TextEditingController controllerEspesor = new TextEditingController();
  List<PhotographicEvidenceModel> listPhotographicThickness = [];
  List<PhotographicEvidenceModel> listPhotographicContinuity = [];
  List<PhotographicEvidenceModel> listPhotographicAdherence = [];

  @override
  void initState() {
    super.initState();

    norma = widget.norma;
    completado = widget.completado;

    controllerEspesor.text = widget.espesor.toString();
    listPhotographicThickness = widget.listPhotographicThickness;
    listPhotographicContinuity = widget.listPhotographicContinuity;
    listPhotographicAdherence = widget.listPhotographicAdherence;
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

      String identificadorTabla = '';
      switch(place) {
        case 'Espesor':
          identificadorTabla = '${widget.noRegistro}|Espesor|${widget.orden}|${widget.materialIdIPA}'; 
          break;
        case 'Continuidad':
          identificadorTabla = '${widget.noRegistro}|Continuidad|${widget.orden}|${widget.materialIdIPA}'; 
          break;
        case 'Adherencia':
          identificadorTabla = '${widget.noRegistro}|Adherencia|${widget.orden}|${widget.materialIdIPA}'; 
          break;
      }

      var photographic = new PhotographicEvidenceModel(
        fotoId: formattedDate,
        content: base64.encode(contentImage).toString(),
        contentType: lookupMimeType(picture.path),
        identificadorTabla: identificadorTabla,
        nombre: p.basename(picture.path),
        nombreTabla: 'HSEQMC.ProteccionAnticorrosiva',
        thumbnail: base64.encode(thumbnailImage).toString(),
      );

      setState(() {
        switch(place) {
          case 'Espesor':
            listPhotographicThickness.add(photographic);
            break;
          case 'Continuidad':
            listPhotographicContinuity.add(photographic);
            break;
          case 'Adherencia':
            listPhotographicAdherence.add(photographic);
            break;
        }
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

      String identificadorTabla = '';
      switch(place) {
        case 'Espesor':
          identificadorTabla = '${widget.noRegistro}|Espesor|${widget.orden}|${widget.materialIdIPA}'; 
          break;
        case 'Continuidad':
          identificadorTabla = '${widget.noRegistro}|Continuidad|${widget.orden}|${widget.materialIdIPA}'; 
          break;
        case 'Adherencia':
          identificadorTabla = '${widget.noRegistro}|Adherencia|${widget.orden}|${widget.materialIdIPA}'; 
          break;
      }

      var photographic = new PhotographicEvidenceModel(
        fotoId: formattedDate,
        content: base64.encode(contentImage).toString(),
        contentType: lookupMimeType(picture.path),
        identificadorTabla: identificadorTabla,
        nombre: p.basename(picture.path),
        nombreTabla: 'HSEQMC.ProteccionAnticorrosiva',
        thumbnail: base64.encode(thumbnailImage).toString(),
      );

      setState(() {
        switch(place) {
          case 'Espesor':
            listPhotographicThickness.add(photographic);
            break;
          case 'Continuidad':
            listPhotographicContinuity.add(photographic);
            break;
          case 'Adherencia':
            listPhotographicAdherence.add(photographic);
            break;
        }
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

  void deletePhotographic(String id, String place) {
    Dialogs.confirm(context,
        title: "¿Esta seguro de eliminar la evidenvia fotografica?",
        description: "El registro sera eliminado y no podra se recuperado",
        onConfirm: () {
      Navigator.pop(context);
      setState(() {
        switch(place) {
          case 'Espesor':
            listPhotographicThickness.removeWhere((element) => element.fotoId == id);
            break;
          case 'Continuidad':
            listPhotographicContinuity.removeWhere((element) => element.fotoId == id);
            break;
          case 'Adherencia':
            listPhotographicAdherence.removeWhere((element) => element.fotoId == id);
        }
      });
    });
  }

  void showPhotographicPreview(String content) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DetailScreen(bytes: base64.decode(content));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Guardar',
            onPressed: () {
              List<String> keys = [];
              keys.add('${widget.noRegistro}|Espesor|${widget.orden}|${widget.materialIdIPA}');

              if(widget.coatingSystemModel.continuidad == 1) {
                keys.add('${widget.noRegistro}|Continuidad|${widget.orden}|${widget.materialIdIPA}');
              }

              if(widget.coatingSystemModel.adherencia == 1) {
                keys.add('${widget.noRegistro}|Adherencia|${widget.orden}|${widget.materialIdIPA}');
              }

              widget.updateData(
                widget.orden,
                widget.materialIdIPA,
                norma,
                double.tryParse(controllerEspesor.text),
                listPhotographicThickness,
                listPhotographicContinuity,
                listPhotographicAdherence,
                widget.existModel,
                keys
              );

              Navigator.of(context).pop();
            },
          )
        ],
        title: Text('Evaluación'),
        content: SingleChildScrollView(
          controller: controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.coatingSystemModel.etapa,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Trazabilidad: ' + widget.materialsTableIPAModel.trazabilidadId,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                child: norma == ''
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.green)),
                            child: Text('D/N',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              setState(() {
                                norma = 'D/N';
                              });
                            },
                          ),
                          SizedBox(width: 5.0),
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            child: Text('F/N',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              setState(() {
                                norma = 'F/N';
                              });
                            },
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    norma == 'D/N'
                                        ? Colors.green
                                        : Colors.red)),
                            child: Text(norma,
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              if (norma == 'F/N') {
                                setState(() {
                                  norma = '';
                                });
                              }
                            },
                          )
                        ],
                      ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text('Espesor'),
                            )),
                        Expanded(
                          flex: 1,
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: TextFormField(
                                  controller: controllerEspesor,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ))),
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text('MLS')),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.coatingSystemModel.continuidad == 1
                          ? 'Continuidad'
                          : '',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.coatingSystemModel.adherencia == 1
                          ? 'Adherencia'
                          : '',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  //Espesor
                  Expanded(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              selectedPhotographic('Espesor');
                            },
                            child: Text('Añadir imagen'),
                          ),
                          Row(
                        children: [
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
                                      width: 300,
                                      child: listPhotographicThickness.length > 0
                                          ? ListView.builder(
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              itemCount: listPhotographicThickness.length,
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
                                                            imagen: listPhotographicThickness[index],
                                                            delete: (id) {
                                                              deletePhotographic(id, 'Espesor');
                                                            },
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
                      )
                        ],
                      )),
                      widget.coatingSystemModel.continuidad == 1 ?
                      Expanded(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              selectedPhotographic('Continuidad');
                            },
                            child: Text('Añadir imagen'),
                          ),
                          Row(
                        children: [
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
                                      width: 300,
                                      child: listPhotographicContinuity.length > 0
                                          ? ListView.builder(
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              itemCount: listPhotographicContinuity.length,
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
                                                            imagen: listPhotographicContinuity[index],
                                                            delete: (id) {
                                                              deletePhotographic(id, 'Continuidad');
                                                            },
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
                      )
                        ],
                      )) :
                      Expanded(
                        child: Text(''),
                      ),
                      widget.coatingSystemModel.adherencia == 1 ?
                      Expanded(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              selectedPhotographic('Adherencia');
                            },
                            child: Text('Añadir imagen'),
                          ),
                          Row(
                        children: [
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
                                      width: 300,
                                      child: listPhotographicAdherence.length > 0
                                          ? ListView.builder(
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              itemCount: listPhotographicAdherence.length,
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
                                                            imagen: listPhotographicAdherence[index],
                                                            delete: (id) {
                                                              deletePhotographic(id, 'Adherencia');
                                                            },
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
                      )
                        ],
                      )) :
                      Expanded(
                        child: Text(''),
                      )
                ],
              )
            ],
          ),
        ));
  }
}
