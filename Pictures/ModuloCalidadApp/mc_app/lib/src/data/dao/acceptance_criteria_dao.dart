import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/acceptance_criteria_model.dart';

class AcceptanceCriteriaDao {
  DBContext context = DBContext();

  Future<List<AcceptanceCriteriaWeldingModel>>
      getCriterioAceptacionSoldadura() async {
    var db = await context.database;

    var res = await db.query('CriterioAceptacion',
        columns: [
          'CriterioAceptacionId',
          'Clave',
          'Criterio',
        ],
        where: 'InsVisSoldadura = 1 AND RegBorrado = 0',
        orderBy: ' CriterioAceptacionId ASC');

    List<AcceptanceCriteriaWeldingModel> list = res.isNotEmpty
        ? res.map((e) => AcceptanceCriteriaWeldingModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<List<AcceptanceCriteriaconformadoModel>>
      getCriterioAceptacionConformado() async {
    var db = await context.database;

    var res = await db.query('CriterioAceptacion',
        columns: [
          'CriterioAceptacionId',
          'Clave',
          'Criterio',
        ],
        where: 'InsVisConformado = 1 AND RegBorrado = 0',
        orderBy: ' CriterioAceptacionId ASC');

    List<AcceptanceCriteriaconformadoModel> list = res.isNotEmpty
        ? res.map((e) => AcceptanceCriteriaconformadoModel.fromJson(e)).toList()
        : [];

    return list;
  }
}
