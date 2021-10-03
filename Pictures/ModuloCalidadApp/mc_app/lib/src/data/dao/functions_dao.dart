import 'package:intl/intl.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/fn_model.dart';
import 'package:mc_app/src/utils/makePlaceholders.dart';

class FunctionsDao {
  DBContext context = DBContext();

  // Traducción de la función [HSEQMC].[fn_SelCantidad_DN_FN]
  Future<int> fnSelCantidadDNFN(String noPlanInspection, int tipo) async {
    var db = await context.database;

    var res = await db.rawQuery('''
    SELECT PD.SiteId,
					PD.PropuestaTecnicaId,
					PD.ActividadId,
					PD.SubActividadId,
					PD.ReprogramacionOTId,
          PD.RegBorrado
  	FROM PlanInspeccionD PD
  	WHERE	PD.NoPlanInspeccion = '$noPlanInspection'
    ''');

    List<FNSelCantidadModel> list = res.isNotEmpty
        ? res.map((e) => FNSelCantidadModel.fromJson(e)).toList()
        : [];

    if (list.isNotEmpty) {
      for (FNSelCantidadModel item in list) {
        String semaforo = await fnSelSemaforoActividades(
          noPlanInspection,
          item.siteId,
          item.propuestaTecnicaId,
          item.actividadId,
          item.subActividadId,
          item.reprogramacionOTId,
        );

        item.semaforo = semaforo;
      }
    }

    switch (tipo) {
      case 1:
        {
          List<FNSelCantidadModel> listFilter = list
              .where((item) => item.semaforo == 'green' && item.regBorrado == 0)
              .toList();

          return listFilter.length;
        }
        break;
      case 2:
        {
          List<FNSelCantidadModel> listFilter = list
              .where((item) => item.semaforo == 'red' && item.regBorrado == 0)
              .toList();

          return listFilter.length;
        }
        break;
      case 3:
        {
          List<FNSelCantidadModel> listFilter = list
              .where(
                  (item) => item.semaforo == 'green' && item.regBorrado == -1)
              .toList();

          return listFilter.length;
        }
        break;
      default:
        {
          return 0;
        }
        break;
    }
  }

