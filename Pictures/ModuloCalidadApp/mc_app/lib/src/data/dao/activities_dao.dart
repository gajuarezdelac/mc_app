import 'package:mc_app/src/data/dao/functions_dao.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';
import 'package:mc_app/src/models/activities_table_model.dart';
import 'package:mc_app/src/models/internal_departure_model.dart';
import 'package:intl/intl.dart';

class ActivitiesDao {
  DBContext context = DBContext();

  Future<int> relateActivity(String siteId, double propuestaTecnicaId,
      double actividadId, int subActividadId, String juntaId) async {
    var dbClient =
        await context.database; // Instancia para acceder a la base de datos

    // Se agrega la fecha
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    var res = await dbClient.rawUpdate(''' 
    UPDATE Junta SET 
	  SiteId = '$siteId',
	  PropuestaTecnicaId = '$propuestaTecnicaId',
	  ActividadId = '$actividadId',
	  SubActividadId = '$subActividadId',
	  SiteModificacion = '$siteId',
	  FechaModificacion = '$currentDate'
	  WHERE JuntaId = '$juntaId'
    ''');

    return res;
  }

  // Consulta para rellenar el dropdown partida interna
  Future<List<InternalDepartureModel>> fetchInternalDeparture(
      String site, String contractId, String workId) async {
    var dbClient = await context.database;
    var res = await dbClient.rawQuery('''  
    WITH PartidaI AS ( SELECT DISTINCT
	PropuestaTecnicaSubActividadesH.ActividadId AS actividadId,
	PropuestaTecnicaSubActividadesH.PropuestaTecnicaId AS propuestaTecnicaId,
	PropuestaTecnicaSubActividadesH.SubActividadId AS subActividadId
	FROM PropuestaTecnicaSubActividadesH
	INNER JOIN FoliosPropuestaTecnica ON FoliosPropuestaTecnica.SiteId = PropuestaTecnicaSubActividadesH.SiteId 
	AND FoliosPropuestaTecnica.PropuestaTecnicaId = PropuestaTecnicaSubActividadesH.PropuestaTecnicaId AND FoliosPropuestaTecnica.RegBorrado = 0 AND IFNULL(FoliosPropuestaTecnica.EmpleadoId,0) <> 0
	WHERE PropuestaTecnicaSubActividadesH.RegBorrado= 0 AND FoliosPropuestaTecnica.ContratoId = '$contractId' AND FoliosPropuestaTecnica.ObraId='$workId' AND FoliosPropuestaTecnica.SiteId = '$site' LIMIT 100
  )


 SELECT CASE WHEN IFNULL(PropuestaTecnica.TipoPlataformaId,1) = 1 THEN
	  	IFNULL(Sistemas.Codigo,'0')  || '.' || IFNULL(Subsistemas.Codigo,'0') || '.' || IFNULL(PropuestaTecnicaActividades.Numero,'0') || '.' || IFNULL(PropuestaTecnicaSubActividades.Numero,'0')
	    ELSE 
	    IFNULL(Zonas.Codigo,'0') || '.' || IFNULL(Areas.Codigo,'0') || '.' || IFNULL(SubAreas.Codigo,'0') || '.' || IFNULL(PropuestaTecnicaActividades.Numero,'0') || '.' ||  IFNULL(PropuestaTecnicaSubActividades.Numero,'0')
	    END PartidaInterna
	    FROM PropuestaTecnica,PartidaI
	    INNER JOIN PropuestaTecnicaActividades ON PropuestaTecnicaActividades.SiteId = PropuestaTecnica.SiteId
	    AND PropuestaTecnicaActividades.PropuestaTecnicaId = PropuestaTecnica.PropuestaTecnicaId AND PropuestaTecnicaActividades.RegBorrado = 0
	    INNER JOIN PropuestaTecnicaSubActividades ON PropuestaTecnicaActividades.SiteId = PropuestaTecnicaSubActividades.SiteId AND PropuestaTecnicaActividades.PropuestaTecnicaId = PropuestaTecnicaSubActividades.PropuestaTecnicaId AND  PropuestaTecnicaActividades.ActividadId = PropuestaTecnicaSubActividades.ActividadId AND PropuestaTecnicaSubActividades.RegBorrado = 0
	    LEFT JOIN Sistemas ON Sistemas.SistemaId= PropuestaTecnicaActividades.SistemaId AND Sistemas.RegBorrado = 0
	    LEFT JOIN Zonas ON Zonas.ZonaId = PropuestaTecnicaActividades.ZonaId AND Zonas.RegBorrado = 0
	    LEFT JOIN Subsistemas ON Subsistemas.SubSistemaId = PropuestaTecnicaActividades.SubSistemaId and Subsistemas.RegBorrado = 0
	    LEFT JOIN Areas ON Areas.AreaId = PropuestaTecnicaActividades.ZonaId AND Areas.RegBorrado = 0
	    LEFT JOIN SubAreas ON SubAreas.SubAreaId = PropuestaTecnicaActividades.SubAreaId AND Areas.RegBorrado = 0     
	    WHERE PropuestaTecnicaSubActividades.SiteId =  '$site' AND PropuestaTecnicaSubActividades.PropuestaTecnicaId =  PartidaI.propuestaTecnicaId
        AND PropuestaTecnicaSubActividades.ActividadId = PartidaI.actividadId AND PropuestaTecnicaSubActividades.SubActividadId = 
        PartidaI.subActividadId AND PropuestaTecnica.RegBorrado = 0 
    ''');

    List<InternalDepartureModel> lis = res.isNotEmpty
        ? res.map((c) => InternalDepartureModel.fromJson(c)).toList()
        : [];
    return lis;
  }

