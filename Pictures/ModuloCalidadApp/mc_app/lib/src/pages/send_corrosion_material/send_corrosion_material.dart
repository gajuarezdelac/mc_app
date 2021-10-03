import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/bloc/materials_corrosion/bloc.dart';
import 'package:mc_app/src/bloc/dropdown_contract/bloc.dart';
import 'package:mc_app/src/models/materiales_corrosion_model.dart';
import 'package:mc_app/src/models/params/get_materials_corrosion_params.dart';
import 'package:mc_app/src/pages/send_corrosion_material/widgets/filters.dart';
import 'package:mc_app/src/pages/send_corrosion_material/widgets/list_of_materials.dart';
import 'package:mc_app/src/pages/send_corrosion_material/widgets/material_to_corrosion.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';

class SendCorrosionMaterial extends StatefulWidget {
  static String id = "Envío de Materiales a Corrosión";

  SendCorrosionMaterial({Key key}) : super(key: key);

  @override
  _SendCorrosionMaterialState createState() => _SendCorrosionMaterialState();
}

class _SendCorrosionMaterialState extends State<SendCorrosionMaterial> {
  MaterialsCorrosionBloc _materialsBloc;
  SpoolDetalleProteccionBloc _spoolDetalleProteccionBloc;
  DropDownContractBloc _downContractBloc;
  DropDownWorkBloc dropDownWorkBloc;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _materialsBloc = BlocProvider.of<MaterialsCorrosionBloc>(context);
    _spoolDetalleProteccionBloc =
        BlocProvider.of<SpoolDetalleProteccionBloc>(context);
    _downContractBloc = BlocProvider.of<DropDownContractBloc>(context);
    dropDownWorkBloc = BlocProvider.of<DropDownWorkBloc>(context);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

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

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        appBar: AppBar(title: Text(SendCorrosionMaterial.id)),
        body: Container(
          padding: EdgeInsets.all(5.0),
          child: SingleChildScrollView(
            controller: _controller,
            child: Container(
                padding: EdgeInsets.only(
                    left: responsive.wp(0.5), right: responsive.wp(0.5)),
                width: double.infinity,
                height: responsive.height,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: [
                        Filters(
                            selectDate: () => _selectDate(),
                            shearch: loadMaterials),
                        BlocBuilder<MaterialsCorrosionBloc,
                            MaterialsCorrosionState>(builder: (context, state) {
                          if (state is SuccessGetAllMaterialsCorrosion) {
                            return ListOfMaterials(
                              orientation: orientation,
                              controller: _controller,
                              joints: state.lstMaterials,
                              navigateToDetails: (item) =>
                                  _navigateToDetails(item),
                            );
                          }

                          if (state is ErrorMaterialsCorrosion) {
                            return errorLoadMaterials(state.errorMessage);
                          }

                          return loading();
                        }),
                        SizedBox(height: 120)
                      ],
                    )
                  ],
                )),
          ),
        ),
      );
    });
  }

  /* Funciones de la ventana de Envío de Materiales a Corrosión */
  //Recupera información inicial de filtros
  void initialData() {
    _downContractBloc.add(GetContracts());
    dropDownWorkBloc.add(GetWorksById(contractId: ''));
    GetMaterialsCorrisionParamsModel request =
        new GetMaterialsCorrisionParamsModel(
      contratoId: '',
      deptoSolicitante: '',
      destino: '',
      fechaFin: '',
      fechaInicio: '',
      noEnvio: '',
      noRegistroInspeccion: '',
      obraId: '',
      observaciones: '',
    );
    loadMaterials(request);
  }

  //Recupera información del lista de materiales
  void loadMaterials(GetMaterialsCorrisionParamsModel request) {
    _materialsBloc.add(GetAllMaterialsCorrosion(params: request));
  }

  void _loadSpoolDetalleProteccion(String noEnvio) {
    _spoolDetalleProteccionBloc
        .add(GetAllSpoolDetalleProteccion(noEnvio: noEnvio));
  }

  //Método para mostrar el calendario para la campo de Fecha
  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {}
  }

  //Método para ir a la ventana de Material a Corrosión
  Future _navigateToDetails(MaterialesCorrosionModel item) {
    _loadSpoolDetalleProteccion(item.noEnvio);
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MaterialToCorrosion(item: item)),
    );
  }

  //Método para indicar la carga de información
  Widget loading() {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          loadingCircular(),
          SizedBox(height: 10),
          Text("Buscando registros...")
        ],
      ),
    );
  }

  //Muestra mensaje de error
  Widget errorLoadMaterials(String error) {
    showNotificationSnackBar(
      context,
      title: "",
      mensaje: error,
      icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
      secondsDuration: 8,
      colorBarIndicator: Colors.red,
      borde: 8,
    );

    return Center(
        child: Container(
      padding: EdgeInsets.only(top: 30),
      child: Text("Se ha producido un error al buscar la información"),
    ));
  }
}
