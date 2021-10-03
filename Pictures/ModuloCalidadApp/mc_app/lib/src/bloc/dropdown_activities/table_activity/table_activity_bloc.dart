import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/table_activity/table_activity_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/table_activity/table_activity_state.dart';
import 'package:mc_app/src/models/activities_table_model.dart';
import 'package:mc_app/src/repository/activities_repository.dart';

class TableActivityBloc extends Bloc<TableActivityEvent, ActivitiesTableState> {
  TableActivityBloc() : super(InitialTableActivityState());

  final _tableActivityRepository = ActivitiesRepository();

  @override
  Stream<ActivitiesTableState> mapEventToState(
      TableActivityEvent event) async* {
    if (event is GetTableActivity) {
      yield IsLoadingTableActivity();

      try {
        List<ActivitiesTableModel> activitiesTableModel =
            await _tableActivityRepository.getTableActivity(
                contratoId: event.contratoId,
                obraId: event.obraId,
                folio: event.folioId,
                especialidad: event.especialidad,
                fechaInicio: event.fechaInicio,
                fechaFin: event.fechaFin,
                reprogramacionOT: event.reprogramacionOT,
                frenteId: event.frenteId,
                sistema: event.sistema,
                plano: event.plano,
                anexo: event.anexo,
                partidaPU: event.partidaPU,
                primaveraId: event.primaveraId,
                noActividadCliente: event.noActividadCliente,
                estatusId: event.estatusId,
                partidaFilter: event.partidaFilter);

        yield SuccessTableActivity(activitiesTableModel: activitiesTableModel);
      } catch (e) {
        yield ErrorTableActivity(errorMessage: e.toString());
      }
    }
  }
}
