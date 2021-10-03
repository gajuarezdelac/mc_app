import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/reports/registro_salida_no_conforme.dart';
import 'package:mc_app/src/bloc/non_compliant_output/report_non_compliant_output/rpt_non_compliant_output_bloc.dart';
import 'package:mc_app/src/bloc/non_compliant_output/report_non_compliant_output/rpt_non_compliant_output_event.dart';
import 'package:mc_app/src/bloc/non_compliant_output/report_non_compliant_output/rpt_non_compliant_output_state.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/show_general_loading.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';

class PruebaPdf extends StatefulWidget {
  @override
  _PruebaPdfState createState() => new _PruebaPdfState();
}

class _PruebaPdfState extends State<PruebaPdf> {
  RptNonCompliantOutputBloc rptNonCompliantOutputBloc;
  RptNonCompliantOutputModel rptNonCompliantOutput;

  @override
  void initState() {
    super.initState();
    initialData();
  }

  void initialData() {
    rptNonCompliantOutputBloc =
        BlocProvider.of<RptNonCompliantOutputBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RptNonCompliantOutputBloc, RptNonCompliantOutputState>(
        builder: (context, state) {
      return Expanded(
          child: MultiBlocListener(
        listeners: [listenerPruebaPdf()],
        child: Container(
          child: IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Prueba PDF',
            onPressed: () {
              rptNonCompliantOutputBloc.add(GetRptNonCompliantOutput(
                  salidaNoConformeId: 'SNCH0000000001'));
              // setState(() {});
            },
          ),
        ),
      ));
    }, listener: (context, state) {
      if (state is SuccessGetRptNonCompliantOutput) {
        Navigator.pop(context);
      } else if (state is IsLoadingRptNonCompliantOutput) {
        showGeneralLoading(context);
      }
    });
  }

  BlocListener listenerPruebaPdf() {
    return BlocListener<RptNonCompliantOutputBloc, RptNonCompliantOutputState>(
        listener: (context, state) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (state is IsLoadingRptNonCompliantOutput) {
        return loadingCircular();
      } else if (state is SuccessGetRptNonCompliantOutput) {
        setState(() {
          rptNonCompliantOutput = state.rptNonCompliantOutput;
        });

        registroSalidaNoConforme(context, rptNonCompliantOutput);
      } else if (state is ErrorRptNonCompliantOutput) {
        Navigator.pop(context);
      }
    });
  }
}
