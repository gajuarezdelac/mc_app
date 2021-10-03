import 'package:intl/intl.dart';
import 'package:mc_app/src/data/dao/consecutive_dao.dart';
import 'package:mc_app/src/data/dao/site_dao.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/UpdateIdModel.dart';
import 'package:mc_app/src/models/params/evidence_welder_card_params.dart';
import 'package:mc_app/src/models/params/photographic_evidence_params_model.dart';
import 'package:mc_app/src/models/photographic_evidence_model.dart';

class PhotographicEvidenceDao {
  final String fotoTable = "Foto";
  DBContext context = DBContext();

  Future<List<PhotographicEvidenceModel>> fetchGetAllPhotographics(
      PhotographicEvidenceParamsModel params) async {
    final db = await context.database;
    List<Map> maps = await db.query(fotoTable,
        where:
            "IdentificadorTabla = ?  AND NombreTabla = ? AND RegBorrado = 0 ",
        whereArgs: [params.identificadorTabla, params.nombreTabla]);

    List<PhotographicEvidenceModel> list = maps.isNotEmpty
        ? maps.map((e) => PhotographicEvidenceModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<List<PhotographicEvidenceModel>> fetchGetAllPhotographicsV2(
      PhotographicEvidenceParamsModel params) async {
    final db = await context.database;
    List<Map> maps = await db.query(fotoTable,
        where:
            "IdentificadorTabla LIKE ?  AND NombreTabla = ? AND RegBorrado = 0 ",
        whereArgs: [params.identificadorTabla, params.nombreTabla]);

    List<PhotographicEvidenceModel> list = maps.isNotEmpty
        ? maps.map((e) => PhotographicEvidenceModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<PhotographicEvidenceModel> fetchDeletePhotographics(String id) async {
    final db = await context.database;

    PhotographicEvidenceModel modelUpdate = await fetchGetPhotographicsById(id);

    modelUpdate.regBorrado = -1;

    await db.update(fotoTable, modelUpdate.toJson(),
        where: "FotoId = ?", whereArgs: [id]);

    return modelUpdate;
  }

  Future<int> fetchAddPhotographics(PhotographicEvidenceModel data) async {
    final db = await context.database;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String currentDate = formatter.format(now);

    final site = SiteDao();
    final consecutive = ConsecutiveDao();

    var siteId = await site.getSiteId();

    var newId = await consecutive.getConsecutiveId(fotoTable, siteId);

    data.fotoId = newId;
    data.siteModificacion = siteId;
    data.fechaModificacion = currentDate;
    data.regBorrado = 0;

    final response = await db.insert(fotoTable, data.toMap());

    return response;
  }

  Future<int> fetchAddAllPhotographics(List<PhotographicEvidenceModel> data,
      List<PhotographicEvidenceModel> delete) async {
    final db = await context.database;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String currentDate = formatter.format(now);

    final site = SiteDao();
    final consecutive = ConsecutiveDao();

    var siteId = await site.getSiteId();
    var response = 1;

    await Future.forEach(data, (e) async {
      var newId = await consecutive.getConsecutiveId(fotoTable, siteId);

      e.fotoId = newId;
      e.siteModificacion = siteId;
      e.fechaModificacion = currentDate;
      e.regBorrado = 0;

      response = await db.insert(fotoTable, e.toMap());
    });

    await Future.forEach(delete, (d) async {
      await db.update(fotoTable, d.toJson(),
          where: "FotoId = ?", whereArgs: [d.fotoId]);
    });

    return response;
  }

  Future<PhotographicEvidenceModel> fetchGetPhotographicsById(String id) async {
    final db = await context.database;
    List<Map> maps =
        await db.query(fotoTable, where: "FotoId=?", whereArgs: [id]);

    PhotographicEvidenceModel photo =
        maps.isNotEmpty ? PhotographicEvidenceModel.fromJson(maps[0]) : {};

    return photo;
  }

  // Control de soldadura Evidencia

  // Recupera la evidencia fotografica en general
  Future<List<PhotographicEvidenceWeldingModel>>
      fetchGetAllPhotographicsWelding(
          PhotographicEvidenceWeldingParamsModel params) async {
    final db = await context.database;
    List<Map> maps = await db.query(fotoTable,
        where:
            "IdentificadorTabla = ?  AND NombreTabla = ? AND RegBorrado = 0 ",
        whereArgs: [params.identificadorTabla, params.nombreTabla]);

    List<PhotographicEvidenceWeldingModel> list = maps.isNotEmpty
        ? maps.map((e) => PhotographicEvidenceWeldingModel.fromJson(e)).toList()
        : [];

    return list;
  }

  // Recupera la evidencia fotografica en general
  // (Sirve para las fichas de los Soldadores)

  Future<List<PhotographicEvidenceWeldingModel>> getAllEvidenceWelders(
    EvidenceWelderCardParams params,
  ) async {
    final db = await context.database;
    String inClause = params.identificadorTabla.toString();

    //Estrategia para sacar los IDs de las evidencias fotográficas
    inClause = inClause.replaceAll("[", "'");
    inClause = inClause.replaceAll(", ", "', '");
    inClause = inClause.replaceAll("]", "'");

    // Estrategia para obtener todas las evidencias fotográficas.
    List<Map> maps = await db.rawQuery(
      '''SELECT * FROM Foto 
      WHERE IdentificadorTabla IN ($inClause)  
      AND NombreTabla = ? AND RegBorrado = 0''',
      [params.nombreTabla],
    );

    List<PhotographicEvidenceWeldingModel> list = maps.isNotEmpty
        ? maps.map((e) => PhotographicEvidenceWeldingModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<PhotographicEvidenceWeldingModel> fetchDeletePhotographicsWelding(
      String id) async {
    final db = await context.database;
    PhotographicEvidenceWeldingModel modelUpdate =
        await fetchGetPhotographicsByIdWelding(id);

    modelUpdate.regBorrado = -1;

    await db.update(fotoTable, modelUpdate.toJson(),
        where: "FotoId = ?", whereArgs: [id]);

    return modelUpdate;
  }

  Future<int> fetchAddPhotographicsWelding(
      PhotographicEvidenceWeldingModel data) async {
    final db = await context.database;

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String currentDate = formatter.format(now);

    final site = SiteDao();
    final consecutive = ConsecutiveDao();

    var siteId = await site.getSiteId();

    var newId = await consecutive.getConsecutiveId(fotoTable, siteId);

    data.fotoId = newId;
    data.siteModificacion = siteId;
    data.fechaModificacion = currentDate;
    data.regBorrado = 0;

    final response = await db.insert(fotoTable, data.toMap());
    return response;
  }

  Future<PhotographicEvidenceWeldingModel> fetchGetPhotographicsByIdWelding(
      String id) async {
    final db = await context.database;
    List<Map> maps =
        await db.query(fotoTable, where: "FotoId=?", whereArgs: [id]);

    PhotographicEvidenceWeldingModel photo = maps.isNotEmpty
        ? PhotographicEvidenceWeldingModel.fromJson(maps[0])
        : {};

    return photo;
  }

  // Plan de inspección
  // -------------------
  // ----------------

  Future<List<PhotographicEvidenceIPModel>> fetchGetAllPhotographicsIP(
      PhotographicEvidenceIPParamsModel params) async {
    final db = await context.database;

    var maps = await db.rawQuery(
        '''SELECT * FROM Foto WHERE IdentificadorTabla LIKE '${params.identificadorTabla}%'  AND NombreTabla = '${params.nombreTabla}' AND RegBorrado = 0''');

    List<PhotographicEvidenceIPModel> list = maps.isNotEmpty
        ? maps.map((e) => PhotographicEvidenceIPModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<PhotographicEvidenceIPModel> fetchDeletePhotographicsIP(
      String id) async {
    final db = await context.database;

    PhotographicEvidenceIPModel modelUpdate =
        await fetchGetPhotographicsIPById(id);

    modelUpdate.regBorrado = -1;

    await db.update(fotoTable, modelUpdate.toJson(),
        where: "FotoId = ?", whereArgs: [id]);

    return modelUpdate;
  }

  Future<int> fetchAddPhotographicsIP(PhotographicEvidenceIPModel data) async {
    final db = await context.database;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String currentDate = formatter.format(now);

    final site = SiteDao();
    final consecutive = ConsecutiveDao();

    var siteId = await site.getSiteId();

    var newId = await consecutive.getConsecutiveId(fotoTable, siteId);

    data.fotoId = newId;
    data.siteModificacion = siteId;
    data.fechaModificacion = currentDate;
    data.regBorrado = 0;

    final response = await db.insert(fotoTable, data.toMap());

    return response;
  }

  Future<int> fetchAddAllPhotographicsIP(List<PhotographicEvidenceIPModel> data,
      List<PhotographicEvidenceIPModel> delete) async {
    final db = await context.database;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String currentDate = formatter.format(now);

    final site = SiteDao();
    final consecutive = ConsecutiveDao();

    var siteId = await site.getSiteId();
    var response = 1;

    await Future.forEach(data, (e) async {
      var newId = await consecutive.getConsecutiveId(fotoTable, siteId);

      e.fotoId = newId;
      e.siteModificacion = siteId;
      e.fechaModificacion = currentDate;
      e.regBorrado = 0;

      response = await db.insert(fotoTable, e.toMap());
    });

    if (delete.isNotEmpty) {
      delete.forEach((element) async {
        await db.update(fotoTable, {"RegBorrado": -1},
            where: "FotoId = ? AND IdentificadorTabla = ?",
            whereArgs: [element.fotoId, element.identificadorTabla]);
      });
    }

    return response;
  }

  // Busca la imagen por ID
  Future<PhotographicEvidenceIPModel> fetchGetPhotographicsIPById(
      String id) async {
    final db = await context.database;
    List<Map> maps =
        await db.query(fotoTable, where: "FotoId=?", whereArgs: [id]);

    PhotographicEvidenceIPModel photo =
        maps.isNotEmpty ? PhotographicEvidenceIPModel.fromJson(maps[0]) : {};

    return photo;
  }

  Future<List<UpdateIdModel>> insUpdEvidencePhotographicV2(
      List<PhotographicEvidenceModel> params,
      String identificadorComun,
      String tablaComun) async {
    final db = await context.database;
    final consecutive = ConsecutiveDao();
    final site = SiteDao();
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String currentDate = formatter.format(now);
    var siteId = await site.getSiteId();

    List<UpdateIdModel> list = [];

    //Eliminamos todas las imagenes
    await db.update(
        'Foto',
        {
          'RegBorrado': -1,
          'SiteModificacion': siteId,
          'FechaModificacion': currentDate
        },
        where:
            'NombreTabla = ? AND IdentificadorTabla LIKE ? AND RegBorrado = 0',
        whereArgs: [tablaComun, identificadorComun]);

    for (var element in params) {
      final photographic = await db.query('Foto',
          columns: ['FotoId'],
          where: 'FotoId = ?',
          whereArgs: [element.fotoId]);

      if (photographic.isNotEmpty) {
        await db.update(
            'Foto',
            {
              'RegBorrado': 0,
              'SiteModificacion': siteId,
              'FechaModificacion': currentDate
            },
            where: 'FotoId = ?',
            whereArgs: [element.fotoId]);
      } else {
        var newId = await consecutive.getConsecutiveId('Foto', siteId);

        await db.insert(
          'Foto',
          {
            'FotoId': newId,
            'Content': element.content,
            'Thumbnail': element.thumbnail,
            'ContentType': element.contentType,
            'Nombre': element.nombre,
            'IdentificadorTabla': element.identificadorTabla,
            'NombreTabla': element.nombreTabla,
            'SiteModificacion': siteId,
            'FechaModificacion': currentDate
          },
        );

        list.add(new UpdateIdModel(consecutivo: newId, id: element.fotoId));
      }
    }

    return list;
  }
}