  // Traducción de la función [HSEQMC].[fn_SelSemaforoActividades]
  Future<String> fnSelSemaforoActividades(
    String noPlanInspection,
    String siteId,
    dynamic propuestaTecnicaId,
    dynamic actividadId,
    dynamic subActividadId,
    dynamic reprogramacionOTId,
  ) async {
    // Params
    int totalMateriales;
    int filasDN;
    String color;

    var db = await context.database;

    List<Map<String, dynamic>> listMateriales = await db.rawQuery('''
    SELECT RCD.MaterialId,RCD.IdTrazabilidad FROM	ReporteCampoC RC
    INNER JOIN	RCMaterial RCM ON RCM.SiteId = RC.SiteId AND RCM.FolioRC = RC.FolioRC AND RCM.RegBorrado = 0
    INNER JOIN	RCMaterialDet RCD ON RCD.FolioRC = RC.FolioRC AND RCD.RegBorrado = 0
    WHERE	RC.SiteId = '$siteId' AND RC.PropuestaTecnicaId = '$propuestaTecnicaId' AND RC.ActividadId = '$actividadId' 
    AND RC.SubActividadId = '$subActividadId' AND IFNULL(RC.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0)		
    UNION
    SELECT	RCD.MaterialId,RCD.IdTrazabilidad FROM ReporteCampoC RC
    INNER JOIN RCMaterialRes RCM ON RCM.SiteId = RC.SiteId AND RCM.FolioRC = RC.FolioRC AND RCM.RegBorrado = 0
    INNER JOIN RCMaterialResDet RCD ON RCD.FolioRC = RC.FolioRC AND RCD.RegBorrado = 0
    WHERE	RC.SiteId = '$siteId' AND RC.PropuestaTecnicaId = '$propuestaTecnicaId' AND RC.ActividadId = '$actividadId' 
    AND RC.SubActividadId = '$subActividadId' AND IFNULL(RC.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0)
    ''');

    if (listMateriales.isEmpty) {
      color = 'black';
    } else {
      List<Map<String, dynamic>> resultadoIsNotNull = await db.rawQuery('''
    SELECT	1 AS Existe
		FROM		(
   	SELECT RCD.MaterialId,RCD.IdTrazabilidad FROM	ReporteCampoC RC
    INNER JOIN	RCMaterial RCM ON RCM.SiteId = RC.SiteId AND RCM.FolioRC = RC.FolioRC AND RCM.RegBorrado = 0
    INNER JOIN	RCMaterialDet RCD ON RCD.FolioRC = RC.FolioRC AND RCD.RegBorrado = 0
    WHERE	RC.SiteId = '$siteId' AND RC.PropuestaTecnicaId = '$propuestaTecnicaId' AND RC.ActividadId = '$actividadId' 
    AND RC.SubActividadId = '$subActividadId' AND IFNULL(RC.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0)		
    UNION
    SELECT	RCD.MaterialId,RCD.IdTrazabilidad FROM ReporteCampoC RC
    INNER JOIN RCMaterialRes RCM ON RCM.SiteId = RC.SiteId AND RCM.FolioRC = RC.FolioRC AND RCM.RegBorrado = 0
    INNER JOIN RCMaterialResDet RCD ON RCD.FolioRC = RC.FolioRC AND RCD.RegBorrado = 0
    WHERE	RC.SiteId = '$siteId' AND RC.PropuestaTecnicaId = '$propuestaTecnicaId' AND RC.ActividadId = '$actividadId' 
    AND RC.SubActividadId = '$subActividadId' AND IFNULL(RC.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0)
	) AS M
		INNER JOIN	ReporteInspeccionActividad RIA 
		ON RIA.NoPlanInspeccion = '$noPlanInspection' AND 
		RIA.SiteId = '$siteId' AND
		RIA.PropuestaTecnicaId = '$propuestaTecnicaId' AND
		RIA.ActividadId = '$actividadId' AND
		RIA.SubActividadId = '$subActividadId' AND
		IFNULL(RIA.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0) AND
		RIA.IdTrazabilidad = M.IdTrazabilidad AND 
		RIA.MaterialId = M.MaterialId AND 
		RIA.Resultado IS NOT NULL
      ''');

      // En caso de que vengan nulos
      if (listMateriales.isEmpty) {
        totalMateriales = 0;
      } else {
        totalMateriales = listMateriales.length;
      }

      // Sección de validaciones

      // if (resultadoIsNotNull.isEmpty) {
      //   color = 'grey';
      //   return color;
      // }
      // if (resultsIsZero.isNotEmpty) {
      //   color = 'red';
      //   return color;
      // }

      // if (totalMateriales == filasDN) {
      //   color = 'green';
      //   return color;
      // }

      if (resultadoIsNotNull.isEmpty) {
        color = 'grey';
        return color;
      } else {
        List<Map<String, dynamic>> filasDNList = await db.rawQuery('''
          SELECT	COUNT(1) AS Total
		      FROM( SELECT RCD.MaterialId,RCD.IdTrazabilidad FROM	ReporteCampoC RC
          INNER JOIN	RCMaterial RCM ON RCM.SiteId = RC.SiteId AND RCM.FolioRC = RC.FolioRC AND RCM.RegBorrado = 0
          INNER JOIN	RCMaterialDet RCD ON RCD.FolioRC = RC.FolioRC AND RCD.RegBorrado = 0
          WHERE	RC.SiteId = '$siteId' AND RC.PropuestaTecnicaId = '$propuestaTecnicaId' AND RC.ActividadId = '$actividadId' 
          AND RC.SubActividadId = '$subActividadId' AND IFNULL(RC.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0)		
          UNION
          SELECT	RCD.MaterialId,RCD.IdTrazabilidad FROM ReporteCampoC RC
          INNER JOIN RCMaterialRes RCM ON RCM.SiteId = RC.SiteId AND RCM.FolioRC = RC.FolioRC AND RCM.RegBorrado = 0
          INNER JOIN RCMaterialResDet RCD ON RCD.FolioRC = RC.FolioRC AND RCD.RegBorrado = 0 WHERE	RC.SiteId = '$siteId' AND RC.PropuestaTecnicaId = '$propuestaTecnicaId' AND RC.ActividadId = '$actividadId'  AND RC.SubActividadId = '$subActividadId' AND IFNULL(RC.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0)) AS M
		      INNER JOIN	ReporteInspeccionActividad RIA 	ON RIA.NoPlanInspeccion = '$noPlanInspection' AND RIA.SiteId = '$siteId' AND	RIA.PropuestaTecnicaId = '$propuestaTecnicaId' AND
		      RIA.ActividadId = '$actividadId' AND RIA.SubActividadId = '$subActividadId' AND IFNULL(RIA.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0) AND RIA.IdTrazabilidad = M.IdTrazabilidad AND 
		      RIA.MaterialId = M.MaterialId AND RIA.Resultado = 1 ''');

        // En caso de que vengan nulos
        if (filasDNList.isEmpty) {
          filasDN = 0;
        } else {
          filasDN = filasDNList[0]['Total'];
        }

        if (totalMateriales == filasDN) {
          color = 'green';
          return color;
        } else {
          List<Map<String, dynamic>> resultsIsZero = await db.rawQuery('''
        WITH M AS (SELECT RCD.MaterialId,RCD.IdTrazabilidad FROM	ReporteCampoC RC
       INNER JOIN	RCMaterial RCM ON RCM.SiteId = RC.SiteId AND RCM.FolioRC = RC.FolioRC AND RCM.RegBorrado = 0
       INNER JOIN	RCMaterialDet RCD ON RCD.FolioRC = RC.FolioRC AND RCD.RegBorrado = 0
       WHERE	RC.SiteId = '$siteId' AND RC.PropuestaTecnicaId = '$propuestaTecnicaId' AND RC.ActividadId = '$actividadId' 
       AND RC.SubActividadId = '$subActividadId' AND IFNULL(RC.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0)		
       UNION
       SELECT	RCD.MaterialId,RCD.IdTrazabilidad FROM ReporteCampoC RC
       INNER JOIN RCMaterialRes RCM ON RCM.SiteId = RC.SiteId AND RCM.FolioRC = RC.FolioRC AND RCM.RegBorrado = 0
       INNER JOIN RCMaterialResDet RCD ON RCD.FolioRC = RC.FolioRC AND RCD.RegBorrado = 0
       WHERE	RC.SiteId = '$siteId' AND RC.PropuestaTecnicaId = '$propuestaTecnicaId' AND RC.ActividadId = '$actividadId' 
       AND RC.SubActividadId = '$subActividadId' AND IFNULL(RC.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0))
       SELECT 1 AS Existe FROM M 
       INNER JOIN ReporteInspeccionActividad RIA  ON RIA.NoPlanInspeccion = '$noPlanInspection' AND RIA.SiteId = '$siteId' AND RIA.PropuestaTecnicaId = '$propuestaTecnicaId' 
       AND RIA.ActividadId = '$actividadId' AND RIA.SubActividadId = '$subActividadId' AND IFNULL(RIA.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0) 
       AND RIA.IdTrazabilidad = M.IdTrazabilidad AND RIA.MaterialId = M.MaterialId AND RIA.Resultado = 0
    ''');
          if (resultsIsZero.isNotEmpty) {
            color = 'red';
            return color;
          }
        }
      }

      return color;
    }
    return color;
  }

