import 'package:intl/intl.dart';
import 'package:mc_app/src/data/dao/consecutive_dao.dart';
import 'package:mc_app/src/data/dao/functions_dao.dart';
import 'package:mc_app/src/data/dao/site_dao.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/models/params/add_welder_parms.dart';
import 'package:mc_app/src/models/params/get_information_welder_Param.dart';

class InspectionPlanDao {
  // Db context
  DBContext context = DBContext();
  final functionsDao = FunctionsDao();
  final siteDao = SiteDao();

  // Consulta que nos retorna todos los contratos.
  Future<List<ContractsInspectionPlanModel>>
      fetchAllContractsInsepcctionPlan() async {
    final db = await context.database;
    final res = await db.query(
      'Contratos',
      columns: ['ContratoId', 'Nombre'],
      where: 'RegBorrado = ?',
      whereArgs: [0],
    );

    List<ContractsInspectionPlanModel> list = res.isNotEmpty
        ? res.map((e) => ContractsInspectionPlanModel.fromJson(e)).toList()
        : [];

    return list;
  }

  // Consulta que nos retorna todos los contratos por ID
  Future<List<WorksInspectionPlanModel>> fetchWorksByIdInsepcctionPlan(
      String contractId) async {
    final db = await context.database;
    final res = await db.query(
      'Obras',
      columns: ['ObraId', 'OT', 'Nombre'],
      where: 'ContratoId = ? AND RegBorrado = ?',
      whereArgs: [contractId, 0],
    );

    List<WorksInspectionPlanModel> list = res.isNotEmpty
        ? res.map((e) => WorksInspectionPlanModel.fromJson(e)).toList()
        : [];

    return list;
  }

  // Consulta que nos retorna las actividades de inspección --  SelPaginadorPlanInspeccionC
  Future<List<InspectionPlanCModel>> fetchPlansInspecctionC(
      String contractId, String workId, bool clear) async {
    // ignore: unused_local_variable
    List<InspectionPlanCModel> listEmpty;

    final db = await context.database;

    if (clear) {
      return listEmpty = [];
    }

    final res = await db.rawQuery('''
    SELECT			
   	CASE WHEN EXISTS (
	  SELECT 1
	  FROM PlanInspeccionD
	  WHERE NoPlanInspeccion = PIC.NoPlanInspeccion AND
	  TipoInspeccion = 0 AND RegBorrado = 0
	  UNION
    SELECT 1
	  FROM ActividadAdicional
	WHERE NoPlanInspeccion = PIC.NoPlanInspeccion AND
	TipoInspeccion = 0 AND RegBorrado = 0
	) THEN 0 ELSE 1 END Semaforo,
	PIC.NoPlanInspeccion AS NoPlanInspeccion,
	C.Nombre AS Contrato,
	O.OT AS Obra,
	P.Descripcion AS Instalacion,
	PIC.Descripcion AS Descripcion,
	PIC.FechaCreacion AS FechaCreacion,
	(SELECT COUNT(NoPlanInspeccion) FROM PlanInspeccionD WHERE NoPlanInspeccion = PIC.NoPlanInspeccion AND RegBorrado = 0) + (SELECT COUNT(1) FROM ActividadAdicional WHERE NoPlanInspeccion = PIC.NoPlanInspeccion AND RegBorrado = 0) AS Actividades
  FROM	PlanInspeccionC PIC
	INNER JOIN		Contratos C ON C.ContratoId = PIC.ContratoId 
	INNER JOIN		Obras O ON O.ObraId = PIC.ObraId 
	INNER JOIN		Plataformas P ON P.PlataformaId = PIC.PlataformaId
    WHERE PIC.ContratoId = '$contractId' AND
		  PIC.ObraId = '$workId' 
	ORDER BY PIC.NoPlanInspeccion ASC	
    ''');

    List<InspectionPlanCModel> list = res.isNotEmpty
        ? res.map((e) => InspectionPlanCModel.fromJson(e)).toList()
        : [];

    // Actividades D/N
    if (list.isNotEmpty) {
      for (InspectionPlanCModel item in list) {
        int activitiesDN =
            await functionsDao.fnSelCantidadDNFN(item.noPlanInspeccion, 1);
        item.dn = activitiesDN;

        int activitiesFN =
            await functionsDao.fnSelCantidadDNFN(item.noPlanInspeccion, 2);
        item.fn = activitiesFN;
      }
    }

    return list;
  }

