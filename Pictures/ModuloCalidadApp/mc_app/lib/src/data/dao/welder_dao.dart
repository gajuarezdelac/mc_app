import 'package:mc_app/src/data/dao/consecutive_dao.dart';
import 'package:mc_app/src/data/dao/site_dao.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/src/models/empleado_soldador_not_valid_model.dart';
import 'package:mc_app/src/models/joint_data_welder_model.dart';
import 'package:mc_app/src/models/params/add_card_welder_not_valid_params.dart';
import 'package:mc_app/src/models/params/add_card_welder_params.dart';
import 'package:mc_app/src/models/welder_to_add_model.dart';
import 'package:mc_app/src/models/welding_tab_model.dart';

class WelderDao {
  DBContext context = DBContext();

  // Se agrega el soldador al registro
  Future<AddWelderModelResponse> addFichaSoldador(
      AddCardWelderParams params) async {
    String query;
    String siteId;
    String vigencia;
    String folioSoldadura;
    String folioCuadranteSoldadura;
    String folioZonaSoldadura;
    String folioRegistroSoldadura;
    String folioNoTarjeta;
    String noTarjeta;
    String soldaduraIdFN;
    int wPSRequerido = 0;
    int result;
    int consecutivo;
    int countWelders;
    List<dynamic> values;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);
    WelderToAddModel welderToAdd;
    JointDataWelderModel jointData;

    final db = await context.database;
    final site = SiteDao();
    final consecutive = ConsecutiveDao();

    EmpleadoSoldadorNotValidModel employeeValid;
    
    query = '''
      SELECT S.SoldadorId, CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 THEN
          CASE WHEN E.Apellidos IS NOT NULL THEN E.Nombre || ' ' || E.Apellidos ELSE E.Nombre END
        ELSE EE.Nombre END AS Nombre,
        CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 THEN E.EstaActivo ELSE 1 END AS Activo,
        CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 THEN CAST(E.Ficha AS TEXT(30)) ELSE EE.Ficha END AS Ficha,
        CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 THEN E.PuestoDescripcion ELSE PE.Puesto END AS Categoria,
        strftime('%Y-%m-%d %H:%M:%S.%f', datetime(SWPQ.FechaEvaluacion,'+6 month')) Vigencia
      FROM Soldador S
        LEFT JOIN EmpleadoExterno EE ON EE.EmpleadoExternoId = S.EmpleadoId AND EE.RegBorrado = 0
        LEFT JOIN PuestoExterno PE ON PE.PuestoExternoId = EE.PuestoExternoId AND PE.RegBorrado = 0
        LEFT JOIN Empleados E ON E.EmpleadoId = IFNULL(CAST(S.EmpleadoId AS REAL(18,0)),0) AND E.RegBorrado=0
        LEFT JOIN SoldadorWPQ SWPQ ON SWPQ.SoldadorId = S.SoldadorId AND SWPQ.RegBorrado = 0
        LEFT JOIN WPQ WPQ ON WPQ.WPQId = SWPQ.WPQId AND WPQ.RegBorrado = 0		
      WHERE S.RegBorrado = 0 AND (IFNULL(E.EmpleadoId, 0) <> 0 OR IFNULL(EE.EmpleadoExternoId, '') <> '') 
        AND CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 THEN CAST(E.Ficha AS TEXT(30)) ELSE EE.Ficha END = ?
    ''';

    values = [params.card];

    final welder = await db.rawQuery(query, values);

    if (welder.isEmpty)
      return AddWelderModelResponse(
        message: 'La ficha ingresada no existe!',
        actionResult: 'error',
        empleadoSoldadorNotValidModel: employeeValid,
      );
    else
      welderToAdd = WelderToAddModel.fromJson(welder.first);

    query = '''
     SELECT J.SiteId, J.TipoJuntaId, J.WPSId, SO.SoldaduraId, J.AvanceJuntaId,SO.RegBorrado
     FROM Junta J
     INNER JOIN Soldadura SO ON SO.JuntaId = J.JuntaId 
     AND J.RegBorrado = 0 AND SO.RegBorrado = 0 WHERE	J.JuntaId = ?
     LIMIT 1
    ''';

    values = [params.jointId];

    final jointDataRes = await db.rawQuery(query, values);
    jointData = JointDataWelderModel.fromJson(jointDataRes.first);

