import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/work_dropdown_model.dart';

class WorkDao {
  DBContext context = DBContext();

  Future<List<WorkDropDownModel>> fetchWorksById(String contractId) async {
    final db = await context.database;
    final res = await db.query(
      'Obras',
      columns: ['ObraId', 'OT', 'Nombre'],
      where: 'ContratoId = ? AND RegBorrado = ?',
      whereArgs: [contractId, 0],
    );

    List<WorkDropDownModel> list = res.isNotEmpty
        ? res.map((e) => WorkDropDownModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<List<WorkDropDownModel>> fetchWorksCS(String contractId) async {
    String sql;
    List<dynamic> arguments;

    final db = await context.database;

    sql = '''
      SELECT DISTINCT(PD.ObraId) ObraId, O.Nombre, O.OT
      FROM PlanoDetalle PD
        INNER JOIN Junta J ON J.PlanoDetalleId = PD.PlanoDetalleId 
          AND J.Estado <> ? AND J.Estado <> ? AND J.RegBorrado = ?
        INNER JOIN Obras O ON O.ObraId = PD.ObraId 
          AND O.ContratoId = ? AND O.RegBorrado = ?
      WHERE PD.RegBorrado = ?
    ''';

    arguments = ['PENDIENTE', 'CANCELADA', 0, contractId, 0, 0];

    final res = await db.rawQuery(sql, arguments);

    List<WorkDropDownModel> list = res.isNotEmpty
        ? res.map((e) => WorkDropDownModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<WorkDropDownModel> fetchWorkById(String obraId) async {
    final db = await context.database;
    final res = await db.query(
      'Obras',
      columns: ['ObraId', 'OT', 'Nombre'],
      where: 'ObraId = ? AND RegBorrado = ?',
      whereArgs: [obraId, 0],
    );

    List<WorkDropDownModel> list = res.isNotEmpty
        ? res.map((e) => WorkDropDownModel.fromJson(e)).toList()
        : [];

    return list.first;
  }
}