  // st_SelPlanInspeccionC
  Future<InspectionPlanHeaderModel> fetchInspectionPlanHeader(
      String noPlanInspection) async {
    // Params

    String semaforo;
    String riaId;

    final db = await context.database;

    List<Map<String, dynamic>> riaList = await db.rawQuery('''
    SELECT IFNULL(RIAId,'') AS RIAId FROM RIA WHERE
    NoPlanInspeccion = '$noPlanInspection'
    AND Tipo = 1 AND RegBorrado = 0 LIMIT 1
    ''');

    if (riaList.isEmpty) {
      riaId = '';
    } else {
      riaId = riaList[0]['RIAId'];
    }

    // riaId = noPlanInspection + riaList[0]['RIAId'];

    List<Map<String, dynamic>> semaforoList = await db.rawQuery('''
    SELECT 1 FROM RIA
    WHERE NoPlanInspeccion = '$noPlanInspection'
    AND Tipo = 1 AND RegBorrado = 0
    ''');

    if (semaforoList.isEmpty) {
      semaforo = 'blue';
    } else {
      semaforo = 'green';
    }

    int actividadesDN =
        await functionsDao.fnSelCantidadDNFN(noPlanInspection, 1);

    /*INICIO. Sección para la impresión del RIA*/

    if (riaId != '') {
      List<Map<String, dynamic>> listaActividadDNReportadas =
          await db.rawQuery('''
          SELECT ActividadesPT FROM RIA WHERE RIAId = '$riaId' AND NoPlanInspeccion = '$noPlanInspection'
          ''');

      int actividadesDNReportadas =
          listaActividadDNReportadas[0]["ActividadesPT"];
      int actividadesDNEliminadasR =
          await functionsDao.fnSelCantidadDNFN(noPlanInspection, 3); // 2

      /*No hay actividades inspeccionadas DN que no se encuentran en el RIA*/
      if (actividadesDN != actividadesDNReportadas ||
          actividadesDNEliminadasR != 0) {
        semaforo = "red";
      }
    } else {
      if (actividadesDN == 0) {
        semaforo = "grey";
      }
    }

    /*FIN. Sección para la impresión del RIA*/

    final res = await db.rawQuery('''
    SELECT
    PIC.NoPlanInspeccion,
		PIC.PlataformaId AS InstalacionId,
		PIC.Elabora,
		PIC.Revisa,
		PIC.Aprueba,
		PIC.Descripcion,
		EM.Descripcion AS Embarcacion,
		P.Descripcion AS Instalacion,
		EE.Nombre AS EmpleadoElabora,
		ER.Nombre AS EmpleadoRevisa,
		EA.Nombre AS EmpleadoAprueba,
		PIC.FechaCreacion,
		'$semaforo' AS Semaforo,
		'$riaId' AS RIAIdClave,
    CASE WHEN '$riaId' <> '' THEN '$noPlanInspection' || '/' || '$riaId' ELSE '' END RIAId,
		$actividadesDN AS ActividadesDN
		FROM PlanInspeccionC PIC
		INNER JOIN	Plataformas P ON P.PlataformaId = PIC.PlataformaId AND P.RegBorrado = 0
		INNER JOIN	Obras O ON O.ObraId = PIC.ObraId
		INNER JOIN	Contratos C ON C.ContratoId = PIC.ContratoId
		INNER JOIN	Embarcaciones EM ON EM.EmbarcacionId = C.EmbarcacionId
		INNER JOIN	FirmanteRSI E ON E.FirmanteRSIId = PIC.Elabora
		INNER JOIN	Empleados EE ON EE.EmpleadoId = E.EmpleadoId
		INNER JOIN	FirmanteRSI R ON R.FirmanteRSIId = PIC.Revisa
		INNER JOIN	Empleados ER ON ER.EmpleadoId = R.EmpleadoId
		INNER JOIN	FirmanteRSI A ON A.FirmanteRSIId = PIC.Aprueba
		INNER JOIN	Empleados EA ON EA.EmpleadoId = A.EmpleadoId
		WHERE		PIC.NoPlanInspeccion = '$noPlanInspection'
    ''');

    if (res.length > 0) {
      return InspectionPlanHeaderModel.fromJson(
        res.first,
      );
    }
    return null;
  }

