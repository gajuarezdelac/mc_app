import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/anticorrosive_protection/report_anticorrosive_protection/rpt_prueba_bloc.dart';
import 'package:mc_app/src/bloc/anticorrosive_protection/report_anticorrosive_protection/rpt_prueba_event.dart';
import 'package:mc_app/src/bloc/anticorrosive_protection/report_anticorrosive_protection/rpt_prueba_state.dart';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/show_general_loading.dart';

class ReportPruebaFoto extends StatefulWidget {
  @override
  _ReportPruebaFotoState createState() => new _ReportPruebaFotoState();
}

class _ReportPruebaFotoState extends State<ReportPruebaFoto> {
  RptPruebaBloc rptPruebaBloc;
  List<RptPrueba> listRptPrueba;

  @override
  void initState() {
    super.initState();
    initialData();
  }

  void initialData() {
    rptPruebaBloc = BlocProvider.of<RptPruebaBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RptPruebaBloc, RptPruebaState>(
        builder: (context, state) {
      return Expanded(
          child: MultiBlocListener(
        listeners: [listenerPruebaPdf()],
        child: Container(
          child: IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Prueba PDF',
            onPressed: () {
              rptPruebaBloc.add(GetRptPrueba());
              // setState(() {});
            },
          ),
        ),
      ));
    }, listener: (context, state) {
      if (state is SuccessGetRptPrueba) {
        Navigator.pop(context);
      } else if (state is IsLoadingRptPrueba) {
        showGeneralLoading(context);
      }
    });
  }

  BlocListener listenerPruebaPdf() {
    return BlocListener<RptPruebaBloc, RptPruebaState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingRptPrueba) {
        return loadingCircular();
      } else if (state is SuccessGetRptPrueba) {
        setState(() {
          listRptPrueba = state.listRptPrueba;
        });

        // proteccionAnticorrosiva(context, listRptPrueba[0].content);
      } else if (state is ErrorRptPrueba) {
        Navigator.pop(context);
      }
    });
  }
}