  // Función para obtener el avance de la actividades  [HSEQMC].[st_SelAvanceActividades]
  Future<dynamic> fnAvanceActividades(
    String siteId,
    propuestaTecnicaId,
    actividadId,
    subActividadId,
    reprogramacionOTId,
    int usaVolumen,
  ) async {
    var db = await context.database;

    dynamic value;

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    if (usaVolumen == 1) {
      var res = await db.rawQuery('''
		SELECT		CASE WHEN SUM(IFNULL(RCE.Avance,0))>= 100 THEN 100 ELSE SUM(IFNULL(ROUND(RCE.Avance,0),0)) END Porcentaje
		FROM		ReporteCampoC RC  
		INNER JOIN	FoliosPropuestaTecnica F ON F.SiteId = RC.PTSiteId and F.PropuestaTecnicaId = RC.PropuestaTecnicaId AND F.RegBorrado = 0 
		INNER JOIN	PropuestaTecnica PT ON PT.SiteId = RC.PTSiteId AND PT.PropuestaTecnicaId = RC.PropuestaTecnicaId AND PT.Regborrado = 0
		INNER JOIN	RCTiempoEfectivo RCE ON RC.FolioRC = RCE.FolioRC AND RCE.RegBorrado = 0
		WHERE		RC.RegBorrado =  0 AND 
		RC.ActividadId = '$actividadId' AND
		RC.SubActividadId = '$subActividadId' AND
		RC.PropuestaTecnicaId = '$propuestaTecnicaId' AND
		IFNULL(RC.ReprogramacionOTId, 0) = IFNULL($reprogramacionOTId, 0) AND
		RC.SiteId = '$siteId' AND
		RC.FechaReporte <= '$currentDate'
		GROUP BY	RC.PTSiteId,
					RC.PropuestaTecnicaId, 
					RC.ActividadId,
					RC.SubActividadId,
					RC.ReprogramacionOTId,
					RC.AvProgramado	
    ''');

      if (res.isEmpty) {
        value = 0;
      } else {
        value = res[0]['Porcentaje'];
      }
    } else {
      var res = await db.rawQuery('''
		SELECT		ROUND(SUM(CASE WHEN ISNULL(RC.Cantidad,0)*100/CASE WHEN PTSAH.CantidadPU = 0 THEN 1 ELSE PTSAH.CantidadPU END > 100 THEN 100 ELSE ISNULL(RC.Cantidad,0)*100/CASE WHEN PTSAH.CantidadPU = 0 THEN 1 ELSE PTSAH.CantidadPU END END),4) AS Porcentaje
		FROM		ReporteCampoC RC 
		INNER JOIN	FoliosPropuestaTecnica F ON F.SiteId = RC.PTSiteId and F.PropuestaTecnicaId = RC.PropuestaTecnicaId AND F.RegBorrado = 0 
		INNER JOIN	PropuestaTecnica PT ON PT.SiteId = RC.PTSiteId AND PT.PropuestaTecnicaId = RC.PropuestaTecnicaId AND PT.Regborrado = 0
		INNER JOIN	PropuestaTecnicaSubActividadesH PTSAH 
		ON		PTSAH.SiteId = RC.SiteId AND 
					PTSAH.PropuestaTecnicaId = RC.PropuestaTecnicaId AND 
					PTSAH.ActividadId = RC.ActividadId AND 
					PTSAH.SubActividadId = RC.SubActividadId AND 
					ISNULL(rc.ReprogramacionOTId,0) = ISNULL(PTSAH.ReprogramacionOTId,0) AND PTSAH.RegBorrado = 0 
		WHERE		RC.RegBorrado =  0 AND 
					RC.ActividadId = '$actividadId' AND
					RC.SubActividadId = '$subActividadId' AND
					RC.PropuestaTecnicaId = '$propuestaTecnicaId' AND
					ISNULL(RC.ReprogramacionOTId, 0) = ISNULL($reprogramacionOTId, 0) AND
					RC.SiteId = '$siteId' AND
					RC.FechaReporte <= '$currentDate'
		GROUP BY	RC.PTSiteId,
					RC.PropuestaTecnicaId, 
					RC.ActividadId,
					RC.SubActividadId,
					RC.ReprogramacionOTId,
					RC.AvProgramado
    ''');

      if (res.isEmpty) {
        value = 0;
      } else {
        value = res[0]['Porcentaje'];
      }
    }

    return value;
  }