  // Consulta que nos retorna las actividades en base a un plan de inspección --  [st_SelPlanInspeccionD]
  Future<List<InspectionPlanDModel>> fetchPlansInspecctionD(
      String noInspectionPlan) async {
    /*Sección para el avance de la actividad cuando se consulta en el RIA*/

    final db = await context.database;

    List<Map<String, dynamic>> contractsList = await db.rawQuery('''
    SELECT ContratoId
		FROM	PlanInspeccionC
		WHERE		NoPlanInspeccion = '$noInspectionPlan' AND
		RegBorrado = 0
    ''');

    String contratoId = contractsList[0]['ContratoId'];

    List<Map<String, dynamic>> usaVolumenList = await db.rawQuery('''
    	SELECT Valor1 FROM vw_ContratoVolumen
		  WHERE	NoContrato = '$contratoId' AND RegBorrado = 0
    ''');

    int usaVolumen = usaVolumenList[0]['Valor1'];

    // Se finaliza

    final res = await db.rawQuery('''    	
	SELECT		    
	PID.SiteId,
	PID.PropuestaTecnicaId,
	PID.ActividadId,
	PID.SubActividadId,
	PID.ReprogramacionOTId,
	IFNULL(CxOT.Anexo, 'Sin Anexo') AS Anexo,
	IFNULL(CxOT.Partida,'Sin Partida') AS PartidaPU,
	PTACT.PrimaveraId,
	PTACT.NoActividadCliente ActividadCliente,
	FPT.FolioId,
	FPT.Folio,
	IFNULL(ROT.Nombre,'Carga Original') ReprogramacionOT,
	PL.PlanoId,
	PL.Descripcion Plano,
	PT.Descripcion DescripcionActividad,
	EP.EspecialidadId,
	EP.DescripcionLarga Especialidad,
	S.SistemaId,
	S.Descripcion Sistema,
	PT.FechaInicio,
	PT.FechaFin,
	E.DescripcionCorta Estatus,
	PID.TipoInspeccion,
	PID.Frecuencia,
	PID.Observacion,
	F.FrenteId,
	F.Descripcion Frente,
	--IIF('PlanInspeccion' = 'PlanInspeccion', 0, HSEQMC.fn_SelAvanceActividades(PID.SiteId, PID.PropuestaTecnicaId, PID.ActividadId, PID.SubActividadId, PID.ReprogramacionOTId, @UsaVolumen)) Avance,
	CASE WHEN PID.TipoInspeccion <> 0 THEN 1 ELSE 0 END Detalle,
	0 AS Adicional,
	CASE WHEN PID.RIAId IS NULL THEN '' ELSE PID.NoPlanInspeccion || PID.RIAId END RIAId,
  PID.RIAId AS ClaveRIAId,
	IFNULL((SELECT	PIAD.IdentificadorDetalle 
	FROM	PIActividadD PIAD 
	WHERE	PIAD.NoPlanInspeccion = '$noInspectionPlan' AND
	PIAD.SiteId = PID.SiteId AND
	PIAD.PropuestaTecnicaId = PID.PropuestaTecnicaId AND
	PIAD.ActividadId = PID.ActividadId AND
	PIAD.SubActividadId = PID.SubActividadId AND
	IFNULL(PIAD.ReprogramacionOTId, 0) = IFNULL(PID.ReprogramacionOTId, 0) AND
	PIAD.Tipo = 5 AND --El 5 indica que son procedimientos.
	PIAD.RegBorrado = 0 ORDER BY PIAD.NoPlanInspeccion LIMIT 1),"") AS Procedimiento
		FROM		PlanInspeccionD PID
		INNER JOIN	PropuestaTecnicaSubActividadesH PT ON PT.SiteId = PID.SiteId AND PT.PropuestaTecnicaId = PID.PropuestaTecnicaId AND PT.ActividadId = PID.ActividadId AND PT.SubActividadId = PID.SubActividadId AND IFNULL(PT.ReprogramacionOTId, 0) = IFNULL(PID.ReprogramacionOTId, 0) AND PT.RegBorrado = 0
		INNER JOIN	FoliosPropuestaTecnica FPT ON FPT.SiteId = PT.SiteId AND FPT.PropuestaTecnicaId = PT.PropuestaTecnicaId AND FPT.RegBorrado = 0 AND IFNULL(FPT.EmpleadoId,0) <> 0
		INNER JOIN	PropuestaTecnicaActividadesH PTACT ON PTACT.SiteId = PT.SiteId AND PTACT.PropuestaTecnicaId = PT.PropuestaTecnicaId AND PTACT.ActividadId = PT.ActividadId AND IFNULL(PTACT.ReprogramacionOTId,0) = IFNULL(PT.ReprogramacionOTId,0) AND PTACT.RegBorrado = 0 
		INNER JOIN	Especialidad EP ON EP.EspecialidadId = PT.EspecialidadId AND EP.RegBorrado = 0
		INNER JOIN	vw_EstatusPTSubActividad E ON E.EstatusId = PT.Estatus AND E.RegBorrado = 0 
		INNER JOIN	Frente F ON F.FrenteId = PTACT.FrenteId
		LEFT JOIN	Conceptos CxOT ON CxOT.ConceptoId = PT.ConceptoId
		LEFT JOIN	ReprogramacionOT ROT ON IFNULL(PT.ReprogramacionOTId,0) = IFNULL(ROT.ReprogramacionOTId,0)
		LEFT JOIN	Planos PL ON PL.PlanoId = PTACT.PlanoId AND PL.RegBorrado = 0
		LEFT JOIN	Sistemas S ON S.SistemaId = PTACT.SistemaId AND S.RegBorrado = 0
		WHERE		PID.NoPlanInspeccion = '$noInspectionPlan' AND
					PID.RegBorrado = 0				
	  ''');

    List<InspectionPlanDModel> list = res.isNotEmpty
        ? res.map((e) => InspectionPlanDModel.fromJson(e)).toList()
        : [];

    if (list.isNotEmpty) {
      for (InspectionPlanDModel item in list) {
        String partidaInterna = await functionsDao.fnPartidaInterna(item.siteId,
            item.propuestaTecnicaId, item.actividadId, item.subActividadId);

        String semaforo = await functionsDao.fnSelSemaforoActividades(
            noInspectionPlan,
            item.siteId,
            item.propuestaTecnicaId,
            item.actividadId,
            item.subActividadId,
            item.reprogramacionOTId);

        dynamic avance = await functionsDao.fnAvanceActividades(
          item.siteId,
          item.propuestaTecnicaId,
          item.actividadId,
          item.subActividadId,
          item.reprogramacionOTId,
          usaVolumen,
        );

        item.avance = avance;
        item.semaforo = semaforo;
        item.partidaInterna = partidaInterna;
      }
    }

    return list;
  }

