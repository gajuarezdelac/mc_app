import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/models/materiales_corrosion_model.dart';
import 'package:mc_app/src/repository/materials_corrosion_repository.dart';

import 'materials_corrosion_event.dart';
import 'materials_corrosion_state.dart';

class MaterialsCorrosionBloc extends Bloc<MaterialsCorrosionEvent, MaterialsCorrosionState> {
  MaterialsCorrosionBloc() : super(InitialMaterialsCorrosionState(lstMaterials:  []));

  final _materialsCorrosionRepository = MaterialsCorrosionRepository();

  @override
  Stream<MaterialsCorrosionState> mapEventToState(MaterialsCorrosionEvent event) async* {
    if (event is GetAllMaterialsCorrosion) {
      yield IsLoadingMaterialsCorrosion();

      try {
        List<MaterialesCorrosionModel> lstMaterils = await _materialsCorrosionRepository.getAllMaterialsCorrosion(params: event.params);

        yield SuccessGetAllMaterialsCorrosion(
          lstMaterials: lstMaterils
        );
      } catch (e) {
        yield ErrorMaterialsCorrosion(errorMessage: e.toString());
      }
    }
}
}
