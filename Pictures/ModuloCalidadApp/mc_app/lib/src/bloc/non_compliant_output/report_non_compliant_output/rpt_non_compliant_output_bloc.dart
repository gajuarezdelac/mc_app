import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/non_compliant_output/report_non_compliant_output/rpt_non_compliant_output_event.dart';
import 'package:mc_app/src/bloc/non_compliant_output/report_non_compliant_output/rpt_non_compliant_output_state.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';
import 'package:mc_app/src/repository/report_repository.dart';

class RptNonCompliantOutputBloc
    extends Bloc<RptNonCompliantOutputEvent, RptNonCompliantOutputState> {
  RptNonCompliantOutputBloc() : super(InitialRptNonCompliantOutputState());

  final _reportRepository = ReportRepository();

  @override
  Stream<RptNonCompliantOutputState> mapEventToState(
      RptNonCompliantOutputEvent event) async* {
    if (event is GetRptNonCompliantOutput) {
      yield IsLoadingRptNonCompliantOutput();

      try {
        RptNonCompliantOutputModel rptNonCompliantOutput =
            await _reportRepository.getRptSalidaNoConforme(
                salidaNoConformeId: event.salidaNoConformeId);

        yield SuccessGetRptNonCompliantOutput(
            rptNonCompliantOutput: rptNonCompliantOutput);
      } catch (e) {
        yield ErrorRptNonCompliantOutput(errorMessage: e.toString());
      }
    }
  }
}