  Future<List<ReporteInspeccionMaterialModel>> fechtListMaterialsbyActivity(
    String noPlanInspeccion,
    String siteId,
    dynamic propuestaTecnicaId,
    dynamic actividadId,
    dynamic subActividadId,
    dynamic reprogramacionOTId,
  ) async {
    var db = await context.database;

    var res = await db.rawQuery('''  
  SELECT	  
  RCD.MaterialId MaterialId,
  M.DescripcionCorta Descripcion,
  RCD.IdTrazabilidad IdTrazabilidad,
  UM.DescripcionCorta UM,
  SUM(IFNULL(RCD.Instalado, 0)) Cantidad,
  RIA.Resultado AS Resultado,
  CASE WHEN RIA.IncluirReporte IS NULL THEN 
	CASE WHEN EXISTS(SELECT 1 FROM Conformado WHERE Trazabilidad1Id = RCD.IdTrazabilidad OR Trazabilidad2Id = RCD.IdTrazabilidad) THEN 0 ELSE 1 END 
  ELSE RIA.IncluirReporte END IncluirReporte,
  IFNULL(RIA.Observaciones,'') AS Observaciones,
  IFNULL(RIA.FechaInspeccion,'') AS FechaInspeccion,
  '$siteId' AS SiteId
    FROM		ReporteCampoC RC
    INNER JOIN	RCMaterial RCM ON RCM.SiteId = RC.SiteId AND RCM.FolioRC = RC.FolioRC AND RCM.RegBorrado = 0
    INNER JOIN	RCMaterialDet RCD ON RCD.FolioRC = RC.FolioRC AND RCD.RegBorrado = 0
    INNER JOIN	DBOMateriales M ON M.MaterialId = RCD.MaterialId AND M.RegBorrado = 0
    INNER JOIN	vw_UnidadMedida UM ON UM.UnidadMedidaId = M.UnidadMedidaId AND UM.RegBorrado = 0
    LEFT JOIN	ReporteInspeccionActividad RIA 
    ON			RIA.SiteId = RC.SiteId AND 
          RIA.PropuestaTecnicaId = RC.PropuestaTecnicaId AND 
          RIA.ActividadId = RC.ActividadId AND 
          RIA.SubActividadId = RC.SubActividadId AND 
          IFNULL(RIA.ReprogramacionOTId, 0) = IFNULL(RC.ReprogramacionOTId, 0) AND 
          RIA.NoPlanInspeccion = '$noPlanInspeccion' AND
          RIA.MaterialId = RCD.MaterialId AND
          RIA.IdTrazabilidad = RCD.IdTrazabilidad
    WHERE		RC.SiteId = '$siteId' AND
          RC.PropuestaTecnicaId = '$propuestaTecnicaId' AND
          RC.ActividadId = '$actividadId' AND
          RC.SubActividadId = '$subActividadId' AND
          IFNULL(RC.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0)
    GROUP BY	RCD.MaterialId,
          M.DescripcionCorta,
          UM.DescripcionCorta,
          RCD.IdTrazabilidad,
          RIA.Resultado,
          RIA.IncluirReporte,
          RIA.Observaciones,
          RIA.FechaInspeccion
   UNION
   	SELECT		RCD.MaterialId MaterialId,
				M.DescripcionCorta Descripcion,
				RCD.IdTrazabilidad IdTrazabilidad,
				UM.DescripcionCorta UM,
				SUM(IFNULL(RCD.Instalado, 0)) Cantidad,
				RIA.Resultado AS Resultado,
				CASE WHEN RIA.IncluirReporte IS NULL THEN 
				CASE WHEN EXISTS(SELECT 1 FROM Conformado WHERE Trazabilidad1Id = RCD.IdTrazabilidad OR Trazabilidad2Id = RCD.IdTrazabilidad) THEN 0 ELSE 1 END
				ELSE RIA.IncluirReporte END IncluirReporte,
				IFNULL(RIA.Observaciones,'') AS Observaciones,
				IFNULL(RIA.FechaInspeccion,'') AS FechaInspeccion,
        '$siteId' AS SiteId
	FROM		ReporteCampoC RC
	INNER JOIN	RCMaterialRes RCM ON RCM.SiteId = RC.SiteId AND RCM.FolioRC = RC.FolioRC AND RCM.RegBorrado = 0
	INNER JOIN	RCMaterialResDet RCD ON RCD.FolioRC = RC.FolioRC AND RCD.RegBorrado = 0
	INNER JOIN	DBOMateriales M ON M.MaterialId = RCD.MaterialId AND M.RegBorrado = 0
	INNER JOIN	vw_UnidadMedida UM ON UM.UnidadMedidaId = M.UnidadMedidaId AND UM.RegBorrado = 0
	LEFT JOIN	ReporteInspeccionActividad RIA 
	ON			RIA.SiteId = RC.SiteId AND 
				RIA.PropuestaTecnicaId = RC.PropuestaTecnicaId AND 
				RIA.ActividadId = RC.ActividadId AND 
				RIA.SubActividadId = RC.SubActividadId AND 
				IFNULL(RIA.ReprogramacionOTId, 0) = IFNULL(RC.ReprogramacionOTId, 0) AND 
				RIA.NoPlanInspeccion = '$noPlanInspeccion' AND
				RIA.MaterialId = RCD.MaterialId AND
				RIA.IdTrazabilidad = RCD.IdTrazabilidad
	WHERE		RC.SiteId = '$siteId' AND
				RC.PropuestaTecnicaId = '$propuestaTecnicaId' AND
				RC.ActividadId = '$actividadId' AND
				RC.SubActividadId = '$subActividadId' AND
				IFNULL(RC.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0)
	GROUP BY	RCD.MaterialId,
				M.DescripcionCorta,
				UM.DescripcionCorta,
				RCD.IdTrazabilidad,
				RIA.Resultado,
				RIA.IncluirReporte,
				RIA.Observaciones,
				RIA.FechaInspeccion
 ''');

    List<ReporteInspeccionMaterialModel> list = res.isNotEmpty
        ? res.map((e) => ReporteInspeccionMaterialModel.fromJson(e)).toList()
        : [];

    if (list.isNotEmpty) {
      for (ReporteInspeccionMaterialModel item in list) {
        item.incluirReporte == 0 ? item.selected = false : item.selected = true;
      }
    }

    return list;
  }

