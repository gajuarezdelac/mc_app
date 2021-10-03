import 'package:mc_app/src/database/db_context.dart';

class DynamicConsecutiveDao {
  DBContext context = DBContext();

  Future<String> getDynamicConsecutiveId(String prefijo,
      {int cantidadDigitos = 3, bool completo = false}) async {
    String query;
    String newId;
    final db = await context.database;
    int exists = 0;

    List<Map<String, dynamic>> res = await db.rawQuery(
        "SELECT 1 FROM ConsecutivoFolioDinamico WHERE Prefijo = '$prefijo'");

    if (res.isNotEmpty) exists = 1;

    if (exists == 1) {
      if (completo == true) {
        query = '''
          SELECT IFNULL(Prefijo,'') || printf((CantDigitos-length(SigNum)), '0') || CAST(SigNum AS TEXT(6)) NuevoId 
          FROM ConsecutivoFolioDinamico WHERE Prefijo = '$prefijo'
          LIMIT 1
        ''';
      } else {
        query = '''
          SELECT substr('000'||CAST(SigNum AS TEXT(6)), -(CantDigitos), 3) AS NuevoId
          FROM ConsecutivoFolioDinamico WHERE Prefijo = '$prefijo'
          LIMIT 1;
        ''';
      }
      List<Map<String, dynamic>> result = await db.rawQuery(query);
      newId = result[0]['NuevoId'];

      query = '''
          UPDATE ConsecutivoFolioDinamico SET SigNum = SigNum + 1 WHERE Prefijo = '$prefijo'
        ''';
      await db.rawUpdate(query);
    } else {
      await db.rawInsert(
          '''INSERT INTO ConsecutivoFolioDinamico (Prefijo, SigNum, CantDigitos)
		    VALUES ('$prefijo', 1, $cantidadDigitos)''');

      if (completo == true) {
        query = '''
          SELECT IFNULL(Prefijo,'') || printf((CantDigitos-length(SigNum)), '0') || CAST(SigNum AS TEXT(6)) NuevoId 
          FROM ConsecutivoFolioDinamico WHERE Prefijo = '$prefijo'
          LIMIT 1
        ''';
      } else {
        query = '''
          SELECT printf((CantDigitos-length(SigNum)), '0') || CAST(SigNum AS TEXT(6)) NuevoId 
          FROM ConsecutivoFolioDinamico WHERE Prefijo = '$prefijo'
          LIMIT 1
        ''';
      }
      List<Map<String, dynamic>> result = await db.rawQuery(query);
      newId = result[0]['NuevoId'];

      query = '''
          UPDATE ConsecutivoFolioDinamico SET SigNum = SigNum + 1 WHERE Prefijo = '$prefijo'
        ''';
      await db.rawUpdate(query);
    }

    return newId;
  }
}
