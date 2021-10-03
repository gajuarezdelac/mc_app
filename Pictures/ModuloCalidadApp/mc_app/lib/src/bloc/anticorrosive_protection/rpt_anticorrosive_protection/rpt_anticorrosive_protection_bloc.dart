import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/anticorrosive_protection/rpt_anticorrosive_protection/rpt_anticorrosive_protection_event.dart';
import 'package:mc_app/src/bloc/anticorrosive_protection/rpt_anticorrosive_protection/rpt_anticorrosive_protection_state.dart';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';
import 'package:mc_app/src/repository/report_repository.dart';

class RptAnticorrosiveProtectionBloc extends Bloc<
    RptAnticorrosiveProtectionEvent, RptAntiCorrosiveProtectionState> {
  RptAnticorrosiveProtectionBloc() : super(InitialGetRptAPState());

  final _reportRepository = ReportRepository();

  @override
  Stream<RptAntiCorrosiveProtectionState> mapEventToState(
      RptAnticorrosiveProtectionEvent event) async* {
    if (event is GetRptAP) {
      yield IsLoadingGetRptAP();

      try {
        RptAPModel rptAPModel =
            await _reportRepository.getRptAPA(noRegistro: event.noRegistro);

        yield SuccessGetRptAP(rptAPModel: rptAPModel);
      } catch (e) {
        yield ErrorGetRptAP(errorMessage: e.toString());
      }
    }
  }
}
