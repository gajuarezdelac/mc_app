import 'package:intl/intl.dart';
import 'package:mc_app/src/data/dao/joint_dao.dart';
import 'package:mc_app/src/data/dao/site_dao.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/pipefitter_model.dart';

class PipefitterDao {
  DBContext context = DBContext();

  Future<int> deletePipefitter(int employeeId, String jointId) async {
    String query;
    String siteId;
    String formingId;
    String jointAdvanceId;
    int result = 0;

    final db = await context.database;
    final site = SiteDao();
    final joint = JointDao();

    siteId = await site.getSiteId();

    List<Map<String, dynamic>> formingIdRes = await db.query(
      'Conformado',
      columns: ['ConformadoId'],
      where: 'JuntaId = ? AND Activo = 1 AND RegBorrado = 0',
      whereArgs: [jointId],
      limit: 1,
    );

    formingId = formingIdRes[0]['ConformadoId'];

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    result = await db.update(
      'EmpleadosConformado',
      {
        'RegBorrado': -1,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where: 'EmpleadoId = ? AND ConformadoId = ? AND RegBorrado = 0',
      whereArgs: [employeeId, formingId],
    );

    query = '''
      SELECT J.AvanceJuntaId AvanceJuntaId
      FROM Conformado C
        INNER JOIN Junta J
      ON C.JuntaId = J.JuntaId AND J.RegBorrado = 0
      WHERE C.ConformadoId = ? AND C.Activo = 1 AND C.RegBorrado = 0
      LIMIT 1
    ''';

    List<Map<String, dynamic>> jointAdvanceIdRes = await db.rawQuery(
      query,
      [formingId],
    );

    jointAdvanceId = jointAdvanceIdRes[0]['AvanceJuntaId'];

    query = '''
      UPDATE AvanceJunta
      SET Tuberos = Tuberos - 1, SiteModificacion = ?, FechaModificacion = ?
      WHERE AvanceJuntaId = ?
    ''';

    result = await db.rawUpdate(query, [siteId, currentDate, jointAdvanceId]);

    //Se actualiza el progreso de la Junta
    result = await joint.updateProgressJoint(jointId);

    return result;
  }

  Future<int> signPipefitter(int employeeId, String jointId) async {
    String siteId;
    String formingId;
    int result = 0;

    final db = await context.database;
    final site = SiteDao();

    siteId = await site.getSiteId();

    List<Map<String, dynamic>> formingIdRes = await db.query(
      'Conformado',
      columns: ['ConformadoId'],
      where: 'JuntaId = ? AND Activo = 1 AND RegBorrado = 0',
      whereArgs: [jointId],
      limit: 1,
    );

    formingId = formingIdRes[0]['ConformadoId'];

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    result = await db.update(
      'EmpleadosConformado',
      {
        'Firmado': 1,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where: 'EmpleadoId = ? AND ConformadoId = ? AND RegBorrado = 0',
      whereArgs: [employeeId, formingId],
    );

    return result;
  }

  Future<int> addPipefitter(int card, String jointId) async {
    String query;
    String siteId;
    String formingId;
    String jointAdvanceId;
    int employeeId;
    int result = 0;

    final db = await context.database;
    final site = SiteDao();
    final joint = JointDao();

    //Se consulta si existe el tubero
    query = '''
      SELECT EmpleadoId
      FROM Empleados
      WHERE PuestoDescripcion LIKE '%tubero%' AND Ficha = ? AND RegBorrado = 0
      LIMIT 1
    ''';

    List<Map<String, dynamic>> employeeIdRes = await db.rawQuery(query, [card]);

    if (employeeIdRes.isNotEmpty) {
      employeeId = employeeIdRes[0]['EmpleadoId'];

      //Se obtiene el ConformadoId
      List<Map<String, dynamic>> formingIdRes = await db.query(
        'Conformado',
        columns: ['ConformadoId'],
        where: 'JuntaId = ? AND Activo = 1 AND RegBorrado = 0',
        whereArgs: [jointId],
        limit: 1,
      );
      formingId = formingIdRes[0]['ConformadoId'];

      //Existe el registro EmpleadosConformado
      final employeeFormingExists = await db.query(
        'EmpleadosConformado',
        columns: ['ConformadoId'],
        where: 'EmpleadoId = ? AND ConformadoId = ? AND RegBorrado = 0',
        whereArgs: [employeeId, formingId],
        limit: 1,
      );

      if (employeeFormingExists.isEmpty) {
        //Se obtiene el SiteId
        siteId = await site.getSiteId();

        //Se valida si el registro ya existe y se encuentra eliminado o es nuevo.
        final isNewEmployee = await db.query(
          'EmpleadosConformado',
          columns: ['ConformadoId'],
          where: 'EmpleadoId = ? AND ConformadoId = ? AND RegBorrado = -1',
          whereArgs: [employeeId, formingId],
        );

        DateTime now = DateTime.now();
        DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
        String currentDate = formatter.format(now);

        if (isNewEmployee.isNotEmpty) {
          result = await db.update(
            'EmpleadosConformado',
            {
              'RegBorrado': 0,
              'SiteModificacion': siteId,
              'FechaModificacion': currentDate,
            },
            where: 'EmpleadoId = ? AND ConformadoId = ?',
            whereArgs: [employeeId, formingId],
          );
        } else {
          result = await db.insert(
            'EmpleadosConformado',
            {
              'EmpleadoId': employeeId,
              'ConformadoId': formingId,
              'Firmado': 0,
              'SiteModificacion': siteId,
              'FechaModificacion': currentDate,
            },
          );
        }

        List<Map<String, dynamic>> jointAdvanceIdRes = await db.query(
          'Junta',
          columns: ['AvanceJuntaId'],
          where: 'JuntaId = ? AND RegBorrado = 0',
          whereArgs: [jointId],
          limit: 1,
        );

        jointAdvanceId = jointAdvanceIdRes[0]['AvanceJuntaId'];

        query = '''
          UPDATE AvanceJunta
					SET Tuberos = Tuberos + 1, SiteModificacion = ?, FechaModificacion = ?
					WHERE AvanceJuntaId = ?
        ''';

        result = await db.rawUpdate(
          query,
          [
            siteId,
            currentDate,
            jointAdvanceId,
          ],
        );

        //Se actualiza el progreso de la junta
        result = await joint.updateProgressJoint(jointId);
      } else {
        throw ('El tubero con la ficha $card, ya se encuentra asignado al conformado.');
      }
    } else {
      throw ('No se encontró ningún tubero con la ficha $card.');
    }

    return result;
  }

  Future<List<PipefitterModel>> getPipefitters(String jointId) async {
    String query;
    String formingId;

    final db = await context.database;

    //Se obtiene el ConformadoId
    List<Map<String, dynamic>> formingIdRes = await db.query(
      'Conformado',
      columns: ['ConformadoId'],
      where: 'JuntaId = ? AND Activo = 1 AND RegBorrado = 0',
      whereArgs: [jointId],
      limit: 1,
    );
    formingId = formingIdRes[0]['ConformadoId'];

    query = '''
      SELECT E.EmpleadoId, EC.Firmado, E.Foto,  E.Nombre, E.Ficha, E.PuestoDescripcion
      FROM EmpleadosConformado EC
        INNER JOIN Empleados E
      ON EC.EmpleadoId = E.EmpleadoId AND E.RegBorrado = 0
      WHERE EC.ConformadoId = ? AND EC.RegBorrado = 0
    ''';

    final res = await db.rawQuery(query, [formingId]);

    List<PipefitterModel> list = res.isNotEmpty
        ? res.map((e) => PipefitterModel.fromJson(e)).toList()
        : [];

    return list;
  }
}
