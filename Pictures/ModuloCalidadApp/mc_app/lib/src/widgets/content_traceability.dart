import 'package:dropdown_search/dropdown_search.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/models/joint_traceability_model.dart';
import 'package:mc_app/src/models/params/joint_traceability_params.dart';
import 'package:mc_app/src/models/params/traceability_params_model.dart';
import 'package:mc_app/src/models/traceability_by_joint_model.dart';
import 'package:mc_app/src/models/traceability_model.dart';
import 'package:mc_app/src/models/work_dropdown_model.dart';
import 'package:mc_app/src/utils/constants.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';
import 'package:mc_app/src/widgets/spinkit.dart';

int radioValue = -1;
List<String> list = [];
Flushbar fuctures;

Future contentTraceability(
  List<JointTraceabilityModel> joints,
  TextEditingController workTrazabilidadSel,
  WorkDropDownModel work,
  WorkTraceability workTraceability,
  TextEditingController juntaSearch,
  TextEditingController planoSearch,
  TextEditingController volumenSearch,
  TextEditingController juntaNo,
  BuildContext parentContext,
  String title,
  TextEditingController cuantity,
  bool isTraceabilityOne,
  String juntaId,
  TraceabilityModel item,
  TraceabilityOneAddBloc _traceabilityOneAddBloc,
  TraceabilityTwoAddBloc _traceabilityTwoAddBloc,
  JointTraceabilityBloc _jointTraceabilityBloc,
) {
  return showDialog(
    context: parentContext,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, StateSetter setState) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constants.padding),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        left: Constants.padding,
                        top: Constants.avatarRadius + Constants.padding,
                        right: Constants.padding,
                        bottom: Constants.padding),
                    margin: EdgeInsets.only(top: 55.0),
                    decoration: new BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: const Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: _addTraceabilityForm(
                              joints,
                              workTrazabilidadSel,
                              isTraceabilityOne,
                              work,
                              juntaSearch,
                              planoSearch,
                              volumenSearch,
                              workTraceability,
                              juntaNo,
                              cuantity,
                              item,
                              setState,
                              _jointTraceabilityBloc),
                        ),
                        SizedBox(height: 22),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  if (fuctures != null) {
                                    fuctures.dismiss(context);
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => _addTraceability(
                                  parentContext,
                                  cuantity.text,
                                  item.idTrazabilidad,
                                  isTraceabilityOne,
                                  juntaId,
                                  _traceabilityOneAddBloc,
                                  _traceabilityTwoAddBloc,
                                  _jointTraceabilityBloc,
                                ),
                                child: Text(
                                  'Agregar',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: Constants.padding,
                    right: Constants.padding,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[500],
                      radius: Constants.avatarRadius,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(Constants.avatarRadius),
                        ),
                        child: Icon(
                          Icons.assignment_late_outlined,
                          size: 64.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
  ).then((_) {
    radioValue = -1;
  });
}