  // Respuesta de la operación con la información del soldador.
  Future<FetchWelderModel> fetchWelderPlan(dynamic noFicha) async {
    var db = await context.database;

    //st_SelSoldadorRIA
    //EE.Puesto
    var soldadoresSQL = await db.rawQuery(''' 
        SELECT	S.SoldadorId,
                CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 then E.Ficha else EE.Ficha end AS Ficha,
                CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 then E.Nombre || ' ' || E.Apellidos else EE.Nombre end AS Nombre,
                CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 then E.PuestoDescripcion else 'Pendiente' end AS Puesto,
                S.RegBorrado
          FROM	Soldador S
          LEFT JOIN	EmpleadoExterno EE ON EE.EmpleadoExternoId = S.EmpleadoId AND EE.RegBorrado = 0
          LEFT JOIN	PuestoExterno PE ON PE.PuestoExternoId = EE.PuestoExternoId AND PE.RegBorrado = 0
          LEFT JOIN	Empleados E ON E.EmpleadoId = IFNULL(S.EmpleadoId, 0) AND E.RegBorrado = 0
         WHERE S.RegBorrado = 0 AND (IFNULL(E.EmpleadoId, 0) <> 0 OR IFNULL(EE.EmpleadoExternoId, '') <> '') 
        AND CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 THEN CAST(E.Ficha AS TEXT(30)) ELSE EE.Ficha END =  '$noFicha'
    ''');

    // var soldadores = soldadoresSQL.where((s) => s[0] == noFicha).toList();
    //
    List<FetchWelderModel> soldadores = soldadoresSQL.isNotEmpty
        ? soldadoresSQL.map((c) => FetchWelderModel.fromJson(c)).toList()
        : [];

    if (soldadores.length == 0) {
      throw "La ficha ingresada no corresponde a la ficha de un soldador";
    } else {
      if (soldadores.first.regBorrado == -1) {
        throw "El soldador se encuentra inactivo";
      } else {
        var response = soldadores.first;

        return response;
      }
    }
  }

  // Respuesta de la operación con la información del soldador.
  Future<List<InformacionadicionalModel>> fetchInformacionadicional(
      GetInformationWelderParam params) async {
    var db = await context.database;

    //st_SelSoldadoresRIA
    var soldadoresSQL = await db.rawQuery('''
    	 SELECT IAS.SoldadorId,
          CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 then E.Ficha else EE.Ficha end AS Ficha,
          CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 then E.Nombre || ' ' || E.Apellidos else EE.Nombre end AS Nombre,
          CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 then E.PuestoDescripcion else EE.Nombre end AS Puesto
      FROM	InspeccionActividadSoldador IAS
      INNER JOIN	Soldador S ON S.SoldadorId = IAS.SoldadorId AND S.RegBorrado = 0
      LEFT JOIN	EmpleadoExterno EE ON EE.EmpleadoExternoId = S.EmpleadoId AND EE.RegBorrado = 0
      LEFT JOIN	PuestoExterno PE ON PE.PuestoExternoId = EE.PuestoExternoId AND PE.RegBorrado = 0
      LEFT JOIN	Empleados E ON E.EmpleadoId = IFNULL(S.EmpleadoId,0) AND E.RegBorrado = 0
      WHERE	(IFNULL(E.EmpleadoId, 0) <> 0 OR IFNULL(EE.EmpleadoExternoId, '') <> '')  AND
            IAS.NoPlanInspeccion = '${params.noPlanInspeccion}' AND
            IAS.SiteId = '${params.siteId}' AND
            IAS.PropuestaTecnicaId = '${params.propuestaTecnicaId}' AND
            IAS.ActividadId = '${params.actividadId}' AND
            IAS.SubActividadId = '${params.subActividadId}' AND
            IFNULL(IAS.ReprogramacionOTId, 0) = IFNULL(${params.reprogramacionOTId}, 0) AND
            IAS.RegBorrado = 0;
    ''');

    //st_SelTrazabilidadRIA
    var trazabilidadSQL = await db.rawQuery('''
    	 SELECT	ST.IdTrazabilidad,
              T.Material MaterialId,
              T.MaterialDescrBreve Descripcion,
              T.UM,
              ST.Volumen,
              IAS.SoldadorId
      FROM		SoldadorTrazabilidad ST
      INNER JOIN	Trazabilidad T ON T.IdTrazabilidad = ST.IdTrazabilidad AND IFNULL(T.SiteId, '') <> '' AND T.RegBorrado = 0
      INNER JOIN	InspeccionActividadSoldador IAS ON IAS.SoldadorActividadId = ST.SoldadorActividadId AND IAS.RegBorrado = 0
      WHERE		IAS.NoPlanInspeccion = '${params.noPlanInspeccion}' AND
            IAS.SiteId = '${params.siteId}' AND
            IAS.PropuestaTecnicaId = '${params.propuestaTecnicaId}'  AND
            IAS.ActividadId = '${params.actividadId}' AND
            IAS.SubActividadId = '${params.subActividadId}' AND
            IFNULL(IAS.ReprogramacionOTId, 0) = IFNULL(${params.reprogramacionOTId}, 0) AND
            ST.RegBorrado = 0
      ORDER BY	ST.Numero ASC
    ''');

    List<InformacionadicionalModel> informacion = soldadoresSQL.isNotEmpty
        ? soldadoresSQL
            .map((c) => InformacionadicionalModel.fromJson(c, false))
            .toList()
        : [];

    List<TrazabilidadModel> trazabilidades = trazabilidadSQL.isNotEmpty
        ? trazabilidadSQL
            .map((c) => TrazabilidadModel.fromJson(c, false))
            .toList()
        : [];

    List<InformacionadicionalModel> result = [];

    informacion.forEach((s) {
      List<TrazabilidadModel> _trazabilidades =
          trazabilidades.where((x) => x.soldadorId == s.soldadorId).toList();

      TrazabilidadGroup grupo1 = TrazabilidadGroup();
      if (_trazabilidades.length >= 1) grupo1.trazabilida1 = _trazabilidades[0];
      if (_trazabilidades.length >= 2) grupo1.trazabilida2 = _trazabilidades[1];

      TrazabilidadGroup grupo2 = TrazabilidadGroup();
      if (_trazabilidades.length >= 3) grupo2.trazabilida1 = _trazabilidades[2];
      if (_trazabilidades.length >= 4) grupo2.trazabilida2 = _trazabilidades[3];

      result.add(InformacionadicionalModel(
          nombre: s.nombre,
          ficha: s.ficha,
          puesto: s.puesto,
          soldadorId: s.soldadorId,
          trazabilidadGrupo1: grupo1,
          trazabilidadGrupo2: grupo2));
    });
    return result.isNotEmpty ? result : [];
  }

