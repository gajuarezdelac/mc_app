import 'package:intl/intl.dart';
import 'package:mc_app/src/data/dao/consecutive_dao.dart';
import 'package:mc_app/src/data/dao/functions_dao.dart';
import 'package:mc_app/src/data/dao/site_dao.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';
import 'package:mc_app/src/models/documents_rpt_model.dart';
import 'package:mc_app/src/models/inspection_plan_model.dart';
import 'package:mc_app/src/models/materiales_corrosion_model.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';
import 'package:mc_app/src/models/planned_resource_model.dart';
import 'package:mc_app/src/models/rpt_anticorrosive_protection_model.dart';

class ReportDao {
  DBContext context = DBContext();

  final functionsDao = FunctionsDao();

  Future<RptMaterialsCorrosionHeader> envioMaterialesCorrosionCabecera(
      String noEnvio) async {
    final db = await context.database;
    String envioMateriales = '''
                SELECT		EMC.NoEnvio,
                          (C.ContratoNombre || ' - ' || C.Nombre) Contrato,
                          (O.OT || ' (' || O.Nombre || ')') Obra,
                          EMC.Destino,
                          EMC.DeptoSolicitante,
                          strftime('%d-%m-%Y', EMC.Fecha) Fecha,
                          EMC.Observaciones
                FROM		  EnvioMaterialesCorrosion EMC 
                          INNER JOIN Obras O ON O.ObraId = EMC.ObraId AND O.RegBorrado = 0
                          INNER JOIN Contratos C ON C.ContratoId = O.ContratoId AND C.RegBorrado = 0	
                WHERE		  EMC.NoEnvio = '$noEnvio' AND 
                          EMC.RegBorrado = 0
      ''';

    var tblEnvioMateriales = await db.rawQuery(envioMateriales);

    if (tblEnvioMateriales.length > 0) {
      return new RptMaterialsCorrosionHeader.fromJson(tblEnvioMateriales.first);
    }

    return null;
  }

  // HSEQMC.st_InsRIA
  Future<String> rptInsRIA(
    String noPlanInspeccion,
    int tipo,
    List<InspectionPlanDModel> list,
  ) async {
    final db = await context.database;

    // Fecha actual
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    //Consecutivo Folio
    String consecutivoFolio;
    String rIAId;
    // ignore: unused_local_variable
    ResInsRIA result;

    // Site ID
    final site = SiteDao();
    final consecutive = ConsecutiveDao();

    String siteId = await site.getSiteId();

    if (tipo == 1) {
      // Actualizar las actividades incluidas en el reporte RIA

      list.forEach((element) async {
        await db.rawUpdate('''
      UPDATE	PlanInspeccionD
		  SET	ReporteRSI = 1,
			SiteModificacion = '$siteId',
			FechaModificacion = '$currentDate'
		  WHERE		NoPlanInspeccion = '$noPlanInspeccion' AND
      SiteId = '${element.siteId}' AND 
			PropuestaTecnicaId = ${element.propuestaTecnicaId} AND 
			ActividadId = '${element.actividadId}' AND 
			SubActividadId = '${element.subActividadId}' AND 
			IFNULL(ReprogramacionOTId, 0) = IFNULL(${element.reprogramacionOTId},0)
      AND RegBorrado = 0
      ''');
      });

      var riaExist = await db.rawQuery(
          '''SELECT 1 FROM RIA WHERE NoPlanInspeccion = '$noPlanInspeccion' AND Tipo = $tipo AND RegBorrado = 0''');

      if (riaExist.isNotEmpty) {
        int activitiesDN =
            await functionsDao.fnSelCantidadDNFN(noPlanInspeccion, 1);

        await db.rawUpdate('''
        UPDATE	RIA
			  SET	ActividadesPT = $activitiesDN,
			  SiteModificacion = '$siteId',
			  FechaModificacion = '$currentDate'
			  WHERE		NoPlanInspeccion = '$noPlanInspeccion' AND
				Tipo = $tipo AND
        RegBorrado = 0''');

        // Devolvemso el RIAId
        var resRIA = await db.rawQuery(
            '''SELECT RIAId FROM	RIA WHERE	NoPlanInspeccion = '$noPlanInspeccion' AND Tipo = '$tipo' AND RegBorrado = 0''');

        rIAId = resRIA[0]['RIAId'];
      } else {
        int activitiesDN =
            await functionsDao.fnSelCantidadDNFN(noPlanInspeccion, 1);

        String consecutivoFolio =
            await consecutive.getConsecutiveId('RIA', siteId);

        await db.rawInsert(
            '''INSERT INTO RIA  (RIAId, NoPlanInspeccion, FechaCreacion, ActividadesPT, Tipo, SiteModificacion, FechaModificacion)
        VALUES('$consecutivoFolio','$noPlanInspeccion', $currentDate,$activitiesDN , $tipo, $siteId, $currentDate''');

        rIAId = consecutivoFolio;
      }
    } else {
      InspectionPlanDModel actividadRPT = list.first;

      var riaIdExiste = await db.rawQuery('''
      SELECT PID.RIAId
      FROM	PlanInspeccionD PID
      WHERE		PID.NoPlanInspeccion = '$noPlanInspeccion' AND PID.SiteId = '${actividadRPT.siteId}' AND
      			PID.PropuestaTecnicaId = '${actividadRPT.propuestaTecnicaId}' AND
      			PID.ActividadId = '${actividadRPT.actividadId}' AND
      			PID.SubActividadId = '${actividadRPT.subActividadId}' AND
      			IFNULL(PID.ReprogramacionOTId, 0) = IFNULL(${actividadRPT.reprogramacionOTId},0) AND
      			PID.RegBorrado = 0
      ''');

      if (riaIdExiste.isEmpty) {
        String consecutivoFolio =
            await consecutive.getConsecutiveId('RIA', siteId);

        await db.rawUpdate('''
        UPDATE	PlanInspeccionD
        SET			RIAId =  '$consecutivoFolio',
        SiteModificacion = '$siteId',
        FechaModificacion = '$currentDate'
        FROM	PlanInspeccionD PIAD
        	WHERE		PIAD.NoPlanInspeccion = '$noPlanInspeccion' AND
         PIAD.SiteId = '${actividadRPT.siteId}' AND
        				PIAD.PropuestaTecnicaId = '${actividadRPT.propuestaTecnicaId}' AND
        				PIAD.ActividadId = '${actividadRPT.actividadId}' AND
        				PIAD.SubActividadId = '${actividadRPT.subActividadId}' AND
        				IFNULL(PIAD.ReprogramacionOTId, 0) = IFNULL(${actividadRPT.reprogramacionOTId},0) AND
        				PIAD.RegBorrado = 0
        ''');

        await db.rawInsert('''
      INSERT INTO RIA (RIAId, NoPlanInspeccion, FechaCreacion, ActividadesPT, Tipo, SiteModificacion, FechaModificacion)
      VALUES ('$consecutivoFolio', '$noPlanInspeccion', '$currentDate', 1, $tipo, '$siteId', '$currentDate')''');

        // En caso de que no exista la actividad.
        rIAId = consecutivoFolio;
      } else {
        // En caso de que si
        rIAId = riaIdExiste[0]['RIAId'];
      }
    }

    result = ResInsRIA(consecutivoFolio: consecutivoFolio, riaID: rIAId);

    return rIAId;
  }

