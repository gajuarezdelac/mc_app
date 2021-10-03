import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/anticorrosive_ipa_model.dart';
import 'package:mc_app/src/models/anticorrosive_protection_header_model.dart';
import 'package:mc_app/src/models/anticorrosive_protection_model.dart';
import 'package:mc_app/src/models/coating_aplication_model.dart';
import 'package:mc_app/src/models/coating_system_model.dart';
import 'package:mc_app/src/models/environmental_conditions_model.dart';
import 'package:mc_app/src/models/equipment_model.dart';
import 'package:mc_app/src/models/material_stages_d_ipa_model.dart';
import 'package:mc_app/src/models/materials_ipa_model.dart';
import 'package:mc_app/src/models/materials_table_ipa_model.dart';
import 'package:mc_app/src/models/params/anticorrosive_grid_params.dart';
import 'package:mc_app/src/models/params/environmental_conditions_params.dart';
import 'package:mc_app/src/models/stage_materials_ipa_model.dart';

import 'functions_dao.dart';

class AnticorrosiveProtectionDao {
  DBContext context = DBContext();

  Future<List<AnticorrosiveProtectionModel>>
      selPaginadorProteccionAnticorrosiva(
    AnticorrosiveGridParams params,
  ) async {
    String sql;
    List<dynamic> arguments;

    sql = '''
      SELECT      PA.NoRegistro, 
                  PA.ContratoId, 
                  O.OT, 
                  PA.Instalacion, 
                  P.Descripcion Plataforma, 
                  SR.Sistema, 
                  PA.Fecha,
                  CASE 
                    WHEN AIPA.NoRegistro IS NULL THEN 0 
                    ELSE 1 
                  END InfoGeneral,
                  CASE 
                    WHEN EXISTS (
                        SELECT    1 
                        FROM      CondicionesAmbientalesIPA 
                        WHERE     NoRegistro = PA.NoRegistro AND 
                                  RegBorrado = 0
                      ) THEN 1 
                    ELSE 0 
                  END Condiciones,
                  CASE 
                    WHEN EXISTS (
                          SELECT    1 
                          FROM      Documentos 
                          WHERE     NombreTabla = 'HSEQMC.ProteccionAnticorrosiva' AND 
                                    IdentificadorTabla = PA.NoRegistro AND 
                                    RegBorrado = 0
                      ) THEN 1 
                    ELSE 0 
                  END Documentos,
                  CASE 
                    WHEN EXISTS (
                          SELECT    1 
                          FROM      Foto 
                          WHERE     NombreTabla = 'HSEQMC.ProteccionAnticorrosiva' AND 
                                    IdentificadorTabla LIKE PA.NoRegistro || '%' AND RegBorrado = 0
                        ) THEN 1 
                    ELSE 0 
                  END Evidencia,
                  CASE 
                    WHEN EXISTS (
                          SELECT    1 
                          FROM      EquiposIMPIPA 
                          WHERE     NoRegistro = PA.NoRegistro AND 
                          RegBorrado = 0
                        ) THEN 1 
                    ELSE 0 
                  END Equipos,
                  CASE 
                    WHEN EXISTS ( 
                          SELECT    1 
                          FROM      AplicacionRecubrimientoIPA 
                          WHERE     NoRegistro = PA.NoRegistro AND 
                                    RegBorrado = 0
                        ) THEN 1 
                    ELSE 0 
                  END AplicacionRecubrimiento
      FROM		    ProteccionAnticorrosiva PA
      INNER JOIN  Obras O ON O.ObraId = PA.ObraId AND O.RegBorrado = 0
      INNER JOIN  Plataformas P ON P.PlataformaId = PA.PlataformaId AND P.RegBorrado = 0
      INNER JOIN  SistemaRecubrimiento SR ON SR.SistemaRecubrimientoId = PA.SistemaId AND SR.RegBorrado = 0
      LEFT JOIN   AnticorrosivoIPA AIPA ON AIPA.NoRegistro = PA.NoRegistro AND AIPA.RegBorrado = 0
      WHERE       PA.RegBorrado = ? AND 
                  (PA.ContratoId = ? OR COALESCE(?, '') = '') AND
                  (PA.ObraId = ? OR COALESCE(?, '') = '') AND
                  (PA.NoRegistro = ? OR COALESCE(?, '') = '') AND
                  (PA.Instalacion = ? OR COALESCE(?, '') = '') AND
                  (P.Descripcion = ? OR COALESCE(?, '') = '') AND
                  (STRFTIME('%d/%m/%Y', PA.Fecha) = ? OR COALESCE(?, '') = '')
      ORDER BY    PA.Fecha ASC
    ''';
    //STRFTIME('%d/%m/%Y', EM.FechaReporte)
    arguments = [
      0,
      params.contractId == null ? '' : params.contractId,
      params.contractId == null ? '' : params.contractId,
      params.workId == null ? '' : params.workId,
      params.workId == null ? '' : params.workId,
      params.registryNumber == null ? '' : params.registryNumber,
      params.registryNumber == null ? '' : params.registryNumber,
      params.place == null ? '' : params.place,
      params.place == null ? '' : params.place,
      params.platform == null ? '' : params.platform,
      params.platform == null ? '' : params.platform,
      params.date == null ? '' : params.date,
      params.date == null ? '' : params.date
    ];

    final db = await context.database;
    final res = await db.rawQuery(sql, arguments);

    List<AnticorrosiveProtectionModel> list = res.isNotEmpty
        ? res.map((e) => AnticorrosiveProtectionModel.fromJson(e)).toList()
        : [];

    await Future.forEach(list, (AnticorrosiveProtectionModel i) async {
      String semaforo = await fnSelSemaforoPA(i.noRegistro);
      i.semaforo = semaforo;
    });

    if (!params.pending && !params.progress && !params.finalized) {
      return list;
    }
    else {
      if(!params.pending) {
        list.removeWhere((element) => element.semaforo == '0xFFFFFFFF');
      }

      if(!params.progress) {
        list.removeWhere((element) => element.semaforo == '0xFFecec0c');
      }

      if(!params.finalized) {
        list.removeWhere((element) => element.semaforo == '0xFF068c3d');
      }

      return list;
    }

  }

