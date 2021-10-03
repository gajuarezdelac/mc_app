import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/document/document_event.dart';
import 'package:mc_app/src/bloc/document/document_state.dart';
import 'package:mc_app/src/models/UpdateIdModel.dart';
import 'package:mc_app/src/models/document_model.dart';
import 'package:mc_app/src/repository/document_repository.dart';

class DocumentBloc
    extends Bloc<DocumentEvent, DocumentState> {
  DocumentBloc() : super(InitialDocumentState());

  final _documentRepository =
      DocumentRepository();

  @override
  Stream<DocumentState> mapEventToState(
      DocumentEvent event) async* {
    if (event is GetDocuments) {
      yield IsLoadingDocument();

      try {
        List<DocumentModel> data =
            await _documentRepository.getDocuments(event.params);

        yield SuccessGetDocuments(data: data);
      } catch (e) {
        yield ErrorDocument(errorMessage: e.toString());
      }
    }

    if (event is InsUpdDocument) {
      yield IsLoadingDocument();

      try {
        List<UpdateIdModel> list = await _documentRepository.insUpdDocuments(
            event.params, event.identificadorTabla, event.nombreTabla);

        yield SuccessInsUpdDocuments(list: list);
      } catch (e) {
        yield ErrorDocument(errorMessage: e.toString());
      }
    }
  }
}
