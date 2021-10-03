import 'package:mc_app/src/data/dao/consecutive_dao.dart';
import 'package:mc_app/src/data/dao/site_dao.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/UpdateIdModel.dart';
import 'package:mc_app/src/models/document_model.dart';
import 'package:mc_app/src/models/params/documents_params.dart';
import 'package:mc_app/src/utils/makePlaceholders.dart';

class DocumentDao {
  DBContext context = DBContext();

  Future<List<DocumentModel>> selDocuments(DocumentsParams params) async {
    String sql;
    List<dynamic> arguments;

    sql = '''
      SELECT			DocumentoId Id,
                  NombreArchivo [Name],
                  ContentType,
                  Content,
                  NombreDocumento Nombre
      FROM			  Documentos
      WHERE			  NombreTabla = ? AND
				          IdentificadorTabla = ? AND
                  RegBorrado = 0
    ''';

    arguments = [params.nombreTabla, params.identificadorTabla];

    final db = await context.database;
    final res = await db.rawQuery(sql, arguments);

    List<DocumentModel> list = res.isNotEmpty
        ? res.map((e) => DocumentModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<List<UpdateIdModel>> insUpdDocumentos(List<DocumentModel> params,
      String identificadorTabla, String nombreTabla) async {
    final consecutive = ConsecutiveDao();
    final site = SiteDao();

    var siteId = await site.getSiteId();

    String sql;
    List<dynamic> arguments;
    List<UpdateIdModel> list = [];

    final db = await context.database;

    //Eliminar los que no llegaron
    if (params.length == 0) {
      sql = '''
        UPDATE 		Documentos
        SET			  RegBorrado = -1
        WHERE		  IdentificadorTabla = ? AND
                  NombreTabla = ? AND
                  RegBorrado = 0
      ''';

      arguments = [identificadorTabla, nombreTabla];

      await db.rawQuery(sql, arguments);
    } else {
      List<dynamic> args = params.map((e) => e.id).toList();

      String placeHolders = makePlaceholders(args.length);

      sql = '''
        UPDATE 		Documentos
        SET			  RegBorrado = -1
        WHERE		  DocumentoId NOT IN ($placeHolders) AND
                  IdentificadorTabla = ? AND
                  NombreTabla = ? AND
                  RegBorrado = 0
      ''';

      args.add(identificadorTabla);
      args.add(nombreTabla);

      await db.rawQuery(sql, args);
    }

    //Actualizar e insertar los documentos
    for (var element in params) {
      final documento = await db.query('Documentos',
          columns: ['DocumentoId'],
          where:
              'DocumentoId = ? AND IdentificadorTabla = ? AND NombreTabla = ? AND RegBorrado = 0',
          whereArgs: [element.id, identificadorTabla, nombreTabla]);

      if (documento.isNotEmpty) {
        await db.update('Documentos', {'NombreDocumento': element.nombre},
            where:
                'DocumentoId = ? AND IdentificadorTabla = ? AND NombreTabla = ? AND RegBorrado = 0',
            whereArgs: [element.id, identificadorTabla, nombreTabla]);
      } else {
        var newId = await consecutive.getConsecutiveId('Documento', siteId);

        await db.insert(
          'Documentos',
          {
            'DocumentoId': newId,
            'NombreDocumento': element.nombre,
            'Content': element.content,
            'ContentType': element.contentType,
            'NombreArchivo': element.name,
            'NombreTabla': nombreTabla,
            'IdentificadorTabla': identificadorTabla
          },
        );

        list.add(new UpdateIdModel(consecutivo: newId, id: element.id));
      }
    }

    return list;
  }
}
