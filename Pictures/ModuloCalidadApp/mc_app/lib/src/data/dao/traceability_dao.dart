import 'package:intl/intl.dart';
import 'package:mc_app/src/data/dao/site_dao.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/existing_element_model.dart';
import 'package:mc_app/src/models/joint_traceability_model.dart';
import 'package:mc_app/src/models/params/joint_traceability_params.dart';
import 'package:mc_app/src/models/params/traceability_delete_params_model.dart';
import 'package:mc_app/src/models/params/traceability_params_model.dart';
import 'package:mc_app/src/models/traceability_by_joint_model.dart';
import 'package:mc_app/src/models/traceability_model.dart';

class TraceabilityDao {
  DBContext context = DBContext();

  // [HSEQMC].[st_SelObras]
  // SP para traer las obras al modal donde se visualiza la trazabilidad
  Future<List<WorkTraceability>> fetchWorkTraceabilty(String contratoId) async {
    final db = await context.database;

    final res = await db.query(
      'Obras',
      columns: ['ObraId', 'Nombre', 'OT'],
      where: 'ContratoId = ? AND RegBorrado = ?',
      whereArgs: [contratoId, 0],
    );

    List<WorkTraceability> list = res.isNotEmpty
        ? res.map((e) => WorkTraceability.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<TraceabilityModel> fetchTraceabilityById(String traceabilityId) async {
    final db = await context.database;

    String sql = '''
      SELECT		  T.IdElementoExistente IdTrazabilidad, 
					        'NA' Material, 
					        999999.0 Cantidad, 
					        T.UM, 
					        T.MaterialDescrBreve
		  FROM		    ElementoExistente T
		  WHERE		    T.RegBorrado = 0 AND 
                  T.IdElementoExistente = ?
    ''';

    final res = await db.query(
      'Trazabilidad',
      columns: [
        'IdTrazabilidad',
        'Material',
        'Cantidad',
        'UM',
        'MaterialDescrBreve',
      ],
      where: 'RegBorrado = ? AND IdTrazabilidad = ?',
      whereArgs: [0, traceabilityId],
      limit: 1,
    );

    final res2 = await db.rawQuery(sql, [traceabilityId]);

    if (res.isEmpty && res2.isEmpty)
      throw ('La trazabilidad $traceabilityId no es correcta, favor de verificar.');

    TraceabilityModel traceability =
        TraceabilityModel.fromJson(res.isEmpty ? res2.first : res.first);

    return traceability;
  }

  Future<TraceabilityByJointModel> fetchTraceabilityByJoint(
      String jointId, bool isTraceabilityOne) async {
    String sql;
    List<dynamic> values;

    sql = '''
      SELECT      T.IdTrazabilidad, 
                  T.Material, 
                  V.CantidadUsada, 
                  T.UM, 
                  T.MaterialDescrBreve 
      FROM        VolumenTrazabilidad V
      INNER JOIN  Trazabilidad T ON V.IdTrazabilidad = T.IdTrazabilidad AND T.RegBorrado = 0
      INNER JOIN  Conformado C ON V.ConformadoId = C.ConformadoId AND C.Activo = 1 AND C.RegBorrado = 0
      WHERE       V.RegBorrado = 0 AND C.JuntaId = ? AND V.Trazabilidad1 = ?
      LIMIT 1
    ''';
    values = [jointId, isTraceabilityOne ? 1 : 0];

    final db = await context.database;
    final res = await db.rawQuery(sql, values);

    TraceabilityByJointModel traceability =
        res.isNotEmpty ? TraceabilityByJointModel.fromJson(res.first) : null;

    if (traceability == null) {
      sql = '''
        SELECT      T.IdElementoExistente IdTrazabilidad, 
                    'N/A' Material, 
                    V.CantidadUsada, 
                    T.UM, 
                    T.MaterialDescrBreve 
        FROM        VolumenTrazabilidad V
        INNER JOIN  ElementoExistente T ON V.IdTrazabilidad = T.IdElementoExistente AND T.RegBorrado = 0
        INNER JOIN  Conformado C ON V.ConformadoId = C.ConformadoId AND C.Activo = 1 AND C.RegBorrado = 0
        WHERE       V.RegBorrado = 0 AND C.JuntaId = ? AND V.Trazabilidad1 = ?
        LIMIT 1
      ''';

      final res2 = await db.rawQuery(sql, values);

      traceability = res2.isNotEmpty
          ? TraceabilityByJointModel.fromJson(res2.first)
          : null;
    }

    return traceability;
  }

  Future<int> setVolume(TraceabilityParamsModel params) async {
    int result = 0;

    result = params.isOrigin
        ? await setVolumeOrigin(params)
        : await setVolumeNotOrigin(params);

    return (result);
  }

  // HSEQMC.st_InsVolumenTrazabilidad --setVolumeOrigin
  Future<int> setVolumeOrigin(TraceabilityParamsModel params) async {
    String query;
    String formingId;
    String siteId;
    int result = 0;
    double actualCuantity;
    List<dynamic> values;

    final site = SiteDao();
    final db = await context.database;

    query = '''
    SELECT	T.Cantidad - SUM(IFNULL(v.CantidadUsada, 0)) AS Cantidad
    FROM		(
    	SELECT		IdTrazabilidad,
    				SUM(Cantidad) Cantidad
    	FROM		Trazabilidad
    	WHERE		RegBorrado = 0
    	GROUP BY	IdTrazabilidad
    	UNION ALL
    	SELECT		IdElementoExistente IdTrazabilidad,
    				CAST(999999 AS REAL) Cantidad
    	FROM		ElementoExistente
    	WHERE		RegBorrado = 0
    	GROUP BY	IdElementoExistente
    ) T
    LEFT JOIN	VolumenTrazabilidad V
    ON			T.IdTrazabilidad = V.IdTrazabilidad AND
    			V.Original = 1 AND
    			V.RegBorrado = 0
    LEFT JOIN	Conformado C ON C.ConformadoId = V.ConformadoId
    WHERE		T.IdTrazabilidad = ? AND
    			(C.Activo = 1 OR C.Activo IS NULL) AND
    			(C.RegBorrado = 0 OR C.RegBorrado IS NULL)
    GROUP BY	T.Cantidad
    ''';

    values = [params.idTrazabilidad];

    List<Map<String, dynamic>> actualCuantityRes =
        await db.rawQuery(query, values);

    actualCuantity = actualCuantityRes[0]['Cantidad'];

    if (params.cantidadUsada > actualCuantity) {
      if (actualCuantity == 0) {
        throw ('Trazabilidad agotada');
      } else {
        throw ('''La cantidad utilizada (${params.cantidadUsada})
          para la trazabilidad, es superior a la disponible($actualCuantity)''');
      }
    } else {
      // En caso de que la cantidad requerida no sea mayor a la cantidad actual
      List<Map<String, dynamic>> formingIdRes = await db.query(
        'Conformado',
        columns: ['ConformadoId'],
        where: 'JuntaId = ? AND Activo = ? AND RegBorrado = ?',
        whereArgs: [params.juntaId, 1, 0],
        limit: 1,
      );

      formingId = formingIdRes[0]['ConformadoId'];

      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
      String currentDate = formatter.format(now);
      siteId = await site.getSiteId();

      query = '''
        UPDATE Conformado
        SET ${params.trazabilidad1 ? 'Trazabilidad1Id' : 'Trazabilidad2Id'} = ?,
          SiteModificacion = ?, FechaModificacion = ?
        WHERE JuntaId = ? AND Activo = 1 AND RegBorrado = 0
      ''';

      values = [params.idTrazabilidad, siteId, currentDate, params.juntaId];
      result =
          await db.rawUpdate(query, values); // Se actualiza la trazabilidad

      values = [formingId, params.idTrazabilidad, params.trazabilidad1 ? 1 : 0];

      final existsVolume = await db.query(
        'VolumenTrazabilidad',
        columns: ['IdTrazabilidad'],
        where: 'ConformadoId = ? AND IdTrazabilidad = ? AND Trazabilidad1 = ?',
        whereArgs: values,
      );

      // Validamos la existencia
      if (existsVolume.isNotEmpty) {
        values = [
          formingId,
          params.idTrazabilidad,
          params.trazabilidad1 ? 1 : 0,
        ];

        result = await db.update(
          'VolumenTrazabilidad',
          {
            'CantidadUsada': params.cantidadUsada,
            'RegBorrado': 0,
            'SiteModificacion': siteId,
            'FechaModificacion': currentDate,
          },
          where:
              'ConformadoId = ? AND IdTrazabilidad = ? AND Trazabilidad1 = ?',
          whereArgs: values,
        );
      } else {
        result = await db.insert(
          'VolumenTrazabilidad',
          {
            'ConformadoId': formingId,
            'IdTrazabilidad': params.idTrazabilidad,
            'CantidadUsada': params.cantidadUsada,
            'Trazabilidad1': params.trazabilidad1 ? 1 : 0,
            'SiteModificacion': siteId,
            'FechaModificacion': currentDate,
          },
        );
      }
    }

    return result;
  }

  // HSEQMC.st_InsTrazabilidadVolumen ---setVolumeNotOrigin
  Future<int> setVolumeNotOrigin(TraceabilityParamsModel params) async {
    String query;
    String formingId;
    String siteId;
    String currentDate;
    int result = 0;
    List<dynamic> values;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');

    final site = SiteDao();
    final db = await context.database;

    // Tener en cuenta que en SQL Server para esta consulta no se requiere el campo activo
    List<Map<String, dynamic>> formingIdRes = await db.query(
      'Conformado',
      columns: ['ConformadoId'],
      where: 'JuntaId = ? AND Activo = ? AND RegBorrado = ?',
      whereArgs: [params.juntaId, 1, 0],
      limit: 1,
    );

    formingId = formingIdRes[0]['ConformadoId'];
    siteId = await site.getSiteId();
    currentDate = formatter.format(now);

    query = '''
      UPDATE Conformado
      SET ${params.trazabilidad1 ? 'Trazabilidad1Id' : 'Trazabilidad2Id'} = ?,
        SiteModificacion = ?, FechaModificacion = ?
      WHERE JuntaId = ? AND Activo = 1 AND RegBorrado = 0
    ''';
    values = [params.idTrazabilidad, siteId, currentDate, params.juntaId];
    result = await db.rawUpdate(query, values); // Se actualiza la junta

    final existVolume = await db.query(
      'VolumenTrazabilidad',
      columns: ['IdTrazabilidad'],
      where: 'ConformadoId = ? AND IdTrazabilidad = ? AND Trazabilidad1 = ?',
      whereArgs: [
        formingId,
        params.idTrazabilidad,
        params.trazabilidad1 ? 1 : 0,
      ],
      limit: 1,
    );

    if (existVolume.isNotEmpty) {
      result = await db.update(
        'VolumenTrazabilidad',
        {
          'CantidadUsada': params.cantidadUsada,
          'JuntaId': params.juntaIdRelacionado,
          'NoTrazabilidad': params.noTrazabilidad,
          'RegBorrado': 0,
          'SiteModificacion': siteId,
          'FechaModificacion': currentDate,
        },
        where: 'ConformadoId = ? AND IdTrazabilidad = ? AND Trazabilidad1 = ?',
        whereArgs: [
          formingId,
          params.idTrazabilidad,
          params.trazabilidad1 ? 1 : 0,
        ],
      );
    } else {
      result = await db.insert(
        'VolumenTrazabilidad',
        {
          'ConformadoId': formingId,
          'IdTrazabilidad': params.idTrazabilidad,
          'CantidadUsada': params.cantidadUsada,
          'Trazabilidad1': params.trazabilidad1 ? 1 : 0,
          'Original': 0,
          'JuntaId': params.juntaIdRelacionado,
          'NoTrazabilidad': params.noTrazabilidad,
          'SiteModificacion': siteId,
          'FechaModificacion': currentDate,
          'RegBorrado': 0
        },
      );
    }

    return result;
  }

  Future<int> deleteVolume(TraceabilityDeleteParamsModel params) async {
    String query;
    String formingId;
    String siteId;
    int result = 0;
    List<dynamic> values;

    final site = SiteDao();
    final db = await context.database;

    values = [params.juntaId];

    List<Map<String, dynamic>> formingIdRes = await db.query(
      'Conformado',
      columns: ['ConformadoId'],
      where: 'JuntaId = ? AND Activo = 1 AND RegBorrado = 0',
      whereArgs: values,
      limit: 1,
    );

    formingId = formingIdRes[0]['ConformadoId'];

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);
    siteId = await site.getSiteId();

    //Actualiza la trazabilidad 1 o 2 del Conformado.
    query = '''
      UPDATE Conformado
      SET ${params.trazabilidad1 ? 'Trazabilidad1Id' : 'Trazabilidad2Id'} = '',
        SiteModificacion = ?, FechaModificacion = ?
      WHERE JuntaId = ? AND Activo = 1 AND RegBorrado = 0
    ''';
    values = [siteId, currentDate, params.juntaId];
    result = await db.rawUpdate(query, values);

    //Eliminar el volumen agrago de la trazabilidad
    values = [formingId, params.idTrazabilidad, params.trazabilidad1 ? 1 : 0];
    result = await db.update(
      'VolumenTrazabilidad',
      {
        'RegBorrado': -1,
        'SiteModificacion': siteId,
        'FechaModificacion': currentDate,
      },
      where:
          'ConformadoId = ? AND IdTrazabilidad = ? AND Trazabilidad1 = ? AND RegBorrado = 0',
      whereArgs: values,
    );

    return result;
  }

  // [HSEQMC].[st_SelJuntasTrazabilidad]
  // Este nos ayuda a buscar referencias de las trazabilidad a�adidad en la misma junta
  Future<List<JointTraceabilityModel>> getJointsTraceability(
      JointTraceabilityParams params) async {
    String sql;
    List<JointTraceabilityModel> list;
    List<JointTraceabilityModel> filterList = [];

    final db = await context.database;

    sql = '''
          SELECT
          PD.NumeroPlano || ' Rev. ' || PD.Revision || ' Hoja ' || PD.Hoja AS Plano, 
          PD.ObraId,J.JuntaId,J.JuntaNo,VT.CantidadUsada,
          CASE WHEN VT.Trazabilidad1 = 1 THEN CAST(1 AS INTEGER) ELSE CAST(2 AS INTEGER) END NoTrazabilidad,
          CASE WHEN (SELECT T.UM FROM Trazabilidad T WHERE T.IdTrazabilidad = ? ORDER BY T.IdTrazabilidad LIMIT 1)<>''
          THEN (SELECT T.UM FROM Trazabilidad T WHERE T.IdTrazabilidad = ? ORDER BY T.IdTrazabilidad LIMIT 1)
          ELSE (SELECT T.UM FROM ElementoExistente T WHERE T.IdElementoExistente = ? ORDER BY T.IdElementoExistente LIMIT 1) END UM,
          PD.PlanoDetalleId AS PlanoDetalleId,
          PD.NumeroPlano AS NumeroPlano,
          PD.Revision AS Revision,
          PD.Hoja AS Hoja
    FROM		VolumenTrazabilidad VT
    INNER JOIN	Conformado C ON C.ConformadoId = VT.ConformadoId AND C.Activo = 1 AND C.RegBorrado = 0
    INNER JOIN	Junta J ON J.JuntaId = C.JuntaId AND J.RegBorrado = 0
    INNER JOIN  PlanoDetalle AS PD ON J.PlanoDetalleId = PD.PlanoDetalleId AND PD.RegBorrado = 0 AND PD.ObraId = ?
    WHERE		VT.IdTrazabilidad = ? AND
    			VT.RegBorrado = 0 AND
    			VT.Original = 1
      ''';

    final jointsRes = await db.rawQuery(
      sql,
      [
        params.traceabilityId,
        params.traceabilityId,
        params.traceabilityId,
        params.obraId,
        params.traceabilityId
      ],
    );

    list = jointsRes.isNotEmpty
        ? jointsRes.map((e) => JointTraceabilityModel.fromJson(e)).toList()
        : [];

    if (list.isNotEmpty) {
      int rowId = 1;

      list.forEach((JointTraceabilityModel i) {
        i.filaId = rowId; // LLena el campo filaId
        rowId++;
      });
    }

    await Future.forEach(list, (JointTraceabilityModel e) async {
      String joints;

      sql = '''
        SELECT	COALESCE(? || ', ', '') || J.JuntaNo
      FROM		VolumenTrazabilidad VT
      INNER JOIN	Conformado C ON C.ConformadoId = VT.ConformadoId AND C.Activo = 1 AND C.RegBorrado = 0
      INNER JOIN	Junta J ON J.JuntaId = C.JuntaId AND J.RegBorrado = 0
      INNER JOIN  PlanoDetalle AS PD ON J.PlanoDetalleId = PD.PlanoDetalleId AND PD.RegBorrado = 0 AND PD.ObraId = ?
      WHERE VT.Original = 0 AND VT.IdTrazabilidad = ? AND VT.JuntaId = '' AND
                  VT.NoTrazabilidad = '' AND VT.RegBorrado = 0
        ''';

      List<Map<String, dynamic>> jointsUpdate = await db.rawQuery(
        sql,
        [e.juntaNo.toString(), params.obraId, params.traceabilityId],
      );

      joints = jointsUpdate.isNotEmpty
          ? jointsUpdate[0]['JuntaNo'].toString()
          : e.juntaNo;

      list[list.indexWhere((JointTraceabilityModel x) => x.filaId == e.filaId)]
          .juntaNo = joints;
    });

    if (params.isFilter) {
      if (params.juntaNo.isNotEmpty) {
        filterList = list
            .where((element) => element.juntaNo
                .toLowerCase()
                .contains(params.juntaNo.toLowerCase()))
            .toList();

        list = filterList;
      }

      if (params.plainDetailId.isNotEmpty) {
        filterList = list
            .where((element) => element.plano
                .toLowerCase()
                .contains(params.plainDetailId.toLowerCase()))
            .toList();

        list = filterList;
      }

      if (params.volumen != null) {
        filterList = list
            .where((element) => element.cantidadUsada == params.volumen)
            .toList();
        list = filterList;
      }

      return list;
    }

    return list;
  }

  Future<List<ExistingElementModel>> getExistingElement(
      String idElementoExistente) async {
    String sql;
    List<ExistingElementModel> list;
    List<dynamic> values;

    final db = await context.database;

    if (idElementoExistente == null) {
      sql = '''
        SELECT		EE.IdElementoExistente, 
                  EE.MaterialDescrBreve 
        FROM		  ElementoExistente EE
        WHERE		  EE.RegBorrado = 0
        ORDER BY	EE.IdElementoExistente ASC
      ''';

      values = [];
    } else {
      sql = '''
        SELECT		EE.IdElementoExistente, 
			            EE.MaterialDescrBreve
        FROM		  ElementoExistente EE
        WHERE		  (EE.IdElementoExistente LIKE '%?%' OR EE.MaterialDescrBreve LIKE '%?%') AND 
			            RegBorrado = 0
        ORDER BY	EE.IdElementoExistente ASC
      ''';

      values = [idElementoExistente, idElementoExistente];
    }

    final res = await db.rawQuery(sql, values);

    list = res.isNotEmpty
        ? res.map((e) => ExistingElementModel.fromJson(e)).toList()
        : [];

    return list;
  }
}
