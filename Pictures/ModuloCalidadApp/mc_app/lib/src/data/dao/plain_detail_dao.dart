import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/plain_detail_dropdown_model.dart';

class PlainDetailDao {
  DBContext context = DBContext();

  Future<List<PlainDetailDropDownModel>> fetchPlainDetails(
      String workId) async {
    final db = await context.database;
    final res = await db.query(
      'PlanoDetalle',
      columns: ['PlanoDetalleId', 'NumeroPlano', 'Revision', 'Hoja'],
      where: 'ObraId = ? AND RegBorrado = ?',
      whereArgs: [workId, 0],
    );

    List<PlainDetailDropDownModel> list = res.isNotEmpty
        ? res.map((e) => PlainDetailDropDownModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<List<PlainDetailDropDownModel>> fetchPlanCS(String workId) async {
    String sql;
    List<dynamic> arguments;

    final db = await context.database;

    sql = '''
      SELECT DISTINCT(PD.PlanoDetalleId) PlanoDetalleId, PD.NumeroPlano, 
        PD.Revision, PD.Hoja
      FROM PlanoDetalle PD 
        INNER JOIN Junta J ON J.PlanoDetalleId = PD.PlanoDetalleId 
          AND PD.ObraId = ? AND J.Estado <> ? 
          AND J.Estado <> ? AND J.RegBorrado = ?
      WHERE PD.RegBorrado = ?
    ''';

    arguments = [workId, 'PENDIENTE', 'CANCELADA', 0, 0];

    final res = await db.rawQuery(sql, arguments);

    List<PlainDetailDropDownModel> list = res.isNotEmpty
        ? res.map((e) => PlainDetailDropDownModel.fromJson(e)).toList()
        : [];

    return list;
  }
}
