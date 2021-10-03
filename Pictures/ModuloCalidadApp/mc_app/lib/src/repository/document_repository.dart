import 'package:mc_app/src/data/dao/document_dao.dart';
import 'package:mc_app/src/models/document_model.dart';
import 'package:mc_app/src/models/params/documents_params.dart';

class DocumentRepository {
  final DocumentDao documentDao = DocumentDao();

  Future getDocuments(DocumentsParams params) =>
      documentDao.selDocuments(params);

  Future insUpdDocuments(List<DocumentModel> params, String identificadorTabla, String nombreTabla) => 
      documentDao.insUpdDocumentos(params, identificadorTabla, nombreTabla);
}