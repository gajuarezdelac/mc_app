import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/front_dropdown_model.dart';

class FrontDao {
  DBContext context = DBContext();

  Future<List<FrontDropdownModel>> fetchFronts() async {
    final db = await context.database;
    final res = await db.query(
      'Frente',
      columns: ['FrenteId', 'Descripcion'],
      where: 'Mostrar = ? AND RegBorrado = ?',
      whereArgs: [1, 0],
    );

    List<FrontDropdownModel> list = res.isNotEmpty
        ? res.map((e) => FrontDropdownModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<List<FrontDropdownModel>> fetchFrontCS(String planDetailId) async {
    String sql;
    List<dynamic> arguments;

    final db = await context.database;

    sql = '''
      SELECT DISTINCT(J.FrenteId) FrenteId, F.Descripcion
      FROM Junta J
      INNER JOIN Frente F ON F.FrenteId = J.FrenteId AND F.RegBorrado = ?
      WHERE J.PlanoDetalleId = ? AND J.Estado <> ? AND J.Estado <> ? AND J.RegBorrado = ?
    ''';

    arguments = [0, planDetailId, 'PENDIENTE', 'CANCELADA', 0];

    final res = await db.rawQuery(sql, arguments);

    List<FrontDropdownModel> list = res.isNotEmpty
        ? res.map((e) => FrontDropdownModel.fromJson(e)).toList()
        : [];

    return list;
  }
}