Widget _addTraceabilityForm(
    List<JointTraceabilityModel> joints,
    TextEditingController workTrazabilidadSel,
    bool isTraceabilityOne,
    WorkDropDownModel work,
    TextEditingController juntaSearch,
    TextEditingController planoSearch,
    TextEditingController volumenSearch,
    WorkTraceability workTraceability,
    TextEditingController juntaNo,
    TextEditingController cuantity,
    TraceabilityModel item,
    StateSetter setState,
    JointTraceabilityBloc _jointTraceabilityBloc) {
  return Column(
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Row(
            children: [
              _textHeader('Trazabilidad:', true),
              SizedBox(width: 20.0),
              _textHeader(item.idTrazabilidad, false),
              SizedBox(width: 20.0),
              _textHeader('C.SAP:', true),
              SizedBox(width: 20.0),
              _textHeader(item.material, false),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              _textHeader('Descripción:', true),
              SizedBox(width: 20.0),
              _textHeader(item.materialDescrBreve, false),
            ],
          ),
          SizedBox(height: 20.0),
          _dropdownSearch(joints, workTrazabilidadSel, isTraceabilityOne, item,
              _jointTraceabilityBloc, workTraceability, work, setState),
          _jointTraceabilityBlocBuilder(
              joints,
              workTrazabilidadSel,
              _jointTraceabilityBloc,
              item,
              isTraceabilityOne,
              workTraceability,
              juntaSearch,
              planoSearch,
              volumenSearch,
              juntaNo,
              cuantity,
              setState),
          Column(
            children: [
              SizedBox(height: 20.0),
              Row(
                children: [
                  Text('Relaconado con: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  Text('${juntaNo.text}', style: TextStyle(fontSize: 17)),
                ],
              ),
              Row(
                children: [
                  _textHeader('Cantidad:', true),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: TextField(
                      controller: cuantity,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () => WidgetsBinding.instance
                                  .addPostFrameCallback(
                                      (_) => cuantity.clear()),
                              icon: Icon(Icons.clear))),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      onChanged: (value) {
                        if (radioValue != -1) setState(() => radioValue = -1);
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,4}'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20.0),
                  _textHeader(item.uM, true),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

BlocBuilder _dropdownSearch(
    List<JointTraceabilityModel> joints,
    TextEditingController workTrazabilidadSel,
    bool isTraceabilityOne,
    TraceabilityModel item,
    JointTraceabilityBloc _jointTraceabilityBloc,
    WorkTraceability workTraceability,
    WorkDropDownModel work,
    StateSetter setState) {
  return BlocBuilder<WorkTraceabilityBloc, WorkTraceabiltyState>(
      builder: (context, state) {
    if (state is IsLoadingWorkTR) {
      return dropdownInitial('Cargando obras..');
    }

    if (state is SuccessGetWorkTR) {
      workTraceability =
          state.worksT.firstWhere((element) => element.ot == '${work.oT}');

      return DropdownSearch<WorkTraceability>(
        showSearchBox: true,
        itemAsString: (WorkTraceability u) => '${u.ot}',
        mode: Mode.MENU,
        hint: 'Seleccione una Obra',
        label: 'Obra',
        items: state.worksT,
        selectedItem: workTraceability,
        isFilteredOnline: true,
        onChanged: (obj) {
          setState(() {
            workTraceability = obj;
            workTrazabilidadSel.text = obj.obraId;
          });

          _jointTraceabilityBloc.add(GetJointTraceability(
              params: JointTraceabilityParams(
                  isFilter: false,
                  obraId: obj.obraId,
                  traceabilityId: item.idTrazabilidad,
                  isTraceabilityOne: isTraceabilityOne)));
        },
      );
    }

    if (state is ErrorWorkTR) {
      return dropdownInitial(state.error);
    }

    return Container(height: 0.0);
  });
}

Widget dropdownInitial(String title) {
  return DropdownSearch<dynamic>(
    showSearchBox: true,
    itemAsString: (u) => 'Cargando',
    mode: Mode.MENU,
    hint: 'Seleccione una obra',
    label: 'Obra',
    items: list,
    selectedItem: 'cntrad',
    onChanged: (obj) {},
  );
}

BlocBuilder _jointTraceabilityBlocBuilder(
    List<JointTraceabilityModel> joints,
    TextEditingController workTrazabilidadSel,
    JointTraceabilityBloc _jointTraceabilityBloc,
    TraceabilityModel item,
    bool isTraceabilityOne,
    WorkTraceability workTraceability,
    TextEditingController juntaSearch,
    TextEditingController planoSearch,
    TextEditingController volumenSearch,
    TextEditingController juntaNo,
    TextEditingController cuantity,
    StateSetter setState) {
  return BlocBuilder<JointTraceabilityBloc, JointTraceabilityState>(
      builder: (context, state) {
    if (state is InitialJointTraceabilityState) {
      return Container(height: 0.0);
    } else if (state is IsLoadingJointTraceability) {
      return Center(
        child: spinkit,
      );
    } else if (state is SuccessJointTraceability) {
      if (state.joints.isNotEmpty) {
        // Cuando la junta es llenada por primera vez surge este detalle por primera vez
        joints = [];
        if (joints.isEmpty) {
          state.joints.forEach((element) {
            joints.add(element);
          });
        }
      }

      return state.joints.isNotEmpty
          ? Container(
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Row(children: <Widget>[
                    Expanded(child: Divider(thickness: 2.0))
                  ]),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Column(
                        children: [
                          _textHeader(
                            'Si ya fue reportado en otra junta del mismo plano, selecciona uno:',
                            true,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Text('Junta No.: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Expanded(
                            child: Container(
                              child: Text('Volumen: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: juntaSearch,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () => WidgetsBinding.instance
                                          .addPostFrameCallback(
                                              (_) => juntaSearch.clear()),
                                      icon: Icon(Icons.clear))),
                              keyboardType: TextInputType.text,
                              onSubmitted: (value) {
                                _jointTraceabilityBloc.add(GetJointTraceability(
                                    params: JointTraceabilityParams(
                                        juntaNo: juntaSearch.text,
                                        isFilter: true,
                                        obraId: workTrazabilidadSel.text,
                                        traceabilityId: item.idTrazabilidad,
                                        isTraceabilityOne: isTraceabilityOne)));

                                juntaSearch.text = '';
                              },
                            ),
                          ),
                          SizedBox(width: 15.0),
                          Expanded(
                            child: TextField(
                              controller: volumenSearch,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () => WidgetsBinding.instance
                                          .addPostFrameCallback(
                                              (_) => volumenSearch.clear()),
                                      icon: Icon(Icons.clear))),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                                signed: false,
                              ),
                              onSubmitted: (value) {
                                _jointTraceabilityBloc.add(GetJointTraceability(
                                    params: JointTraceabilityParams(
                                        volumen:
                                            double.parse(volumenSearch.text),
                                        isFilter: true,
                                        obraId: workTrazabilidadSel.text,
                                        traceabilityId: item.idTrazabilidad,
                                        isTraceabilityOne: isTraceabilityOne)));

                                volumenSearch.text = '';
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,4}'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Text('Plano Detalle: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17))
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: planoSearch,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () => WidgetsBinding.instance
                                          .addPostFrameCallback(
                                              (_) => planoSearch.clear()),
                                      icon: Icon(Icons.clear))),
                              keyboardType: TextInputType.text,
                              onSubmitted: (value) {
                                _jointTraceabilityBloc.add(GetJointTraceability(
                                    params: JointTraceabilityParams(
                                        plainDetailId: planoSearch.text,
                                        isFilter: true,
                                        obraId: workTrazabilidadSel.text,
                                        traceabilityId: item.idTrazabilidad,
                                        isTraceabilityOne: isTraceabilityOne)));

                                planoSearch.text = '';
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                      children: joints
                          .map((e) => listRadio(e, juntaNo, cuantity, setState))
                          .toList()),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Expanded(child: Divider(thickness: 2.0)),
                      SizedBox(width: 5.0),
                      Text('Ó', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 5.0),
                      Expanded(child: Divider(thickness: 2.0)),
                    ],
                  ),
                ],
              ),
            )
          : Container(height: 0.0);
    }

    return Container(height: 0.0);
  });
}