  // HSEQMC.st_SelRptPlanInspeccion && HSEQMC.st_SelRptPlanInspeccionD
  Future<RptInspectionPlanModel> planDeInspeccion(
      String noPlanInspeccion) async {
    var dbClient = await context.database;

    RptInspectionPlanHeader header;
    List<RtpInspectionPlanList> list = [];
    RptInspectionPlanModel result;

    String planInspecctionHeader = '''
  SELECT		PIC.NoPlanInspeccion,
				PIC.ContratoId,
				O.OT,
				E.Descripcion Embarcacion,
				UPPER(P.Descripcion) Instalacion,
				O.Descripcion Obra,
				PIC.FechaCreacion,
				'ING.' || CASE WHEN EE.Apellidos IS NOT NULL THEN EE.Nombre || ' ' || EE.Apellidos ELSE EE.Nombre END AS Elabora,
				 EE.PuestoDescripcion PuestoElabora,
				'ING.' || CASE WHEN ER.Apellidos IS NOT NULL THEN  ER.Nombre || ' ' || ER.Apellidos ELSE ER.Nombre END AS Revisa,
				 ER.PuestoDescripcion PuestoRevisa,
				'ING.' || CASE WHEN EA.Apellidos IS NOT NULL THEN  EA.Nombre || ' ' || EA.Apellidos ELSE EA.Nombre END AS Aprueba,
				 EA.PuestoDescripcion PuestoAprueba
	FROM	PlanInspeccionC PIC
	INNER JOIN	Obras O ON O.ObraId = PIC.ObraId AND O.RegBorrado = 0
	INNER JOIN	Contratos C ON C.ContratoId = PIC.ContratoId AND C.RegBorrado = 0
	INNER JOIN	Embarcaciones E ON E.EmbarcacionId = C.EmbarcacionId AND E.RegBorrado = 0
	INNER JOIN	Plataformas P ON P.PlataformaId = PIC.PlataformaId AND P.RegBorrado = 0
	INNER JOIN	FirmanteRSI FE ON FE.FirmanteRSIId = PIC.Elabora AND FE.RegBorrado = 0
	INNER JOIN	Empleados EE ON EE.EmpleadoId = FE.EmpleadoId AND EE.RegBorrado = 0
	INNER JOIN	FirmanteRSI FR ON FR.FirmanteRSIId = PIC.Revisa AND FR.RegBorrado = 0
	INNER JOIN	Empleados ER ON ER.EmpleadoId = FR.EmpleadoId AND ER.RegBorrado = 0
	INNER JOIN	FirmanteRSI FA ON FA.FirmanteRSIId = PIC.Aprueba AND FA.RegBorrado = 0
	INNER JOIN	Empleados EA ON EA.EmpleadoId = FA.EmpleadoId AND EA.RegBorrado = 0
	WHERE		PIC.NoPlanInspeccion = '$noPlanInspeccion' AND
				PIC.RegBorrado = 0
    ''';

    var tblPlanInspeccion = await dbClient.rawQuery(planInspecctionHeader);

    if (tblPlanInspeccion.isEmpty) {
      header = RptInspectionPlanHeader(
        aprueba: '',
        contratoId: '',
        elabora: '',
        embarcacion: '',
        fechaCreacion: '',
        instalacion: '',
        obra: '',
        ot: '',
        noPlanInspection: '',
        puestoAprueba: '',
        revisa: '',
      );
    } else {
      header = RptInspectionPlanHeader.fromJson(tblPlanInspeccion.first);
    }

    // List

    String listInspectionPlan = '''
  SELECT
  1 AS Tipo,
  PID.SiteId SiteId,
  PID.PropuestaTecnicaId PropuestaTecnicaId,
  PID.ActividadId ActividadId,
  PID.SubActividadId SubActividadId,
  PID.ReprogramacionOTId ReprogramacionOTId,
  '' AS Partida,
  PID.Frecuencia || '%' AS Frecuencia,
  UPPER(PT.Descripcion) AS Descripcion,
  CASE WHEN PID.TipoInspeccion = 3 THEN 'PIO/PV' WHEN PID.TipoInspeccion = 1 THEN 'PV' WHEN PID.TipoInspeccion = 2 THEN 'PIO' ELSE '' END TipoInspeccion,
  UPPER(PID.Observacion) Observacion,
  FPT.Folio,
  UPPER(EP.DescripcionLarga) Especialidad,
  UPPER(S.DescripcionCorta) Sistema,
  UPPER(F.Descripcion) Frente
	FROM			PlanInspeccionD PID
	INNER JOIN		PropuestaTecnicaSubActividadesH PT ON PT.SiteId = PID.SiteId AND PT.PropuestaTecnicaId = PID.PropuestaTecnicaId AND PT.ActividadId = PID.ActividadId AND PT.SubActividadId = PID.SubActividadId AND IFNULL(PT.ReprogramacionOTId, 0) = IFNULL(PID.ReprogramacionOTId, 0) AND PT.RegBorrado = 0
	INNER JOIN		FoliosPropuestaTecnica FPT ON FPT.SiteId = PT.SiteId AND FPT.PropuestaTecnicaId = PT.PropuestaTecnicaId AND FPT.RegBorrado = 0 AND IFNULL(FPT.EmpleadoId,0) <> 0
	INNER JOIN		PropuestaTecnicaActividadesH PTACT ON PTACT.SiteId = PT.SiteId AND PTACT.PropuestaTecnicaId = PT.PropuestaTecnicaId AND PTACT.ActividadId = PT.ActividadId AND IFNULL(PTACT.ReprogramacionOTId,0) = IFNULL(PT.ReprogramacionOTId,0) AND PTACT.RegBorrado = 0 
	INNER JOIN		Especialidad EP ON EP.EspecialidadId = PT.EspecialidadId AND EP.RegBorrado = 0
	INNER JOIN		Frente F ON F.FrenteId = PTACT.FrenteId AND F.RegBorrado = 0
	LEFT JOIN		Sistemas S ON S.SistemaId = PTACT.SistemaId AND S.RegBorrado = 0
    WHERE	PID.NoPlanInspeccion = '$noPlanInspeccion' AND PID.RegBorrado = 0			
	UNION
	SELECT			
    0 AS Tipo,
   '' AS SiteId,
   '' AS PropuestaTecnicaId,
   '' AS ActividadId,
   '' AS SubActividadId,
   '' AS ReprogramacionOTId,
  AA.Partida,
  AA.Frecuencia || '%' AS Frecuencia,
	UPPER(AA.Descripcion) Descripcion,
	CASE WHEN AA.TipoInspeccion = 3 THEN 'PIO/PV' WHEN AA.TipoInspeccion = 1 THEN 'PV' WHEN AA.TipoInspeccion = 2 THEN 'PIO' ELSE '' END TipoInspeccion,
	UPPER(AA.Observacion) Observacion,
	FPT.Folio,
	UPPER(ES.DescripcionLarga) Especialidad,
	UPPER(S.DescripcionCorta) Sistema,
	UPPER(F.Descripcion) Frente
	FROM ActividadAdicional AA
	INNER JOIN	PlanInspeccionC PIC ON PIC.NoPlanInspeccion = '$noPlanInspeccion' AND PIC.RegBorrado = 0
	INNER JOIN	FoliosPropuestaTecnica FPT ON FPT.FolioId = AA.FolioId AND FPT.RegBorrado = 0 AND IFNULL(FPT.EmpleadoId,0) <> 0 AND FPT.ContratoId = PIC.ContratoId AND FPT.ObraId = PIC.ObraId
	INNER JOIN	Especialidad ES ON ES.EspecialidadId = AA.EspecialidadId AND ES.RegBorrado = 0
	INNER JOIN	Sistemas S ON S.SistemaId = AA.SistemaId AND S.RegBorrado = 0
	INNER JOIN	Frente F ON F.FrenteId = AA.FrenteId AND F.RegBorrado = 0
	WHERE AA.NoPlanInspeccion = '$noPlanInspeccion' AND AA.RegBorrado = 0
    ''';

    var tblListPlanInspection = await dbClient.rawQuery(listInspectionPlan);

    list = listInspectionPlan.isNotEmpty
        ? tblListPlanInspection
            .map((e) => RtpInspectionPlanList.fromJson(e))
            .toList()
        : [];

    if (list.isNotEmpty) {
      for (RtpInspectionPlanList item in list) {
        String partidaInterna;
        String tecnicas;
        String planos;
        String responsables;
        String equipos;
        String procedimientos;
        String formatos;

        if (item.tipo == 1) {
          partidaInterna = await functionsDao.fnPartidaInterna(item.siteId,
              item.propuestaTecnicaId, item.actividadId, item.subActividadId);

          tecnicas = await functionsDao.fnSelDetallesActividades(
              noPlanInspeccion,
              item.siteId,
              item.propuestaTecnicaId,
              item.actividadId,
              item.subActividadId,
              item.reprogramacionOTId,
              1);

          planos = await functionsDao.fnSelDetallesActividades(
              noPlanInspeccion,
              item.siteId,
              item.propuestaTecnicaId,
              item.actividadId,
              item.subActividadId,
              item.reprogramacionOTId,
              4);

          responsables = await functionsDao.fnSelDetallesActividades(
              noPlanInspeccion,
              item.siteId,
              item.propuestaTecnicaId,
              item.actividadId,
              item.subActividadId,
              item.reprogramacionOTId,
              3);

          equipos = await functionsDao.fnSelDetallesActividades(
              noPlanInspeccion,
              item.siteId,
              item.propuestaTecnicaId,
              item.actividadId,
              item.subActividadId,
              item.reprogramacionOTId,
              2);

          procedimientos = await functionsDao.fnSelDetallesActividades(
              noPlanInspeccion,
              item.siteId,
              item.propuestaTecnicaId,
              item.actividadId,
              item.subActividadId,
              item.reprogramacionOTId,
              5);

          formatos = await functionsDao.fnSelDetallesActividades(
              noPlanInspeccion,
              item.siteId,
              item.propuestaTecnicaId,
              item.actividadId,
              item.subActividadId,
              item.reprogramacionOTId,
              6);
        } else {
          partidaInterna = item.partidaA;
          tecnicas = await functionsDao.fnSelDetallesActividadesA(
              noPlanInspeccion, item.partidaA, 1);

          planos = await functionsDao.fnSelDetallesActividadesA(
              noPlanInspeccion, item.partidaA, 4);

          responsables = await functionsDao.fnSelDetallesActividadesA(
              noPlanInspeccion, item.partidaA, 3);

          equipos = await functionsDao.fnSelDetallesActividadesA(
              noPlanInspeccion, item.partidaA, 2);

          procedimientos = await functionsDao.fnSelDetallesActividadesA(
              noPlanInspeccion, item.partidaA, 5);

          formatos = await functionsDao.fnSelDetallesActividadesA(
              noPlanInspeccion, item.partidaA, 6);
        }

        item.partidaInterna = partidaInterna;
        item.tecnicas = tecnicas;
        item.planos = planos;
        item.responsable = responsables;
        item.equipos = equipos;
        item.procedimientos = procedimientos;
        item.formatos = formatos;
      }
    }

    result = RptInspectionPlanModel(element: header, list: list);

    return result;
  }

