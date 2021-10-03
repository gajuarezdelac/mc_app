import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/reports/proteccion_anticorrosiva.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';
import 'package:mc_app/src/models/params/anticorrosive_grid_params.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:mc_app/src/widgets/show_general_loading.dart';
import 'package:mc_app/src/widgets/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:mc_app/src/pages/anticorrosive_protection/anticorrosive_modal.dart';
import 'package:mc_app/src/pages/anticorrosive_protection/widgets/anticorrosive_filters.dart';
import 'package:mc_app/src/pages/anticorrosive_protection/widgets/anticorrosive_items.dart';

class AnticorrosiveProtection extends StatefulWidget {
  static String id = 'Protección Anticorrosiva';

  AnticorrosiveProtection({Key key}) : super(key: key);

  @override
  _AnticorrosiveProtectionState createState() =>
      _AnticorrosiveProtectionState();
}

class _AnticorrosiveProtectionState extends State<AnticorrosiveProtection> {
  String _contractSelection;
  String _workSelection;
  bool _pendingChecked = false;
  bool _processChecked = false;
  bool _finishedChecked = false;
  bool _clean = false;

  TextEditingController _registryNumber = TextEditingController();
  TextEditingController _place = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _platform = TextEditingController();
  DateTime _dates = DateTime.now();

  RptAnticorrosiveProtectionBloc _rptAnticorrosiveProtectionBloc;
  RptAPModel rptAPModel;
  DropDownContractBloc _contractsBloc;
  DropDownWorkBloc _dropDownWorkBloc;
  AnticorrosiveGridBloc _anticorrosiveGridBloc;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    _rptAnticorrosiveProtectionBloc =
        BlocProvider.of<RptAnticorrosiveProtectionBloc>(context);

    _contractsBloc = BlocProvider.of<DropDownContractBloc>(context);
    _dropDownWorkBloc = BlocProvider.of<DropDownWorkBloc>(context);
    _anticorrosiveGridBloc = BlocProvider.of<AnticorrosiveGridBloc>(context);

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
    AnticorrosiveGridParams params = AnticorrosiveGridParams(
        registryNumber: null,
        contractId: null,
        workId: null,
        date: null,
        place: null,
        platform: null,
        pending: _pendingChecked,
        progress: _processChecked,
        finalized: _finishedChecked);