  // Función para obtener la partida interna  [dbo].[fn_GetPartidaInterna]
  Future<String> fnPartidaInterna(dynamic siteId, dynamic propuestaTecnicaId,
      dynamic actividadId, dynamic subActividadId) async {
    var db = await context.database;

    var res = await db.rawQuery('''
     SELECT CASE WHEN IFNULL(PT.TipoPlataformaId,1) = 1 THEN
	  	IFNULL(S.Codigo,'0')  || '.' || IFNULL(SS.Codigo,'0') || '.' || IFNULL(PTA.Numero,'0') || '.' || IFNULL(PTS.Numero,'0')
	    ELSE 
	    IFNULL(Z.Codigo,'0') || '.' || IFNULL(A.Codigo,'0') || '.' || IFNULL(SA.Codigo,'0') || '.' || IFNULL(PTA.Numero,'0') || '.' ||  IFNULL(PTS.Numero,'0')
	    END PartidaInterna
	    FROM PropuestaTecnica AS PT
	    INNER JOIN PropuestaTecnicaActividades AS PTA ON PTA.SiteId = PT.SiteId
	    AND PTA.PropuestaTecnicaId = PT.PropuestaTecnicaId AND PTA.RegBorrado = 0
	    INNER JOIN PropuestaTecnicaSubActividades AS PTS ON PTA.SiteId = PTS.SiteId AND PTA.PropuestaTecnicaId = PTS.PropuestaTecnicaId AND  PTA.ActividadId = PTS.ActividadId AND PTS.RegBorrado = 0
	    LEFT JOIN Sistemas AS S ON S.SistemaId= PTA.SistemaId AND S.RegBorrado = 0
	    LEFT JOIN Zonas AS Z ON Z.ZonaId = PTA.ZonaId AND Z.RegBorrado = 0
	    LEFT JOIN Subsistemas AS SS ON SS.SubSistemaId = PTA.SubSistemaId and SS.RegBorrado = 0
	    LEFT JOIN Areas AS A ON A.AreaId = PTA.ZonaId AND A.RegBorrado = 0
	    LEFT JOIN SubAreas AS SA ON SA.SubAreaId = PTA.SubAreaId AND A.RegBorrado = 0     
	    WHERE PTS.SiteId =  '$siteId' AND PTS.PropuestaTecnicaId =  '$propuestaTecnicaId'
      AND PTS.ActividadId = '$actividadId' AND PTS.SubActividadId = 
      '$subActividadId' AND PT.RegBorrado = 0 LIMIT 1    
    ''');

    if (res.isNotEmpty) {
      return res[0]['PartidaInterna'];
    } else {
      return '';
    }
  }