  // [HSEQMC].[st_InsUpdReporteInspeccionActividad] -- 	SP para insertar el reporte de inspección de actividad

  Future<InsUpdateReporteIPModel> insUpdReporteInspeccionActividad(
    String noPlanInspection,
    String siteId,
    dynamic propuestaTecnicaId,
    dynamic actividadId,
    dynamic subActividadId,
    dynamic reprogramacionOTId,
    String materialId,
    String idTrazabilidad,
    int resultado,
    int incluirReporte,
    String comentarios,
  ) async {
    String updateReporteInspeccionActividad;
    String insertReporteInspeccionActividad;
    String siteIdG;
    String actionResult;

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    siteIdG = await siteDao.getSiteId();

    var dbClient = await context.database;

    var existeRIA = await dbClient.rawQuery(
        '''SELECT 1 FROM ReporteInspeccionActividad WHERE NoPlanInspeccion = '$noPlanInspection' AND SiteId = '$siteId' AND PropuestaTecnicaId = '$propuestaTecnicaId' AND ActividadId = '$actividadId' AND SubActividadId = '$subActividadId'  AND MaterialId = '$materialId' AND IdTrazabilidad = '$idTrazabilidad' AND RegBorrado = 0 ''');

    updateReporteInspeccionActividad = '''
    UPDATE	ReporteInspeccionActividad 
    SET Resultado = $resultado, IncluirReporte = $incluirReporte, Observaciones = '$comentarios',FechaInspeccion = '$currentDate',SiteModificacion = '$siteIdG',FechaModificacion = '$currentDate'
		WHERE		NoPlanInspeccion = '$noPlanInspection' AND 
				SiteId = '$siteId' AND 
				PropuestaTecnicaId = '$propuestaTecnicaId' AND
				ActividadId = '$actividadId' AND 
				SubActividadId = '$subActividadId' AND 
				MaterialId = '$materialId' AND 
				IdTrazabilidad = '$idTrazabilidad' AND RegBorrado = 0
    ''';

    insertReporteInspeccionActividad = '''
     INSERT INTO	ReporteInspeccionActividad(NoPlanInspeccion, SiteId, PropuestaTecnicaId, ActividadId, SubActividadId, ReprogramacionOTId, MaterialId, IdTrazabilidad, Resultado, IncluirReporte, Observaciones, FechaInspeccion, SiteModificacion, FechaModificacion)
     VALUES('$noPlanInspection', '$siteId', '$propuestaTecnicaId', '$actividadId', '$subActividadId', $reprogramacionOTId, '$materialId', '$idTrazabilidad', $resultado, $incluirReporte, '$comentarios', '$currentDate', '$siteIdG', '$currentDate')  
     ''';

    if (existeRIA.isNotEmpty) {
      await dbClient.rawUpdate(updateReporteInspeccionActividad);
      actionResult = 'Actualizado';
    } else {
      await dbClient.rawInsert(insertReporteInspeccionActividad);
      actionResult = 'Insertado';
    }

    InsUpdateReporteIPModel insUpdateReporteIPModel = InsUpdateReporteIPModel(
      actionResult: actionResult,
      actividadId: actividadId,
      comentarios: comentarios,
      idTrazabilidad: idTrazabilidad,
      propuestaTecnicaId: propuestaTecnicaId,
      subActividadId: subActividadId,
      resultado: resultado,
      incluirReporte: incluirReporte,
      noPlanInspection: noPlanInspection,
      materialId: materialId,
      reprogramacionOTId: reprogramacionOTId,
      siteId: siteId,
    );

    return insUpdateReporteIPModel;
  }

