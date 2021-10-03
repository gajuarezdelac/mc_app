import 'package:intl/intl.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/acceptance_criteria_model.dart';
import 'package:mc_app/src/models/joint_wc_model.dart';
import 'package:mc_app/src/models/params/forming_cs_params.dart';
import 'package:mc_app/src/models/params/require_change_material_model.dart';
import 'package:mc_app/src/models/params/update_welding_detail_params.dart';
import 'package:mc_app/src/models/requireChangeMaterial.dart';
import 'site_dao.dart';
import 'consecutive_dao.dart';

class JointDao {
  DBContext context = DBContext();

  Future<List<JointWCModel>> fetchJointsWC(
    String plainDetailId,
    int frontId,
    String state,
    bool clear,
  ) async {
    String sql;
    int firmaTuberos = -1;
    String firmaCaboConformado = '';
    int firmaSoldadores = -1;
    String firmaCaboSoldadura = '';
    String solicitudPNDEnviada = '';
    String solicitudPNDTerminada = '';
    String pndEnviadaEnProceso = '';
    String pndEnviadaCompletada = '';
    String pndTerminadaEnProceso = '';
    String conformado = '';
    String soldadura = '';
    List<dynamic> values;
    List<JointWCModel> list;

    if (clear) {
      list = [];
    } else {
      if (state == 'CONFORMADO') {
        firmaTuberos = 0;
        firmaCaboConformado = 'PENDIENTE';
      } else if (state == 'REALIZAR_REPARAR') {
        firmaSoldadores = 0;
        firmaCaboSoldadura = 'PENDIENTE';
      } else if (state == 'PND') {
        solicitudPNDEnviada = 'PENDIENTE';
        solicitudPNDTerminada = 'PENDIENTE';
        pndEnviadaEnProceso = 'PROCESO';
        pndTerminadaEnProceso = 'PROCESO';
        pndEnviadaCompletada = 'COMPLETADA';
      } else if (state == 'LIBERADAS') {
        firmaTuberos = 1;
        conformado = 'PENDIENTE';
        firmaSoldadores = 1;
        soldadura = 'PENDIENTE';
        solicitudPNDEnviada = 'COMPLETADA';
        solicitudPNDTerminada = 'COMPLETADA';
      }

      sql = '''
      SELECT J.JuntaId, J.JuntaNo Junta, J.SiteId, D.Descripcion Diametro,
        E.Descripcion Espesor, TJ.Descripcion TipoJunta, WPS.ClaveWPS, 
        J.SpoolEstructura, F.Descripcion Frente, AJ.Tuberos, AJ.FirmaTuberos, 
        AJ.Progreso, C.Liberado ConformadoLiberado, C.Norma InspecVisConformado,
        S.Liberado SoldaduraLiberada, S.Norma InspecVisSoldadura, AJ.Soldadores, 
        AJ.FirmaSoldadores, AJ.SolicitudPNDEnviada, AJ.SolicitudPNDTerminada, 
        C.ConformadoId, CASE WHEN J.FrenteId = 1 THEN PD.ProgresoPatio 
          ELSE PD.ProgresoCostaFuera END AS ProgresoGeneral
      FROM Junta J
        INNER JOIN Diametro D 
      ON J.DiametroId = D.DiametroId AND D.RegBorrado = 0
        INNER JOIN Espesor E
      ON J.EspesorId = E.EspesorId AND E.RegBorrado = 0
        INNER JOIN TipoJunta TJ
      ON J.TipoJuntaId = TJ.TipoJuntaId AND E.RegBorrado = 0
        INNER JOIN WPS 
      ON J.WPSId = WPS.WPSId AND WPS.RegBorrado = 0
        INNER JOIN Frente F 
      ON J.FrenteId = F.FrenteId AND F.RegBorrado = 0
        INNER JOIN AvanceJunta AJ 
      ON J.AvanceJuntaId = AJ.AvanceJuntaId AND AJ.RegBorrado = 0
        INNER JOIN PlanoDetalle PD 
      ON J.PlanoDetalleId = PD.PlanoDetalleId AND PD.RegBorrado = 0		
        LEFT JOIN Conformado C 
      ON  J.JuntaId = C.JuntaId AND C.Activo = 1 AND C.RegBorrado = 0
        LEFT JOIN Soldadura S 
      ON J.JuntaId = S.JuntaId AND S.Activo = 1 AND S.RegBorrado = 0
      WHERE J.RegBorrado = 0
        AND(J.Estado <> 'PENDIENTE' AND J.Estado <> 'CANCELADA')
        AND(J.Estado = ? OR COALESCE(?, '') = '')
        AND(J.PlanoDetalleId = ?)
        AND(J.FrenteId = ?)
        AND(AJ.FirmaTuberos = ? OR COALESCE(?, -1) = -1)
        AND(C.Norma = ? OR COALESCE(?, '') = '')		
        AND(AJ.FirmaSoldadores = ? OR COALESCE(?, -1) = -1)
        AND(S.Norma = ? OR COALESCE(?, '') = '')				
        AND((AJ.SolicitudPNDEnviada = ? OR COALESCE(?, '') = '')
          OR(AJ.SolicitudPNDEnviada = ? OR COALESCE(?, '') = '')
          OR(AJ.SolicitudPNDEnviada = ? OR COALESCE(?, '') = ''))
        AND((AJ.SolicitudPNDTerminada = ? OR COALESCE(?, '') = '')
          OR (AJ.SolicitudPNDTerminada = ? OR COALESCE(?, '') = ''))
        AND(C.Norma <> ? OR COALESCE(?, '') = '')		
        AND(S.Norma <> ? OR COALESCE(?, '') = '')
      ORDER BY J.JuntaNo ASC
    ''';

      values = [
        state,
        state,
        plainDetailId,
        frontId,
        firmaTuberos,
        firmaTuberos,
        firmaCaboConformado,
        firmaCaboConformado,
        firmaSoldadores,
        firmaSoldadores,
        firmaCaboSoldadura,
        firmaCaboSoldadura,
        solicitudPNDEnviada,
        solicitudPNDEnviada,
        pndEnviadaEnProceso,
        pndEnviadaEnProceso,
        pndEnviadaCompletada,
        pndEnviadaCompletada,
        solicitudPNDTerminada,
        solicitudPNDTerminada,
        pndTerminadaEnProceso,
        pndTerminadaEnProceso,
        conformado,
        conformado,
        soldadura,
        soldadura,
      ];

      final db = await context.database;
      final res = await db.rawQuery(sql, values);

      list = res.isNotEmpty
          ? res.map((e) => JointWCModel.fromJson(e)).toList()
          : [];
    }

    return list;
  }