  Future<String> fnSelDetallesActividades(
      String noPlanInspection,
      String siteId,
      dynamic propuestaTecnicaId,
      dynamic actividadId,
      dynamic subActividadId,
      dynamic reprogramacionOTId,
      int tipo) async {
    final db = await context.database;
    String value = '';

    List<EquiposFnSelDetallesActividadesA> equipos = [
      EquiposFnSelDetallesActividadesA(clave: '1', valor: 'CINTA MÉTRICA'),
      EquiposFnSelDetallesActividadesA(clave: '2', valor: 'REGLA METÁLICA'),
      EquiposFnSelDetallesActividadesA(clave: '3', valor: 'VERNIER'),
      EquiposFnSelDetallesActividadesA(clave: '4', valor: 'BRIDGE CAM GAGE'),
      EquiposFnSelDetallesActividadesA(clave: '5', valor: 'HI-LO GAGE'),
      EquiposFnSelDetallesActividadesA(clave: '6', valor: 'V-WAC GAGE'),
      EquiposFnSelDetallesActividadesA(clave: '7', valor: 'FILLET WELD GAGE'),
      EquiposFnSelDetallesActividadesA(
          clave: '8', valor: 'AMPERIMETRO DE GANCHO'),
      EquiposFnSelDetallesActividadesA(
          clave: '9', valor: 'PIROMETRO INFRARROJO'),
      EquiposFnSelDetallesActividadesA(clave: '10', valor: 'LÁPIZ TÉRMICO'),
      EquiposFnSelDetallesActividadesA(clave: '11', valor: 'ESPEJOS'),
      EquiposFnSelDetallesActividadesA(clave: '12', valor: 'LUPA'),
      EquiposFnSelDetallesActividadesA(clave: '13', valor: 'LINTERNA'),
      EquiposFnSelDetallesActividadesA(clave: '14', valor: 'TERMÓMETRO'),
      EquiposFnSelDetallesActividadesA(clave: '15', valor: 'TERMOPOZO'),
      EquiposFnSelDetallesActividadesA(clave: '16', valor: 'CINTA RÉPLICA'),
      EquiposFnSelDetallesActividadesA(clave: '17', valor: 'MICRÓMETRO'),
      EquiposFnSelDetallesActividadesA(
          clave: '18',
          valor: 'TERMOHIGROMETRO ( MEDIDOR DE HUMEDAD Y TEMPERATURA)'),
      EquiposFnSelDetallesActividadesA(
          clave: '19', valor: 'MEDIDOR DE PELICULA SECA POSITECTOR'),
      EquiposFnSelDetallesActividadesA(clave: '20', valor: 'CINTA PERMACEL'),
      EquiposFnSelDetallesActividadesA(clave: '21', valor: 'NAVAJA'),
      EquiposFnSelDetallesActividadesA(clave: '22', valor: 'MEGGER'),
      EquiposFnSelDetallesActividadesA(clave: '23', valor: 'MULTÍMETRO'),
      EquiposFnSelDetallesActividadesA(
          clave: '24', valor: 'NORDSON MEDIDOR PELICULA HUMEDA'),
      EquiposFnSelDetallesActividadesA(clave: '25', valor: 'YUGO MAGNÉTICO'),
      EquiposFnSelDetallesActividadesA(
          clave: '26', valor: 'FUENTE O EQUIPO DE RT'),
      EquiposFnSelDetallesActividadesA(
          clave: '27', valor: 'LIQUIDOS PENETRANTES')
    ];

    int _reprogramacionOTId =
        reprogramacionOTId == null ? 0 : reprogramacionOTId;

    //INICIA. Variables comunes
    final detalleActividad = await db.query(
      'PIActividadD',
      columns: ['IdentificadorDetalle'],
      where:
          'NoPlanInspeccion = ? AND SiteId = ? AND PropuestaTecnicaId = ? AND ActividadId = ? AND SubActividadId = ? AND IFNULL(ReprogramacionOTId,0) = ? AND Tipo = ? AND RegBorrado = 0',
      whereArgs: [
        noPlanInspection,
        siteId,
        propuestaTecnicaId,
        actividadId,
        subActividadId,
        _reprogramacionOTId,
        tipo
      ],
    );

    String result =
        detalleActividad[0]['IdentificadorDetalle']; //TIA0001|TIA0004
    List<String> claves = result.split('|');
    //FIN. Variables comunes

    //Técnicas de inspección
    if (tipo == 1) {
      String placeHolder = makePlaceholders(claves.length);

      final tecnicas = await db.query('TecnicaInspeccionActividad',
          columns: ['Clave'],
          where:
              'TecnicaInspeccionActividadId IN ($placeHolder) AND RegBorrado = 0',
          whereArgs: claves);

      for (var i = 0; i < tecnicas.length; i++) {
        value = value + tecnicas[i]['Clave'];
        if (i != tecnicas.length - 1) {
          value = value + '\n';
        }
      }
    }

    //Equipos
    if (tipo == 2) {
      for (var i = 0; i < claves.length; i++) {
        var item = equipos.where((element) => element.clave == claves[i]).first;
        value = value + item.valor;
        if (i != claves.length - 1) {
          value = value + '\n';
        }
      }
    }

    //Responsables - Procedimientos - Formatos
    if (tipo == 3 || tipo == 5 || tipo == 6) {
      for (var i = 0; i < claves.length; i++) {
        value = value + claves[i];
        if (i != claves.length - 1) {
          value = value + '\n';
        }
      }
    }

    if (tipo == 4) {
      for (var i = 0; i < claves.length; i++) {
        bool planoDetalle = false;
        var plano = await db.query('Planos',
            columns: ['Nombre'],
            where: 'PlanoId = ? AND RegBorrado = 0',
            whereArgs: [claves[i]]);

        if (plano.isEmpty) {
          planoDetalle = true;

          plano = await db.query('PlanoDetalle',
              columns: ['NumeroPlano', 'Revision', 'Hoja'],
              where: 'PlanoDetalleId = ? AND RegBorrado = 0',
              whereArgs: [claves[i]]);
        }

        if (plano.isNotEmpty) {
          if (planoDetalle) {
            value = value +
                plano[0]['NumeroPlano'] +
                ' Rev. ' +
                plano[0]['Revision'].toString() +
                ' Hoja ' +
                plano[0]['Hoja'].toString();
          } else {
            value = value + plano[0]['Nombre'];
          }

          if (i != claves.length - 1) {
            value = value + '\n';
          }
        }
      }
    }

    if (value == null || value.isEmpty) {
      value = '';
    }

    return value;
  }