  // [HSEQMC].[st_InsUpdSoldadorTrazabilidad]   Inserta las trazabilidades agregadas al soldador.
  Future<int> insUpdSoldadorTrazabilidad(
      List<SoldadorTrazabilidadRIA> trazabilidades) async {
    final site = SiteDao();
    var db = await context.database;
    int result;
    var siteId = await site.getSiteId();

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    trazabilidades.forEach((element) async {
      // Eliminar las trazabilidades de la actividad que se removieron
      result = await db.update(
        'SoldadorTrazabilidad',
        {
          'RegBorrado': -1,
          'SiteModificacion': siteId,
          'FechaModificacion': currentDate,
        },
        where: 'SoldadorActividadId = ? AND RegBorrado = 0',
        whereArgs: [element.soldadorActividadId],
      );

      final exist = await db.query(
        'SoldadorTrazabilidad',
        columns: [
          'SoldadorActividadId',
          'SoldadorId',
          'IdTrazabilidad',
          'Numero',
          'Volumen'
        ],
        where:
            'SoldadorActividadId = ? AND IdTrazabilidad = ? AND SoldadorId = ? AND Numero = ? ',
        whereArgs: [
          element.soldadorActividadId,
          element.idTrazabilidad,
          element.soldadorId,
          element.numero
        ],
      );

      if (exist.isEmpty) {
        result = await db.insert(
          'SoldadorTrazabilidad',
          {
            'SoldadorActividadId': element.soldadorActividadId,
            'SoldadorId': element.soldadorId,
            'IdTrazabilidad': element.idTrazabilidad,
            'Numero': element.numero,
            'Volumen': element.volumen,
            'RegBorrado': 0,
            'SiteModificacion': siteId,
            'FechaModificacion': currentDate,
          },
        );
      } else {
        result = await db.update(
          'SoldadorTrazabilidad',
          {
            'Volumen': element.volumen,
            'RegBorrado': 0,
            'SiteModificacion': siteId,
            'FechaModificacion': currentDate,
          },
          where:
              'SoldadorActividadId = ? AND IdTrazabilidad = ? AND SoldadorId = ? AND Numero = ? ',
          whereArgs: [
            element.soldadorActividadId,
            element.idTrazabilidad,
            element.soldadorId,
            element.numero
          ],
        );
      }
    });

    return result;
  }