  // Consulta para rellenar el dropdown folio
  Future<List<FolioDropdownModel>> fetchFolioByParams(
      String contractId, String workId, String site) async {
    var dbClient = await context.database;
    var res = await dbClient.rawQuery(''' 
    SELECT FTP.FolioId, FTP.Folio
    FROM PropuestaTecnica AS PT INNER JOIN FoliosPropuestaTecnica AS FTP ON FTP.SiteId = PT.SiteId
    AND FTP.PropuestaTecnicaId = PT.PropuestaTecnicaId AND FTP.RegBorrado = 0
    WHERE PT.RegBorrado = 0 AND PT.ContratoId = '$contractId' AND PT.ObraId= '$workId'  AND FTP.EmpleadoId IS NOT NULL AND PT.SiteId = '$site'
    ''');

    List<FolioDropdownModel> lis = res.isNotEmpty
        ? res.map((c) => FolioDropdownModel.fromJson(c)).toList()
        : [];
    return lis;
  }

  // Consulta para rellenar el dropdown reprogramación

  Future<List<ReprogramacionModel>> fetchReprogramacion(String workId) async {
    var dbClient = await context.database;
    var res = await dbClient.rawQuery('''
    SELECT 
	  ReprogramacionOTId,
	  Nombre
    FROM ReprogramacionOT
	  WHERE ReprogramacionOT.ObraId = '$workId' AND
	  ReprogramacionOT.RegBorrado = 0 AND ReprogramacionOTId
	  GROUP By ReprogramacionOT.Nombre
    ''');

    List<Map<String, dynamic>> data = [
      {'Nombre': 'CARGA ORIGINAL'}
    ];

    var e = data.map((e) => ReprogramacionModel.fromJson(e)).toList();

    List<ReprogramacionModel> list = res.isNotEmpty
        ? res.map((c) => ReprogramacionModel.fromJson(c)).toList()
        : [];

    return e + list;
  }