  Future<String> fnSelDetallesActividadesA(
      String noPlanInspection, String partida, int tipo) async {
    final db = await context.database;
    String value = '';

    List<EquiposFnSelDetallesActividadesA> equipos = [
      EquiposFnSelDetallesActividadesA(clave: '1', valor: 'CINTA MÉTRICA'),
      EquiposFnSelDetallesActividadesA(clave: '2', valor: 'REGLA METÁLICA'),
      EquiposFnSelDetallesActividadesA(clave: '3', valor: 'VERNIER'),
      EquiposFnSelDetallesActividadesA(clave: '4', valor: 'BRIDGE CAM GAGE'),
      EquiposFnSelDetallesActividadesA(clave: '5', valor: 'HI-LO GAGE'),
      EquiposFnSelDetallesActividadesA(clave: '6', valor: 'V-WAC GAGE'),
      EquiposFnSelDetallesActividadesA(clave: '7', valor: 'FILLET WELD GAGE'),
      EquiposFnSelDetallesActividadesA(
          clave: '8', valor: 'AMPERIMETRO DE GANCHO'),
      EquiposFnSelDetallesActividadesA(
          clave: '9', valor: 'PIROMETRO INFRARROJO'),
      EquiposFnSelDetallesActividadesA(clave: '10', valor: 'LÁPIZ TÉRMICO'),
      EquiposFnSelDetallesActividadesA(clave: '11', valor: 'ESPEJOS'),
      EquiposFnSelDetallesActividadesA(clave: '12', valor: 'LUPA'),
      EquiposFnSelDetallesActividadesA(clave: '13', valor: 'LINTERNA'),
      EquiposFnSelDetallesActividadesA(clave: '14', valor: 'TERMÓMETRO'),
      EquiposFnSelDetallesActividadesA(clave: '15', valor: 'TERMOPOZO'),
      EquiposFnSelDetallesActividadesA(clave: '16', valor: 'CINTA RÉPLICA'),
      EquiposFnSelDetallesActividadesA(clave: '17', valor: 'MICRÓMETRO'),
      EquiposFnSelDetallesActividadesA(
          clave: '18',
          valor: 'TERMOHIGROMETRO ( MEDIDOR DE HUMEDAD Y TEMPERATURA)'),
      EquiposFnSelDetallesActividadesA(
          clave: '19', valor: 'MEDIDOR DE PELICULA SECA POSITECTOR'),
      EquiposFnSelDetallesActividadesA(clave: '20', valor: 'CINTA PERMACEL'),
      EquiposFnSelDetallesActividadesA(clave: '21', valor: 'NAVAJA'),
      EquiposFnSelDetallesActividadesA(clave: '22', valor: 'MEGGER'),
      EquiposFnSelDetallesActividadesA(clave: '23', valor: 'MULTÍMETRO'),
      EquiposFnSelDetallesActividadesA(
          clave: '24', valor: 'NORDSON MEDIDOR PELICULA HUMEDA'),
      EquiposFnSelDetallesActividadesA(clave: '25', valor: 'YUGO MAGNÉTICO'),
      EquiposFnSelDetallesActividadesA(
          clave: '26', valor: 'FUENTE O EQUIPO DE RT'),
      EquiposFnSelDetallesActividadesA(
          clave: '27', valor: 'LIQUIDOS PENETRANTES')
    ];

    //INICIA. Variables comunes
    final detalleActividad = await db.query(
      'DetalleAA',
      columns: ['IdentificadorDetalle'],
      where:
          'NoPlanInspeccion = ? AND Partida = ? AND Tipo = ? AND RegBorrado = 0',
      whereArgs: [noPlanInspection, partida, tipo],
    );

    String result =
        detalleActividad[0]['IdentificadorDetalle']; //TIA0001|TIA0004
    List<String> claves = result.split('|');
    //FIN. Variables comunes

    //Técnicas de inspección
    if (tipo == 1) {
      String placeHolder = makePlaceholders(claves.length);

      final tecnicas = await db.query('TecnicaInspeccionActividad',
          columns: ['Clave'],
          where:
              'TecnicaInspeccionActividadId IN ($placeHolder) AND RegBorrado = 0',
          whereArgs: claves);

      for (var i = 0; i < tecnicas.length; i++) {
        value = value + tecnicas[i]['Clave'];
        if (i != tecnicas.length - 1) {
          value = value + '\n';
        }
      }
    }

    //Equipos
    if (tipo == 2) {
      for (var i = 0; i < claves.length; i++) {
        var item = equipos.where((element) => element.clave == claves[i]).first;
        value = value + item.valor;
        if (i != claves.length - 1) {
          value = value + '\n';
        }
      }
    }

    //Responsables - Procedimientos - Formatos
    if (tipo == 3 || tipo == 5 || tipo == 6) {
      for (var i = 0; i < claves.length; i++) {
        value = value + claves[i];
        if (i != claves.length - 1) {
          value = value + '\n';
        }
      }
    }

    if (tipo == 4) {
      for (var i = 0; i < claves.length; i++) {
        bool planoDetalle = false;
        var plano = await db.query('Planos',
            columns: ['Nombre'],
            where: 'PlanoId = ? AND RegBorrado = 0',
            whereArgs: [claves[i]]);

        if (plano.isEmpty) {
          planoDetalle = true;

          plano = await db.query('PlanoDetalle',
              columns: ['NumeroPlano', 'Revision', 'Hoja'],
              where: 'PlanoDetalleId = ? AND RegBorrado = 0',
              whereArgs: [claves[i]]);
        }

        if (plano.isNotEmpty) {
          if (planoDetalle) {
            value = value +
                plano[0]['NumeroPlano'] +
                ' Rev. ' +
                plano[0]['Revision'].toString() +
                ' Hoja ' +
                plano[0]['Hoja'].toString();
          } else {
            value = value + plano[0]['Nombre'];
          }

          if (i != claves.length - 1) {
            value = value + '\n';
          }
        }
      }
    }

    if (value == null || value.isEmpty) {
      value = '';
    }

    return value;
  }

