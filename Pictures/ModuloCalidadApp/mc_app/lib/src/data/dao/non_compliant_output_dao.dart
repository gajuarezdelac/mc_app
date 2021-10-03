import 'package:mc_app/src/data/dao/contract_dao.dart';
import 'package:mc_app/src/data/dao/work_dao.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/contract_dropdown_model.dart';
import 'package:mc_app/src/models/disposition_description_model.dart';
import 'package:mc_app/src/models/work_dropdown_model.dart';
import 'package:mc_app/src/models/select_dropdown_model.dart';
import 'package:mc_app/src/models/non_compliant_output_paginator_model.dart';
import 'package:mc_app/src/models/non_compliant_id_model.dart';
import 'package:mc_app/src/models/non_compliant_output_model.dart';
import 'package:mc_app/src/models/params/disposition_description_params.dart';
import 'disposition_description_dao.dart';
import 'site_dao.dart';
import 'consecutive_dao.dart';
import 'package:mc_app/src/models/planned_resource_model.dart';
import 'package:mc_app/src/models/params/evaluation_snc_params.dart';
import 'dynamic_consecutive_dao.dart';

class NonCompliantOutputDao {
  DBContext context = DBContext();

  Future<List<WorkDropDownModelSNC>> fetchWorksSNC(int bandeja) async {
    var dbClient = await context.database;
    String strEstatus;

    if (bandeja == 1)
      strEstatus = "'Sin Registro','Pendiente','Proceso','D/N','F/N'";
    else
      strEstatus = "'Pendiente','Proceso'";

    var res = await dbClient.rawQuery('''
    SELECT		DISTINCT(O.ObraId) ObraId,
				O.Nombre,
				O.OT
	  FROM		SalidaNoConforme SNC
	  INNER JOIN	Obras O ON O.ObraId = SNC.ObraId AND O.RegBorrado = 0
	  WHERE		SNC.Estatus IN ($strEstatus) AND
				    SNC.RegBorrado = 0''');

    List<WorkDropDownModelSNC> lis = res.isNotEmpty
        ? res.map((c) => WorkDropDownModelSNC.fromJson(c)).toList()
        : [];
    return lis;
  }

  Future<List<PlainDetailDropDownModelSNC>> fetchPlainDetailSNC(
      int bandeja) async {
    var dbClient = await context.database;
    String strEstatus;

    if (bandeja == 1)
      strEstatus = "'Sin Registro','Pendiente','Proceso','D/N','F/N'";
    else
      strEstatus = "'Pendiente','Proceso'";

    var res = await dbClient.rawQuery('''
    SELECT		DISTINCT(PD.PlanoDetalleId) PlanoDetalleId,
				PD.NumeroPlano,
				PD.Revision,
				PD.Hoja
    FROM		SalidaNoConforme SNC
    INNER JOIN	PlanoDetalle PD ON PD.PlanoDetalleId = SNC.PlanoDetalleId AND PD.RegBorrado = 0
    WHERE		SNC.Estatus IN ($strEstatus) AND
				    SNC.RegBorrado = 0''');

    List<PlainDetailDropDownModelSNC> lis = res.isNotEmpty
        ? res.map((c) => PlainDetailDropDownModelSNC.fromJson(c)).toList()
        : [];
    return lis;
  }

  Future<List<TypeModelSNC>> fetchTypeSNC(int bandeja) async {
    var dbClient = await context.database;
    String strEstatus;

    if (bandeja == 1)
      strEstatus = "'Sin Registro','Pendiente','Proceso','D/N','F/N'";
    else
      strEstatus = "'Pendiente','Proceso'";

    var res = await dbClient.rawQuery('''
    SELECT		DISTINCT(Tipo) Tipo
    FROM		SalidaNoConforme SNC
    WHERE		SNC.Estatus IN ($strEstatus) AND
				RegBorrado = 0''');

    List<TypeModelSNC> lis =
        res.isNotEmpty ? res.map((c) => TypeModelSNC.fromJson(c)).toList() : [];
    return lis;
  }