    if (welderToAdd.ficha == '' || welderToAdd.ficha == null)
      return AddWelderModelResponse(
        message: 'La ficha ingresada no es correcta',
        actionResult: 'error',
        empleadoSoldadorNotValidModel: employeeValid,
      );
    else if (!welderToAdd.activo && !params.acceptInactiveWelder) {
       employeeValid = EmpleadoSoldadorNotValidModel(
        ficha: welderToAdd.ficha, 
        folioSoldaduraFN: params.consecutiveWeldingFN,
      );
      return AddWelderModelResponse(
        message: 'El empleado no está activo',
        actionResult: 'inactivo',
        empleadoSoldadorNotValidModel: employeeValid,
      );
    }

    query = '''
      SELECT count(S.SoldadorId) Cantidad,
        strftime('%Y-%m-%d %H:%M:%S.%f', datetime(SWPQ.FechaEvaluacion,'+6 month')) Vigencia
      FROM Soldador S
        LEFT JOIN EmpleadoExterno EE ON EE.EmpleadoExternoId = S.EmpleadoId AND EE.RegBorrado = 0
        LEFT JOIN PuestoExterno PE ON PE.PuestoExternoId = EE.PuestoExternoId AND PE.RegBorrado = 0
        LEFT JOIN Empleados E ON E.EmpleadoId = IFNULL(CAST(S.EmpleadoId AS REAL(18,0)),0) AND E.RegBorrado=0
        LEFT JOIN SoldadorWPQ SWPQ ON SWPQ.SoldadorId = S.SoldadorId AND SWPQ.RegBorrado = 0
        LEFT JOIN WPQ WPQ ON WPQ.WPQId = SWPQ.WPQId AND WPQ.RegBorrado = 0		
      WHERE S.RegBorrado = 0 AND (IFNULL(E.EmpleadoId, 0) <> 0 OR IFNULL(EE.EmpleadoExternoId, '') <> '') 
        AND CASE WHEN IFNULL(E.EmpleadoId, 0)<> 0 THEN CAST(E.Ficha AS TEXT(30)) ELSE EE.Ficha END = ?
        AND WPQ.WPSId = ?
    ''';

    values = [params.card, jointData.wPSId];

    List<Map<String, dynamic>> welderCount = await db.rawQuery(query, values);

    wPSRequerido = welderCount[0]['Cantidad'];
    vigencia = welderCount[0]['Vigencia'];

    if (wPSRequerido == 0)
      return AddWelderModelResponse(
        message: 'El soldador indicado no cuenta con el WPS requerido',
        actionResult: 'error',
        empleadoSoldadorNotValidModel: employeeValid,
      );

    DateTime fechaVigencia = formatter.parse(vigencia);

