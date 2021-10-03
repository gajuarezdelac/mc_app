import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/materials_corrosion/spool_detalle_proteccion/spool_detalle_proteccion_event.dart';
import 'package:mc_app/src/bloc/materials_corrosion/spool_detalle_proteccion/spool_detalle_proteccion_state.dart';
import 'package:mc_app/src/models/materiales_corrosion_model.dart';
import 'package:mc_app/src/repository/materials_corrosion_repository.dart';

class SpoolDetalleProteccionBloc
    extends Bloc<SpoolDetalleProteccionEvent, SpoolDetalleProteccionState> {
  SpoolDetalleProteccionBloc()
      : super(
            InitialSpoolDetalleProteccionState(lstSpoolDetalleProteccion: []));

  final _materialsCorrosionRepository = MaterialsCorrosionRepository();

  @override
  Stream<SpoolDetalleProteccionState> mapEventToState(
      SpoolDetalleProteccionEvent event) async* {
    if (event is GetAllSpoolDetalleProteccion) {
      yield IsLoadingSpoolDetalleProteccion();

      try {
        List<SpoolDetalleProteccionModel> lstSpoolDetalleProteccion =
            await _materialsCorrosionRepository.getSpoolDetalleProteccion(
                noEnvio: event.noEnvio, isReport: event.isReport);

        yield SuccessGetSpoolDetalleProteccion(
            lstSpoolDetalleProteccion: lstSpoolDetalleProteccion);
      } catch (e) {
        print(e.toString());
        yield ErrorSpoolDetalleProteccion(errorMessage: e.toString());
      }
    }
  }
}