  // RIA HSEQMC.st_SelRptPlanInspeccion && HSEQMC.st_SelRptPlanInspeccionD

  Future<RptRIAModel> rptRIA(String riaId) async {
    var dbClient = await context.database;

    RptRIAHeader header;
    List<RptRIAList> list = [];
    RptRIAModel result;

    // Params
    int tipo;
    String noPlanInspection;
    String query;

    String sqlRIAHeader = '''
  	SELECT	
        O.Descripcion Obra,
				R.NoPlanInspeccion || '/' || R.RIAId NoReporte,
				PC.ContratoId Contrato,
				O.OT,
				UPPER(P.Descripcion) Instalacion,
				E.Descripcion Embarcacion,
				R.FechaCreacion AS Fecha,
				'ING.' || CASE WHEN EE.Apellidos IS NOT NULL THEN EE.Nombre || ' ' || EE.Apellidos ELSE EE.Nombre END AS Elabora,
				 EE.PuestoDescripcion PuestoElabora,
				'ING.' || CASE WHEN ER.Apellidos IS NOT NULL THEN  ER.Nombre || ' ' || ER.Apellidos ELSE ER.Nombre END AS Revisa,
				 ER.PuestoDescripcion PuestoRevisa,
				'ING.' || CASE WHEN EA.Apellidos IS NOT NULL THEN  EA.Nombre || ' ' || EA.Apellidos ELSE EA.Nombre END AS Aprueba,
				 EA.PuestoDescripcion PuestoAprueba,
				 PC.NoPlanInspeccion
	FROM		RIA R
	INNER JOIN	PlanInspeccionC PC ON PC.NoPlanInspeccion = R.NoPlanInspeccion AND PC.RegBorrado = 0
	INNER JOIN	Contratos C ON C.ContratoId = PC.ContratoId AND C.RegBorrado = 0
	INNER JOIN	Embarcaciones E ON E.EmbarcacionId = C.EmbarcacionId AND E.RegBorrado = 0
	INNER JOIN	FirmanteRSI EF ON EF.FirmanteRSIId = PC.Elabora
	INNER JOIN	Empleados EE ON EE.EmpleadoId = EF.EmpleadoId
	INNER JOIN	FirmanteRSI RS ON RS.FirmanteRSIId = PC.Revisa
	INNER JOIN	Empleados ER ON ER.EmpleadoId = RS.EmpleadoId
	INNER JOIN	FirmanteRSI A ON A.FirmanteRSIId = PC.Aprueba
	INNER JOIN	Empleados EA ON EA.EmpleadoId = A.EmpleadoId
	INNER JOIN	Obras O ON O.ObraId = PC.ObraId AND O.RegBorrado = 0
	INNER JOIN	Plataformas P ON P.PlataformaId = PC.PlataformaId AND P.RegBorrado = 0
	WHERE		R.RIAId = '$riaId' AND
				R.RegBorrado = 0
    ''';

    var tblPlanInspeccion = await dbClient.rawQuery(sqlRIAHeader);

    if (tblPlanInspeccion.isEmpty) {
      header = RptRIAHeader(
        contrato: '',
        embarcacion: '',
        fecha: '',
        instalacion: '',
        noPlanInspeccion: '',
        noReporte: '',
        obra: '',
        ot: '',
      );
    } else {
      header = RptRIAHeader.fromJson(tblPlanInspeccion.first);
    }

    //  1 REPORTE NIVEL PLAN DE INSPECCI�N | 2 REPORTE NIVEL ACTIVIDAD
    var tipoMap = await dbClient.rawQuery(
        '''SELECT Tipo FROM RIA WHERE RIAId = '$riaId' AND RegBorrado = 0''');

    if (tipoMap.isNotEmpty) {
      tipo = tipoMap[0]["Tipo"];
    }

    var noPlanInspeccionMap = await dbClient.rawQuery(
        '''SELECT NoPlanInspeccion FROM RIA WHERE RIAId = '$riaId' AND RegBorrado = 0''');

    if (noPlanInspeccionMap.isNotEmpty) {
      noPlanInspection = noPlanInspeccionMap[0]['NoPlanInspeccion'];
    } else {
      noPlanInspection = '';
    }

    if (tipo == 1) {
      query = '''
      	SELECT PID.NoPlanInspeccion,
						PT.SiteId,
						PT.PropuestaTecnicaId,
						PT.ActividadId,
						PT.SubActividadId,
						PT.ReprogramacionOTId,
						PT.Descripcion Actividad,
						FPT.Folio,
						F.Descripcion Frente,
						EP.DescripcionLarga Especialidad,
						S.Descripcion Sistema,
						PL.Descripcion Plano,
						REPLACE ((
							SELECT	IdentificadorDetalle
							FROM		PIActividadD 
							WHERE		NoPlanInspeccion = PID.NoPlanInspeccion AND 
										SiteId = PID.SiteId AND 
										PropuestaTecnicaId = PID.PropuestaTecnicaId AND 
										ActividadId = PID.ActividadId AND 
										SubActividadId = PID.SubActividadId AND 
										IFNULL(ReprogramacionOTId, 0) = IFNULL(PID.ReprogramacionOTId, 0) AND
										Tipo = 5 AND
										RegBorrado = 0
							ORDER BY	IdentificadorDetalle LIMIT 1
						), '|', ', ') Procedimiento
		FROM  PlanInspeccionD PID
		INNER JOIN		PropuestaTecnicaSubActividadesH PT ON PT.SiteId = PID.SiteId AND PT.PropuestaTecnicaId = PID.PropuestaTecnicaId AND PT.ActividadId = PID.ActividadId AND PT.SubActividadId = PID.SubActividadId AND IFNULL(PT.ReprogramacionOTId, 0) = IFNULL(PID.ReprogramacionOTId, 0)
		INNER JOIN		FoliosPropuestaTecnica FPT ON FPT.SiteId = PT.SiteId AND FPT.PropuestaTecnicaId = PT.PropuestaTecnicaId AND FPT.RegBorrado = 0 AND IFNULL(FPT.EmpleadoId,0) <> 0
		INNER JOIN		PropuestaTecnicaActividadesH PTACT ON PTACT.SiteId = PT.SiteId AND PTACT.PropuestaTecnicaId = PT.PropuestaTecnicaId AND PTACT.ActividadId = PT.ActividadId AND IFNULL(PTACT.ReprogramacionOTId,0) = IFNULL(PT.ReprogramacionOTId,0) AND PTACT.RegBorrado = 0 
		INNER JOIN		Especialidad EP ON EP.EspecialidadId = PT.EspecialidadId AND EP.RegBorrado = 0
		INNER JOIN		Frente F ON F.FrenteId = PTACT.FrenteId
		LEFT JOIN		Planos PL ON PL.PlanoId = PTACT.PlanoId AND PL.RegBorrado = 0
		LEFT JOIN		Sistemas S ON S.SistemaId = PTACT.SistemaId AND S.RegBorrado = 0
		WHERE			PID.NoPlanInspeccion = '$noPlanInspection' AND
                        PID.ReporteRSI = 1 AND
						PID.RegBorrado = 0''';
    } else {
      query = '''
      	SELECT PID.NoPlanInspeccion,
						PT.SiteId,
						PT.PropuestaTecnicaId,
						PT.ActividadId,
						PT.SubActividadId,
						PT.ReprogramacionOTId,
						PT.Descripcion Actividad,
						FPT.Folio,
						F.Descripcion Frente,
						EP.DescripcionLarga Especialidad,
						S.Descripcion Sistema,
						PL.Descripcion Plano,
						REPLACE ((
							SELECT		IdentificadorDetalle
							FROM		PIActividadD 
							WHERE		NoPlanInspeccion = PID.NoPlanInspeccion AND 
										SiteId = PID.SiteId AND 
										PropuestaTecnicaId = PID.PropuestaTecnicaId AND 
										ActividadId = PID.ActividadId AND 
										SubActividadId = PID.SubActividadId AND 
										IFNULL(ReprogramacionOTId, 0) = IFNULL(PID.ReprogramacionOTId, 0) AND
										Tipo = 5 AND
										RegBorrado = 0
							ORDER BY	IdentificadorDetalle LIMIT 1
						), '|', ', ') Procedimiento
		FROM	PlanInspeccionD AS PID
		INNER JOIN		PropuestaTecnicaSubActividadesH PT ON PT.SiteId = PID.SiteId AND PT.PropuestaTecnicaId = PID.PropuestaTecnicaId AND PT.ActividadId = PID.ActividadId AND PT.SubActividadId = PID.SubActividadId AND IFNULL(PT.ReprogramacionOTId, 0) = IFNULL(PID.ReprogramacionOTId, 0)
		INNER JOIN		FoliosPropuestaTecnica FPT ON FPT.SiteId = PT.SiteId AND FPT.PropuestaTecnicaId = PT.PropuestaTecnicaId AND FPT.RegBorrado = 0 AND IFNULL(FPT.EmpleadoId,0) <> 0
		INNER JOIN		PropuestaTecnicaActividadesH PTACT ON PTACT.SiteId = PT.SiteId AND PTACT.PropuestaTecnicaId = PT.PropuestaTecnicaId AND PTACT.ActividadId = PT.ActividadId AND IFNULL(PTACT.ReprogramacionOTId,0) = IFNULL(PT.ReprogramacionOTId,0) AND PTACT.RegBorrado = 0 
		INNER JOIN		Especialidad EP ON EP.EspecialidadId = PT.EspecialidadId AND EP.RegBorrado = 0
		INNER JOIN		Frente F ON F.FrenteId = PTACT.FrenteId
		LEFT JOIN		Planos PL ON PL.PlanoId = PTACT.PlanoId AND PL.RegBorrado = 0
		LEFT JOIN		Sistemas S ON S.SistemaId = PTACT.SistemaId AND S.RegBorrado = 0
		WHERE			PID.NoPlanInspeccion = '$noPlanInspection' AND
						PID.RegBorrado = 0 AND
						PID.RIAId ='$riaId' AND
						PID.RegBorrado = 0
      ''';
    }

    var tblListRIA = await dbClient.rawQuery(query);

    list = tblListRIA.isNotEmpty
        ? tblListRIA.map((e) => RptRIAList.fromJson(e)).toList()
        : [];

    if (list.isNotEmpty) {
      for (RptRIAList item in list) {
        String partidaInterna = await functionsDao.fnPartidaInterna(item.siteId,
            item.propuestaTecnicaId, item.actividadId, item.subActividadId);

        List<RptMaterialesReportados> listMReports;

        var tblMaterialesReportados = await dbClient.rawQuery('''
      SELECT	RIA.NoPlanInspeccion,RIA.SiteId,RIA.MaterialId,M.DescripcionCorta Descripcion,RIA.IdTrazabilidad,
			CASE WHEN RIA.Resultado = 1 THEN 'D/N' ELSE 'F/N' END Resultado,
    	RIA.FechaInspeccion,
    	RIA.Observaciones
      FROM	ReporteInspeccionActividad RIA
      INNER JOIN	DBOMateriales M ON M.MaterialId = RIA.MaterialId AND M.RegBorrado = 0
      WHERE	RIA.NoPlanInspeccion = '${item.noPlanInspection}' AND
    				RIA.SiteId = '${item.siteId}' AND
    				RIA.PropuestaTecnicaId = '${item.propuestaTecnicaId}' AND
    				RIA.ActividadId = '${item.actividadId}' AND
    				RIA.SubActividadId = '${item.subActividadId}' AND
    				RIA.IncluirReporte = 0
      ''');

        listMReports = tblMaterialesReportados.isNotEmpty
            ? tblMaterialesReportados
                .map((e) => RptMaterialesReportados.fromJson(e))
                .toList()
            : [];

        item.listMaterialsReports = listMReports;
        item.partidaInterna = partidaInterna;
      }
    }

    result = RptRIAModel(rptRIAHeader: header, rptRIAList: list);

    return result;
  }

