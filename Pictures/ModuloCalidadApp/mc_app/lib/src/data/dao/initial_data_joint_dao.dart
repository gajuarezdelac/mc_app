import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/initial_data_joint_model.dart';

class InitialDataJointDao {
  DBContext context = DBContext();

  // st_SelJuntaByIdInitialData
  Future<InitialDataJointModel> fetchInitialDataJoint(String juntaId) async {
    var db = await context.database;
    var res = await db.rawQuery('''
  SELECT
  Junta.SiteId,
	Junta.JuntaId,
	Junta.JuntaNo AS Nombre,
	WPS.ClaveWPS AS WPS,
	Diametro.Descripcion AS Diametro,
	Espesor.Descripcion AS Espesor,
	TipoJunta.Descripcion AS Tipo,
	Junta.SpoolEstructura AS Spool,
	PlanoDetalle.NumeroPlano || ' Rev. ' || PlanoDetalle.Revision || ' Hoja ' || PlanoDetalle.Hoja AS PlanoDetalle,
	IFNULL(Conformado.Liberado, 0) ConformadoLiberado,
	IFNULL(Conformado.Norma, 'PENDIENTE') ConformadoNorma,
  Conformado.ConformadoId,
  IFNULL(Conformado.Consecutivo, 0) Consecutivo,
  Conformado.FechaFin,
  Conformado.FechaInicio,
  IFNULL(Conformado.CaboId, 0) CaboId,
  IFNULL(Conformado.InspectorCCAId, 0) InspectorCCAId,
  Conformado.Observaciones,
  Conformado.MotivoFN,
  IFNULL(Conformado.CriteriosAceptacionId,'') AS CriteriosAceptacionId,
  Soldadura.SoldaduraId AS SoldaduraId,
  Soldadura.Consecutivo AS SoldaduraConsecutivo,
	Soldadura.Norma AS SoldaduraNorma,
	Soldadura.Liberado AS SoldaduraLiberada,
  IFNULL(Soldadura.CaboId, 0) AS SoldadorCaboId,
	Soldadura.InspectorCCAId AS SoldaduraInspectorCCAId,
	Soldadura.CambioMaterial AS SoldaduraCambioMaterial,
  Junta.ActividadId,
  Junta.PropuestaTecnicaId,
  Junta.SubActividadId
FROM Junta
	INNER JOIN WPS ON Junta.WPSId = WPS.WPSId
	INNER JOIN Diametro ON  Junta.DiametroId = Diametro.DiametroId
	INNER JOIN Espesor ON Junta.EspesorId = Espesor.EspesorId
	INNER JOIN TipoJunta  ON Junta.TipoJuntaId = TipoJunta.TipoJuntaId
	INNER JOIN PlanoDetalle ON Junta.PlanoDetalleId = PlanoDetalle.PlanoDetalleId
	INNER JOIN Frente ON Junta.FrenteId = Frente.FrenteId
	INNER JOIN Obras  ON PlanoDetalle.ObraId = Obras.ObraId
	INNER JOIN Contratos ON Obras.ContratoId = Contratos.ContratoId
	LEFT JOIN Conformado ON Junta.JuntaId = Conformado.JuntaId AND Conformado.Activo = 1 AND Conformado.RegBorrado = 0
	LEFT JOIN Soldadura ON Soldadura.JuntaId = Junta.JuntaId AND Soldadura.Activo = 1 AND Soldadura.RegBorrado = 0
WHERE Junta.JuntaId = '$juntaId' AND Junta.RegBorrado = 0
    ''');

    if (res.length > 0) {
      return InitialDataJointModel.fromJson(res.first);
    }
    return null;
  }
}
