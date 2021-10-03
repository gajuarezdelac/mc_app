import 'package:mc_app/src/data/dao/materiales_corrosion_dao.dart';
import 'package:mc_app/src/models/params/get_materials_corrosion_params.dart';

class MaterialsCorrosionRepository {
  final materialsCorrosionDao = MaterialesCorrosionDao();

  Future getAllMaterialsCorrosion({GetMaterialsCorrisionParamsModel params}) =>
      materialsCorrosionDao.fetchGetAllMaterialsC(params);

  Future getSpoolDetalleProteccion({String noEnvio, bool isReport}) =>
      materialsCorrosionDao.fetchGetSpoolDetalleProteccion(noEnvio, isReport);
}