    _contractsBloc.add(GetContracts());
    _anticorrosiveGridBloc.add(GetAnticorrosiveItems(params: params));
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return OrientationBuilder(builder: (context, orientation) {
      return MultiBlocListener(
        listeners: [listenerAnticorrosiveGrid(), listenerRptAnticorrosive()],
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: Text(AnticorrosiveProtection.id)),
          body: SingleChildScrollView(
            controller: _controller,
            child: Container(
                padding: EdgeInsets.only(
                    left: responsive.wp(0.5), right: responsive.wp(0.5)),
                width: double.infinity,
                height: responsive.height,
                child: ListView(
                  children: <Widget>[
                    Column(children: [
                      AnticorrosiveFilters(
                        registryNumber: _registryNumber,
                        place: _place,
                        platform: _platform,
                        date: _date,
                        contractSelection: _contractSelection,
                        workSelection: _workSelection,
                        pendingChecked: _pendingChecked,
                        processChecked: _processChecked,
                        finishedChecked: _finishedChecked,
                        selectDate: () => _selectDate(),
                        clearDate: () => _cleanDate(),
                        onChangeContract: _onChangeContract,
                        onChangeWork: _onChangeWork,
                        onChangePendingCheck: _onChangePendingCheck,
                        onChangeProcessCheck: _onChangeProcessCheck,
                        onChangeFinishedCheck: _onChangeFinishedCheck,
                        search: _search,
                      ),
                      AnticorrosiveItems(
                        orientation: orientation,
                        controller: _controller,
                        navigateToDetails: _navigateToDetails,
                        printReport: _printReport,
                      ),
                      SizedBox(height: 120),
                    ])
                  ],
                )),
          ),
        ),
      );
    });
  }

  /* Funciones de la ventana de Protección Anticorrosiva */

  //Método onChange del Combo de Contratos
  void _onChangeContract(dynamic contractId) {
    setState(() {
      _contractSelection = contractId;
      _workSelection = null;
    });
    _dropDownWorkBloc.add(GetWorksById(contractId: contractId));
  }

  //Método onChange del Combo de Obras
  void _onChangeWork(dynamic workId) {
    setState(() {
      _workSelection = workId;
    });
  }

  void _cleanDate() {
    setState(() {
      _date.clear();
      _clean = true;
      _dates = DateTime.now();
    });
  }

  //Método para mostrar el calendario para el campo de Fecha
  Future<void> _selectDate() async {
    if (!_clean) {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _dates,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null) {
        DateFormat formatter = DateFormat('dd/MM/yyyy');
        setState(() {
          _date.text = formatter.format(picked);
          _dates = picked;
        });
      }
    }
    setState(() {
      _clean = false;
    });
  }

  //Método para el checkbox Pendiente
  void _onChangePendingCheck(bool value) {
    setState(() => _pendingChecked = value);
  }

  //Método para el checkbox Proceso
  void _onChangeProcessCheck(bool value) {
    setState(() => _processChecked = value);
  }

  //Método para el checkbox Finalizado
  void _onChangeFinishedCheck(bool value) {
    setState(() => _finishedChecked = value);
  }

  //Método para el botón de búsqueda
  void _search() {
    AnticorrosiveGridParams params = AnticorrosiveGridParams(
        registryNumber:
            _registryNumber.text.isNotEmpty ? _registryNumber.text : null,
        contractId: _contractSelection,
        workId: _workSelection,
        date: _date.text == '' ? null : _date.text,
        place: _place.text == '' ? null : _place.text,
        platform: _platform.text == '' ? null : _platform.text,
        pending: _pendingChecked,
        progress: _processChecked,
        finalized: _finishedChecked);

    _anticorrosiveGridBloc.add(GetAnticorrosiveItems(params: params));
  }

  //Método para ir a la ventana de detalles de Material a Corrosión
  Future _navigateToDetails(
      AnticorrosiveProtectionModel anticorrosiveProtectionModel) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnticorrosiveModal(
          anticorrosiveProtectionModel: anticorrosiveProtectionModel,
          search: _search,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  //Método para ir a la ventana de detalles de Material a Corrosión
  Future<void> _printReport(
      AnticorrosiveProtectionModel anticorrosiveProtectionModel) async {
    _rptAnticorrosiveProtectionBloc
        .add(GetRptAP(noRegistro: anticorrosiveProtectionModel.noRegistro));
  }

  /* Lógica de los BLoCs */

  //Listener para el Grid principal
  BlocListener listenerAnticorrosiveGrid() {
    return BlocListener<AnticorrosiveGridBloc, AnticorrosiveGridState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (state is IsLoadingAntiItems) {
        showGeneralLoading(context);
      } else if (state is SuccessAntiItems) {
        Navigator.pop(context);
      } else if (state is ErrorAntiItems) {
        Navigator.pop(context);

        showNotificationSnackBar(
          context,
          title: "",
          mensaje: state.error,
          icon: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
          secondsDuration: 8,
          colorBarIndicator: Colors.red,
          borde: 8,
        );
      }
    });
  }

  BlocListener listenerRptAnticorrosive() {
    return BlocListener<RptAnticorrosiveProtectionBloc,
        RptAntiCorrosiveProtectionState>(listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingGetRptAP) {
        showGeneralLoading(context);
      } else if (state is SuccessGetRptAP) {
        Navigator.pop(context);
        setState(() {
          rptAPModel = state.rptAPModel;
        });

        proteccionAnticorrosiva(context, rptAPModel);
      } else if (state is ErrorGetRptAP) {
        Navigator.pop(context);
      }
    });
  }
}