  Future<RptNonCompliantOutputModel> salidaNoConforme(
      String salidaNoConformeId) async {
    var dbClient = await context.database;

    List<NonCompliantOutputModel2> listSalidaNoConforme;
    List<PlannedResourceModel2> listRecursosPlaneados = [];
    RptNonCompliantOutputModel result;

    String querySalidaNoConforme = ''' SELECT		
			CASE WHEN E.Apellidos IS NULL THEN E.Nombre ELSE E.Nombre || ' ' || E.Apellidos END Detecta,
				SNC.Fecha,
				SNC.Consecutivo,
				SNC.ContratoId,
 				O.OT,
				PD.NumeroPlano || ' Rev. ' || PD.Revision || ' Hoja ' || PD.Hoja Plano,
				SNC.DescripcionActividad,
				CASE WHEN SNC.Aplica = 1 THEN  'X' ELSE '' END Prefabricado,
				CASE WHEN SNC.Aplica = 2 THEN 'X' ELSE '' END Instalacion,
				CASE WHEN SNC.Aplica = 3 THEN 'X' ELSE '' END Servicio,
				CASE WHEN SNC.Atribuible = 1 THEN 'X' ELSE '' END Cotemar,
				CASE WHEN SNC.Atribuible = 2 THEN 'X' ELSE '' END Cliente,
				CASE WHEN SNC.Atribuible = 3 THEN 'X' ELSE '' END Subcontratista,
				SNC.Requisito,
				SNC.Falla,
				SNC.Evidencia,
				SNC.NoConcesion,
				CASE WHEN SNC.Disposicion = 1 THEN 'X' ELSE '' END Rechazo,
				CASE WHEN SNC.Disposicion = 2 THEN 'X' ELSE '' END Devuelto,
				CASE WHEN SNC.Disposicion = 3 THEN 'X' ELSE '' END Correccion,
				SNC.Otra,
				DD.Acciones,
				CASE WHEN ER.Apellidos IS NULL THEN ER.Nombre ELSE ER.Nombre || ' ' || ER.Apellidos END Responsable,
				DD.FechaEjecucion,
				CASE WHEN EA.Apellidos IS NULL THEN EA.Nombre ELSE EA.Nombre || ' ' || EA.Apellidos END Autoriza,
				CASE WHEN SNC.Estatus = 'D/N' THEN 'X' ELSE '' END DN,
				CASE WHEN SNC.Estatus = 'F/N' THEN 'X' ELSE '' END FN,
				CASE WHEN SNC.Estatus = 'N/A' THEN 'X' ELSE '' END NA,
				SNC.InformacionSoporte,
				DD.DescripcionDisposicionId,
        SNC.FechaCorreccion,
        SNC.FechaRecepcionCierre
	FROM		SalidaNoConforme SNC
	INNER JOIN	Empleados E ON E.Ficha = SNC.Ficha AND E.RegBorrado = 0
	INNER JOIN	Obras O ON O.ObraId = SNC.ObraId AND O.RegBorrado = 0
	INNER JOIN	PlanoDetalle PD ON PD.PlanoDetalleId = SNC.PlanoDetalleId AND PD.RegBorrado = 0
	INNER JOIN	DescripcionDisposicion DD ON DD.SalidaNoConformeId = SNC.SalidaNoConformeId AND DD.RegBorrado = 0
	INNER JOIN	Empleados ER ON ER.Ficha = DD.FichaRealiza AND IFNULL(ER.EstaActivo,1) = 1 AND ER.RegBorrado = 0
	INNER JOIN	Empleados EA ON EA.Ficha = DD.FichaAutoriza AND IFNULL(EA.EstaActivo,1) = 1 AND EA.RegBorrado = 0
	WHERE		SNC.SalidaNoConformeId = '$salidaNoConformeId' AND
				SNC.RegBorrado = 0''';

    var tblSalidaNoConforme = await dbClient.rawQuery(querySalidaNoConforme);

    listSalidaNoConforme = tblSalidaNoConforme.isNotEmpty
        ? tblSalidaNoConforme
            .map((e) => NonCompliantOutputModel2.fromJson(e))
            .toList()
        : [];

    if (listSalidaNoConforme.isNotEmpty) {
      listSalidaNoConforme.forEach((element) async {
        String descripcionDisposicionId = element.descripcionDisposicionId;
        String recursosPlaneados = '''SELECT		RP.Cantidad,
				RP.Puesto,
				RP.HrPlaneadas,
				RP.HrReales
        FROM		RecursosPlaneados RP
        WHERE		RP.DescripcionDisposicionId = '$descripcionDisposicionId' AND
              RP.RegBorrado = 0
      	ORDER BY	RP.Orden ASC''';
        var tblRecursosPlaneados = await dbClient.rawQuery(recursosPlaneados);

        if (tblRecursosPlaneados.isNotEmpty) {
          tblRecursosPlaneados.forEach((planneResourceModel) {
            listRecursosPlaneados
                .add(PlannedResourceModel2.fromJson(planneResourceModel));
          });
        }
      });
    }

    //[HSEQMC].[st_SelDocumentosRpt] INICIO
    String getDocumentsQuery;

    getDocumentsQuery = '''
      SELECT			Content [Data]             
      FROM			  Documentos
      WHERE			  NombreTabla = 'HSEQMC.SalidaNoConforme' AND
				          IdentificadorTabla = '$salidaNoConformeId' AND
                  RegBorrado = 0
    ''';

    var res = await dbClient.rawQuery(getDocumentsQuery);

    List<DocumentsRptModel> listDocumentsRpt = res.isNotEmpty
        ? res.map((e) => DocumentsRptModel.fromJson(e)).toList()
        : [];
    //[HSEQMC].[st_SelDocumentosRpt] FIN

    result = RptNonCompliantOutputModel(
        listSalidaNoConforme: listSalidaNoConforme,
        recursosPlaneados: listRecursosPlaneados,
        documentsRpt: listDocumentsRpt);

    return result;
  }

  Future<List<RptPrueba>> rptPruebaFoto() async {
    var dbClient = await context.database;

    List<RptPrueba> listFotos;

    String query =
        ''' SELECT Content, ContentType FROM Foto WHERE FotoId = 'FOH0000000003'  OR FotoId = 'FOH0000000004' ''';

    var tblData = await dbClient.rawQuery(query);

    listFotos = tblData.isNotEmpty
        ? tblData.map((e) => RptPrueba.fromJson(e)).toList()
        : [];

    return listFotos;
  }