  Future<List<SelectDropDownModel>> fetchDetectsSNC(
      int bandeja, String nombre) async {
    var dbClient = await context.database;
    String strEstatus;

    if (bandeja == 1)
      strEstatus = "'Sin Registro','Pendiente','Proceso','D/N','F/N'";
    else
      strEstatus = "'Pendiente','Proceso'";

    var res = await dbClient.rawQuery('''
    SELECT		DISTINCT(E.Ficha) Key,
				 IFNULL(E.Nombre || ' ' || E.Apellidos, E.Nombre) Value
    FROM		Empleados E
    INNER JOIN	SalidaNoConforme SNC ON SNC.Ficha = E.Ficha AND SNC.RegBorrado = 0
    WHERE		E.EstaActivo = 1 AND
          IFNULL(E.Nombre || ' ' || E.Apellidos, E.Nombre) LIKE '%$nombre%' AND
          SNC.Estatus IN($strEstatus) AND
          E.RegBorrado = 0''');

    List<SelectDropDownModel> lis = res.isNotEmpty
        ? res.map((c) => SelectDropDownModel.fromJson(c)).toList()
        : [];
    return lis;
  }

  Future<List<SelectDropDownModel>> fetchConsecutiveSNC(
      int bandeja, String id) async {
    var dbClient = await context.database;
    String strEstatus;

    if (bandeja == 1)
      strEstatus = "'Sin Registro','Pendiente','Proceso','D/N','F/N'";
    else
      strEstatus = "'Pendiente','Proceso'";

    var res = await dbClient.rawQuery('''
    SELECT		SalidaNoConformeId Key,
				Consecutivo Value
	FROM		SalidaNoConforme
	WHERE		Consecutivo IS NOT NULL AND
				Consecutivo LIKE '%$id%' AND
				Estatus IN($strEstatus) AND
				RegBorrado = 0''');

    List<SelectDropDownModel> lis = res.isNotEmpty
        ? res.map((c) => SelectDropDownModel.fromJson(c)).toList()
        : [];
    return lis;
  }

