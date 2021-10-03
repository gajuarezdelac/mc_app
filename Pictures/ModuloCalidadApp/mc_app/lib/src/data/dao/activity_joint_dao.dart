import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/activity_joint_model.dart';

class ActivityJointDao {
  DBContext context = DBContext();

  Future<ActivityJointModel> fetchActivityByJoint(
    String siteId,
    double propuestaTecnicaId,
    double actividadId,
    int subActividadId,
  ) async {
    var dbClient = await context.database;
    var res = await dbClient.rawQuery('''
    SELECT
		IFNULL(Conceptos.Partida, 'N/A') AS PartidaPU,
		PropuestaTecnicaActividadesH.PrimaveraId,
		PropuestaTecnicaActividadesH.NoActividadCliente ActividadCliente,
		FoliosPropuestaTecnica.Folio,
    PropuestaTecnicaSubActividadesH.SiteId,
    PropuestaTecnicaSubActividadesH.PropuestaTecnicaId AS PropuestaTecnicaId,
    PropuestaTecnicaSubActividadesH.ActividadId,
    PropuestaTecnicaSubActividadesH.SubActividadId,
    PropuestaTecnicaSubActividadesH.ReprogramacionOTId
	  FROM PropuestaTecnicaSubActividadesH
  	INNER JOIN FoliosPropuestaTecnica 
	  ON PropuestaTecnicaSubActividadesH.SiteId = FoliosPropuestaTecnica.SiteId AND PropuestaTecnicaSubActividadesH.PropuestaTecnicaId = FoliosPropuestaTecnica.PropuestaTecnicaId AND FoliosPropuestaTecnica.RegBorrado = 0 AND IFNULL(FoliosPropuestaTecnica.EmpleadoId,0) <> 0
   	INNER JOIN PropuestaTecnicaActividadesH 
  	ON PropuestaTecnicaSubActividadesH.SiteId = PropuestaTecnicaActividadesH.SiteId AND
	  PropuestaTecnicaSubActividadesH.PropuestaTecnicaId = PropuestaTecnicaActividadesH.PropuestaTecnicaId AND
	  PropuestaTecnicaSubActividadesH.ActividadId = PropuestaTecnicaActividadesH.ActividadId AND
	  IFNULL(PropuestaTecnicaSubActividadesH.ReprogramacionOTId, 0) = IFNULL(PropuestaTecnicaActividadesH.ReprogramacionOTId, 0) AND
  	PropuestaTecnicaActividadesH.RegBorrado = 0
	  LEFT JOIN Conceptos ON PropuestaTecnicaSubActividadesH.ConceptoId = Conceptos.ConceptoId AND Conceptos.RegBorrado = 0
	WHERE PropuestaTecnicaSubActividadesH.SiteId = '$siteId' AND
	PropuestaTecnicaSubActividadesH.PropuestaTecnicaId = '$propuestaTecnicaId' AND
	PropuestaTecnicaSubActividadesH.ActividadId = '$actividadId' AND
	PropuestaTecnicaSubActividadesH.SubActividadId = '$subActividadId' AND
	PropuestaTecnicaSubActividadesH.RegBorrado = 0 LIMIT 1
        ''');

    ActivityJointModel elements = res.length > 0
        ? ActivityJointModel.fromJson(res.first)
        : ActivityJointModel(
            partidaPU: '',
            primaveraId: '',
            actividadCliente: '',
            folio: '',
            siteId: '',
            propuestaTecnicaId: 0,
            actividadId: 0,
            subActividadId: 0,
            partidaInterna: '',
          );

    if (elements != null && elements.actividadId != null) {
      String query;

      query = ''' 
      SELECT CASE WHEN IFNULL(PropuestaTecnica.TipoPlataformaId,1) = 1 THEN
	  	IFNULL(Sistemas.Codigo,'0')  || '.' || IFNULL(Subsistemas.Codigo,'0') || '.' || IFNULL(PropuestaTecnicaActividades.Numero,'0') || '.' || IFNULL(PropuestaTecnicaSubActividades.Numero,'0')
	    ELSE 
	    IFNULL(Zonas.Codigo,'0') || '.' || IFNULL(Areas.Codigo,'0') || '.' || IFNULL(SubAreas.Codigo,'0') || '.' || IFNULL(PropuestaTecnicaActividades.Numero,'0') || '.' ||  IFNULL(PropuestaTecnicaSubActividades.Numero,'0')
	    END PartidaInterna
	    FROM PropuestaTecnica
	    INNER JOIN PropuestaTecnicaActividades ON PropuestaTecnicaActividades.SiteId = PropuestaTecnica.SiteId
	    AND PropuestaTecnicaActividades.PropuestaTecnicaId = PropuestaTecnica.PropuestaTecnicaId AND PropuestaTecnicaActividades.RegBorrado = 0
	    INNER JOIN PropuestaTecnicaSubActividades ON PropuestaTecnicaActividades.SiteId = PropuestaTecnicaSubActividades.SiteId AND PropuestaTecnicaActividades.PropuestaTecnicaId = PropuestaTecnicaSubActividades.PropuestaTecnicaId AND  PropuestaTecnicaActividades.ActividadId = PropuestaTecnicaSubActividades.ActividadId AND PropuestaTecnicaSubActividades.RegBorrado = 0
	    LEFT JOIN Sistemas ON Sistemas.SistemaId= PropuestaTecnicaActividades.SistemaId AND Sistemas.RegBorrado = 0
	    LEFT JOIN Zonas ON Zonas.ZonaId = PropuestaTecnicaActividades.ZonaId AND Zonas.RegBorrado = 0
	    LEFT JOIN Subsistemas ON Subsistemas.SubSistemaId = PropuestaTecnicaActividades.SubSistemaId and Subsistemas.RegBorrado = 0
	    LEFT JOIN Areas ON Areas.AreaId = PropuestaTecnicaActividades.ZonaId AND Areas.RegBorrado = 0
	    LEFT JOIN SubAreas ON SubAreas.SubAreaId = PropuestaTecnicaActividades.SubAreaId AND Areas.RegBorrado = 0     
	    WHERE PropuestaTecnicaSubActividades.SiteId =  '${elements.siteId}' AND PropuestaTecnicaSubActividades.PropuestaTecnicaId =  '${elements.propuestaTecnicaId}'
      AND PropuestaTecnicaSubActividades.ActividadId = '${elements.actividadId}' AND PropuestaTecnicaSubActividades.SubActividadId = 
      '${elements.subActividadId}' AND PropuestaTecnica.RegBorrado = 0 LIMIT 1         
        ''';

      var res = await dbClient.rawQuery(query);

      String partida = res.isNotEmpty ? res[0]['PartidaInterna'] : '0.0.0.0';

      elements.partidaInterna = partida;
      // ciclo
    }

    return elements;
  }
}