  Future<String> fnSelSemaforoPA(String noRegistro) async {
    String sql;
    String sistemaId;
    String value = '0xFFFFFFFF';
    int estatusCondicionAmbiental;
    int estatusInfoGeneral;
    int estatusAplicacionRecubrimiento;
    int estatusEquipos;
    int totalEtapas;
    int totalEtapasRecubrimiento;
    int totalEtapasCA;
    int totalEtapasAR;
    int totalCondiciones;
    int totalAplicacion;
    List<dynamic> arguments;

    final db = await context.database;

    sql = '''
      SELECT COUNT(1) TotalEtapasCA FROM CondicionesAmbientalesIPA CA
        INNER JOIN	ProteccionAnticorrosiva PA 
          ON PA.NoRegistro = CA.NoRegistro AND PA.RegBorrado = ?
        INNER JOIN	SistemaRecubrimientoD SRD 
          ON SRD.SistemaRecubrimientoId = PA.SistemaId 
          AND SRD.Orden = CA.Orden AND SRD.RegBorrado = ?
      WHERE CA.NoRegistro = ? AND CA.RegBorrado = ?
    ''';
    arguments = [0, 0, noRegistro, 0];

    List<Map<String, dynamic>> totalEtapasCARes = await db.rawQuery(
      sql,
      arguments,
    );

    totalEtapasCA = totalEtapasCARes[0]['TotalEtapasCA'];

    sql = '''
      SELECT COUNT(1) TotalEtapasAR FROM AplicacionRecubrimientoIPA AR
        INNER JOIN	ProteccionAnticorrosiva PA
          ON PA.NoRegistro = AR.NoRegistro AND PA.RegBorrado = ?
        INNER JOIN	SistemaRecubrimientoD SRD 
          ON SRD.SistemaRecubrimientoId = PA.SistemaId AND SRD.Orden = AR.Orden 
          AND SRD.Recubrimiento = ? AND SRD.RegBorrado = ?
      WHERE AR.NoRegistro = ? AND AR.RegBorrado = ?
    ''';
    arguments = [0, 1, 0, noRegistro, 0];

    List<Map<String, dynamic>> totalEtapasARRes = await db.rawQuery(
      sql,
      arguments,
    );

    totalEtapasAR = totalEtapasARRes[0]['TotalEtapasAR'];
    sistemaId = await selSistemaId(noRegistro);
    arguments = [sistemaId, 0];
    sql = '''
      SELECT COUNT(1) TotalEtapas FROM SistemaRecubrimientoD
      WHERE SistemaRecubrimientoId = ? AND RegBorrado = ?
    ''';

    List<Map<String, dynamic>> totalEtapasRes = await db.rawQuery(
      sql,
      arguments,
    );

    totalEtapas = totalEtapasRes[0]['TotalEtapas'];

    arguments = [sistemaId, 1, 0];
    sql = '''
      SELECT COUNT(1) TotalEtapasRecubrimiento FROM SistemaRecubrimientoD
      WHERE SistemaRecubrimientoId = ? AND Recubrimiento = ? AND RegBorrado = ?
    ''';

    List<Map<String, dynamic>> totalEtapasRecubrimientoRes = await db.rawQuery(
      sql,
      arguments,
    );

    totalEtapasRecubrimiento =
        totalEtapasRecubrimientoRes[0]['TotalEtapasRecubrimiento'];

    /*Condiciones ambientales*/
    final existenCondiciones = await db.query(
      'CondicionesAmbientalesIPA',
      columns: ['NoRegistro'],
      where: 'NoRegistro = ? AND RegBorrado = ?',
      whereArgs: [noRegistro, 0],
    );

    if (existenCondiciones.isEmpty) {
      estatusCondicionAmbiental = 0;
    } else if (totalEtapasCA == totalEtapas) {
      estatusCondicionAmbiental = 2;

      arguments = [noRegistro];
      sql = '''
          SELECT COUNT(1) TotalCondiciones FROM CondicionesAmbientalesIPA CA
          INNER JOIN ProteccionAnticorrosiva PA 
            ON PA.NoRegistro = CA.NoRegistro AND PA.RegBorrado = 0
          INNER JOIN SistemaRecubrimientoD SRD 
            ON SRD.SistemaRecubrimientoId = PA.SistemaId 
            AND SRD.Orden = CA.Orden AND SRD.RegBorrado = 0
          WHERE CA.NoRegistro = ? AND
            TRIM(IFNULL(CA.TemperaturaAmbiente, '')) <> '' AND
            TRIM(IFNULL(CA.TemperaturaSustrato, '')) <> '' AND
            TRIM(IFNULL(CA.HumedadRelativa, '')) <> '' AND
            CA.RegBorrado = 0
        ''';

      List<Map<String, dynamic>> totalCondicionesRes = await db.rawQuery(
        sql,
        arguments,
      );

      totalCondiciones = totalCondicionesRes[0]['TotalCondiciones'];

      if (totalCondiciones == totalEtapas) estatusCondicionAmbiental = 3;
    } else {
      estatusCondicionAmbiental = 1;
    }

    /*Aplicaci�n de recubrimiento*/
    final existenAplicaciones = await db.query(
      'AplicacionRecubrimientoIPA',
      columns: ['NoRegistro'],
      where: 'NoRegistro = ? AND RegBorrado = ?',
      whereArgs: [noRegistro, 0],
    );

    if (existenAplicaciones.isEmpty) {
      estatusAplicacionRecubrimiento = 0;
    } else if (totalEtapasAR == totalEtapasRecubrimiento) {
      estatusAplicacionRecubrimiento = 2;

      arguments = [noRegistro];
      sql = '''
          SELECT COUNT(1) TotalAplicacion FROM AplicacionRecubrimientoIPA AR
          INNER JOIN ProteccionAnticorrosiva PA 
            ON PA.NoRegistro = AR.NoRegistro AND PA.RegBorrado = 0
          INNER JOIN SistemaRecubrimientoD SRD 
            ON SRD.SistemaRecubrimientoId = PA.SistemaId 
            AND SRD.Orden = AR.Orden AND SRD.RegBorrado = 0
          WHERE AR.NoRegistro = ? AND
            TRIM(IFNULL(AR.Observacion, '')) <> '' AND
            TRIM(IFNULL(AR.NoLote, '')) <> '' AND
            TRIM(IFNULL(AR.FechaCaducidad, '')) <> '' AND
            TRIM(IFNULL(AR.MetodoAplicacion, '')) <> '' AND
            TRIM(IFNULL(AR.TipoRecubrimiento, '')) <> '' AND
            TRIM(IFNULL(AR.Mezcla, '')) <> '' AND
            TRIM(IFNULL(AR.EspesorSecoPromedio, '')) <> '' AND
            TRIM(IFNULL(AR.TiempoSecado, '')) <> '' AND
            TRIM(IFNULL(AR.TipoEnvolvente, '')) <> '' AND
            1 = CASE WHEN SRD.Continuidad = 1 
              THEN CASE WHEN TRIM(IFNULL(AR.PruebaContinuidad, '')) <> '' 
                THEN 1 
                ELSE 0 END 
              ELSE 1 END 
            AND	
            1 = CASE WHEN SRD.Adherencia = 1 
              THEN CASE WHEN TRIM(IFNULL(AR.PruebaAdherencia, '')) <> '' 
                THEN 1 
                ELSE 0 END 
              ELSE 1 END 
            AND
            1 = CASE WHEN SRD.Adherencia = 1 
              THEN CASE WHEN TRIM(IFNULL(AR.DocumentoAplicable, '')) <> '' 
                THEN 1 
                ELSE 0 END 
              ELSE 1 END 
            AND
            1 = CASE WHEN SRD.Continuidad = 1 
              THEN CASE WHEN TRIM(IFNULL(AR.ComentariosContinuidad, '')) <> '' 
                THEN 1 
                ELSE 0 END 
              ELSE 1 END 
            AND
            1 = CASE WHEN SRD.Adherencia = 1 
              THEN CASE WHEN TRIM(IFNULL(AR.ComentariosAdherencia, '')) <> '' 
                THEN 1 
                ELSE 0 END 
              ELSE 1 END 
            AND	
            1 = CASE WHEN SRD.Adherencia = 1 
              THEN CASE WHEN IFNULL(AR.NumeroPruebas, 0) <> 0 
                THEN 1 
                ELSE 0 END 
              ELSE 1 END 
            AND AR.RegBorrado = 0
        ''';

      List<Map<String, dynamic>> totalAplicacionRes = await db.rawQuery(
        sql,
        arguments,
      );

      totalAplicacion = totalAplicacionRes[0]['TotalAplicacion'];

      if (totalAplicacion == totalEtapasRecubrimiento)
        estatusAplicacionRecubrimiento = 3;
    } else {
      estatusAplicacionRecubrimiento = 1;
    }

    /*Informaci�n general*/
    final existeAnticorrosivo = await db.query(
      'AnticorrosivoIPA',
      columns: ['NoRegistro'],
      where: 'NoRegistro = ? AND RegBorrado = ?',
      whereArgs: [noRegistro, 0],
    );

    if (existeAnticorrosivo.isEmpty) {
      estatusInfoGeneral = 0;
    } else {
      estatusInfoGeneral = 1;
      arguments = [noRegistro];
      sql = '''
        SELECT 1 FROM AnticorrosivoIPA
        WHERE NoRegistro = ? AND
          TRIM(IFNULL(Observaciones, '')) <> '' AND
          TRIM(IFNULL(ObservacionRF, '')) <> '' AND
          TRIM(IFNULL(CondicionesSustrato, '')) <> '' AND
          TRIM(IFNULL(TipoAbrasivo, '')) <> '' AND
          TRIM(IFNULL(PerfilAnclajePromedio, '')) <> '' AND
          TRIM(IFNULL(EstandarLimpieza, '')) <> '' AND
          RegBorrado = 0
      ''';

      final anticorrosivoRes = await db.rawQuery(sql, arguments);

      if (anticorrosivoRes.isNotEmpty) estatusInfoGeneral = 2;
    }

    /*Equipos*/
    final existeEquipo = await db.query(
      'EquiposIMPIPA',
      columns: ['NoRegistro'],
      where: 'NoRegistro = ? AND RegBorrado = ?',
      whereArgs: [noRegistro, 0],
    );

    existeEquipo.isNotEmpty ? estatusEquipos = 1 : estatusEquipos = 0;

    /*EVALUACI�N GENERAL DE TODAS LAS SECCIONES*/
    value = estatusCondicionAmbiental == 0 &&
            estatusInfoGeneral == 0 &&
            estatusAplicacionRecubrimiento == 0 &&
            estatusEquipos == 0
        ? '0xFFFFFFFF'
        : estatusCondicionAmbiental == 3 &&
                estatusInfoGeneral == 2 &&
                estatusAplicacionRecubrimiento == 3 &&
                estatusEquipos == 1
            ? '0xFF068c3d'
            : '0xFFecec0c';

    return value;
  }