  Future<List<NonCompliantOutputPaginatorModel>>
      fetchNonCompliantOutputPaginator(int bandeja,
          {String ids = '',
          String contratos = '',
          String obras = '',
          String planos = '',
          String tipos = '',
          String fichas = '',
          String aplica = '',
          String atribuible = '',
          String estatus = '',
          int offset = 0,
          int nextrows = 10}) async {
    var dbClient = await context.database;
    String strEstatus;

    if (bandeja == 1)
      strEstatus = "'Sin Registro','Pendiente','Proceso','D/N','F/N','N/A'";
    else
      strEstatus = "'Pendiente','Proceso'";

    String idsIN;
    if (ids == '')
      idsIN = '';
    else
      idsIN = "'" + ids.replaceAll("|", "','") + "'";
    //ids="'"+ids.replaceAll("|", "','")+"'";
    contratos = "'" + contratos.replaceAll("|", "','") + "'";
    obras = "'" + obras.replaceAll("|", "','") + "'";
    planos = "'" + planos.replaceAll("|", "','") + "'";
    tipos = "'" + tipos.replaceAll("|", "','") + "'";
    String fichasIN;
    if (fichas == '')
      fichasIN = '';
    else
      fichasIN = "'" + fichas.replaceAll("|", "','") + "'";
    String aplicaIN;
    if (aplica == '')
      aplicaIN = "''";
    else
      aplicaIN = "'" + aplica.replaceAll("|", "','") + "'";
    atribuible = "'" + atribuible.replaceAll("|", "','") + "'";

    var res = await dbClient.rawQuery('''
    SELECT			10 AS TotalCount,
					SNC.SalidaNoConformeId,
				  CASE
 						WHEN SNC.Estatus = 'Sin Registro' THEN 'gris'
 						WHEN SNC.Estatus = 'Pendiente' THEN 'azul'
 						WHEN SNC.Estatus = 'Proceso' THEN 'amarillo'
 						WHEN (SNC.Estatus = 'D/N' OR SNC.Estatus = 'N/A') THEN 'verde'
 						WHEN SNC.Estatus = 'F/N' THEN 'rojo'
 						ELSE ''
 					END AS Semaforo,
					SNC.Consecutivo,
					SNC.Tipo,
					C.ContratoNombre Contrato,
					O.OT,
					IFNULL(E.Nombre || ' ' || E.Apellidos, E.Nombre) Detecta,
					PD.NumeroPlano || ' Rev. ' || CAST(PD.Revision AS TEXT) || ' Hoja ' || CAST(PD.Hoja AS TEXT) Plano,
					CASE
 						WHEN SNC.Aplica = 1 THEN 'PREFABRICADO'
 						WHEN SNC.Aplica = 2 THEN 'INSTALACIÓN'
 						WHEN SNC.Aplica = 3 THEN 'SERVICIO'
 						ELSE ''
 					END AS Aplica,
					CASE
 						WHEN SNC.Atribuible = 1 THEN 'COTEMAR'
 						WHEN SNC.Atribuible = 2 THEN 'CLIENTE'
 						WHEN SNC.Atribuible = 3 THEN 'SUBCONTRATISTA'
 						ELSE ''
 					END AS Atribuible,
					SNC.DescripcionActividad,
					SNC.Estatus,
					(SELECT COUNT(1) FROM Documentos WHERE NombreTabla = 'HSEQMC.SalidaNoConforme' AND IdentificadorTabla = SNC.SalidaNoConformeId AND RegBorrado = 0) TotalDocumentos
	FROM			SalidaNoConforme SNC
	INNER JOIN		Contratos C ON C.ContratoId = SNC.ContratoId AND C.RegBorrado = 0
	INNER JOIN		Obras O ON O.ObraId = SNC.ObraId AND O.RegBorrado = 0
	INNER JOIN		Empleados E ON E.Ficha = SNC.Ficha AND IFNULL(E.EstaActivo,1) = 1 AND E.RegBorrado = 0
	INNER JOIN		PlanoDetalle PD ON PD.PlanoDetalleId = SNC.PlanoDetalleId AND PD.RegBorrado = 0
	WHERE		(
          (SNC.SalidaNoConformeId IN($idsIN) OR '$ids'='') AND
 				  (C.ContratoId IN($contratos) OR $contratos='') AND
 	  		  (O.ObraId IN($obras) OR $obras='') AND
  			  (PD.PlanoDetalleId IN($planos) OR $planos='') AND
          (SNC.Tipo IN($tipos) OR $tipos='') AND
				  (E.Ficha IN($fichasIN)  OR '$fichas'='') AND
  			  (SNC.Aplica IN ($aplicaIN) OR '$aplica'='') AND
          (SNC.Atribuible IN($atribuible) OR $atribuible='') OR 
          ('$ids' = '' AND $contratos = '' AND $obras = '' AND $planos = '' AND $tipos = '' AND '$fichas' = '' AND '$aplica' = '' AND $atribuible = '')) AND
          ((CASE WHEN SNC.Estatus = 'N/A' THEN 'D/N' ELSE SNC.Estatus END) = '$estatus' OR '$estatus' = '') AND
          SNC.Estatus IN($strEstatus) AND
					SNC.RegBorrado = 0
	ORDER BY		SNC.SalidaNoConformeId ASC;'''); //OFFSET			$offset ROWS FETCH NEXT $nextrows ROWS ONLY; (IIF(SNC.Estatus = 'N/A', 'D/N', SNC.Estatus) = $estatus OR $estatus = '') AND
// //COUNT(*) OVER() AS TOTALCOUNT,
//     var res = await dbClient.rawQuery('''
//     SELECT
// 					SNC.SalidaNoConformeId,
// 					CASE
// 						WHEN SNC.Estatus = 'Sin Registro' THEN '#e1dcdc'
// 						WHEN SNC.Estatus = 'Pendiente' THEN '#3884b7'
// 						WHEN SNC.Estatus = 'Proceso' THEN '#efe80f'
// 						WHEN (SNC.Estatus = 'D/N' OR SNC.Estatus = 'N/A') THEN '#0aa505'
// 						WHEN SNC.Estatus = 'F/N' THEN '#c10d0d'
// 						ELSE ''
// 					END AS Semaforo,
// 					SNC.Consecutivo,
// 					SNC.Tipo,
// 					C.ContratoNombre Contrato,
// 					O.OT,
// 					IFNULL(E.Nombre || ' ' || E.Apellidos, E.Nombre) Detecta,
// 					PD.NumeroPlano || ' Rev. ' + CONVERT(VARCHAR(MAX), PD.Revision) || ' Hoja ' || CONVERT(VARCHAR(MAX), PD.Hoja) Plano,
// 					CASE
// 						WHEN SNC.Aplica = 1 THEN 'PREFABRICADO'
// 						WHEN SNC.Aplica = 2 THEN 'INSTALACIÓN'
// 						WHEN SNC.Aplica = 3 THEN 'SERVICIO'
// 						ELSE ''
// 					END AS Aplica,
// 					CASE
// 						WHEN SNC.Atribuible = 1 THEN 'COTEMAR'
// 						WHEN SNC.Atribuible = 2 THEN 'CLIENTE'
// 						WHEN SNC.Atribuible = 3 THEN 'SUBCONTRATISTA'
// 						ELSE ''
// 					END AS Atribuible,
// 					SNC.DescripcionActividad,
// 					SNC.Estatus,
// 					(SELECT COUNT(1) FROM HSEQMC.Documentos WHERE NombreTabla = 'HSEQMC.SalidaNoConforme' AND IdentificadorTabla = SNC.SalidaNoConformeId AND RegBorrado = 0) TotalDocumentos
// 	FROM			SalidaNoConforme SNC
// 	INNER JOIN		Contratos C ON C.ContratoId = SNC.ContratoId AND C.RegBorrado = 0
// 	INNER JOIN		Obras O ON O.ObraId = SNC.ObraId AND O.RegBorrado = 0
// 	INNER JOIN		Empleados E ON E.Ficha = SNC.Ficha AND E.EstaActivo = 1 AND E.RegBorrado = 0
// 	INNER JOIN		PlanoDetalle PD ON PD.PlanoDetalleId = SNC.PlanoDetalleId AND PD.RegBorrado = 0
// 	WHERE			(SNC.SalidaNoConformeId IN($ids) OR
// 					   C.ContratoId IN($contratos) OR --true
// 					   O.ObraId IN($obras) OR
// 					   PD.PlanoDetalleId IN($planos) OR
// 					   SNC.Tipo IN($tipos) OR
// 					   E.Ficha IN($fichas)  OR
// 					   SNC.Aplica ($aplica) OR
// 					   SNC.Atribuible ($atribuible) OR
// 					($ids = '' AND $contratos = '' AND $obras = '' AND $planos = '' AND $tipos = '' AND $fichas = '' AND $aplica = '' AND $atribuible = '')) AND
// 					(IIF(SNC.Estatus = 'N/A', 'D/N', SNC.Estatus) = $estatus OR $estatus = '') AND
// 					SNC.Estatus IN($strEstatus) AND
// 					SNC.RegBorrado = 0
// 	ORDER BY		SNC.SalidaNoConformeId ASC
// 	LIMIT 10;''');//OFFSET			$offset ROWS FETCH NEXT $nextrows ROWS ONLY;

    List<NonCompliantOutputPaginatorModel> lis = res.isNotEmpty
        ? res.map((c) => NonCompliantOutputPaginatorModel.fromJson(c)).toList()
        : [];
    return lis;
  }

