import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/anticorrosive_protection/report_anticorrosive_protection/rpt_prueba_event.dart';
import 'package:mc_app/src/bloc/anticorrosive_protection/report_anticorrosive_protection/rpt_prueba_state.dart';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';
import 'package:mc_app/src/repository/report_repository.dart';

class RptPruebaBloc extends Bloc<RptPruebaEvent, RptPruebaState> {
  RptPruebaBloc() : super(InitialRptPruebaState());

  final _reportRepository = ReportRepository();

  @override
  Stream<RptPruebaState> mapEventToState(RptPruebaEvent event) async* {
    if (event is GetRptPrueba) {
      yield IsLoadingRptPrueba();

      try {
        List<RptPrueba> listRptPrueba = await _reportRepository.getRptPrueba();

        yield SuccessGetRptPrueba(listRptPrueba: listRptPrueba);
      } catch (e) {
        yield ErrorRptPrueba(errorMessage: e.toString());
      }
    }
  }
}