  Future<String> selSistemaId(String noRegistro) async {
    String sistemaId;

    final db = await context.database;

    List<Map<String, dynamic>> sistemaIdRes = await db.query(
      'ProteccionAnticorrosiva',
      columns: ['SistemaId'],
      where: 'NoRegistro = ? AND RegBorrado = ?',
      whereArgs: [noRegistro, 0],
      orderBy: 'NoRegistro',
      limit: 1,
    );

    sistemaId = sistemaIdRes[0]['SistemaId'];

    return sistemaId;
  }

  Future<AnticorrosiveIPAModel> selAnticorrosivoIPA(String noRegistro) async {
    String sql;
    List<dynamic> arguments;

    sql = '''
      SELECT    ObservacionRF ObservacionesRF,
                CondicionesSustrato Sustrato,
                TipoAbrasivo Abrasivo,
                PerfilAnclajePromedio Anclaje,
                EstandarLimpieza Limpieza,
                IncluirImagenes IncluirEvidencias,
                Observaciones
      FROM      AnticorrosivoIPA
      WHERE     NoRegistro = ? AND
                RegBorrado = 0
    ''';

    arguments = [noRegistro];

    final db = await context.database;
    final res = await db.rawQuery(sql, arguments);

    if (res.length > 0) {
      return AnticorrosiveIPAModel.fromJson(res.first);
    } else {
      return null;
    }
  }