  Future<String> fnSelEvaluacion(String noRegistro) async {
    // params
    String value;

    final db = await context.database;

    var tblEvaluaciones = await db.rawQuery('''
  SELECT	AR.PruebaContinuidad Evaluacion FROM SistemaRecubrimientoD SRD
	INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.NoRegistro = PA.NoRegistro AND AR.Orden = SRD.Orden AND AR.PruebaContinuidad IS NOT NULL  AND AR.RegBorrado = 0
	WHERE SRD.Recubrimiento = 1 AND SRD.RegBorrado = 0				
	UNION ALL
	SELECT	AR.PruebaAdherencia Evaluacion
	FROM SistemaRecubrimientoD SRD
	INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = '$noRegistro' AND PA.RegBorrado = 0
	INNER JOIN	AplicacionRecubrimientoIPA AR ON AR.NoRegistro = PA.NoRegistro AND AR.Orden = SRD.Orden AND AR.PruebaAdherencia IS NOT NULL  AND AR.RegBorrado = 0
	WHERE SRD.Recubrimiento = 1 AND SRD.RegBorrado = 0
    ''');

    List<TablaEvaluacionesModel> list = tblEvaluaciones.isNotEmpty
        ? tblEvaluaciones
            .map((e) => TablaEvaluacionesModel.fromJson(e))
            .toList()
        : [];

    // Existe
    var existe = list.where((element) => element.evaluacion == 'F/N').toList();

    if (existe.isNotEmpty) {
      value = 'F/N';
    } else {
      value = 'D/N';
    }

    return value;
  }

  Future<String> fnSelDetailSpool(String spool) async {
    String value = '';

    final db = await context.database;
    String sql;
    List<dynamic> arguments;

    sql = '''
      SELECT 		  DISTINCT(PD.NumeroPlano || ' Rev. ' || CAST(PD.Revision AS TEXT) || ' Hoja ' || CAST(PD.Hoja AS TEXT)) Plano
      FROM		    Junta J
      INNER JOIN	PlanoDetalle PD ON PD.PlanoDetalleId = J.PlanoDetalleId AND PD.RegBorrado = 0
      WHERE		    J.SpoolEstructura = ? AND
                  J.RegBorrado = 0
    ''';

    arguments = [spool];

    final res = await db.rawQuery(sql, arguments);
    List<dynamic> values;

    if (res.isNotEmpty) {
      values = res.map((e) => e['Plano']).toList();
    }

    values.forEach((element) {
      value = value + element.toString();
      if (values.indexOf(element) != values.length - 1) {
        value = value + '\n';
      }
    });

    return value;
  }
}