    if (now.isAfter(fechaVigencia)) {
      employeeValid = EmpleadoSoldadorNotValidModel(
        folioSoldadura: folioSoldadura,
        soldadorId: welderToAdd.soldadorId,
        soldaduraId: jointData.soldaduraId,
        siteId: jointData.siteId,
        registroSoldaduraId: '',
        cuadranteSoldaduraId: '',
        zonaSoldaduraId: '',
        noTarjeta: '',
        nombre: welderToAdd.nombre,
        ficha: welderToAdd.ficha,
        categoria: welderToAdd.categoria,
        wPSVigente: false,
        folioSoldaduraFN: params.consecutiveWeldingFN,
        consecutivo: 0,
      );

      return AddWelderModelResponse(
        message: 'Soldador no vigente',
        actionResult: 'no-vigente',
        empleadoSoldadorNotValidModel: employeeValid,
      );
    } else {
      siteId = await site.getSiteId();
      //Se obtienen los nuevos folios
      folioSoldadura =
          await consecutive.getConsecutiveId('EmpleadosSoldadura', siteId);
      folioCuadranteSoldadura =
          await consecutive.getConsecutiveId('CuadranteSoldadura', siteId);
      folioZonaSoldadura =
          await consecutive.getConsecutiveId('ZonaSoldadura', siteId);
      folioRegistroSoldadura =
          await consecutive.getConsecutiveId('RegistroSoldadura', siteId);
      folioNoTarjeta = await consecutive.getConsecutiveId('NoTarjeta', siteId);

      result = await db.insert(
        'CuadranteSoldadura',
        {
          'CuadranteSoldaduraId': folioCuadranteSoldadura,
          'SiteModificacion': siteId,
          'FechaModificacion': currentDate,
        },
      );

      result = await db.insert(
        'ZonaSoldadura',
        {
          'ZonaSoldaduraId': folioZonaSoldadura,
          'SiteModificacion': siteId,
          'FechaModificacion': currentDate,
        },
      );

      result = await db.insert(
        'RegistroSoldadura',
        {
          'RegistroSoldaduraId': folioRegistroSoldadura,
          'CuadranteSoldaduraId': folioCuadranteSoldadura,
          'ZonaSoldaduraId': folioZonaSoldadura,
          'SiteModificacion': siteId,
          'FechaModificacion': currentDate,
        },
      );

      DateFormat formatterCard = DateFormat('yyyyMMdd');
      String currentDateCard = formatterCard.format(now);

      noTarjeta = '$currentDateCard${jointData.siteId}$folioNoTarjeta';

      result = await db.insert(
        'EmpleadosSoldadura',
        {
          'FolioSoldadura': folioSoldadura,
          'SoldadorId': welderToAdd.soldadorId,
          'SoldaduraId': jointData.soldaduraId,
          'JuntaId': params.jointId,
          'RegistroSoldaduraId': folioRegistroSoldadura,
          'NoTarjeta': noTarjeta,
          'Norma': 'PENDIENTE',
          'SiteModificacion': siteId,
          'FechaModificacion': currentDate,
        },
      );

      if (params.consecutiveWeldingFN.isNotEmpty) {
        query = '''
          SELECT S.SoldaduraId, S.Consecutivo
          FROM EmpleadosSoldadura ES
          INNER JOIN Soldadura S ON S.SoldaduraId = ES.SoldaduraId
          WHERE ES.FolioSoldadura = ?
          LIMIT 1
        ''';
        values = [params.consecutiveWeldingFN];

        List<Map<String, dynamic>> dataToUpdate =
            await db.rawQuery(query, values);

        soldaduraIdFN = dataToUpdate[0]['SoldaduraId'];
        consecutivo = dataToUpdate[0]['Consecutivo'];

        result = await db.update(
          'EmpleadosSoldadura',
          {
            'RegBorrado': -1,
            'SiteModificacion': siteId,
            'FechaModificacion': currentDate,
          },
          where: 'FolioSoldadura = ?',
          whereArgs: values,
        );

        final employeesFN = await db.query(
          'EmpleadosSoldadura',
          columns: ['FolioSoldadura'],
          where: 'Norma = ? AND SoldaduraId = ? AND RegBorrado = ?',
          whereArgs: ['F/N', soldaduraIdFN, 0],
          limit: 1,
        );

        if (employeesFN.isEmpty) {
          result = await db.update(
            'Soldadura',
            {
              'CambioMaterial': 'PENDIENTE',
              'Consecutivo': consecutivo + params.consecutiveWelding,
              'SiteModificacion': siteId,
              'FechaModificacion': currentDate,
            },
            where: 'SoldaduraId = ?',
            whereArgs: [soldaduraIdFN],
          );
        }

        result = await db.update(
          'Soldadura',
          {
            'Liberado': 0,
            'CaboId': null,
            'SiteModificacion': siteId,
            'FechaModificacion': currentDate,
          },
          where: 'SoldaduraId = ?',
          whereArgs: [soldaduraIdFN],
        );

        result = await db.update(
          'Junta',
          {
            'Estado': 'REALIZAR_REPARAR',
            'SiteModificacion': siteId,
            'FechaModificacion': currentDate,
          },
          where: 'JuntaId = ?',
          whereArgs: [params.jointId],
        );
      }

      query = '''
      SELECT COUNT(ES.FolioSoldadura) CantidadSoldadores FROM EmpleadosSoldadura  ES
      INNER JOIN Soldadura S ON S.SoldaduraId = ES.SoldaduraId AND S.RegBorrado = ?
      INNER JOIN Junta J ON S.JuntaId = J.JuntaId AND J.RegBorrado = ?
      WHERE J.JuntaId = ? AND ES.RegBorrado = ?
    ''';

      values = [0, 0, params.jointId, 0];
      List<Map<String, dynamic>> welders = await db.rawQuery(query, values);
      countWelders = welders[0]['CantidadSoldadores'];

      //Actualizar el numero de soldadores en la tabla de Avancejunta
      result = await db.update(
        'AvanceJunta',
        {
          'Soldadores': countWelders,
          'SiteModificacion': siteId,
          'FechaModificacion': currentDate,
        },
        where: 'AvanceJuntaId = ?',
        whereArgs: [jointData.avanceJuntaId],
      );

      employeeValid = EmpleadoSoldadorNotValidModel(
        folioSoldadura: folioSoldadura,
        soldadorId: welderToAdd.soldadorId,
        soldaduraId: jointData.soldaduraId,
        siteId: jointData.siteId,
        registroSoldaduraId: folioRegistroSoldadura,
        cuadranteSoldaduraId: folioCuadranteSoldadura,
        zonaSoldaduraId: folioZonaSoldadura,
        noTarjeta: noTarjeta,
        nombre: welderToAdd.nombre,
        ficha: welderToAdd.ficha,
        categoria: welderToAdd.categoria,
        wPSVigente: true,
        folioSoldaduraFN: params.consecutiveWeldingFN,
        consecutivo:
            consecutivo == null ? 0 : consecutivo + params.consecutiveWelding,
      );

      if (result >= 1) {
        return AddWelderModelResponse(
          message: 'Soldador Agregado correctamente!',
          actionResult: 'success',
          empleadoSoldadorNotValidModel: employeeValid,
        );
      }
    }
    return AddWelderModelResponse(
      message: 'Flujo terminado con problemas',
      actionResult: 'error',
      empleadoSoldadorNotValidModel: employeeValid,
    );
  }

  // Firma del soldador manualmente
  Future<int> addWelderSignature(String folioSoldadura) async {
    String siteId;
    String sql;

    var dbClient = await context.database;
    sql = 'SELECT * FROM SiteConfig LIMIT 1';

    List<Map<String, dynamic>> siteIdRes = await dbClient.rawQuery(sql);
    siteId = siteIdRes[0]['SiteId'];
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    var res = await dbClient.rawUpdate('''
    UPDATE EmpleadosSoldadura 
	  SET Firmado = 1,
	  SiteModificacion = '$siteId',
	  FechaModificacion = '$currentDate'
	  WHERE	FolioSoldadura = '$folioSoldadura'
    ''');

    return res;
  }

  Future<EmpleadoSoldadorNotValidModel> addCardWelderWPSNotValid(
      AddCardWelderNotValidParams data) async {
    String siteId;
    String folioSoldadura;
    String folioZonaSoldadura;
    String folioCuadranteSoldadura;
    String folioRegistroSoldadura;
    String folioNoTarjeta;
    String noTarjeta;
    String soldaduraIdFN;
    String query;
    String avanceJuntaId;
    int result = 0;
    int consecutivo;
    int countWelders;
    List<dynamic> values;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);
    EmpleadoSoldadorNotValidModel employeeNotValid;

    final db = await context.database;
    final site = SiteDao();
    final consecutive = ConsecutiveDao();

    siteId = await site.getSiteId();
    //Se obtienen los nuevos folios
    folioSoldadura =
        await consecutive.getConsecutiveId('EmpleadosSoldadura', siteId);
    folioCuadranteSoldadura =
        await consecutive.getConsecutiveId('CuadranteSoldadura', siteId);
    folioZonaSoldadura =
        await consecutive.getConsecutiveId('ZonaSoldadura', siteId);
    folioRegistroSoldadura =
        await consecutive.getConsecutiveId('RegistroSoldadura', siteId);
    folioNoTarjeta = await consecutive.getConsecutiveId('NoTarjeta', siteId);

    // Se crea el Cuadrante de Soldadura
    result = await db.insert(
      'CuadranteSoldadura',
      {
        'CuadranteSoldaduraId': folioCuadranteSoldadura,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
    );
    //Se crea la Zona de Soldadura
    result = await db.insert(
      'ZonaSoldadura',
      {
        'ZonaSoldaduraId': folioZonaSoldadura,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
    );
    //Se crea el Registro de la Soldadura
    result = await db.insert(
      'RegistroSoldadura',
      {
        'RegistroSoldaduraId': folioRegistroSoldadura,
        'CuadranteSoldaduraId': folioCuadranteSoldadura,
        'ZonaSoldaduraId': folioZonaSoldadura,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
    );

    DateFormat formatterCard = DateFormat('yyyyMMdd');
    String currentDateCard = formatterCard.format(now);

    noTarjeta = '$currentDateCard$siteId$folioNoTarjeta';

    //Se crea el Empleado Soldadura
    result = await db.insert(
      'EmpleadosSoldadura',
      {
        'FolioSoldadura': folioSoldadura,
        'SoldadorId': data.welderId,
        'SoldaduraId': data.weldingId,
        'JuntaId': data.jointId,
        'RegistroSoldaduraId': folioRegistroSoldadura,
        'NoTarjeta': noTarjeta,
        'Norma': 'PENDIENTE',
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
    );

    if (data.consecutiveWeldingFN.isNotEmpty) {
      query = '''
        SELECT S.SoldaduraId, S.Consecutivo
        FROM EmpleadosSoldadura ES
        INNER JOIN Soldadura S ON S.SoldaduraId = ES.SoldaduraId
        WHERE ES.FolioSoldadura = ?
      ''';

      values = [data.consecutiveWeldingFN];

      List<Map<String, dynamic>> weldingRes = await db.rawQuery(query, values);

      soldaduraIdFN = weldingRes[0]['SoldaduraId'];
      consecutivo = weldingRes[0]['Consecutivo'];

      result = await db.update(
        'EmpleadosSoldadura',
        {
          'RegBorrado': -1,
          'SiteModificacion': siteId,
          'FechaModificacion': currentDate,
        },
        where: 'FolioSoldadura = ?',
        whereArgs: [data.consecutiveWeldingFN],
      );

      final employeesFN = await db.query(
        'EmpleadosSoldadura',
        columns: ['FolioSoldadura'],
        where: 'Norma = ? AND SoldaduraId = ? AND RegBorrado = ?',
        whereArgs: ['F/N', soldaduraIdFN, 0],
      );
      //Si algún empleado no esta en F/N es que ya se reemplazaron todos los
      //soldadores que estuvieron en F/N, debemos cambiar el campo
      //CambioMaterial a 'PENDIENTE' para que cuando se realiza de nuevo el
      //flujo puedea preguntar si se necesita cambio de material o no
      if (employeesFN.isEmpty) {
        result = await db.update(
          'Soldadura',
          {
            'CambioMaterial': 'PENDIENTE',
            'Consecutivo': consecutivo + data.consecutiveWelding,
            'SiteModificacion': siteId,
            'FechaModificacion': currentDate,
          },
          where: 'SoldaduraId = ?',
          whereArgs: [soldaduraIdFN],
        );
      }

      result = await db.update(
        'Soldadura',
        {
          'Liberado': 0,
          'CaboId': null,
          'SiteModificacion': siteId,
          'FechaModificacion': currentDate,
        },
        where: 'SoldaduraId = ?',
        whereArgs: [soldaduraIdFN],
      );

      result = await db.update(
        'Junta',
        {
          'Estado': 'REALIZAR_REPARAR',
          'SiteModificacion': siteId,
          'FechaModificacion': currentDate,
        },
        where: 'JuntaId = ?',
        whereArgs: [data.jointId],
      );
    }

    query = '''
      SELECT COUNT(ES.FolioSoldadura) CantidadSoldadores FROM EmpleadosSoldadura  ES
      INNER JOIN Soldadura S ON S.SoldaduraId = ES.SoldaduraId AND S.RegBorrado = ?
      INNER JOIN Junta J ON S.JuntaId = J.JuntaId AND J.RegBorrado = ?
      WHERE J.JuntaId = ? AND ES.RegBorrado = ?
    ''';

    values = [0, 0, data.jointId, 0];

    List<Map<String, dynamic>> welders = await db.rawQuery(query, values);
    List<Map<String, dynamic>> avanceJunta = await db.query(
      'Junta',
      columns: ['AvanceJuntaId'],
      where: 'JuntaId = ?',
      whereArgs: [data.jointId],
      limit: 1,
    );

    countWelders = welders[0]['CantidadSoldadores'];
    avanceJuntaId = avanceJunta[0]['AvanceJuntaId'];

    //Actualizar el numero de soldadores en la tabla de Avancejunta
    result = await db.update(
      'AvanceJunta',
      {
        'Soldadores': countWelders,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where: 'AvanceJuntaId = ?',
      whereArgs: [avanceJuntaId],
    );

    employeeNotValid = EmpleadoSoldadorNotValidModel(
      folioSoldadura: folioSoldadura,
      soldadorId: data.welderId,
      soldaduraId: data.weldingId,
      siteId: siteId,
      registroSoldaduraId: folioRegistroSoldadura,
      cuadranteSoldaduraId: folioCuadranteSoldadura,
      zonaSoldaduraId: folioZonaSoldadura,
      noTarjeta: noTarjeta,
      nombre: data.name,
      ficha: data.card,
      categoria: data.category,
      wPSVigente: false,
      folioSoldaduraFN: data.consecutiveWeldingFN,
      consecutivo:
          consecutivo == null ? 0 : consecutivo + data.consecutiveWelding,
      result: result,
    );

    return employeeNotValid;
  }
}