  //[HSEQMC].[st_InsUpdInspeccionActividadSoldador]   Insertar los soldadores vinculados a la actividad.
  Future<List<ResponseSaveWelder>> insUpdInspeccionActividadSoldador(
      AddWelderParams params) async {
    final site = SiteDao();
    final consecutive = ConsecutiveDao();

    var db = await context.database;
    var siteId = await site.getSiteId();
    List<Map<String, dynamic>> response;
    String soldadorActividadId;

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    // ignore: non_constant_identifier_names
    List<SoldadoresIP> listSoldadores_ = [];

    // Debido a que todos los registros fuerón removidos.
    if (params.soldadores.isEmpty) {
      // Elimina los detalles de actividad de inspeccion.
      await db.rawUpdate('''
       UPDATE SoldadorTrazabilidad
	     SET	RegBorrado = -1,
		   SiteModificacion = '$siteId',
		   FechaModificacion = '$currentDate'
	     WHERE SoldadorActividadId = (
	     SELECT ST.SoldadorActividadId FROM	SoldadorTrazabilidad ST INNER JOIN	InspeccionActividadSoldador IAS ON IAS.SoldadorActividadId = ST.SoldadorActividadId AND IAS.SoldadorId = ST.SoldadorId AND IAS.RegBorrado = 0
	     WHERE  IAS.NoPlanInspeccion =  '${params.noPlanInspeccion}' AND IAS.SiteId = '${params.siteId}' AND IAS.PropuestaTecnicaId = '${params.propuestaTecnicaId}' AND IAS.ActividadId = '${params.actividadId}' AND IAS.SubActividadId = '${params.subActividadId}' AND IFNULL(IAS.ReprogramacionOTId, 0) = IFNULL(${params.reprogramacionOTId}, 0)) 
       AND SoldadorId = (
	     SELECT ST.SoldadorId FROM	SoldadorTrazabilidad ST INNER JOIN	InspeccionActividadSoldador IAS ON IAS.SoldadorActividadId = ST.SoldadorActividadId AND IAS.SoldadorId = ST.SoldadorId  AND  IAS.RegBorrado = 0
	   	 WHERE IAS.NoPlanInspeccion =  '${params.noPlanInspeccion}' AND IAS.SiteId = '${params.siteId}' AND IAS.PropuestaTecnicaId = '${params.propuestaTecnicaId}' AND IAS.ActividadId = '${params.actividadId}' AND IAS.SubActividadId = '${params.subActividadId}' AND IFNULL(IAS.ReprogramacionOTId, 0) = IFNULL(${params.reprogramacionOTId}, 0)) 
       AND IdTrazabilidad = (
       SELECT ST.IdTrazabilidad FROM	SoldadorTrazabilidad ST INNER JOIN	InspeccionActividadSoldador IAS ON IAS.SoldadorActividadId = ST.SoldadorActividadId AND IAS.SoldadorId = ST.SoldadorId AND IAS.RegBorrado = 0
	     WHERE IAS.NoPlanInspeccion =  '${params.noPlanInspeccion}' AND IAS.SiteId = '${params.siteId}' AND IAS.PropuestaTecnicaId = '${params.propuestaTecnicaId}' AND IAS.ActividadId = '${params.actividadId}' AND IAS.SubActividadId = '${params.subActividadId}' AND IFNULL(IAS.ReprogramacionOTId, 0) = IFNULL(${params.reprogramacionOTId}, 0))  
        ''');

      // Elimina los soldadores que estaban añadidos a la sección
      await db.rawUpdate('''
      UPDATE InspeccionActividadSoldador
	     SET RegBorrado = -1,
       SiteModificacion = '${params.siteId}',
		   FechaModificacion = '$currentDate'
    	WHERE SoldadorActividadId IN (
		  SELECT  IAS.SoldadorActividadId
		  FROM	InspeccionActividadSoldador IAS
		  WHERE IAS.NoPlanInspeccion =  '${params.noPlanInspeccion}' 
		  AND IAS.SiteId = '${params.siteId}' AND IAS.PropuestaTecnicaId = '${params.propuestaTecnicaId}'
		  AND IAS.ActividadId = '${params.actividadId}' AND IAS.SubActividadId = '${params.subActividadId}' 
		  AND IFNULL(IAS.ReprogramacionOTId, 0) = IFNULL(${params.reprogramacionOTId}, 0) AND IAS.RegBorrado = 0)
        ''');
    } else {
      // Elimina todos
      await db.rawUpdate('''
      UPDATE InspeccionActividadSoldador
	     SET RegBorrado = -1,
       SiteModificacion = '$siteId',
		   FechaModificacion = '$currentDate'
    	WHERE SoldadorActividadId IN (
		  SELECT  IAS.SoldadorActividadId
		  FROM	InspeccionActividadSoldador IAS
		  WHERE IAS.NoPlanInspeccion =  '${params.noPlanInspeccion}' 
		  AND IAS.SiteId = '${params.siteId}' AND IAS.PropuestaTecnicaId = '${params.propuestaTecnicaId}'
		  AND IAS.ActividadId = '${params.actividadId}' AND IAS.SubActividadId = '${params.subActividadId}' 
		  AND IFNULL(IAS.ReprogramacionOTId, 0) = IFNULL(${params.reprogramacionOTId}, 0) AND IAS.RegBorrado = 0)''');

      var res = await db.rawQuery('''
      SELECT      
		  IAS.SoldadorId,
		  IAS.SoldadorActividadId
      FROM	InspeccionActividadSoldador AS IAS 
		  WHERE IAS.NoPlanInspeccion =  '${params.noPlanInspeccion}' 
		  AND IAS.SiteId = '${params.siteId}' AND IAS.PropuestaTecnicaId = '${params.propuestaTecnicaId}'
		  AND IAS.ActividadId = '${params.actividadId}' AND IAS.SubActividadId = '${params.subActividadId}' 
		  AND IFNULL(IAS.ReprogramacionOTId, 0) = IFNULL(${params.reprogramacionOTId}, 0)
      ORDER BY IAS.SoldadorId ASC
      ''');

      listSoldadores_ = res.isNotEmpty
          ? res.map((c) => SoldadoresIP.fromJson(c)).toList()
          : [];

      if (listSoldadores_.isNotEmpty) {
        int count = 1;
        listSoldadores_.forEach((element) {
          element.filaId = count;
          count++;
        });
      }

      params.soldadores.forEach((element) async {
        // Si entre listado de todos actividades del soldador relacionadas a la actividad coincide pues si existe
        var exist = listSoldadores_.indexWhere((x) => x.soldadorId == element);

        // Si existe
        if (exist == -1) {
          var newId = await consecutive.getConsecutiveId(
              'InspeccionActividadSoldador', siteId);

          var newRegistro = {
            "SoldadorActividadId": newId,
            "NoPlanInspeccion": params.noPlanInspeccion,
            "SiteId": params.siteId,
            "PropuestaTecnicaId": params.propuestaTecnicaId,
            "ActividadId": params.actividadId,
            "SubActividadId": params.subActividadId,
            "ReprogramacionOTId": params.reprogramacionOTId,
            "SoldadorId": element,
            "SiteModificacion": siteId,
            "FechaModificacion": currentDate,
          };
          await db.insert("InspeccionActividadSoldador", newRegistro);
        } else {
          var listTemp = listSoldadores_
              .where((p) => p.soldadorId == element)
              .toList()
              .first;

          if (listTemp.soldadorActividadId == null) {
            soldadorActividadId = '';
          } else {
            soldadorActividadId = listTemp.soldadorActividadId;
          }

          await db.rawUpdate('''
          UPDATE	InspeccionActividadSoldador 
				  SET RegBorrado = 0,
					SiteModificacion = '$siteId',
					FechaModificacion = '$currentDate'
				  WHERE	SoldadorActividadId = (
          SELECT  IAS.SoldadorActividadId
		       FROM	InspeccionActividadSoldador IAS
		       WHERE  SoldadorActividadId = '$soldadorActividadId' AND  IAS.NoPlanInspeccion =  '${params.noPlanInspeccion}' AND IAS.SoldadorId = '$element'
		       AND IAS.SiteId = '${params.siteId}' AND IAS.PropuestaTecnicaId = '${params.propuestaTecnicaId}'
		       AND IAS.ActividadId = '${params.actividadId}' AND IAS.SubActividadId = '${params.subActividadId}' 
		       AND IFNULL(IAS.ReprogramacionOTId, 0) = IFNULL(${params.reprogramacionOTId}, 0)
          )
          ''');
        }
      });
    }

    response = await db.rawQuery('''
    SELECT		SoldadorActividadId,SoldadorId,NoPlanInspeccion, RegBorrado
    FROM		InspeccionActividadSoldador
    WHERE		NoPlanInspeccion = '${params.noPlanInspeccion}' AND
    SiteId = '${params.siteId}' AND
    PropuestaTecnicaId = '${params.propuestaTecnicaId}' AND
    ActividadId = '${params.actividadId}' AND
    SubActividadId = '${params.subActividadId}' AND
    IFNULL(ReprogramacionOTId, 0) = IFNULL(${params.reprogramacionOTId}, 0) AND
    RegBorrado = 0
    ''');

    List<ResponseSaveWelder> list = response.isNotEmpty
        ? response.map((c) => ResponseSaveWelder.fromJson(c)).toList()
        : [];

    return list;
  }
}