  Future<List<NonCompliantOutputIdModel>> fetchNonCompliantOutputId(
      String nonCompliantOutputId) async {
    var dbClient = await context.database;

    var res = await dbClient.rawQuery('''
    SELECT		SNC.SalidaNoConformeId,
				SNC.Ficha,
				SNC.Fecha,
				SNC.Consecutivo,
				SNC.ContratoId,
				SNC.ObraId,
				SNC.PlanoDetalleId,
				SNC.DescripcionActividad,
				SNC.Aplica,
				SNC.Atribuible,
				SNC.Requisito,
				SNC.Falla,
				SNC.Evidencia,
				SNC.NoConcesion,
				SNC.Disposicion,
				SNC.Otra,
				SNC.Estatus,
				SNC.InformacionSoporte,
				SNC.Tipo,
				(SELECT Consecutivo FROM SalidaNoConforme WHERE SalidaNoConformeId = SNC.IdentificadorTabla AND RegBorrado = 0 ORDER BY SalidaNoConformeId LIMIT 1) Origen,
        SNC.FechaCorreccion,
        SNC.FechaRecepcionCierre
	FROM		SalidaNoConforme SNC
	WHERE		SalidaNoConformeId = '$nonCompliantOutputId' AND
				RegBorrado = 0''');

    List<NonCompliantOutputIdModel> lis = res.isNotEmpty
        ? res.map((c) => NonCompliantOutputIdModel.fromJson(c)).toList()
        : [];
    return lis;
  }

