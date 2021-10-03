import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/contract_cs_dropdown_model.dart';
import 'package:mc_app/src/models/contract_dropdown_model.dart';
import 'package:mc_app/src/utils/get_current_date.dart';

class ContractDao {
  DBContext context = DBContext();

  Future<List<ContractDropdownModel>> fetchAllContracts() async {
    final db = await context.database;
    final res = await db.query(
      'Contratos',
      columns: ['ContratoId', 'Nombre'],
      where: 'RegBorrado = ?',
      whereArgs: [0],
    );

    List<ContractDropdownModel> list = res.isNotEmpty
        ? res.map((e) => ContractDropdownModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<List<ContractCSDropdownModel>> fetchContractsCS() async {
    String sql;
    String currentDate;
    List<dynamic> arguments;
    List<ContractCSDropdownModel> list;

    final db = await context.database;

    arguments = ['table', 'PlanoDetalle'];

    final planTable = await db.query(
      'sqlite_master',
      columns: ['name'],
      where: 'type = ? AND name = ?',
      whereArgs: arguments,
      limit: 1,
    );

    if (planTable.isNotEmpty) {
      currentDate = getCurrentDate();

      sql = '''
      SELECT DISTINCT(C.ContratoId) ContratoId, C.ContratoNombre, C.Nombre
      FROM PlanoDetalle PD
        INNER JOIN	Junta J ON J.PlanoDetalleId = PD.PlanoDetalleId 
          AND J.Estado <> ? AND J.Estado <> ? AND J.RegBorrado = ?
        INNER JOIN	Obras O ON O.ObraId = PD.ObraId AND O.RegBorrado = ?
        INNER JOIN	Contratos C ON C.ContratoId = O.ContratoId 
          AND ? <= C.FechaTermino AND C.RegBorrado = ?
      WHERE PD.RegBorrado = ?
    ''';

      arguments = ['PENDIENTE', 'CANCELADA', 0, 0, currentDate, 0, 0];

      final res = await db.rawQuery(sql, arguments);

      list = res.isNotEmpty
          ? res.map((e) => ContractCSDropdownModel.fromJson(e)).toList()
          : [];
    } else {
      list = [];
    }

    return list;
  }

  Future<ContractDropdownModel> fetchContractId(contratoId) async {
    final db = await context.database;
    final res = await db.query(
      'Contratos',
      columns: ['ContratoId', 'Nombre'],
      where: 'ContratoId = ? AND RegBorrado = ?',
      whereArgs: [contratoId, 0],
    );

    List<ContractDropdownModel> list = res.isNotEmpty
        ? res.map((e) => ContractDropdownModel.fromJson(e)).toList()
        : [];

    return list.first;
  }
}
