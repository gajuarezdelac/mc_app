import 'package:mc_app/src/database/db_context.dart';

class ConsecutiveDao {
  DBContext context = DBContext();

  Future<String> getConsecutiveId(String type, String siteId) async {
    String query;
    String newId;
    final db = await context.database;

    query = '''
      SELECT IFNULL(Prefijo,'') || IFNULL(Separador,'') || printf('%.' || (CantDigitos-length(SigNum)) ||'c', '0') || CAST(SigNum AS TEXT(6)) NuevoId 
      FROM ConsecutivoFolio WHERE Tipo = '$type' AND Embarcacion = '$siteId'
      LIMIT 1
    ''';

    List<Map<String, dynamic>> result = await db.rawQuery(query);
    newId = result[0]['NuevoId'];

    query = '''
      UPDATE ConsecutivoFolio SET SigNum = SigNum + 1 WHERE Tipo = '$type' AND Embarcacion = '$siteId'
    ''';

    await db.rawUpdate(query);

    return newId;
  }
}