  Future<List<NonCompliantOutputModel>> fetchNonCompliantOutputDD(
      String nonCompliantOutputId) async {
    var dbClient = await context.database;

    var res = await dbClient.rawQuery('''
   SELECT		SNC.SalidaNoConformeId,
				'Control de Calidad' Departamento,
				SNC.Fecha,
				SNC.Consecutivo,
				SNC.ContratoId,
				O.OT,
				PD.NumeroPlano + ' Rev. ' + CONVERT(VARCHAR(MAX), PD.Revision) + ' Hoja ' + CONVERT(VARCHAR(MAX), PD.Hoja) Plano,
				SNC.DescripcionActividad,
				SNC.Ficha
	FROM		SalidaNoConforme SNC
	INNER JOIN	Obras O ON O.ObraId = SNC.ObraId AND O.RegBorrado = 0
	INNER JOIN	PlanoDetalle PD ON PD.PlanoDetalleId = SNC.PlanoDetalleId AND PD.RegBorrado = 0
	WHERE		SNC.SalidaNoConformeId = $nonCompliantOutputId AND
				SNC.RegBorrado = 0''');

    List<NonCompliantOutputModel> lis = res.isNotEmpty
        ? res.map((c) => NonCompliantOutputModel.fromJson(c)).toList()
        : [];
    return lis;
  }

  Future<List<ContractDropdownModelSNC>> fetchContractsSNC(int bandeja) async {
    var dbClient = await context.database;
    String strEstatus;

    if (bandeja == 1)
      strEstatus = "'Sin Registro','Pendiente','Proceso','D/N','F/N'";
    else
      strEstatus = "'Pendiente','Proceso'";

    var res = await dbClient.rawQuery('''
    SELECT		DISTINCT(C.ContratoId) ContratoId,
				C.ContratoNombre,
				C.Nombre,
				'' Embarcacion
	FROM		SalidaNoConforme SNC
	INNER JOIN	Contratos C ON C.ContratoId = SNC.ContratoId AND C.RegBorrado = 0
	WHERE		SNC.Estatus IN($strEstatus) AND
				SNC.RegBorrado = 0''');

    List<ContractDropdownModelSNC> lis = res.isNotEmpty
        ? res.map((c) => ContractDropdownModelSNC.fromJson(c)).toList()
        : [];
    return lis;
  }

  Future<void> insUpdDispositionDescription(
      DispositionDescriptionParams params) async {
    var dbClient = await context.database;

    final ddDao = DispositionDescriptionDao();
    //Obtiene el SiteId
    DispositionDescriptionModel ddModel =
        await ddDao.getById(params.dispositionDescriptionId);
    if (ddModel != null) {
      await dbClient.transaction((txn) async {
        await txn.update(
          'DescripcionDisposicion',
          {
            'Acciones': params.actions,
            'FechaEjecucion': params.executionDate.toString(),
            'FichaRealiza': params.employeeMakes,
          },
          where: 'DescripcionDisposicionId = ? AND RegBorrado=0',
          whereArgs: [params.dispositionDescriptionId],
        );

        await txn.update(
          'RecursosPlaneados',
          {
            'RegBorrado': 1,
          },
          where: 'DescripcionDisposicionId = ? AND RegBorrado=0',
          whereArgs: [params.dispositionDescriptionId],
        );

        params.resources.forEach((element) {
          //verifivar cual es la llave para ver si funciona el replace
          txn.execute(
              '''INSERT OR REPLACE INTO RecursosPlaneados(DescripcionDisposicionId,	Orden, Cantidad, Puesto, HrPlaneadas, HrReales, RegBorrado) VALUES('${params.dispositionDescriptionId}', '${element.orden}', ${element.cantidad},	'${element.puesto}', '${element.hrPlaneadas}', '', 0);''');
        });
      });

      //   if (result == 1) {
      //   return RemoveMachineWeldingResponseModel(
      //     mensaje: 'Maquina removida correctamente!',
      //     rowsAffected: result,
      //     actionResult: 'success',
      //     folioSoldaduraId: folioSoldadura,
      //   );
      // }
    } else {
      final site = SiteDao();
      final consecutive = ConsecutiveDao();

      String siteId = await site.getSiteId();
      String newId =
          await consecutive.getConsecutiveId('SalidaNoConforme', siteId);
      ddModel = DispositionDescriptionModel(
        actions: params.actions,
        dispositionDescriptionId: newId,
        employeMakes: params.employeeMakes,
        employeeAuth: params.employeeAuth,
        executionDate: params.executionDate.toString(),
        nonCompliantOutputId: params.nonCompliantOutputId,
      );

      await dbClient.transaction((txn) async {
        await txn.insert('DescripcionDisposicion', ddModel.toJson());

        for (int i = 0; i < params.resources.length; i++) {
          await txn.insert(
            'RecursosPlaneados',
            {
              'DescripcionDisposicionId': newId,
              'Orden': params.resources[i].orden,
              'Cantidad': params.resources[i].cantidad,
              'Puesto': params.resources[i].puesto,
              'HrPlaneadas': params.resources[i].hrPlaneadas,
              'HrReales': params.resources[i].hrReales,
            },
          );
        }

        await txn.update(
          'SalidaNoConforme',
          {
            'Estatus': 'Proceso',
          },
          where: 'SalidaNoConformeId = ? AND RegBorrado=0',
          whereArgs: [params.nonCompliantOutputId],
        );
      });
    }
  }