  // [st_SelRptProteccionAnticorrosiva]  -- [st_SelRptAplicacionRecubrimiento] -- [st_SelRptEquiposIMP]
  Future<RptAPModel> rptProteccionAnticorrosiva(String noRegistro) async {
    var db = await context.database;

    RptAPModel result;
    RptHeaderProteccionAnticorrosiva header;
    List<EquiposIMPAP> listEquiposIMP = [];
    List<DataTableDymanic> listAplicacionRecub = [];
    List<TblTempEvidecias> listEvidecias = [];
    List<TblTempTotalRows> listTableRows = [];
    List<DocumentsRptModel> listDocumentsRpt = [];
    // Params
    int incluirReporte;
    int etapasRecubrimiento = 0;
    int contador = 1;

    var sql = '''
    SELECT PA.Fecha,
				PA.NoRegistro,
				PA.ContratoId,
				C.Descripcion DescripcionContrato,
				O.OT,
				PA.Instalacion,
				P.Descripcion Plataforma,
				O.Descripcion DescripcionObra,
				SR.Sistema,
				SR.Recubrimientos,
				AP.CondicionesSustrato,
				AP.TipoAbrasivo,
				AP.PerfilAnclajePromedio,
				AP.EstandarLimpieza,
				AP.Observaciones,
				AP.ObservacionRF,
			  CASE WHEN ER.Apellidos IS NULL THEN 'ING. ' || ER.Nombre ELSE 'ING. ' || ER.Nombre || ' ' || ER.Apellidos END Revisa,
				CASE WHEN EE.Apellidos IS NULL THEN 'ING. ' || EE.Nombre ELSE 'ING. ' || EE.Nombre || ' ' || EE.Apellidos END Elabora,
				CASE WHEN EA.Apellidos IS NULL THEN 'ING. ' || EA.Nombre ELSE 'ING. ' || EA.Nombre || ' ' || EA.Apellidos END Aprueba,
				AP.IncluirImagenes,
				(SELECT Content FROM Foto WHERE NombreTabla = 'HSEQMC.ProteccionAnticorrosiva' AND IdentificadorTabla = PA.NoRegistro AND RegBorrado = 0 ORDER BY FotoId LIMIT 1) Content1,
				(SELECT ContentType FROM Foto WHERE NombreTabla = 'HSEQMC.ProteccionAnticorrosiva' AND IdentificadorTabla = PA.NoRegistro AND RegBorrado = 0 ORDER BY FotoId LIMIT 1) Mime1
	FROM		ProteccionAnticorrosiva PA
	INNER JOIN	FirmanteRSI FR ON FR.FirmanteRSIId = PA.RevisaId AND FR.RegBorrado = 0
	INNER JOIN	Empleados ER ON ER.EmpleadoId = FR.EmpleadoId AND ER.RegBorrado = 0
	INNER JOIN	FirmanteRSI FE ON FE.FirmanteRSIId = PA.ElaboraId AND FE.RegBorrado = 0
	INNER JOIN	Empleados EE ON EE.EmpleadoId = FE.EmpleadoId AND EE.RegBorrado = 0
	INNER JOIN	FirmanteRSI FA ON FA.FirmanteRSIId = PA.ApruebaId AND FA.RegBorrado = 0
	INNER JOIN	Empleados EA ON EA.EmpleadoId = FA.EmpleadoId AND EA.RegBorrado = 0
	INNER JOIN	Contratos C ON C.ContratoId = PA.ContratoId AND C.RegBorrado = 0
	INNER JOIN	Obras O ON O.ObraId = PA.ObraId AND O.RegBorrado = 0
	INNER JOIN	Plataformas P ON P.PlataformaId = PA.PlataformaId AND P.RegBorrado = 0
	INNER JOIN	SistemaRecubrimiento SR ON SR.SistemaRecubrimientoId = PA.SistemaId AND SR.RegBorrado = 0
	INNER JOIN	AnticorrosivoIPA AP ON AP.NoRegistro = PA.NoRegistro AND AP.RegBorrado = 0
	WHERE		PA.NoRegistro = '$noRegistro' AND
			    PA.RegBorrado = 0
        ''';

    var resHeader = await db.rawQuery(sql);

    // se obtien la cabecera
    if (resHeader.isEmpty) {
      return null;
    } else {
      header = RptHeaderProteccionAnticorrosiva.fromJson(resHeader.first);

      // Asignamos la función
      header.evaluacion = await functionsDao.fnSelEvaluacion(header.noRegistro);
    }

    // [st_SelRptAplicacionRecubrimiento]

    var sqlAplicacionRecubrimiento = '''
    SELECT		'A' Orden, 'No. DE LOTE:' RowDescription,SRD.Etapa DynamicColumnHeader, AR.NoLote Value, AR.Orden OA
	  FROM		SistemaRecubrimientoD SRD INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	  INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.Orden = SRD.Orden AND AR.NoRegistro = PA.NoRegistro AND AR.RegBorrado = 0
	  WHERE		SRD.Recubrimiento = 1 AND SRD.RegBorrado = 0
	  UNION
	  SELECT		'B' Orden, 'FECHA DE CADUCIDAD:' RowDescription, SRD.Etapa DynamicColumnHeader, AR.FechaCaducidad Value, AR.Orden OA
	  FROM SistemaRecubrimientoD SRD INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	  INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.Orden = SRD.Orden AND AR.NoRegistro = PA.NoRegistro AND AR.RegBorrado = 0
	  WHERE		SRD.Recubrimiento = 1 AND SRD.RegBorrado = 0
	  UNION
    SELECT		'C' Orden, 'MÉTODO DE APLICACIÓN:' RowDescription, SRD.Etapa DynamicColumnHeader, AR.MetodoAplicacion Value, AR.Orden OA
	  FROM		SistemaRecubrimientoD SRD INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	  INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.Orden = SRD.Orden AND AR.NoRegistro = PA.NoRegistro AND AR.RegBorrado = 0
	  WHERE		SRD.Recubrimiento = 1 AND	SRD.RegBorrado = 0
	  UNION
	  SELECT		'D' Orden,'TIPO DE RECUBRIMIENTO:' RowDescription,SRD.Etapa DynamicColumnHeader, SRD.ActividadRecubrimiento || ' \n\n ' || AR.TipoRecubrimiento Value,
		AR.Orden OA FROM SistemaRecubrimientoD SRD INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	  INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.Orden = SRD.Orden AND AR.NoRegistro = PA.NoRegistro AND AR.RegBorrado = 0
	  WHERE		SRD.Recubrimiento = 1 AND SRD.RegBorrado = 0
	  UNION
	   SELECT		'E' Orden,'% DE MEZCLA:' RowDescription, SRD.Etapa DynamicColumnHeader, AR.Mezcla Value,AR.Orden OA
	  FROM		SistemaRecubrimientoD SRD INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	  INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.Orden = SRD.Orden AND AR.NoRegistro = PA.NoRegistro AND AR.RegBorrado = 0
	  WHERE		SRD.Recubrimiento = 1 AND SRD.RegBorrado = 0
	  UNION
	 	SELECT 'F' Orden, 'ESPESOR SECO PROMEDIO:' RowDescription, SRD.Etapa DynamicColumnHeader,AR.EspesorSecoPromedio || '.00' || ' MILS' Value, AR.Orden OA
	  FROM		SistemaRecubrimientoD SRD
	  INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro =  '$noRegistro'  AND PA.RegBorrado = 0
	  INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.Orden = SRD.Orden AND AR.NoRegistro = PA.NoRegistro AND AR.RegBorrado = 0
	  WHERE		SRD.Recubrimiento = 1 AND SRD.RegBorrado = 0
	  UNION
	  SELECT		'G' Orden,'TIEMPO DE SECADO:' RowDescription,SRD.Etapa DynamicColumnHeader,AR.TiempoSecado Value,AR.Orden OA
	  FROM		SistemaRecubrimientoD SRD INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro =  '$noRegistro' AND PA.RegBorrado = 0
	  INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.Orden = SRD.Orden AND AR.NoRegistro = PA.NoRegistro AND AR.RegBorrado = 0
	  WHERE		SRD.Recubrimiento = 1 AND SRD.RegBorrado = 0	
    UNION
	  SELECT 'H' Orden,'TIPO DE SOLVENTE O ADELGAZADOR:' RowDescription,SRD.Etapa DynamicColumnHeader,AR.TipoEnvolvente Value,AR.Orden OA
	  FROM		SistemaRecubrimientoD SRD INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	  INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.Orden = SRD.Orden AND AR.NoRegistro = PA.NoRegistro AND AR.RegBorrado = 0
	  WHERE		SRD.Recubrimiento = 1 AND SRD.RegBorrado = 0
	  UNION
    SELECT 'I' Orden, 'PRUEBA DE CONTINUIDAD:' RowDescription,SRD.Etapa DynamicColumnHeader,CASE WHEN SRD.Continuidad = 1 THEN AR.PruebaContinuidad ELSE '-' END Value,AR.Orden OA
	  FROM		SistemaRecubrimientoD SRD INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro =  '$noRegistro'  AND PA.RegBorrado = 0
	  INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.Orden = SRD.Orden AND AR.NoRegistro = PA.NoRegistro AND AR.RegBorrado = 0
	  WHERE		SRD.Recubrimiento = 1 AND SRD.RegBorrado = 0
	  UNION
	  SELECT 'J' Orden,'PRUEBA DE ADHERENCIA:' RowDescription, SRD.Etapa DynamicColumnHeader,CASE WHEN SRD.Adherencia = 1 THEN AR.PruebaAdherencia ELSE '-' END Value,AR.Orden OA
	  FROM		SistemaRecubrimientoD SRD INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	  INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.Orden = SRD.Orden AND AR.NoRegistro = PA.NoRegistro AND AR.RegBorrado = 0
	  WHERE		SRD.Recubrimiento = 1 AND SRD.RegBorrado = 0
    ''';

    var tblAplicacionRecub = await db.rawQuery(sqlAplicacionRecubrimiento);

    listAplicacionRecub = tblAplicacionRecub.isNotEmpty
        ? tblAplicacionRecub.map((e) => DataTableDymanic.fromJson(e)).toList()
        : [];

    var sqlEquiposIMP =
        '''SELECT Nombre FROM EquiposIMPIPA WHERE		NoRegistro = '$noRegistro'  AND RegBorrado = 0''';

    var tblEquiposIMP = await db.rawQuery(sqlEquiposIMP);

    listEquiposIMP = tblEquiposIMP.isNotEmpty
        ? tblEquiposIMP.map((e) => EquiposIMPAP.fromJson(e)).toList()
        : [];

    //
    //
    //
    //
    //

    var evidencias = await db.rawQuery('''
    SELECT FotoId,Content,ContentType
	  FROM Foto WHERE IdentificadorTabla = '$noRegistro'  AND
	  RegBorrado = 0 ORDER BY FotoId ASC LIMIT 2
    ''');

    listEvidecias = evidencias.isNotEmpty
        ? evidencias.map((e) => TblTempEvidecias.fromJson(e)).toList()
        : [];

    var sqlIncluirEvidencias = await db.rawQuery(
        '''SELECT IncluirImagenes FROM AnticorrosivoIPA WHERE NoRegistro = '$noRegistro' AND RegBorrado = 0''');

    incluirReporte = sqlIncluirEvidencias[0]["IncluirImagenes"];

    /*Tab Anticorrosivo*/
    if (incluirReporte == 1 && listEvidecias.isNotEmpty) {
      var observacionRes = await db.rawQuery('''
      SELECT	AP.ObservacionRF Observacion FROM	AnticorrosivoIPA AP WHERE	AP.NoRegistro = '$noRegistro' AND AP.RegBorrado = 0''');

      var observacion = observacionRes[0]["Observacion"];

      var content2 =
          listEvidecias[1].content.isNotEmpty ? listEvidecias[1].content : "0x";
      var contentType2 = listEvidecias[1].contentType.isNotEmpty
          ? listEvidecias[1].contentType
          : "0x";

      TblTempTotalRows temp = TblTempTotalRows(
        observacion: observacion,
        content1: listEvidecias[0].content,
        content2: content2,
        contentType1: listEvidecias[0].contentType,
        contentType2: contentType2,
      );

      listTableRows.add(temp);
    }

    var resEtapaRecubrimiento = await db.rawQuery('''
      SELECT SRD.Orden,SRD.Continuidad FROM SistemaRecubrimientoD SRD
	    INNER JOIN	ProteccionAnticorrosiva PA ON PA.NoRegistro = '$noRegistro' AND PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.RegBorrado = 0
	    WHERE SRD.Recubrimiento = 1 AND
		  SRD.RegBorrado = 0
      ORDER BY SRD.Orden ASC
      ''');

    List<TblEtapasRecubrimiento> listEtapasRecubrimiento =
        resEtapaRecubrimiento.isNotEmpty
            ? resEtapaRecubrimiento
                .map((e) => TblEtapasRecubrimiento.fromJson(e))
                .toList()
            : [];

    if (listEtapasRecubrimiento.isNotEmpty) {
      int count = 1;
      listEtapasRecubrimiento.forEach((element) {
        element.filaId = count;
        count++;
      });
    }

    etapasRecubrimiento = listEtapasRecubrimiento.length;

    while (contador <= etapasRecubrimiento) {
      // Obtener el orden en base al contador
      var ordenActual = listEtapasRecubrimiento
          .where((element) => element.filaId == contador)
          .first
          .orden;

      var continuidad = listEtapasRecubrimiento
          .where((element) => element.filaId == contador)
          .first
          .continuidad;

      listEvidecias = [];

      var evidenciasEspesor = await db.rawQuery('''
     	SELECT FotoId,Content,ContentType,IdentificadorTabla FROM Foto
      WHERE IdentificadorTabla LIKE '$noRegistro' || '|Espesor|' || '$ordenActual' || '%' AND
      RegBorrado = 0 ORDER BY	FotoId ASC LIMIT 2
      ''');

      listEvidecias = evidenciasEspesor.isNotEmpty
          ? evidenciasEspesor.map((e) => TblTempEvidecias.fromJson(e)).toList()
          : [];

      if (evidenciasEspesor.isNotEmpty) {
        var observacionResE = await db.rawQuery('''
      SELECT	AR.Observacion
      FROM		AplicacionRecubrimientoIPA AR
      WHERE		AR.NoRegistro = '$noRegistro' AND
      			AR.Orden = '$ordenActual' AND
      			AR.RegBorrado = 0
        ''');

        var observacionE = observacionResE[0]["Observacion"];

        var content2 = listEvidecias[1].content.isNotEmpty
            ? listEvidecias[1].content
            : "0x";
        var contentType2 = listEvidecias[1].contentType.isNotEmpty
            ? listEvidecias[1].contentType
            : "0x";

        TblTempTotalRows temp = TblTempTotalRows(
          observacion: observacionE,
          content1: listEvidecias[0].content,
          content2: content2,
          contentType1: listEvidecias[0].contentType,
          contentType2: contentType2,
        );

        listTableRows.add(temp);
      }

      listEvidecias = [];

      // Continuidad
      var evidenciasContinuidad = await db.rawQuery('''
        SELECT FotoId,Content,ContentType,IdentificadorTabla FROM Foto
        WHERE IdentificadorTabla LIKE '$noRegistro' || '|Continuidad|' || '$ordenActual' || '%' AND
        RegBorrado = 0 ORDER BY	FotoId ASC LIMIT 2
        ''');

      listEvidecias = evidenciasContinuidad.isNotEmpty
          ? evidenciasContinuidad
              .map((e) => TblTempEvidecias.fromJson(e))
              .toList()
          : [];

      if (evidenciasContinuidad.isNotEmpty &&
          ordenActual == contador &&
          continuidad == 1) {
        var observacionResR = await db.rawQuery('''
          	SELECT		AR.Observacion FROM	AplicacionRecubrimientoIPA AR
            WHERE		AR.NoRegistro = '$noRegistro' AND	AR.Orden = '$ordenActual' AND
      			AR.RegBorrado = 0
          ''');

        var observacionR = observacionResR[0]["Observacion"];

        var content2 = listEvidecias[1].content.isNotEmpty
            ? listEvidecias[1].content
            : "0x";
        var contentType2 = listEvidecias[1].contentType.isNotEmpty
            ? listEvidecias[1].contentType
            : "0x";

        TblTempTotalRows temp = TblTempTotalRows(
          observacion: observacionR,
          content1: listEvidecias[0].content,
          content2: content2,
          contentType1: listEvidecias[0].contentType,
          contentType2: contentType2,
        );

        listTableRows.add(temp);
      }

      contador++;
    }

//[HSEQMC].[st_SelRptCondicionesAmbientales] INICIO

    List<DataTableDymanic> listConditionEnvironmentModel = [];
    List<DataTableDymanic> listTempAmbiente = [];
    List<DataTableDymanic> listTempSustrato = [];
    List<DataTableDymanic> listHumedad = [];

    //TemperaturaAmbiente
    String queryTempAmbiente = ''' SELECT		'A' Orden,
				'TEMPERATURA AMBIENTE:' RowDescription,
				SRD.Etapa DynamicColumnHeader,
				CA.TemperaturaAmbiente [Value],
				CA.Orden OA
	FROM		SistemaRecubrimientoD SRD
	INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	INNER JOIN	CondicionesAmbientalesIPA CA ON CA.NoRegistro = PA.NoRegistro AND CA.Orden = SRD.Orden AND CA.RegBorrado = 0
	WHERE		SRD.RegBorrado = 0''';

    //TemperaturaSustrato
    String queryTempSustrato = ''' SELECT		'B' Orden,
				'TEMPERATURA DEL SUSTRATO:' RowDescription,
				SRD.Etapa DynamicColumnHeader,
				CA.TemperaturaSustrato [Value],
				CA.Orden OA
	FROM		SistemaRecubrimientoD SRD
	INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	INNER JOIN	CondicionesAmbientalesIPA CA ON CA.NoRegistro = PA.NoRegistro AND CA.Orden = SRD.Orden AND CA.RegBorrado = 0
	WHERE		SRD.RegBorrado = 0''';

    //HumedadRelativa
    String queryHumedad = ''' SELECT		'C' Orden,
				'HUMEDAD RELATIVA:' RowDescription,
				SRD.Etapa DynamicColumnHeader,
				CA.HumedadRelativa [Value],
				CA.Orden OA
	FROM		SistemaRecubrimientoD SRD
	INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	INNER JOIN	CondicionesAmbientalesIPA CA ON CA.NoRegistro = PA.NoRegistro AND CA.Orden = SRD.Orden AND CA.RegBorrado = 0
	WHERE		SRD.RegBorrado = 0''';

    var tblTemperaturaAmbiente = await db.rawQuery(queryTempAmbiente);
    listTempAmbiente = tblTemperaturaAmbiente.isNotEmpty
        ? tblTemperaturaAmbiente
            .map((e) => DataTableDymanic.fromJson(e))
            .toList()
        : [];

    var tblTempSustrato = await db.rawQuery(queryTempSustrato);
    listTempSustrato = tblTempSustrato.isNotEmpty
        ? tblTempSustrato.map((e) => DataTableDymanic.fromJson(e)).toList()
        : [];

    var tblHumedad = await db.rawQuery(queryHumedad);
    listHumedad = tblHumedad.isNotEmpty
        ? tblHumedad.map((e) => DataTableDymanic.fromJson(e)).toList()
        : [];

    listConditionEnvironmentModel = [
      ...listTempAmbiente,
      ...listTempSustrato,
      ...listHumedad
    ];
//[HSEQMC].[st_SelRptCondicionesAmbientales] FIN

// //[st_SelRptMateriales] INICIO
    String instalacion = '';
    String observaciones = '';
    List<StagesModel> listEtapas = [];
    PlaneRecordsModel planeRecords1;
    List<PlaneRecordsModel> listPlaneRecords2;

    String queryInstalacion = '''SELECT 	 Instalacion
	FROM			ProteccionAnticorrosiva
	WHERE			NoRegistro = '$noRegistro' AND
					RegBorrado = 0
	ORDER BY		NoRegistro
	LIMIT 1''';

    String queryObservaciones = ''' SELECT 			Observaciones
	FROM			AnticorrosivoIPA
	WHERE			NoRegistro = '$noRegistro' AND
					RegBorrado = 0
	ORDER BY		NoRegistro
	LIMIT 1''';

    String queryEtapas = '''SELECT	
    			SRD.Etapa,
    			SRD.Orden
    FROM		SistemaRecubrimientoD SRD
    INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
    WHERE		SRD.Recubrimiento = 1 AND
    			SRD.RegBorrado = 0 
          ORDER BY SRD.Orden ASC
          ''';

    var valueInstalacion = await db.rawQuery(queryInstalacion);
    instalacion =
        valueInstalacion.isNotEmpty ? valueInstalacion[0]['Instalacion'] : '';

    var valueObservaciones = await db.rawQuery(queryObservaciones);
    observaciones = valueObservaciones.isNotEmpty
        ? valueObservaciones[0]['Observaciones']
        : '';

    var tblEtapas = await db.rawQuery(queryEtapas);
    listEtapas = tblEtapas.isNotEmpty
        ? tblEtapas.map((e) => StagesModel.fromJson(e)).toList()
        : [];

    if (listEtapas.isNotEmpty) {
      int count = 1;
      listEtapas.forEach((element) {
        element.filaId = count;
        count++;
      });
    }

    int orden = listEtapas.where((e) => e.filaId == 1).first.orden;
    int orden2 = listEtapas.where((e) => e.filaId == 2).first.orden;
    int orden3 = listEtapas.where((e) => e.filaId == 3).first.orden;
    String queryMateriales = ''' SELECT 
        'B' Orden,
        COALESCE((SELECT Char(65 + (T1.MaterialIdIPA - 475255) / 456976 % 26) WHERE T1.MaterialIdIPA >= 475255), '')
				|| COALESCE((SELECT Char(65 + (T1.MaterialIdIPA - 18279) / 17576 % 26) WHERE T1.MaterialIdIPA >= 18279), '')
				|| COALESCE((SELECT Char(65 + (T1.MaterialIdIPA - 703) / 676 % 26) WHERE T1.MaterialIdIPA >= 703), '')
				|| COALESCE((SELECT Char(65 + (T1.MaterialIdIPA - 27) / 26 % 26) WHERE T1.MaterialIdIPA >= 27), '')
				|| (SELECT Char(65 + (T1.MaterialIdIPA - 1) % 26)) Orden2,		
        '$instalacion' Ubicacion,		
				T1.NombreElemento Concepto,
				T1.Localizacion,
				T1.PlanoLocalizacion PlanoDetalle,				
        CASE WHEN (IFNULL((SELECT  FechaReporteLiberacion FROM EtapasMaterialesIPA WHERE NoRegistro = '$noRegistro' AND RegBorrado = 0 ORDER BY NoRegistro LIMIT 1), '0001-01-01 00:00:00.000') = '0001-01-01 00:00:00.000' )
            THEN CASE WHEN (IFNULL((SELECT Liberacion FROM MaterialesIPA WHERE NoRegistro = '$noRegistro' AND MaterialIdIPA = T1.MaterialIdIPA AND RegBorrado = 0 ORDER BY NoRegistro LIMIT 1),'0001-01-01 00:00:00.000') = '0001-01-01 00:00:00.000')
                     THEN ''
                     ELSE (SELECT Liberacion FROM MaterialesIPA WHERE NoRegistro = '$noRegistro' AND MaterialIdIPA = T1.MaterialIdIPA AND RegBorrado = 0 ORDER BY NoRegistro LIMIT 1) END
            ELSE (SELECT FechaReporteLiberacion FROM EtapasMaterialesIPA WHERE NoRegistro = '$noRegistro' AND RegBorrado = 0 ORDER BY NoRegistro LIMIT 1) 
            END Liberacion,
            '$observaciones' Observaciones,

            CASE WHEN (IFNULL((SELECT FechaReporte FROM EtapasMaterialesIPA WHERE Orden = '$orden' AND NoRegistro = '$noRegistro' AND RegBorrado = 0 ORDER BY Orden LIMIT 1), '0001-01-01 00:00:00.000') = '0001-01-01 00:00:00.000')
                THEN CASE WHEN (IFNULL((SELECT FechaPropuesta FROM EtapasMaterialesDIPA WHERE MaterialIdIPA = T1.MaterialIdIPA AND Orden = '$orden' AND NoRegistro = '$noRegistro' AND RegBorrado = 0),'0001-01-01 00:00:00.000') = '0001-01-01 00:00:00.000')
                         THEN CASE WHEN (IFNULL((SELECT FechaEvaluacion FROM EtapasMaterialesDIPA WHERE MaterialIdIPA = T1.MaterialIdIPA AND Orden = '$orden' AND NoRegistro = '$noRegistro' AND RegBorrado = 0), '0001-01-01 00:00:00.000') = '0001-01-01 00:00:00.000')
                                THEN '' 
                                ELSE (SELECT FechaEvaluacion FROM EtapasMaterialesDIPA WHERE MaterialIdIPA = T1.MaterialIdIPA AND Orden = '$orden' AND NoRegistro = '$noRegistro' AND RegBorrado = 0)
                              END
                         ELSE (SELECT FechaPropuesta FROM EtapasMaterialesDIPA WHERE MaterialIdIPA = T1.MaterialIdIPA AND Orden = '$orden' AND NoRegistro = '$noRegistro' AND RegBorrado = 0)
                      END
                ELSE  (SELECT FechaReporte FROM EtapasMaterialesIPA WHERE Orden = '$orden' AND NoRegistro = '$noRegistro' AND RegBorrado = 0 ORDER BY Orden LIMIT 1)
            END  Fecha1,
            CASE WHEN (IFNULL((SELECT FechaReporte FROM EtapasMaterialesIPA WHERE Orden = '$orden2' AND NoRegistro = '$noRegistro' AND RegBorrado = 0 ORDER BY Orden LIMIT 1), '0001-01-01 00:00:00.000') = '0001-01-01 00:00:00.000')
                THEN CASE WHEN (IFNULL((SELECT FechaPropuesta FROM EtapasMaterialesDIPA WHERE MaterialIdIPA = T1.MaterialIdIPA AND Orden = '$orden2' AND NoRegistro = '$noRegistro' AND RegBorrado = 0),'0001-01-01 00:00:00.000') = '0001-01-01 00:00:00.000')
                         THEN CASE WHEN (IFNULL((SELECT FechaEvaluacion FROM EtapasMaterialesDIPA WHERE MaterialIdIPA = T1.MaterialIdIPA AND Orden = '$orden2' AND NoRegistro = '$noRegistro' AND RegBorrado = 0), '0001-01-01 00:00:00.000') = '0001-01-01 00:00:00.000')
                                THEN '' 
                                ELSE (SELECT FechaEvaluacion FROM EtapasMaterialesDIPA WHERE MaterialIdIPA = T1.MaterialIdIPA AND Orden = '$orden2' AND NoRegistro = '$noRegistro' AND RegBorrado = 0)
                              END
                         ELSE (SELECT FechaPropuesta FROM EtapasMaterialesDIPA WHERE MaterialIdIPA = T1.MaterialIdIPA AND Orden = '$orden2' AND NoRegistro = '$noRegistro' AND RegBorrado = 0)
                      END
                ELSE  (SELECT FechaReporte FROM EtapasMaterialesIPA WHERE Orden = '$orden2' AND NoRegistro = '$noRegistro' AND RegBorrado = 0 ORDER BY Orden LIMIT 1)
            END Fecha2,

            CASE WHEN (IFNULL((SELECT FechaReporte FROM EtapasMaterialesIPA WHERE Orden = '$orden3' AND NoRegistro = '$noRegistro' AND RegBorrado = 0 ORDER BY Orden LIMIT 1), '0001-01-01 00:00:00.000') = '0001-01-01 00:00:00.000')
                THEN CASE WHEN (IFNULL((SELECT FechaPropuesta FROM EtapasMaterialesDIPA WHERE MaterialIdIPA = T1.MaterialIdIPA AND Orden = '$orden3' AND NoRegistro = '$noRegistro' AND RegBorrado = 0),'0001-01-01 00:00:00.000') = '0001-01-01 00:00:00.000')
                         THEN CASE WHEN (IFNULL((SELECT FechaEvaluacion FROM EtapasMaterialesDIPA WHERE MaterialIdIPA = T1.MaterialIdIPA AND Orden = '$orden3' AND NoRegistro = '$noRegistro' AND RegBorrado = 0), '0001-01-01 00:00:00.000') = '0001-01-01 00:00:00.000')
                                THEN '' 
                                ELSE (SELECT FechaEvaluacion FROM EtapasMaterialesDIPA WHERE MaterialIdIPA = T1.MaterialIdIPA AND Orden = '$orden3' AND NoRegistro = '$noRegistro' AND RegBorrado = 0)
                              END
                         ELSE (SELECT FechaPropuesta FROM EtapasMaterialesDIPA WHERE MaterialIdIPA = T1.MaterialIdIPA AND Orden = '$orden3' AND NoRegistro = '$noRegistro' AND RegBorrado = 0)
                      END
                ELSE  (SELECT FechaReporte FROM EtapasMaterialesIPA WHERE Orden = '$orden3' AND NoRegistro = '$noRegistro' AND RegBorrado = 0 ORDER BY Orden LIMIT 1)
            END Fecha3                                           							
					FROM		MaterialesIPA T1  
	WHERE		T1.NoRegistro = '$noRegistro' AND 
				T1.RegBorrado = 0 ''';
    var tblMateriales = await db.rawQuery(queryMateriales);
    listPlaneRecords2 = tblMateriales.isNotEmpty
        ? tblMateriales.map((e) => PlaneRecordsModel.fromJson(e)).toList()
        : [];

    planeRecords1 = new PlaneRecordsModel(
      orden: 'A',
      orden2: 'A',
      ubicacion: 'UBICACIÓN',
      concepto: 'CONCEPTO',
      localizacion: 'PLANO DE DETALLE',
      planoDetalle: 'ISOMÉTRICO DE LOCALIZACIÓN',
      liberacion: 'LIBERADO',
      observaciones: 'OBSERVACIONES',
      fecha1: listEtapas.where((e) => e.filaId == 1).first.etapa,
      fecha2: listEtapas.where((e) => e.filaId == 2).first.etapa,
      fecha3: listEtapas.where((e) => e.filaId == 3).first.etapa,
    );

    listPlaneRecords2.insert(0, planeRecords1);

    //[st_SelRptMateriales] FIN

    //[st_SelRptPruebasAdherencia] INICIO
    PruebasAdherencia pruebasAdherencia;

    String queryPruebasAdherencia = '''	
		SELECT		PA.Fecha,
		PA.ContratoId,
		PA.NoRegistro,
		PA.Instalacion,
		P.Descripcion Plataforma,
		O.OT,
		AR.DocumentoAplicable,
		AR.Observacion,
		AR.Orden
	FROM		SistemaRecubrimientoD SRD
	INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	INNER JOIN	Plataformas P ON P.PlataformaId = PA.PlataformaId AND P.RegBorrado = 0
	INNER JOIN	Obras O ON O.ObraId = PA.ObraId AND O.RegBorrado = 0
	INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.NoRegistro = PA.NoRegistro AND AR.Orden = SRD.Orden AND AR.RegBorrado = 0
	WHERE		SRD.Recubrimiento = 1 AND
				SRD.Adherencia = 1 AND
				SRD.RegBorrado = 0
    ''';

    var tblPruebasAdherencia = await db.rawQuery(queryPruebasAdherencia);

    if (tblPruebasAdherencia.isEmpty) {
      pruebasAdherencia = PruebasAdherencia(
        fecha: '',
        contratoId: '',
        noRegistro: '',
        instalacion: '',
        plataforma: '',
        ot: '',
        documentoAplicable: '',
        observacion: '',
        orden: 0,
      );
    } else {
      pruebasAdherencia =
          PruebasAdherencia.fromJson(tblPruebasAdherencia.first);
    }

    //[st_SelRptPruebasAdherencia] FIN

    //[HSEQMC].[st_SelRptImagenesAdherencia] INICIO
    int numeroPrueba = 0;
    int contador2 = 1;

    List<TempRegistroImgAdherencia> listRegistroImgAdherencia = [];
    List<EvidenciaImgAdherencia> listEvideciasImgAdherencia = [];
    int ordenIA = pruebasAdherencia.orden;

    var numeroPruebaRes = await db.rawQuery('''
    SELECT	AR.NumeroPruebas
	  FROM	AplicacionRecubrimientoIPA AR
	  WHERE		AR.NoRegistro = '$noRegistro' AND
		AR.Orden = '$ordenIA' AND
		AR.RegBorrado = 0
    ''');

    if (numeroPruebaRes.isNotEmpty) {
      numeroPrueba = numeroPruebaRes[0]["NumeroPruebas"];
    }

    String like = noRegistro + '|Adherencia|' + ordenIA.toString() + '%';
    var evidenciasRes = await db.rawQuery('''
    SELECT	Content,ContentType	FROM Foto
	  WHERE NombreTabla = 'HSEQMC.ProteccionAnticorrosiva' AND
		IdentificadorTabla LIKE '$like' AND
    RegBorrado = 0 
    ORDER BY FotoId ASC
    LIMIT 2
    
    ''');

    listEvideciasImgAdherencia = evidenciasRes.isNotEmpty
        ? evidenciasRes.map((e) => EvidenciaImgAdherencia.fromJson(e)).toList()
        : [];

    if (listEvideciasImgAdherencia.isNotEmpty) {
      int count = 1;
      listEvideciasImgAdherencia.forEach((element) {
        element.filaId = count;
        count++;
      });
    }

    while (contador2 <= numeroPrueba) {
      var observacionRes = await db.rawQuery('''
      	SELECT		AR.ComentariosAdherencia AS Observacion,
				'PRUEBA No ' || '$contador2' AS Prueba
    		FROM		AplicacionRecubrimientoIPA AR
		    WHERE		AR.NoRegistro = '$noRegistro' AND
				AR.Orden = '$ordenIA' AND
				AR.RegBorrado = 0
      ''');

      var observacionE = observacionRes[0]["Observacion"];
      var pruebaE = observacionRes[0]["Prueba"];

      var content2 = listEvideciasImgAdherencia[1].content.isNotEmpty
          ? listEvideciasImgAdherencia[1].content
          : "0x";
      var contentType2 = listEvideciasImgAdherencia[1].contentType.isNotEmpty
          ? listEvideciasImgAdherencia[1].contentType
          : "0x";

      TempRegistroImgAdherencia element = TempRegistroImgAdherencia(
          observacion: observacionE,
          prueba: pruebaE,
          content1: listEvideciasImgAdherencia[0].content,
          contentType1: listEvideciasImgAdherencia[0].contentType,
          content2: content2,
          contentType2: contentType2);

      listRegistroImgAdherencia.add(element);

      contador2++;
    }
    //[HSEQMC].[st_SelRptImagenesAdherencia] FIN

    //[HSEQMC].[st_SelDocumentosRpt] INICIO
    String getDocumentsQuery;

    getDocumentsQuery = '''
      SELECT			Content [Data]             
      FROM			  Documentos
      WHERE			  NombreTabla = 'HSEQMC.ProteccionAnticorrosiva' AND
				          IdentificadorTabla = '$noRegistro' AND
                  RegBorrado = 0
    ''';

    var res = await db.rawQuery(getDocumentsQuery);

    listDocumentsRpt = res.isNotEmpty
        ? res.map((e) => DocumentsRptModel.fromJson(e)).toList()
        : [];
    //[HSEQMC].[st_SelDocumentosRpt] FIN

    // Resultados!!!
    result = RptAPModel(
        listTableRows: listTableRows,
        headerAP: header,
        listAplicacionRecub: listAplicacionRecub,
        listEquiposIMP: listEquiposIMP,
        listConditionEnvironmentModel: listConditionEnvironmentModel,
        listPlaneRecords: listPlaneRecords2,
        pruebasAdherencia: pruebasAdherencia,
        listRegistroImgAdherencia: listRegistroImgAdherencia,
        listDocumentsRpt: listDocumentsRpt);

    return result;
  }
}