Widget listRadio(JointTraceabilityModel e, TextEditingController juntaNo,
    TextEditingController cuantity, StateSetter setState) {
  return SingleChildScrollView(
    child: ListTile(
      title: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Junta(s): ${e.juntaNo}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          Expanded(
            flex: 2,
            child: Text('${e.plano}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          Expanded(
            child: Text('${e.cantidadUsada} ${e.uM}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
      leading: Radio(
        activeColor: Color(0xFF001D85),
        value: e.filaId,
        groupValue: radioValue,
        onChanged: (int value) {
          setState(() {
            radioValue = value;
          });
          cuantity.text = e.cantidadUsada.toString();
          juntaNo.text = e.juntaNo;
        },
      ),
    ),
  );
}

Widget _textHeader(String text, isTitle) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: isTitle ? FontWeight.bold : null,
    ),
  );
}

void _addTraceability(
  BuildContext context,
  String value,
  String traceabilityId,
  bool isTraceabilityOne,
  String juntaId,
  TraceabilityOneAddBloc _traceabilityOneAddBloc,
  TraceabilityTwoAddBloc _traceabilityTwoAddBloc,
  JointTraceabilityBloc _jointTraceabilityBloc,
) {
  if (fuctures != null) {
    fuctures.dismiss(context);
  }

  if (value.isEmpty) {
    fuctures = showNotificationSnackBarHide(
      context,
      title: "",
      mensaje: 'La cantidad es requerida.',
      icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
      secondsDuration: 8,
      colorBarIndicator: Colors.red,
      borde: 8,
    );

    Future.delayed(Duration.zero, () {
      fuctures.show(context);
    });
  } else {
    double cuantity = double.parse(value);

    if (cuantity > 0) {
      bool isOrigin = true;
      JointTraceabilityModel item = JointTraceabilityModel();

      if (radioValue != -1) {
        item = _jointTraceabilityBloc.state.joints
            .where((e) => e.filaId == radioValue)
            .first;

        isOrigin = false;
      }

      TraceabilityParamsModel params = TraceabilityParamsModel(
        juntaId: juntaId,
        juntaIdRelacionado: item.juntaId,
        noTrazabilidad: item.noTrazabilidad,
        isOrigin: isOrigin,
        idTrazabilidad: traceabilityId,
        cantidadUsada: cuantity,
        trazabilidad1: isTraceabilityOne,
      );

      if (isTraceabilityOne) {
        _traceabilityOneAddBloc.add(
          AddTraceabilityOne(
            params: params,
          ),
        );
      } else {
        _traceabilityTwoAddBloc.add(
          AddTraceabilityTwo(
            params: params,
          ),
        );
      }

      Navigator.of(context).pop();
    } else {
      showNotificationSnackBar(
        context,
        title: "",
        mensaje: 'La cantidad debe ser mayor a 0.',
        icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
        secondsDuration: 8,
        colorBarIndicator: Colors.red,
        borde: 8,
      );
    }
  }
}