  Future<int> saveFormingCS(FormingCSParams params) async {
    String siteId;
    String newFormingId;
    int result = 0;
    int employeeId;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    final db = await context.database;
    final site = SiteDao();
    final consecutive = ConsecutiveDao();

    if (params.repair) {
      result = await repairJoint(params.jointId);
    } else {
      List<Map<String, dynamic>> employee = await db.query(
        'Empleados',
        columns: ['EmpleadoId'],
        where: 'Ficha = ? AND RegBorrado = ?',
        whereArgs: [params.employeeId, 0],
        limit: 1,
      );

      employeeId =
          employee.isNotEmpty ? employee[0]['EmpleadoId'] : params.employeeId;

      final forming = await db.query(
        'Conformado',
        columns: ['ConformadoId'],
        where: 'JuntaId = ? AND Activo = ? AND RegBorrado = ?',
        whereArgs: [params.jointId, 1, 0],
        limit: 1,
      );

      siteId = await site.getSiteId();

      if (forming.isEmpty) {
        newFormingId = await consecutive.getConsecutiveId('Conformado', siteId);

        result = await db.insert(
          'Conformado',
          {
            'ConformadoId': newFormingId,
            'JuntaId': params.jointId,
            'Consecutivo': 0,
            'Norma': 'PENDIENTE',
            'Liberado': 0,
            'Observaciones': params.comments,
            'FechaInicio': params.initialDate,
            'FechaFin': params.finalDate,
            'Activo': 1,
            'RegBorrado': 0,
            'SiteModificacion': siteId,
            'FechaModificacion': currentDate,
          },
        );
      } else {
        result = await db.update(
          'Conformado',
          {
            'Observaciones': params.comments,
            'FechaInicio': params.initialDate,
            'FechaFin': params.finalDate,
            'SiteModificacion': siteId,
            'FechaModificacion': currentDate,
          },
          where: 'JuntaId = ? AND Activo = ? AND RegBorrado = ?',
          whereArgs: [params.jointId, 1, 0],
        );
      }

      switch (params.action) {
        case 'LIBERAR':
          result = await realeaseForming(
              employeeId, siteId, currentDate, params.jointId);
          break;
        case 'D/N':
          result =
              await dNForming(siteId, employeeId, currentDate, params.jointId);
          break;
        case 'F/N':
          result = await fNForming(employeeId, siteId, currentDate,
              params.jointId, params.reasonFN, params.acceptanceCriteriaId);
          break;
        default:
          break;
      }
    }

    return result;
  }