  Future<DispositionDescriptionModel> fetchDispositionDescription(
      String nonCompliantOutputId) async {
    final db = await context.database;
    List<Map<String, dynamic>> res;

    res = await db.query('DescripcionDisposicion',
        columns: [
          'DescripcionDisposicionId',
          'SalidaNoConformeId',
          'Acciones',
          'FichaAutoriza',
          'FichaRealiza',
          'FechaEjecucion'
        ],
        where: 'SalidaNoConformeId = ? AND RegBorrado=0',
        whereArgs: [nonCompliantOutputId],
        limit: 1);
    DispositionDescriptionModel elements =
        res.length > 0 ? DispositionDescriptionModel.fromJson(res.first) : null;

    return elements;
  }

  Future<List<PlannedResourceModel>> fetchPlannedResources(
      String dispositionDescriptionId) async {
    var dbClient = await context.database;

    var res = await dbClient.rawQuery('''
    SELECT		Orden,
				Cantidad,
				Puesto,
				HrPlaneadas,
				HrReales
	FROM		RecursosPlaneados
	WHERE		DescripcionDisposicionId = '$dispositionDescriptionId' AND
				RegBorrado = 0''');

    List<PlannedResourceModel> lis = res.isNotEmpty
        ? res.map((c) => PlannedResourceModel.fromJson(c)).toList()
        : [];
    return lis;
  }

  Future<List<PlannedResourceModel>> fetchPlannedResourcesBySNCId(
      String nonOutputCompliantId) async {
    var dbClient = await context.database;
// IFNULL(ER.EstaActivo, 1) = 1 AND
    var res = await dbClient.rawQuery('''
    SELECT		DD.Acciones,
				IFNULL(ER.Nombre || ' ' || ER.Apellidos, ER.Nombre) Responsable,
				FechaEjecucion,
				RP.Orden,
				RP.Cantidad,
				RP.Puesto,
				RP.HrPlaneadas,
				RP.HrReales,
				DD.FichaRealiza,
				DD.FichaAutoriza
	FROM		DescripcionDisposicion DD
	INNER JOIN	Empleados ER ON ER.Ficha = DD.FichaRealiza AND ER.RegBorrado = 0
	INNER JOIN	RecursosPlaneados RP ON RP.DescripcionDisposicionId = DD.DescripcionDisposicionId AND RP.RegBorrado = 0
	WHERE		DD.SalidaNoConformeId = '$nonOutputCompliantId' AND
				DD.RegBorrado = 0''');

    List<PlannedResourceModel> lis = res.isNotEmpty
        ? res.map((c) => PlannedResourceModel.fromJson(c)).toList()
        : [];
    return lis;
  }