  Future<AnticorrosiveProtectionHeaderModel> selAnticorrosiveHeader(
      String noRegistro) async {
    String sql;
    List<dynamic> arguments;

    sql = '''
      SELECT 		  PA.ContratoId,
                  O.OT,
                  SR.Sistema,
                  PA.Instalacion,
                  P.Descripcion Plataforma
      FROM		    ProteccionAnticorrosiva PA
      INNER JOIN	Obras O ON O.ObraId = PA.ObraId AND O.RegBorrado = 0
      INNER JOIN	SistemaRecubrimiento SR ON SR.SistemaRecubrimientoId = PA.SistemaId AND SR.RegBorrado = 0
      INNER JOIN	Plataformas P ON P.PlataformaId = PA.PlataformaId AND P.RegBorrado = 0
      WHERE		    PA.NoRegistro = ? AND
                  PA.RegBorrado = 0
    ''';

    arguments = [noRegistro];

    final db = await context.database;
    final res = await db.rawQuery(sql, arguments);

    if (res.length > 0) {
      return AnticorrosiveProtectionHeaderModel.fromJson(res.first);
    } else {
      return null;
    }
  }

  Future<List<CoatingSystemModel>> selEtapasSistemaRecubrimiento(
      String noRegistro) async {

    String sql;
    List<dynamic> arguments;

    sql = '''
      SELECT		  SRD.Orden,
                  SRD.Etapa,
                  SRD.ActividadRecubrimiento,
                  SRD.Recubrimiento,
                  SRD.Adherencia,
                  SRD.Continuidad
      FROM		    SistemaRecubrimientoD SRD
      INNER JOIN 	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = ?
      WHERE       SRD.RegBorrado = 0
    ''';

    arguments = [noRegistro];

    final db = await context.database;
    final res = await db.rawQuery(sql, arguments);

    List<CoatingSystemModel> list = res.isNotEmpty
        ? res.map((e) => CoatingSystemModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<List<EquipmentModel>> selEquipos(String noRegistro) async {
    String sql;
    List<dynamic> arguments;

    sql = '''
      SELECT		Orden,
				        Nombre
	    FROM		  EquiposIMPIPA
	    WHERE		  NoRegistro = ? AND 
                RegBorrado = 0
    ''';

    arguments = [noRegistro];

    final db = await context.database;
    final res = await db.rawQuery(sql, arguments);

    List<EquipmentModel> list = res.isNotEmpty
        ? res.map((e) => EquipmentModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<List<EnvironmentalConditionsModel>> selCondicionesAmbientales(
      String noRegistro) async {
    String sql;
    List<dynamic> arguments;

    sql = '''
      SELECT		Orden,
				        TemperaturaAmbiente,
				        TemperaturaSustrato,
				        HumedadRelativa
	    FROM		  CondicionesAmbientalesIPA
	    WHERE		  NoRegistro = ?
    ''';

    arguments = [noRegistro];

    final db = await context.database;
    final res = await db.rawQuery(sql, arguments);

    List<EnvironmentalConditionsModel> list = res.isNotEmpty
        ? res.map((e) => EnvironmentalConditionsModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<List<CoatingAplicationModel>> selAplicacionRecubrimiento(
      String noRegistro) async {
    String sql;
    List<dynamic> arguments;

    sql = '''
      SELECT		  SRD.Orden,
                  ARIPA.Observacion,
                  ARIPA.NoLote,
                  ARIPA.FechaCaducidad,
                  ARIPA.MetodoAplicacion,
                  ARIPA.TipoRecubrimiento,
                  ARIPA.Mezcla,
                  ARIPA.EspesorSecoPromedio,
                  ARIPA.TiempoSecado,
                  ARIPA.TipoEnvolvente,
                  ARIPA.PruebaContinuidad,
                  ARIPA.PruebaAdherencia,
                  ARIPA.DocumentoAplicable,
                  ARIPA.ComentariosContinuidad,
                  ARIPA.ComentariosAdherencia,
                  ARIPA.NumeroPruebas
	    FROM		    SistemaRecubrimientoD SRD
	    INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = ? AND PA.RegBorrado = 0
	    LEFT JOIN	  AplicacionRecubrimientoIPA ARIPA ON ARIPA.NoRegistro = PA.NoRegistro AND ARIPA.Orden = SRD.Orden AND ARIPA.RegBorrado = 0
	    WHERE		    SRD.Recubrimiento = 1 AND
                  SRD.RegBorrado = 0
    ''';

    arguments = [noRegistro];

    final db = await context.database;

    final res = await db.rawQuery(sql, arguments);

    List<CoatingAplicationModel> list = res.isNotEmpty
        ? res.map((e) => CoatingAplicationModel.fromJson(e)).toList()
        : [];

    return list;
  }

  //Inserta o actualiza las condiciones ambientales
  Future<int> insUpdCondicionesAmbientales(
      String noRegistro, List<EnvironmentalConditionsParams> param) async {
    int result = 0;

    final db = await context.database;

    if (param.isNotEmpty) {
      param.forEach((item) async {
        //Si existe
        final condicionAmbiental = await db.query('CondicionesAmbientalesIPA',
            columns: ['NoRegistro', 'Orden'],
            where: 'NoRegistro = ? AND Orden = ?',
            whereArgs: [noRegistro, item.orden]);

        //Merge. Cuando coincide
        if (condicionAmbiental.isNotEmpty) {
          result = await db.update(
              'CondicionesAmbientalesIPA',
              {
                'TemperaturaAmbiente': item.temperaturaAmbiente,
                'TemperaturaSustrato': item.temperaturaSustrato,
                'HumedadRelativa': item.humedadRelativa
              },
              where: 'NoRegistro = ? AND Orden = ? AND RegBorrado = 0',
              whereArgs: [noRegistro, item.orden]);
        } else {
          //Cuando no coincide
          result = await db.insert(
            'CondicionesAmbientalesIPA',
            {
              'NoRegistro': noRegistro,
              'Orden': item.orden,
              'TemperaturaAmbiente': item.temperaturaAmbiente,
              'TemperaturaSustrato': item.temperaturaSustrato,
              'HumedadRelativa': item.humedadRelativa
            },
          );
        }
      });
    }

    return result;
  }

  //Inserta o actualiza la información general
  Future<int> insUpdInfoGeneral(
      String noRegistro, AnticorrosiveIPAModel anticorrosiveIPAModel) async {
    int result = 0;

    final db = await context.database;

    final infoGeneral = await db.query('AnticorrosivoIPA',
        columns: ['NoRegistro'],
        where: 'NoRegistro = ? AND RegBorrado = 0',
        whereArgs: [noRegistro]);

    if (infoGeneral.isNotEmpty) {
      //Actualizar
      result = await db.update(
          'AnticorrosivoIPA',
          {
            'Observaciones': anticorrosiveIPAModel.observaciones,
            'IncluirImagenes': anticorrosiveIPAModel.incluirEvidencias ? 1 : 0,
            'ObservacionRF': anticorrosiveIPAModel.observacionesRF,
            'CondicionesSustrato': anticorrosiveIPAModel.sustrato,
            'TipoAbrasivo': anticorrosiveIPAModel.abrasivo,
            'PerfilAnclajePromedio': anticorrosiveIPAModel.anclaje,
            'EstandarLimpieza': anticorrosiveIPAModel.limpieza
          },
          where: 'NoRegistro = ? AND RegBorrado = 0',
          whereArgs: [noRegistro]);
    } else {
      //Insertar
      result = await db.insert(
        'AnticorrosivoIPA',
        {
          'NoRegistro': noRegistro,
          'Observaciones': anticorrosiveIPAModel.observaciones,
          'IncluirImagenes': anticorrosiveIPAModel.incluirEvidencias ? 1 : 0,
          'ObservacionRF': anticorrosiveIPAModel.observacionesRF,
          'CondicionesSustrato': anticorrosiveIPAModel.sustrato,
          'TipoAbrasivo': anticorrosiveIPAModel.abrasivo,
          'PerfilAnclajePromedio': anticorrosiveIPAModel.anclaje,
          'EstandarLimpieza': anticorrosiveIPAModel.limpieza,
          'RegBorrado': 0
        },
      );
    }

    return result;
  }

  Future<int> insUpdCoatingApplication(
      List<CoatingAplicationModel> params, String noRegistro) async {
    int result = 0;

    final db = await context.database;

    if (params.isNotEmpty) {
      params.forEach((item) async {
        final recubrimiento = await db.query('AplicacionRecubrimientoIPA',
            columns: ['NoRegistro', 'Orden'],
            where: 'NoRegistro = ? AND Orden = ? AND RegBorrado = 0',
            whereArgs: [noRegistro, item.orden]);

        if (recubrimiento.isNotEmpty) {
          //Actualizar
          result = await db.update(
              'AplicacionRecubrimientoIPA',
              {
                'Observacion': item.observacion,
                'NoLote': item.noLote,
                'FechaCaducidad': item.fechaCaducidad,
                'MetodoAplicacion': item.metodoAplicacion,
                'TipoRecubrimiento': item.tipoRecubrimiento,
                'Mezcla': item.mezcla,
                'EspesorSecoPromedio': item.espesorSecoPromedio,
                'TiempoSecado': item.tiempoSecado,
                'TipoEnvolvente': item.tipoEnvolvente,
                'PruebaContinuidad': item.pruebaContinuidad,
                'PruebaAdherencia': item.pruebaAdherencia,
                'DocumentoAplicable': item.documentoAplicable,
                'ComentariosContinuidad': item.comentariosContinuidad,
                'ComentariosAdherencia': item.comentariosAdherencia,
                'NumeroPruebas': item.numeroPruebas
              },
              where: 'NoRegistro = ? AND Orden = ? AND RegBorrado = 0',
              whereArgs: [noRegistro, item.orden]);
        } else {
          //Insertar
          result = await db.insert(
            'AplicacionRecubrimientoIPA',
            {
              'NoRegistro': noRegistro,
              'Orden': item.orden,
              'Observacion': item.observacion,
              'NoLote': item.noLote,
              'FechaCaducidad': item.fechaCaducidad,
              'MetodoAplicacion': item.metodoAplicacion,
              'TipoRecubrimiento': item.tipoRecubrimiento,
              'Mezcla': item.mezcla,
              'EspesorSecoPromedio': item.espesorSecoPromedio,
              'TiempoSecado': item.tiempoSecado,
              'TipoEnvolvente': item.tipoEnvolvente,
              'PruebaContinuidad': item.pruebaContinuidad,
              'PruebaAdherencia': item.pruebaAdherencia,
              'DocumentoAplicable': item.documentoAplicable,
              'ComentariosContinuidad': item.comentariosContinuidad,
              'ComentariosAdherencia': item.comentariosAdherencia,
              'NumeroPruebas': item.numeroPruebas
            },
          );
        }
      });
    }

    return result;
  }

  Future<int> insUpdEquipment(
      String noRegistro, List<EquipmentModel> params) async {
    int result = 0;

    final db = await context.database;

    //Eliminar todo para hacer el merge y activarlos nuevamente
    result = await db.update('EquiposIMPIPA', {'RegBorrado': -1},
        where: 'NoRegistro = ? AND RegBorrado = 0', whereArgs: [noRegistro]);

    if (params.isNotEmpty) {
      params.forEach((item) async {
        final equipo = await db.query('EquiposIMPIPA',
            columns: ['Nombre'],
            where: 'NoRegistro = ? AND Orden = ?',
            whereArgs: [noRegistro, item.orden]);

        if (equipo.isNotEmpty) {
          result = await db.update(
              'EquiposIMPIPA', {'Nombre': item.nombre, 'RegBorrado': 0},
              where: 'NoRegistro = ? AND Orden = ?',
              whereArgs: [noRegistro, item.orden]);
        } else {
          result = await db.insert(
            'EquiposIMPIPA',
            {
              'NoRegistro': noRegistro,
              'Orden': item.orden,
              'Nombre': item.nombre,
              'RegBorrado': 0
            },
          );
        }
      });
    }

    return result;
  }

  Future<List<StageMaterialsIPAModel>> selEtapaMaterialIPA(String noRegistro) async {
    String sql;
    List<dynamic> arguments;

    final db = await context.database;

    sql = '''
      SELECT 			PA.NoRegistro,
				          SRD.Orden,
				          SRD.Etapa,
				          IFNULL(EM.PorcentajeInspeccion, 0) PorcentajeInspeccion,
                  CASE 
                    WHEN EM.FechaReporte = '0001-01-01 00:00:00.000' THEN NULL
                    ELSE STRFTIME('%d/%m/%Y', EM.FechaReporte)
                  END FechaReporte,
                  CASE 
                    WHEN EM.FechaReporteLiberacion = '0001-01-01 00:00:00.000' THEN NULL
                    ELSE STRFTIME('%d/%m/%Y', EM.FechaReporteLiberacion) 
                  END FechaLiberacion
      FROM 			  SistemaRecubrimientoD SRD
      INNER JOIN	ProteccionAnticorrosiva PA ON PA.SistemaId = SRD.SistemaRecubrimientoId AND PA.NoRegistro = ? AND PA.RegBorrado = 0
      LEFT JOIN		EtapasMaterialesIPA EM ON EM.Orden = SRD.Orden AND EM.NoRegistro = PA.NoRegistro AND EM.RegBorrado = 0
      WHERE			  SRD.Recubrimiento = 1 AND
				          SRD.RegBorrado = 0
    ''';

    arguments = [noRegistro];

    final res = await db.rawQuery(sql, arguments);

    List<StageMaterialsIPAModel> list = res.isNotEmpty
        ? res.map((e) => StageMaterialsIPAModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<int> insUpdStagesMaterialIPA(List<StageMaterialsIPAModel> params) async {
    int result = 0;

    final db = await context.database;

    if (params.isNotEmpty) {
      params.forEach((item) async {
        final row = await db.query('EtapasMaterialesIPA',
          columns: ['NoRegistro'],
          where: 'NoRegistro = ? AND Orden = ?',
          whereArgs: [item.noRegistro, item.orden]
        );

        if(row.isNotEmpty) {
          result = await db.update(
            'EtapasMaterialesIPA',
            {
              'PorcentajeInspeccion': item.porcentajeInspeccion,
              'FechaReporte': item.fechaReporte,
              'FechaReporteLiberacion': item.fechaLiberacion,
              'RegBorrado': 0
            },
            where: 'NoRegistro = ? AND Orden = ?',
            whereArgs: [item.noRegistro, item.orden]
          );


        } else {
          result = await db.insert(
            'EtapasMaterialesIPA',
            {
              'NoRegistro': item.noRegistro,
              'Orden': item.orden,
              'Etapa': item.etapa,
              'PorcentajeInspeccion': item.porcentajeInspeccion,
              'FechaReporte': item.fechaReporte,
              'FechaReporteLiberacion': item.fechaLiberacion
            }
          );
        }
      });
    }

    return result;
  }

  Future<List<MaterialsTableIPAModel>> selMaterialsByRecordNo(String noRegistro) async {
    String sql;
    List<dynamic> arguments;

    final functionsDao = new FunctionsDao();
    List<MaterialsTableIPAModel> table = [];
    
    final db = await context.database;
    
    sql = '''
      SELECT 		      M.NombreElemento,
                      CASE 
                        WHEN M.TrazabilidadId = '' THEN J.JuntaNo
                        ELSE NULL
                      END JuntaNo,
                      M.PlanoDetalleId,
                      CASE
                        WHEN M.TrazabilidadId = '' THEN VT.IdTrazabilidad
                        ELSE M.TrazabilidadId
                      END TrazabilidadId,
                      CASE 
                        WHEN M.TrazabilidadId = '' THEN (SELECT UM FROM Trazabilidad WHERE IdTrazabilidad = VT.IdTrazabilidad AND RegBorrado = 0 LIMIT 1)
                        ELSE (SELECT UM FROM Trazabilidad WHERE IdTrazabilidad = M.TrazabilidadId AND RegBorrado = 0 LIMIT 1)
                      END UM,
                      CASE
                        WHEN M.TrazabilidadId = '' THEN 'Spool'
                        ELSE 'PiezaSuelta'
                      END TipoMaterial,
                      CASE 
                        WHEN M.TrazabilidadId = '' THEN VT.CantidadUsada
                        ELSE VPS.CantidadUsada
                      END CantidadUsada
          FROM 	      Materiales M
          INNER JOIN	EnvioMaterialesCorrosion EMC ON EMC.NoEnvio = M.NoEnvio AND EMC.NoRegistroInspeccion = ? AND EMC.RegBorrado = 0
          LEFT JOIN	  Junta J ON J.SpoolEstructura = M.NombreElemento AND J.Estado = 'LIBERADA' AND J.RegBorrado = 0
          LEFT JOIN 	Conformado C ON C.JuntaId = J.JuntaId AND C.Activo = 1 AND C.RegBorrado = 0
          LEFT JOIN	  VolumenTrazabilidad VT ON VT.ConformadoId = C.ConformadoId AND VT.RegBorrado = 0
          LEFT JOIN 	VolumenTrazabilidadPS VPS ON M.TrazabilidadId = VPS.IdTrazabilidad AND VPS.RegBorrado = 0
          WHERE		    M.RegBorrado = 0 AND
                      M.TrazabilidadId = ''
    ''';

    arguments = [noRegistro];

    final resSpool = await db.rawQuery(sql, arguments);

    List<MaterialsIPAModel> listSpool = resSpool.isNotEmpty
        ? resSpool.map((e) => MaterialsIPAModel.fromJson(e)).toList()
        : [];

    sql = '''
      SELECT 		      M.NombreElemento,
                      CASE 
                        WHEN M.TrazabilidadId = '' THEN J.JuntaNo
                        ELSE NULL
                      END JuntaNo,
                      M.PlanoDetalleId,
                      CASE
                        WHEN M.TrazabilidadId = '' THEN VT.IdTrazabilidad
                        ELSE M.TrazabilidadId
                      END TrazabilidadId,
                      CASE 
                        WHEN M.TrazabilidadId = '' THEN (SELECT UM FROM Trazabilidad WHERE IdTrazabilidad = VT.IdTrazabilidad AND RegBorrado = 0 LIMIT 1)
                        ELSE (SELECT UM FROM Trazabilidad WHERE IdTrazabilidad = M.TrazabilidadId AND RegBorrado = 0 LIMIT 1)
                      END UM,
                      CASE
                        WHEN M.TrazabilidadId = '' THEN 'Spool'
                        ELSE 'PiezaSuelta'
                      END TipoMaterial,
                      CASE 
                        WHEN M.TrazabilidadId = '' THEN VT.CantidadUsada
                        ELSE VPS.CantidadUsada
                      END CantidadUsada
          FROM 	      Materiales M
          INNER JOIN	EnvioMaterialesCorrosion EMC ON EMC.NoEnvio = M.NoEnvio AND EMC.NoRegistroInspeccion = ? AND EMC.RegBorrado = 0
          LEFT JOIN	  Junta J ON J.SpoolEstructura = M.NombreElemento AND J.Estado = 'LIBERADA' AND J.RegBorrado = 0
          LEFT JOIN 	Conformado C ON C.JuntaId = J.JuntaId AND C.Activo = 1 AND C.RegBorrado = 0
          LEFT JOIN	  VolumenTrazabilidad VT ON VT.ConformadoId = C.ConformadoId AND VT.RegBorrado = 0
          LEFT JOIN 	VolumenTrazabilidadPS VPS ON M.TrazabilidadId = VPS.IdTrazabilidad AND VPS.RegBorrado = 0
          WHERE		    M.RegBorrado = 0 AND
                      M.TrazabilidadId <> ''
    ''';

    arguments = [noRegistro];
    final resPza = await db.rawQuery(sql, arguments);

    List<MaterialsIPAModel> listPza = resPza.isNotEmpty
        ? resPza.map((e) => MaterialsIPAModel.fromJson(e)).toList()
        : [];

    

    List<MaterialsIPAModel> list = listSpool + listPza;

    print('');

    if (list.isNotEmpty) {
      for (var item in list) {
        String planoDetalle = '';

        sql = '''
          SELECT 		Localizacion,
                    CASE 
                      WHEN Liberacion = '0001-01-01 00:00:00.000' THEN NULL
                      ELSE STRFTIME('%d/%m/%Y', Liberacion) 
                    END Liberacion
          FROM		  MaterialesIPA
          WHERE		  NoRegistro = ? AND
                    MaterialIdIPA = ? AND
                    RegBorrado = 0
        ''';

        arguments = [noRegistro, list.indexOf(item) + 1];

        final info = await db.rawQuery(sql, arguments);
        String localizacion = '';
        String liberacion;

        if(info.isNotEmpty) {
          localizacion = info.first['Localizacion'];
          liberacion = info.first['Liberacion'];
        }

        if (item.tipoMaterial == 'Spool') {
          planoDetalle = await functionsDao.fnSelDetailSpool(item.nombreElemento);
        } else {
          sql = '''
            SELECT 		PD.NumeroPlano || ' Rev. ' || CAST(PD.Revision AS TEXT) || ' Hoja ' || CAST(PD.Hoja AS TEXT) Plano
            FROM		  PlanoDetalle PD
            WHERE 		PD.PlanoDetalleId = ? AND
                      PD.RegBorrado = 0
          ''';

          arguments = [item.planoDetalleId];

          final plano = await db.rawQuery(sql, arguments);
          if(plano.isNotEmpty) {
            planoDetalle = plano.first['Plano'];
          }
        }

        table.add(new MaterialsTableIPAModel(
          materialIdIPA: list.indexOf(item) + 1,
          nombreElemento: item.tipoMaterial == 'Spool' ? item.nombreElemento + '\n' + item.juntaNo : item.nombreElemento,
          localizacion: localizacion,
          trazabilidadId: item.trazabilidadId,
          planoDetalle: planoDetalle,
          um: item.um,
          tipoMaterial: item.tipoMaterial,
          cantidadUsada: item.cantidadUsada,
          fechaLiberacion: liberacion
        ));
      }
    }

    return table;
  }

  Future<List<MaterialStagesDIPAModel>> selMaterialStagesDIPA(String noRegistro) async { 
    String sql;
    List<dynamic> arguments;
    
    final db = await context.database;

    sql = '''
      SELECT 		NoRegistro,
                MaterialIdIPA,
                Orden,
				        CASE
					        WHEN FechaEvaluacion = '0001-01-01 00:00:00.000' THEN NULL
					        ELSE STRFTIME('%d/%m/%Y', FechaEvaluacion)
                END FechaEvaluacion,
				        CASE
                  WHEN FechaPropuesta = '0001-01-01 00:00:00.000' THEN NULL
                  ELSE STRFTIME('%d/%m/%Y', FechaPropuesta)
                END FechaPropuesta,
				        Norma,
				        Espesor,
				        Completado
      FROM			EtapasMaterialesDIPA
      WHERE			NoRegistro = ? AND
				        RegBorrado = 0
    ''';

    arguments = [noRegistro];

    final res = await db.rawQuery(sql, arguments);

    List<MaterialStagesDIPAModel> list = res.isNotEmpty
        ? res.map((e) => MaterialStagesDIPAModel.fromJson(e)).toList()
        : [];


    return list; 
  }

  Future<int> insUpdMaterialsIPA(List<MaterialsTableIPAModel> params, String noRegistro) async {
    int result = 0;

    final db = await context.database;

    if (params.isNotEmpty) {
      params.forEach((item) async {
        final row = await db.query('MaterialesIPA',
          columns: ['NoRegistro'],
          where: 'NoRegistro = ? AND MaterialIdIPA = ? AND RegBorrado = 0',
          whereArgs: [noRegistro, item.materialIdIPA]
        );

        if(row.isNotEmpty) {
          result = await db.update(
            'MaterialesIPA',
            {
              'Localizacion': item.localizacion,
              'Liberacion': item.fechaLiberacion
            },
            where: 'NoRegistro = ? AND MaterialIdIPA = ? AND RegBorrado = 0',
            whereArgs: [noRegistro, item.materialIdIPA]
          );
        } else {
          result = await db.insert(
            'MaterialesIPA',
            {
              'NoRegistro': noRegistro,
              'MaterialIdIPA': item.materialIdIPA,
              'Localizacion': item.localizacion,
              'Liberacion': item.fechaLiberacion,
              'TipoMaterial': item.tipoMaterial,
              'NombreElemento': item.nombreElemento,
              'PlanoLocalizacion': item.planoDetalle,
              'Trazabilidad': item.trazabilidadId,
              'Cantidad': item.cantidadUsada,
              'UM': item.um
            }
          );
        }
      });
    }

    return result;
  }

  Future<int> insUpdMaterialsStagesDIPA(List<MaterialStagesDIPAModel> params) async {
    int result = 0;

    final db = await context.database;

    if (params.isNotEmpty) {
      params.forEach((item) async {
        final row = await db.query('EtapasMaterialesDIPA',
          columns: ['NoRegistro'],
          where: 'NoRegistro = ? AND MaterialIdIPA = ? AND Orden = ? AND RegBorrado = 0',
          whereArgs: [item.noRegistro, item.materialIdIPA, item.orden]
        );

        if(row.isNotEmpty) {
          result = await db.update(
            'EtapasMaterialesDIPA',
            {
              'FechaEvaluacion': item.fechaEvaluacion,
              'FechaPropuesta': item.fechaPropuesta,
              'Norma': item.norma,
              'Espesor': item.espesor,
              'Completado': item.completado
            },
            where: 'NoRegistro = ? AND MaterialIdIPA = ? AND Orden = ? AND RegBorrado = 0',
            whereArgs: [item.noRegistro, item.materialIdIPA, item.orden]
          );
        } else {
          result = await db.insert(
            'EtapasMaterialesDIPA',
            {
              'NoRegistro': item.noRegistro,
              'MaterialIdIPA': item.materialIdIPA,
              'Orden': item.orden,
              'Etapa': '',
              'FechaEvaluacion': item.fechaEvaluacion,
              'FechaPropuesta': item.fechaPropuesta,
              'Norma': item.norma,
              'Espesor': item.espesor,
              'Completado': item.completado
            }
          );
        }
      });
    }

    return result;
  }
}