  //  Consulta para rellenar el dropdown Especialidad
  Future<List<EspecialidadModel>> fetchEspecialidad(
      String contratoId, int folioId) async {
    var dbClient = await context.database;
    var res = await dbClient.rawQuery('''   
  SELECT DISTINCT PTH.EspecialidadId,ES.DescripcionLarga FROM PropuestaTecnica AS PT INNER JOIN	PropuestaTecnicaActividadesH AS PTH ON 
  PTH.PropuestaTecnicaId = PT.PropuestaTecnicaId  AND PTH.RegBorrado = 0 INNER JOIN	Especialidad AS ES ON ES.EspecialidadId = PTH.EspecialidadId AND ES.RegBorrado = 0 INNER JOIN	FoliosPropuestaTecnica AS FTP 
  ON FTP.PropuestaTecnicaId = PT.PropuestaTecnicaId  AND FTP.RegBorrado = 0
	WHERE	PT.ContratoId = '$contratoId' AND	FTP.FolioId = $folioId AND
	PT.RegBorrado = 0 AND ES.Autorizado = 1
    ''');

    List<EspecialidadModel> list = res.isNotEmpty
        ? res.map((c) => EspecialidadModel.fromJson(c)).toList()
        : [];
    return list;
  }

  // Consulta para rellenar el dropdown sistema

  Future<List<SistemaModel>> fetchSistema(
      String contratoId, int folioId) async {
    var dbClient = await context.database;
    var res = await dbClient.rawQuery('''
  SELECT DISTINCT PTH.SistemaId,S.DescripcionCorta
	FROM PropuestaTecnica AS PT INNER JOIN	PropuestaTecnicaActividadesH AS PTH
  ON PTH.PropuestaTecnicaId = PT.PropuestaTecnicaId  AND PTH.RegBorrado = 0
	INNER JOIN	Sistemas AS S ON S.SistemaId = PTH.SistemaId AND S.RegBorrado = 0
	INNER JOIN	FoliosPropuestaTecnica AS FP ON FP.PropuestaTecnicaId = PT.PropuestaTecnicaId AND FP.RegBorrado = 0
	WHERE		PT.ContratoId = '$contratoId' AND	FP.FolioId = '$folioId' AND PT.RegBorrado = 0 
  ''');

    List<SistemaModel> list =
        res.isNotEmpty ? res.map((c) => SistemaModel.fromJson(c)).toList() : [];
    return list;
  }

  // PlanoSubActividad
  Future<List<PlanoSubActividadModel>> fetchPlanoSubActividad(
      String contractId, int folioId) async {
    var dbClient = await context.database;
    var res = await dbClient.rawQuery('''
  SELECT DISTINCT PTH.PlanoId, P.Nombre FROM PropuestaTecnica AS PT
	INNER JOIN	PropuestaTecnicaActividadesH AS PTH ON PTH.PropuestaTecnicaId = PT.PropuestaTecnicaId
	INNER JOIN	Planos AS P ON P.PlanoId = PTH.PlanoId 
	INNER JOIN	FoliosPropuestaTecnica  AS FTP ON FTP.PropuestaTecnicaId = PT.PropuestaTecnicaId  AND FTP.RegBorrado = 0
	WHERE PT.ContratoId = '$contractId' AND FTP.FolioId = '$folioId'
  ''');

    List<PlanoSubActividadModel> list = res.isNotEmpty
        ? res.map((c) => PlanoSubActividadModel.fromJson(c)).toList()
        : [];
    return list;
  }

  // Anexo
  Future<List<AnexoModel>> fetchAnexo() async {
    var dbClient = await context.database;
    var res = await dbClient.rawQuery('''
  SELECT DISTINCT C.Anexo FROM Conceptos AS C WHERE C.Anexo != '' AND C.RegBorrado = 0
  ''');

    List<AnexoModel> list =
        res.isNotEmpty ? res.map((c) => AnexoModel.fromJson(c)).toList() : [];
    return list;
  }

  // Partida PU
  Future<List<PartidaPUModel>> fetchPartidaPU(String contratoId) async {
    var dbClient = await context.database;
    var res = await dbClient.rawQuery('''
    SELECT DISTINCT C.Partida FROM Conceptos AS C WHERE C.RegBorrado= 0  AND C.ContratoId = '$contratoId' AND IFNULL(C.Partida,'') <> '' LIMIT 200
   ''');

    List<PartidaPUModel> list = res.isNotEmpty
        ? res.map((c) => PartidaPUModel.fromJson(c)).toList()
        : [];
    return list;
  }

