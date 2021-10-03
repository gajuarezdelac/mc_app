import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/synchronization_model.dart';

class SynchronizationDao {
  DBContext context = DBContext();

  Future<List<SynchronizationModel>> fetchAllSynchronizations() async {
    final db = await context.database;
    final res = await db.query('Sincronizaciones');

    List<SynchronizationModel> list = res.isNotEmpty
        ? res.map((e) => SynchronizationModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<List<SynchronizationModel>> fetchLastSynchronization() async {
    final db = await context.database;
    final res = await db.query('Sincronizaciones',
        orderBy: "FechaUltimaActualizacion DESC", limit: 1);

    List<SynchronizationModel> list = res.isNotEmpty
        ? res.map((e) => SynchronizationModel.fromJson(e)).toList()
        : null;

    return list;
  }

  Future<int> insertSynchronization(SynchronizationModel sync) async {
    final db = await context.database;
    int id = await db.insert("Sincronizaciones", sync.toJson());
    return id;
  }

  Future<int> updateSynchronization(SynchronizationModel sync) async {
    final db = await context.database;
    int id = await db.update("Sincronizaciones", sync.toJson(),
        where: 'SincronizacionId = ?', whereArgs: [sync.sincronizacionId]);
    return id;
  }
}