  Future<void> updEvaluateSNC(EvaluationSNCParams params) async {
    var dbClient = await context.database;
    String descripcionDisposicionId;

    DispositionDescriptionModel ddModel =
        await fetchDispositionDescription(params.nonCompliantOutputId);
    if (ddModel != null)
      descripcionDisposicionId = ddModel.dispositionDescriptionId;
    await dbClient.transaction((txn) async {
      await txn.update(
        'SalidaNoConforme',
        {
          'Estatus': params.estatus,
          'InformacionSoporte': params.informacionSoporte,
          'FechaCorreccion': params.fechaCorreccion,
          'FechaRecepcionCierre': params.fechaRecepcionCierre,
        },
        where: 'SalidaNoConformeId = ? AND RegBorrado=0',
        whereArgs: [params.nonCompliantOutputId],
      );

      params.resources.forEach((element) {
        txn.update(
          'RecursosPlaneados',
          {
            'HrReales': element.hrReales,
          },
          where: 'DescripcionDisposicionId = ? AND Orden=?',
          whereArgs: [descripcionDisposicionId, element.orden],
        );
      });
    });
  }

  Future<void> insSNCFN(String nonCompliantOutoutId) async {
    var dbClient = await context.database;
    String folioConsecutivo;
    String consecutivo;
    String prefijo;
    String nombreContrato;
    String ot;
    String letra;
    String siteId;
    String fechaActual;
    String contratoId;
    String obraId;

    final site = SiteDao();
    siteId = await site.getSiteId();

    List<NonCompliantOutputIdModel> modelList =
        await fetchNonCompliantOutputId(nonCompliantOutoutId);
    contratoId = modelList.first.contratoId;
    obraId = modelList.first.obraId;

    final contractDao = ContractDao();
    ContractDropdownModel contractDDModel =
        await contractDao.fetchContractId(contratoId);
    nombreContrato = contractDDModel.nombre;

    final workDao = WorkDao();
    WorkDropDownModel obraDDModel = await workDao.fetchWorkById(obraId);
    ot = obraDDModel.oT;

    fechaActual = DateTime.now().year.toString();

    if (siteId == 'HUB') {
      letra = 'T';
    } else {
      letra = 'M';
    }
//TODo revisar si arma bien el prefijo como en sqlserver
    prefijo = nombreContrato.substring(0, 2) +
        '-' +
        ot +
        '-SNC-' +
        letra +
        '-' +
        fechaActual.substring(fechaActual.length - 2, fechaActual.length - 1);

    final consecutiveDao = DynamicConsecutiveDao();
    consecutivo =
        await consecutiveDao.getDynamicConsecutiveId(prefijo, completo: false);

    consecutivo = nombreContrato.substring(0, 2) +
        '-' +
        ot +
        '-SNC-' +
        letra +
        consecutivo +
        '-' +
        fechaActual.substring(fechaActual.length - 2, fechaActual.length - 1);

    final consecutive = ConsecutiveDao();
    folioConsecutivo =
        await consecutive.getConsecutiveId('SalidaNoConforme', siteId);

    await dbClient.rawInsert('''INSERT INTO SalidaNoConforme
	(
		SalidaNoConformeId,
		Consecutivo,
		Ficha,
		Fecha,
		ContratoId,
		ObraId,
		PlanoDetalleId,
		DescripcionActividad,
		Aplica,
		Atribuible,
		Requisito,
		Falla,
		Evidencia,
		NoConcesion,
		Disposicion,
		Otra,
		Tipo,
		Estatus,
		NombreTabla,
		IdentificadorTabla
	)
	SELECT	?, 
			?, 
			Ficha,
			?,
			ContratoId,
			ObraId,
			PlanoDetalleId,
			DescripcionActividad,
			Aplica,
			Atribuible,
			Requisito,
			Falla,
			Evidencia,
			NoConcesion,
			Disposicion,
			Otra,
			'SNC-A',
			'Pendiente',
			'HSEQMC.SalidaNoConforme',
			@SalidaNoConformeId
	FROM	SalidaNoConforme 
	WHERE	SalidaNoConformeId = '$nonCompliantOutoutId' AND
			RegBorrado = 0''', [
      folioConsecutivo,
      consecutivo,
      DateTime.now().toString(),
      nonCompliantOutoutId
    ]);
  }