  // PrimaveraId
  Future<List<PrimaveraIdModel>> fetchPrimaveraId(
      String contratoId, String obraId) async {
    var dbClient = await context.database;
    var res = await dbClient.rawQuery('''
    SELECT DISTINCT PrimaveraId
	  FROM PropuestaTecnicaActividadesH AS PTH
	  INNER JOIN FoliosPropuestaTecnica AS FPT ON FPT.SiteId = PTH.SiteId 
    AND FPT.PropuestaTecnicaId = PTH.PropuestaTecnicaId  AND FPT.RegBorrado = 0 AND IFNULL(FPT.EmpleadoId,0) != 0
	  WHERE PTH.RegBorrado=0 AND FPT.ContratoId = '$contratoId'  AND FPT.ObraId = '$obraId' LIMIT 200
  ''');

    List<PrimaveraIdModel> list = res.isNotEmpty
        ? res.map((c) => PrimaveraIdModel.fromJson(c)).toList()
        : [];
    return list;
  }

  // ActividadCliente

  Future<List<ActividadClienteModel>> fetchActividadCliente(
      String contractId, String workId) async {
    var dbClient = await context.database;
    var res = await dbClient.rawQuery('''
   SELECT DISTINCT NoActividadCliente FROM 
   PropuestaTecnicaActividadesH AS PTH INNER JOIN FoliosPropuestaTecnica AS FPT
   ON FPT.SiteId = PTH.SiteId  AND FPT.PropuestaTecnicaId = FPT.PropuestaTecnicaId AND
   FPT.RegBorrado = 0 AND IFNULL(FPT.EmpleadoId,0) <> 0  AND  IFNULL(PTH.NoActividadCliente,'') <> '' WHERE  PTH.RegBorrado=0  AND FPT.ContratoId = '$contractId'  AND FPT.ObraId = '$workId' LIMIT 500
  ''');

    List<ActividadClienteModel> list = res.isNotEmpty
        ? res.map((c) => ActividadClienteModel.fromJson(c)).toList()
        : [];
    return list;
  }

  // Recuperación del status
  Future<List<EstatusIdModel>> fetchAllEstatus() async {
    final db = await context.database;
    final res = await db.query(
      'vw_EstatusPTSubActividad',
      columns: ['EstatusId', 'DescripcionCorta'],
    );

    List<EstatusIdModel> list = res.isNotEmpty
        ? res.map((e) => EstatusIdModel.fromJson(e)).toList()
        : [];

    return list;
  }

  // Consulta que me ayudara a recuperar todas los registros para rellenar la tabla. [HSEQMC].[st_SelActividades]