  Future<int> realeaseForming(
    int employeeId,
    String siteId,
    String currentDate,
    String jointId,
  ) async {
    int result = 0;

    final db = await context.database;

    result = await db.update(
      'Conformado',
      {
        'Liberado': 1,
        'CaboId': employeeId,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where: 'JuntaId = ? AND Activo = ? AND RegBorrado = ?',
      whereArgs: [jointId, 1, 0],
    );

    //Se actualiza el progreso de la Junta
    result = await updateProgressJoint(jointId);

    return result;
  }

  Future<int> dNForming(
    String siteId,
    int employeeId,
    String currentDate,
    String jointId,
  ) async {
    String newWeldingId;
    int result = 0;

    final consecutive = ConsecutiveDao();
    final db = await context.database;

    newWeldingId = await consecutive.getConsecutiveId('Soldadura', siteId);

    result = await db.update(
      'Conformado',
      {
        'Norma': 'D/N',
        'InspectorCCAId': employeeId,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where: 'JuntaId = ? AND Activo = ? AND RegBorrado = ?',
      whereArgs: [jointId, 1, 0],
    );

    result = await db.update(
      'Junta',
      {
        'Estado': 'REALIZAR_REPARAR',
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where: 'JuntaId = ? AND RegBorrado = ?',
      whereArgs: [jointId, 0],
    );

    result = await db.insert(
      'Soldadura',
      {
        'SoldaduraId': newWeldingId,
        'JuntaId': jointId,
        'Norma': 'PENDIENTE',
        'Consecutivo': 0,
        //'FechaCreacion': currentDate,
        'CambioMaterial': 'PENDIENTE',
        'Liberado': 0,
        'Activo': 1,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
    );

    //Se actualiza el progreso de la Junta
    result = await updateProgressJoint(jointId);

    return result;
  }

  Future<int> fNForming(
    int employeeId,
    String siteId,
    String currentDate,
    String jointId,
    String reasonFN,
    List<AcceptanceCriteriaconformadoModel> criterioAceptacionId,
  ) async {
    int result = 0;
    String strCriterioAceptacionId = '';

    final db = await context.database;

    if (criterioAceptacionId != null) {
      criterioAceptacionId.forEach((c) {
        db.insert(
          'CriterioAceptacionAsignacion',
          {
            'CriterioAceptacionId': c.criterioAceptacionId,
            'NombreTabla': 'HSEQMC.Conformado',
            'IdentificadorTabla': jointId,
          },
        );
        strCriterioAceptacionId = strCriterioAceptacionId + '|' + c.criterioAceptacionId;
      });
      strCriterioAceptacionId=strCriterioAceptacionId.substring(1);
    }

    result = await db.update(
      'Conformado',
      {
        'Norma': 'F/N',
        'InspectorCCAId': employeeId,
        'MotivoFN': reasonFN,
        'CriteriosAceptacionId': strCriterioAceptacionId,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where: 'JuntaId = ? AND Activo = ? AND RegBorrado = ?',
      whereArgs: [jointId, 1, 0],
    );

    //Se actualiza el progreso de la Junta
    result = await updateProgressJoint(jointId);

    return result;
  }

  Future<int> updateProgressJoint(String jointId) async {
    String query;
    String plainDetailId;
    String jointAdvanceId;
    int result = 0;
    int progreso;
    int frontId;
    double tieneTuberos;
    double conformadoLiberado;
    double conformadoDN;
    double existenSoldadores;
    double soldaduraLiberada;
    double soldaduraDN;
    double solicitudPND;
    double pND;
    double generalProgress;
    List<dynamic> values;

    final db = await context.database;

    query = '''
      SELECT 1 FROM  Junta J
      JOIN AvanceJunta A ON J.AvanceJuntaId = A.AvanceJuntaId
      WHERE A.Tuberos > ? AND J.JuntaId = ? AND A.RegBorrado = ?
    ''';

    values = [0, jointId, 0];

    final hasPipefitter = await db.rawQuery(query, values);

    //La junta cuenta con tuberos asignados?
    tieneTuberos = hasPipefitter.isNotEmpty ? 1 : 0;

    query = '''
      SELECT 1 FROM Junta J
      INNER JOIN Conformado C ON J.JuntaId = C.JuntaId
      WHERE C.Liberado = ? AND J.JuntaId = ? 
        AND C.Activo = ? AND J.RegBorrado = ?
    ''';

    values = [1, jointId, 1, 0];

    final formingRealeased = await db.rawQuery(query, values);

    //El conformado se encuentra liberado?
    conformadoLiberado = formingRealeased.isNotEmpty ? 1 : 0;

    query = '''
      SELECT 1 FROM Junta J
      INNER JOIN Conformado C ON J.JuntaId = C.JuntaId
      WHERE C.Norma = ? AND J.JuntaId = ? AND C.Activo = ? AND J.RegBorrado = ?
    ''';

    values = ['D/N', jointId, 1, 0];

    final isDN = await db.rawQuery(query, values);

    //El conformado está dentro de norma?
    conformadoDN = isDN.isNotEmpty ? 1 : 0;

    query = '''
      SELECT 1 FROM AvanceJunta A 
      INNER JOIN Junta J ON J.AvanceJuntaId = A.AvanceJuntaId
      WHERE A.Soldadores > ? AND J.JuntaId = ? AND A.RegBorrado = ?
    ''';

    values = [0, jointId, 0];

    final hasWelders = await db.rawQuery(query, values);

    // Existen Soldadores asignados a la Soldadura?
    existenSoldadores = hasWelders.isNotEmpty ? 1 : 0;

    query = '''
      SELECT S.JuntaId FROM Soldadura S
      INNER JOIN Junta J ON S.JuntaId = J.JuntaId 
      WHERE S.Liberado = ?  AND J.JuntaId = ? 
        AND S.Activo = ? AND S.RegBorrado = ?
    ''';

    values = [1, jointId, 1, 0];

    final weldingReleased = await db.rawQuery(query, values);

    //La soldadura está liberada?
    soldaduraLiberada = weldingReleased.isNotEmpty ? 1 : 0;

    query = '''
      SELECT 1 FROM Soldadura S
      INNER JOIN Junta J ON S.JuntaId = J.JuntaId 
      WHERE S.Norma = ?  AND J.JuntaId = ? AND S.Activo = ? AND S.RegBorrado = ?
    ''';

    values = ['D/N', jointId, 1, 0];

    final weldingDN = await db.rawQuery(query, values);

    //La soldadura se encuentra dentro de norma?
    soldaduraDN = weldingDN.isNotEmpty ? 1 : 0;

    query = '''
      SELECT 1 FROM Junta J
      INNER JOIN AvanceJunta AJ
      ON J.AvanceJuntaId = AJ.AvanceJuntaId AND AJ.RegBorrado = 0
      WHERE J.JuntaId = ? AND AJ.SolicitudPNDEnviada = ? AND J.RegBorrado = ?
      LIMIT 1
    ''';

    values = [jointId, 'COMPLETADA', 0];

    final requestNDT = await db.rawQuery(query, values);

    // se ha realizado la solicitud de PND?
    solicitudPND = requestNDT.isNotEmpty ? 1 : 0;

    query = '''
      SELECT 1 FROM Junta J
		  INNER JOIN AvanceJunta AJ
	    ON J.AvanceJuntaId = AJ.AvanceJuntaId AND AJ.RegBorrado = 0
	    WHERE J.JuntaId = ? AND AJ.SolicitudPNDEnviada = ? 
		    AND AJ.SolicitudPNDTerminada = ? AND J.RegBorrado = ?
      LIMIT 1
    ''';

    values = [jointId, 'COMPLETADA', 'COMPLETADA', 0];

    final registerNDT = await db.rawQuery(query, values);

    //Se ha realizado la evaluación de PND's?
    pND = registerNDT.isNotEmpty ? 1 : 0;

    query = '''
      SELECT 1 FROM AvanceJunta A 
      JOIN Junta J ON J.AvanceJuntaId = A.AvanceJuntaId
      WHERE A.PNDs > ? AND J.JuntaId = ? AND A.RegBorrado = ?
    ''';

    values = [0, jointId, 0];

    final appliesNDT = await db.rawQuery(query, values);

    if (appliesNDT.isNotEmpty) {
      progreso = ((tieneTuberos +
                  conformadoDN +
                  conformadoLiberado +
                  existenSoldadores +
                  soldaduraDN +
                  soldaduraLiberada +
                  solicitudPND +
                  pND) *
              (100.0 / 8.0))
          .round();
    } else {
      progreso = ((tieneTuberos +
                  conformadoDN +
                  conformadoLiberado +
                  existenSoldadores +
                  soldaduraDN +
                  soldaduraLiberada) *
              (100.0 / 6.0))
          .round();
    }

    List<Map<String, dynamic>> jointAdvanceIdRes = await db.query(
      'Junta',
      columns: ['AvanceJuntaId'],
      where: 'JuntaId = ? AND RegBorrado = 0',
      whereArgs: [jointId],
    );
    jointAdvanceId = jointAdvanceIdRes[0]['AvanceJuntaId'];

    query = '''
      UPDATE AvanceJunta SET Progreso = ? 
      WHERE AvanceJuntaId = ? AND RegBorrado = ?
    ''';

    values = [progreso, jointAdvanceId, 0];

    // Se actualiza el progreso de la Junta
    result = await db.rawUpdate(query, values);

    List<Map<String, dynamic>> joint = await db.query(
      'Junta',
      columns: ['PlanoDetalleId', 'FrenteId'],
      where: 'JuntaId = ? AND RegBorrado = ?',
      whereArgs: [jointId, 0],
    );

    plainDetailId = joint[0]['PlanoDetalleId'];
    frontId = joint[0]['FrenteId'];

    query = '''
      SELECT ROUND(AVG(AJ.Progreso), 0) Progreso
      FROM Junta J
      INNER JOIN AvanceJunta  AJ ON AJ.AvanceJuntaId =J.AvanceJuntaId
      LEFT JOIN Frente F ON  J.FrenteId  = F.FrenteId
      LEFT JOIN PlanoDetalle  P ON P.PlanoDetalleId = J.PlanoDetalleId
      WHERE J.RegBorrado = ? AND(J.Estado <> ? AND J.Estado <> ?)
      AND  J.PlanoDetalleId = ? AND J.FrenteId = ?
    ''';

    values = [0, 'PENDIENTE', 'CANCELADA', plainDetailId, frontId];

    List<Map<String, dynamic>> generalProgressRes =
        await db.rawQuery(query, values);

    generalProgress = generalProgressRes[0]['Progreso'];

    if (frontId == 1) {
      result = await db.update(
        'PlanoDetalle',
        {'ProgresoPatio': generalProgress},
        where: 'PlanoDetalleId = ? AND RegBorrado = 0',
        whereArgs: [plainDetailId],
      );
    } else {
      result = await db.update(
        'PlanoDetalle',
        {'ProgresoCostaFuera': generalProgress},
        where: 'PlanoDetalleId = ? AND RegBorrado = 0',
        whereArgs: [plainDetailId],
      );
    }

    return result;
  }

  Future<RequireChangeMaterialResponse> requiresChangeMaterial(
      RequireChangeMaterialModel params) async {
    int result = 0;
    String newJoint;
    String siteId;
    String sql;

    final db = await context.database;

    sql = 'SELECT SiteId FROM SiteConfig LIMIT 1';

    List<Map<String, dynamic>> siteIdRes = await db.rawQuery(sql);
    siteId = siteIdRes[0]['SiteId'];

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    //Método para rembrar una junta
    result = await renameJoint(params.jointId);

    if (params.requiresChangeMaterial) {
      sql = '''
              UPDATE Soldadura
              SET CambioMaterial = 'APLICA',
                SiteModificacion = '$siteId',
                FechaModificacion = '$currentDate'
              WHERE SoldaduraId = '${params.weldingId}'
            ''';

      //Se realiza el proceso de cambio de material
      result = await changeMaterials(params.jointId);
    } else {
      sql = '''
              UPDATE Soldadura
              SET CambioMaterial = 'NO APLICA',
                SiteModificacion = '$siteId',
                FechaModificacion = '$currentDate'
              WHERE SoldaduraId = '${params.weldingId}'
            ''';
    }

    List<Map<String, dynamic>> itemJoint = await db.query(
      'Junta',
      columns: ['JuntaNo'],
      where: 'JuntaId = ?',
      whereArgs: [params.jointId],
      limit: 1,
    );

    newJoint = itemJoint[0]['JuntaNo'];
    result = await db.rawUpdate(sql);

    return RequireChangeMaterialResponse(joint: newJoint, rowsAffected: result);
  }

  Future<int> renameJoint(String jointId) async {
    int result = 0;
    int consecutive;
    String query;
    String siteId;
    String jointNoOrigin;
    String nuevaJuntaFNId;
    String nuevoEmpleadosSoldaduraFNId;

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    final db = await context.database;
    final siteDao = SiteDao();
    final consecutiveDao = ConsecutiveDao();

    //Obtiene el SiteId
    siteId = await siteDao.getSiteId();
    //Obtiene el nuevo ConsecutivoFolio a insertar
    nuevaJuntaFNId = await consecutiveDao.getConsecutiveId('JuntaFN', siteId);

    query = '''
            INSERT INTO JuntaFN (
              JuntaFNId, JuntaId, JuntaNo, ConformadoId, SoldaduraId, SiteModificacion, FechaModificacion) 
            VALUES (
              '$nuevaJuntaFNId', '$jointId', (SELECT JuntaNo FROM Junta WHERE JuntaId = '$jointId'),
              (SELECT ConformadoId FROM Conformado WHERE JuntaId = '$jointId' AND Activo = 1),
              (SELECT SoldaduraId FROM Soldadura WHERE JuntaId = '$jointId' AND Activo = 1),
              '$siteId', '$currentDate')
          ''';

    result = await db.rawInsert(query);

    final weldingActive = await db.query(
      'Soldadura',
      columns: ['SoldaduraId'],
      where: 'JuntaId = ? AND Activo = ?',
      whereArgs: [jointId, 1],
    );

    if (weldingActive.isNotEmpty) {
      query = '''
              SELECT FolioSoldadura FROM EmpleadosSoldadura AS ES 
              LEFT JOIN Soldadura AS S ON ES.SoldaduraId = S.SoldaduraId 
              WHERE S.JuntaId = '$jointId' AND ES.RegBorrado = 0
            ''';

      List<Map<String, dynamic>> consecutivesWelding = await db.rawQuery(query);

      if (consecutivesWelding.isNotEmpty) {
        await Future.forEach(consecutivesWelding, (item) async {
          //Obtiene el nuevo ConsecutivoFolio a insertar
          nuevoEmpleadosSoldaduraFNId = await consecutiveDao.getConsecutiveId(
            'EmpleadosSoldaduraFN',
            siteId,
          );

          query = '''
                  INSERT INTO EmpleadosSoldaduraFN (
                    EmpleadosSoldaduraFNId, JuntaFNId, FolioSoldadura, SiteModificacion, FechaModificacion)
                  VALUES (
                    '$nuevoEmpleadosSoldaduraFNId', '$nuevaJuntaFNId', '${item['FolioSoldadura']}', '$siteId', '$currentDate')
                ''';

          result = await db.rawInsert(query);
        });
      }
    }

    List<Map<String, dynamic>> originalJoint = await db.query(
      'Junta',
      columns: ['Consecutivo', 'JuntaNoOrigen'],
      where: 'JuntaId = ?',
      whereArgs: [jointId],
      limit: 1,
    );

    consecutive = originalJoint[0]['Consecutivo'];
    jointNoOrigin = originalJoint[0]['JuntaNoOrigen'];

    switch (consecutive) {
      case 0:
        jointNoOrigin = '$jointNoOrigin R';
        break;
      case 1:
        jointNoOrigin = '$jointNoOrigin M';
        break;
      case 2:
        jointNoOrigin = '$jointNoOrigin MM';
        break;
      case 3:
        jointNoOrigin = '$jointNoOrigin MMM';
        break;
      default:
        jointNoOrigin = '$jointNoOrigin M ${consecutive.toString()}';
        break;
    }

    query = '''
            UPDATE Junta 
            SET JuntaNo = '$jointNoOrigin', Consecutivo = ($consecutive + 1),
            SiteModificacion='$siteId',
            FechaModificacion = '$currentDate'
            WHERE JuntaId = '$jointId'
          ''';

    result = await db.rawUpdate(query);

    return result;
  }

  Future<int> changeMaterials(String jointId) async {
    int result;
    String siteId;
    String query;
    String newFormingId;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    final db = await context.database;
    final siteDao = SiteDao();
    final consecutiveDao = ConsecutiveDao();

    siteId = await siteDao.getSiteId();

    //Limpiar EmpleadosSoldadura
    query = '''
            UPDATE EmpleadosSoldadura 
            SET RegBorrado = -1, SiteModificacion = '$siteId', FechaModificacion = '$currentDate' 
            WHERE SoldaduraId IN (SELECT SoldaduraId FROM Soldadura WHERE JuntaId = '$jointId') AND RegBorrado = 0
          ''';

    result = await db.rawUpdate(query);

    //Limpiar Soldadura
    query = '''
            UPDATE Soldadura 
            SET RegBorrado = -1, Activo = 0, SiteModificacion = '$siteId', FechaModificacion = '$currentDate' 
            WHERE JuntaId = '$jointId' AND RegBorrado = 0 AND Activo = 1
          ''';

    result = await db.rawUpdate(query);

    //Limpiar Conformado
    query = '''
            UPDATE Conformado
            SET RegBorrado = -1, Activo = 0, SiteModificacion = '$siteId', FechaModificacion = '$currentDate' 
            WHERE JuntaId = '$jointId' AND RegBorrado = 0 AND Activo = 1
          ''';

    result = await db.rawUpdate(query);

    //Calcular el folio a insertar del nuevo conformado
    newFormingId = await consecutiveDao.getConsecutiveId('Conformado', siteId);

    // Se crea el nuevo conformado
    query = '''
            INSERT INTO Conformado (
              ConformadoId, JuntaId, Consecutivo, Norma, Activo, RegBorrado, SiteModificacion, FechaModificacion)
            VALUES ('$newFormingId', '$jointId', 0, 'PENDIENTE', 1, 0, '$siteId', '$currentDate')
          ''';

    result = await db.rawInsert(query);

    //Reiniciar valores AvanceJunta
    query = '''
            UPDATE AvanceJunta 
            SET Tuberos=0, Soldadores=0, Progreso=0, FirmaTuberos=0, FirmaSoldadores=0,
            SolicitudPNDEnviada='PENDIENTE', SolicitudPNDTerminada='PENDIENTE',
            SiteModificacion = '$siteId', FechaModificacion = '$currentDate'
            WHERE AvanceJuntaId = (SELECT AvanceJuntaId FROM Junta WHERE JuntaId = '$jointId')
          ''';

    result = await db.rawUpdate(query);

    //Actualizar Junta
    result = await db.update(
      'Junta',
      {
        'Estado': 'CONFORMADO',
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where: 'JuntaId = ?',
      whereArgs: [jointId],
    );

    return result;
  }

  //Representa al SP st_UpdRegistroSoldadura
  Future<int> updateWeldingDetail(
      List<UpdateWeldingDetailParams> params) async {
    String siteId;
    int result = 0;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    final db = await context.database;
    final site = SiteDao();

    if (params.isNotEmpty) {
      siteId = await site.getSiteId();

      params.forEach((item) async {
        //Valida si existe el Registro de Soldadura
        final registroSoldaduraRes = await db.query(
          'RegistroSoldadura',
          columns: ['RegistroSoldaduraId'],
          where: 'RegistroSoldaduraId = ?',
          whereArgs: [item.registroSoldaduraId],
        );

        //Actualiza el RegistroSoldadura si existe
        if (registroSoldaduraRes.isNotEmpty) {
          result = await db.update(
            'RegistroSoldadura',
            {
              'Fondeo': item.fondeo ? 1 : 0,
              'PasoCaliente': item.pasoCaliente ? 1 : 0,
              'Refresco1': item.refresco1 ? 1 : 0,
              'Refresco2': item.refresco2 ? 1 : 0,
              'Refresco3': item.refresco3 ? 1 : 0,
              'Refresco4': item.refresco4 ? 1 : 0,
              'Refresco5': item.refresco5 ? 1 : 0,
              'Refresco6': item.refresco6 ? 1 : 0,
              'Vista': item.vista ? 1 : 0,
              'LongitudSoldada': item.longitudSoldada,
              'Observaciones': item.observaciones,
              'OtrosElementos': item.otrosElementos,
              'FechaInicio': item.fechaInicio,
              'FechaFin': item.fechaFin,
              'SiteModificacion': siteId,
              'FechaModificacion': currentDate,
            },
            where: 'RegistroSoldaduraId = ?',
            whereArgs: [item.registroSoldaduraId],
          );
        }

        //Valida si existe el registro en CuadreSoldadura
        final cuadranteSoldaduraRes = await db.query(
          'CuadranteSoldadura',
          columns: ['CuadranteSoldaduraId'],
          where: 'CuadranteSoldaduraId = ?',
          whereArgs: [item.cuadranteSoldaduraId],
        );

        //Actualiza el CuadranteSoldadura
        if (cuadranteSoldaduraRes.isNotEmpty) {
          result = await db.update(
            'CuadranteSoldadura',
            {
              'Cuadrante1': item.cuadrante1 ? 1 : 0,
              'Cuadrante2': item.cuadrante2 ? 1 : 0,
              'Cuadrante3': item.cuadrante3 ? 1 : 0,
              'Cuadrante4': item.cuadrante4 ? 1 : 0,
              'SiteModificacion': siteId,
              'FechaModificacion': currentDate,
            },
            where: 'CuadranteSoldaduraId = ?',
            whereArgs: [item.cuadranteSoldaduraId],
          );
        }

        //Valida si existe el registro en ZonaSoldadura
        final zonaSoldaduraRes = await db.query(
          'ZonaSoldadura',
          columns: ['ZonaSoldaduraId'],
          where: 'ZonaSoldaduraId = ?',
          whereArgs: [item.zonaSoldaduraId],
        );

        //Actualiza la ZonaSoldadura
        if (zonaSoldaduraRes.isNotEmpty) {
          result = await db.update(
            'ZonaSoldadura',
            {
              'ZonaA': item.zonaA ? 1 : 0,
              'ZonaB': item.zonaB ? 1 : 0,
              'ZonaC': item.zonaC ? 1 : 0,
              'ZonaD': item.zonaD ? 1 : 0,
              'ZonaE': item.zonaE ? 1 : 0,
              'ZonaF': item.zonaF ? 1 : 0,
              'ZonaG': item.zonaG ? 1 : 0,
              'ZonaH': item.zonaH ? 1 : 0,
              'ZonaV': item.zonaV ? 1 : 0,
              'SiteModificacion': siteId,
              'FechaModificacion': currentDate,
            },
            where: 'ZonaSoldaduraId = ?',
            whereArgs: [item.zonaSoldaduraId],
          );
        }
      });
    }

    return result;
  }

  Future<int> repairJoint(String jointId) async {
    String formingId;
    String advanceJointId;
    String newFormingId;
    String siteId;
    int result = 0;
    int consecutiveId;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    final db = await context.database;
    final site = SiteDao();
    final consecutive = ConsecutiveDao();

    List<Map<String, dynamic>> formingRes = await db.query(
      'Conformado',
      columns: ['ConformadoId', 'Consecutivo'],
      where: 'JuntaId = ? AND Activo = 1 AND RegBorrado = 0',
      whereArgs: [jointId],
      limit: 1,
    );

    List<Map<String, dynamic>> advanceJointRes = await db.query(
      'Junta',
      columns: ['AvanceJuntaId'],
      where: 'JuntaId = ? AND RegBorrado = 0',
      whereArgs: [jointId],
      limit: 1,
    );

    formingId = formingRes[0]['ConformadoId'];
    advanceJointId = advanceJointRes[0]['AvanceJuntaId'];
    consecutiveId = formingRes[0]['Consecutivo'] + 1;
    siteId = await site.getSiteId();

    //Se eliminan los volúmenes de trazabilidad
    result = await db.update(
      'VolumenTrazabilidad',
      {
        'RegBorrado': -1,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where: 'ConformadoId = ? AND RegBorrado = 0',
      whereArgs: [formingId],
    );

    //Se eliminan los tuberos
    result = await db.update(
      'EmpleadosConformado',
      {
        'RegBorrado': -1,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where: 'ConformadoId = ? AND RegBorrado = 0',
      whereArgs: [formingId],
    );

    //Se elimina el Conformado
    result = await db.update(
      'Conformado',
      {
        'RegBorrado': -1,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where: 'JuntaId = ? AND Activo = 1 AND RegBorrado = 0',
      whereArgs: [jointId],
    );

    //Se reinicia el avance de la Junta
    result = await db.update(
      'AvanceJunta',
      {
        'Tuberos': 0,
        'Progreso': 0,
        'FirmaTuberos': 0,
        'SolicitudPNDEnviada': 'PENDIENTE',
        'SolicitudPNDTerminada': 'PENDIENTE',
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where: 'AvanceJuntaId = ? AND RegBorrado = ?',
      whereArgs: [advanceJointId, 0],
    );

    newFormingId = await consecutive.getConsecutiveId('Conformado', siteId);

    //Se crea el nuevo conformado
    result = await db.insert(
      'Conformado',
      {
        'ConformadoId': newFormingId,
        'JuntaId': jointId,
        'Trazabilidad1Id': '',
        'Trazabilidad2Id': '',
        'Consecutivo': consecutiveId,
        'Norma': 'PENDIENTE',
        'Liberado': 0,
        'Observaciones': '',
        'FechaInicio': null,
        'FechaFin': null,
        'Activo': 1,
        'MotivoFN': '',
        'RegBorrado': 0,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
    );

    return result;
  }
}