  Future<void> insUpdSNC(NonCompliantOutputIdModel model) async {
    var dbClient = await context.database;
    String estatus;
    String consecutivo;
    String prefijo;
    String nombreContrato;
    String ot;
    String letra;
    String siteId;
    String fechaActual;

    final contractDao = ContractDao();
    ContractDropdownModel contractDDModel =
        await contractDao.fetchContractId(model.contratoId);
    nombreContrato = contractDDModel.nombre;

    final workDao = WorkDao();
    WorkDropDownModel obraDDModel = await workDao.fetchWorkById(model.obraId);
    ot = obraDDModel.oT;

    final site = SiteDao();
    siteId = await site.getSiteId();

    fechaActual = DateTime.now().year.toString();

    if (siteId == 'HUB') {
      letra = 'T';
    } else {
      letra = 'M';
    }

    List<NonCompliantOutputIdModel> modelList =
        await fetchNonCompliantOutputId(model.salidaNoConformeId);
    if (modelList.length > 0) {
      consecutivo = modelList.first.consecutivo;
      estatus = modelList.first.estatus;

      if (modelList.first.estatus == 'Sin Registro') {
        prefijo = nombreContrato.substring(0, 3) +
            '-' +
            ot +
            '-SNC-' +
            letra +
            '-' +
            fechaActual.substring(fechaActual.length - 2, fechaActual.length);

        final consecutiveDao = DynamicConsecutiveDao();
        consecutivo = await consecutiveDao.getDynamicConsecutiveId(prefijo,
            completo: false);

        consecutivo = nombreContrato.substring(0, 3) +
            '-' +
            ot +
            '-SNC-' +
            letra +
            consecutivo +
            '-' +
            fechaActual.substring(fechaActual.length - 2, fechaActual.length);

        estatus = 'Pendiente';
      }

      await dbClient.update(
          'SalidaNoConforme',
          {
            'Consecutivo': consecutivo,
            'Fecha': model.fecha,
            'ContratoId': model.contratoId,
            'ObraId': model.obraId,
            'PlanoDetalleId': model.planoDetalleId,
            'DescripcionActividad': model.descripcionActividad,
            'Aplica': model.aplica,
            'Atribuible': model.atribuible,
            'Requisito': model.requisito,
            'Falla': model.falla,
            'Evidencia': model.evidencia,
            'NoConcesion': model.noConcesion,
            'Disposicion': model.disposicion,
            'Otra': model.otra,
            'Estatus': estatus,
          },
          where: 'SalidaNoConformeId = ? AND RegBorrado=0',
          whereArgs: [model.salidaNoConformeId]);
    } else {
      if (model.tipo == "Manual") {
        final consecutive = ConsecutiveDao();
        String folioConsecutivo =
            await consecutive.getConsecutiveId('SalidaNoConforme', siteId);

        prefijo = nombreContrato.substring(0, 3) +
            '-' +
            ot +
            '-SNC-' +
            letra +
            '-' +
            fechaActual.substring(fechaActual.length - 2, fechaActual.length);

        final consecutiveDao = DynamicConsecutiveDao();
        consecutivo = await consecutiveDao.getDynamicConsecutiveId(prefijo,
            completo: false);

        consecutivo = nombreContrato.substring(0, 3) +
            '-' +
            ot +
            '-SNC-' +
            letra +
            consecutivo +
            '-' +
            fechaActual.substring(fechaActual.length - 2, fechaActual.length);

        estatus = 'Pendiente';
        await dbClient.insert(
          'SalidaNoConforme',
          {
            'SalidaNoConformeId': folioConsecutivo,
            'Consecutivo': consecutivo,
            'Ficha': model.ficha,
            'Fecha': model.fecha,
            'ContratoId': model.contratoId,
            'ObraId': model.obraId,
            'PlanoDetalleId': model.planoDetalleId,
            'DescripcionActividad': model.descripcionActividad,
            'TextoDefault': '',
            'Aplica': model.aplica,
            'Atribuible': model.atribuible,
            'Requisito': model.requisito,
            'Falla': model.falla,
            'Evidencia': model.evidencia,
            'NoConcesion': model.noConcesion,
            'Disposicion': model.disposicion,
            'Otra': model.otra,
            'Tipo': model.tipo,
            'Estatus': estatus,
          },
        );
      }
    }
  }
}