  Future<List<ActivitiesTableModel>> fetchActividades(
    String contratoId,
    String obraId,
    String folio,
    String especialidad,
    String fechaInicio,
    String reprogramacionOT,
    String fechaFin,
    int frenteId,
    String sistema,
    String plano,
    String anexo,
    String partidaPU,
    String primaveraId,
    String noActividadCliente,
    String estatusId,
    String partidaFilter,
  ) async {
    var dbClient = await context.database;

    final functionsDao = FunctionsDao();
    var res = await dbClient.rawQuery('''  
    SELECT	 PS.SiteId,PS.PropuestaTecnicaId, PS.ActividadId,PS.SubActividadId,IFNULL(CO.Anexo, 'Sin anexo') AS Anexo,IFNULL(CO.Partida,'Sin partida') AS Partida,PA.PrimaveraId, PA.NoActividadCliente AS NoActividadCliente, F.Folio,IFNULL(ROT.Nombre, 'CARGA ORIGINAL') ReprogramacionOT, P.Descripcion AS PlanoSubActividad,  PA.Descripcion PropuestaTecnicaActividadesH, E.DescripcionLarga AS Especialidad,S.Descripcion AS Sistema, FE.Descripcion AS Frente, PS.FechaInicio, PS.FechaFin, EPTSA.DescripcionCorta
	  FROM			PropuestaTecnicaSubActividadesH PS INNER JOIN		FoliosPropuestaTecnica F ON F.SiteId = PS.SiteId AND F.PropuestaTecnicaId = PS.PropuestaTecnicaId AND F.RegBorrado = 0 AND IFNULL(F.EmpleadoId,0) <> 0
	INNER JOIN		PropuestaTecnicaActividadesH PA ON PA.SiteId = PS.SiteId AND PA.PropuestaTecnicaId = PS.PropuestaTecnicaId AND PA.ActividadId = PS.ActividadId 
	AND IFNULL(PA.ReprogramacionOTId,0) = IFNULL(PS.ReprogramacionOTId,0)	AND PA.RegBorrado = 0 
	INNER JOIN		Frente FE ON FE.FrenteId = PA.FrenteId AND FE.Regborrado = 0
	INNER JOIN		Especialidad E ON E.EspecialidadId = PS.EspecialidadId AND E.RegBorrado = 0
	INNER JOIN		vw_EstatusPTSubActividad EPTSA ON EPTSA.EstatusId = PS.Estatus AND EPTSA.RegBorrado = 0
	LEFT JOIN		Conceptos CO ON CO.ConceptoId = PS.ConceptoId
	LEFT JOIN		ReprogramacionOT ROT ON IFNULL(PS.ReprogramacionOTId,0) = IFNULL(ROT.ReprogramacionOTId,0)
	LEFT JOIN		Planos P ON P.PlanoId = PA.PlanoId AND P.RegBorrado = 0
	LEFT JOIN		Sistemas AS S ON S.SistemaId = PA.SistemaId AND S.RegBorrado = 0
	WHERE			F.ObraId = '$obraId' AND
					F.ContratoId = '$contratoId' AND
					(F.Folio = '$folio' OR COALESCE('$folio','')='') AND
                    IFNULL(ROT.Nombre, 'CARGA ORIGINAL') = '$reprogramacionOT'
					AND  (E.DescripcionLarga = '$especialidad' OR COALESCE('$especialidad','')='') AND
                    (S.Descripcion = '$sistema' OR COALESCE('$sistema','')='') AND
					(FE.FrenteId = $frenteId OR COALESCE($frenteId,0)=0) AND	
					(P.Descripcion = '$plano' OR COALESCE('$plano','')='') AND
					(CO.Anexo = '$anexo' OR COALESCE('$anexo','')='') AND
					(CO.Partida = '$partidaPU' OR COALESCE('$partidaPU','')='') AND		
					(PA.PrimaveraId = '$primaveraId' OR COALESCE('$primaveraId','')='') AND
					(PA.NoActividadCliente = '$noActividadCliente' OR COALESCE('$noActividadCliente','')='') AND
					(EPTSA.EstatusId = '$estatusId' OR COALESCE('$estatusId','')='') AND	
					(PS.FechaInicio >= '$fechaInicio' OR COALESCE('$fechaInicio','')='') AND
					(PS.FechaFin <= '$fechaFin' OR COALESCE('$fechaFin','')='') AND
					 PS.RegBorrado = 0
  ''');

    List<ActivitiesTableModel> list = res.isNotEmpty
        ? res.map((c) => ActivitiesTableModel.fromJson(c)).toList()
        : [];

    if (list.isNotEmpty) {
      for (ActivitiesTableModel item in list) {
        String partidaInterna = await functionsDao.fnPartidaInterna(item.siteId,
            item.propuestaTecnicaId, item.actividadId, item.subActividadId);

        String partida = partidaInterna.isNotEmpty ? partidaInterna : '0.0.0.0';

        item.partida = partida;
      }
    }

    if (partidaFilter != '') {
      List<ActivitiesTableModel> listFilter =
          list.where((activity) => activity.partida == partidaFilter).toList();

      list = listFilter;
    }

    return list;
  }
}
