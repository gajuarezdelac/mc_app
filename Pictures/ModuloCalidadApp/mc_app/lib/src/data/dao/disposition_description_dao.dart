import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/disposition_description_model.dart';

class DispositionDescriptionDao {
  DBContext context = DBContext();

  Future<DispositionDescriptionModel> getById(
      String descripcionDisposicionId) async {
    final db = await context.database;
    List<Map<String, dynamic>> res;

    res = await db.query('DescripcionDisposicion',
        columns: [
          'DescripcionDisposicionId',
          'SalidaNoConformeId',
          'Acciones',
          'FichaAutoriza',
          'FichaRealiza',
          'FechaEjecucion'
        ],
        where: 'DescripcionDisposicionId = ? AND RegBorrado=0',
        whereArgs: [descripcionDisposicionId],
        limit: 1);
    DispositionDescriptionModel elements =
        res.length > 0 ? DispositionDescriptionModel.fromJson(res.first) : null;

    return elements;
  }
}
