import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/ndt_progress_model.dart';

class NDTProgressDao {
  DBContext context = DBContext();

  Future<List<NDTProgressModel>> fetchNDTJointProgress(String jointId) async {
    String sql;
    sql = '''
      SELECT TP.Clave,
				IFNULL(SPND.FolioPND, 'Pendiente') FolioPND,
				IFNULL(CAST(SPND.FechaPND AS TEXT(20)),'Pendiente') FechaPND,
				IFNULL(ES.NoTarjeta, 'Sin tarjeta disponible') NoTarjeta,
				CASE WHEN IFNULL(E.EmpleadoId, 0) <> 0 THEN E.Nombre ELSE EE.Nombre END AS Nombre,
				CASE WHEN IFNULL(SP.Evaluacion,'') = '' THEN 'Pendiente' ELSE SP.Evaluacion END AS Evaluacion
      FROM Junta J
      INNER JOIN JuntaTipoPND JTP ON JTP.JuntaId = J.JuntaId AND JTP.RegBorrado = 0
      INNER JOIN TipoPND TP ON TP.TipoPNDId = JTP.TipoPNDId
      INNER JOIN Soldadura S ON S.JuntaId = J.JuntaId AND S.RegBorrado = 0
      INNER JOIN EmpleadosSoldadura ES ON ES.SoldaduraId = S.SoldaduraId AND ES.RegBorrado = 0
      INNER JOIN Soldador SOL ON SOL.SoldadorId = ES.SoldadorId
      LEFT JOIN	Empleados E ON E.EmpleadoId = IFNULL(CAST(SOL.EmpleadoId AS REAL(18,0)),0)
      LEFT JOIN	EmpleadoExterno EE ON EE.EmpleadoExternoId = SOL.EmpleadoId
      LEFT JOIN	SoldaduraPND SP ON SP.FolioSoldadura = ES.FolioSoldadura AND (SELECT TipoPNDId FROM SolicitudPND WHERE SolicitudPNDId = SP.SolicitudPNDId) = TP.TipoPNDId AND SP.RegBorrado = 0
      LEFT JOIN	SolicitudPND SPND ON SPND.SolicitudPNDId = SP.SolicitudPNDId AND SPND.RegBorrado = 0
      WHERE J.JuntaId = ? AND J.RegBorrado = 0
    ''';

    final db = await context.database;
    final res = await db.rawQuery(sql, [jointId]);

    List<NDTProgressModel> list = res.isNotEmpty
        ? res.map((e) => NDTProgressModel.fromJson(e)).toList()
        : [];

    return list;
  }
}
