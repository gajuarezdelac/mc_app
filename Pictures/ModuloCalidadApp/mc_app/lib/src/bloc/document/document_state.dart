import 'package:flutter/material.dart';
import 'package:mc_app/src/models/UpdateIdModel.dart';
import 'package:mc_app/src/models/document_model.dart';

@immutable
abstract class DocumentState {
  final List<DocumentModel> data;
  final String message;
  final List<UpdateIdModel> list;

  DocumentState({this.data, this.message, this.list});
}

class InitialDocumentState extends DocumentState {}

class IsLoadingDocument extends DocumentState {}

class ErrorDocument extends DocumentState {
  ErrorDocument({@required String errorMessage})
  : super(message: errorMessage);
}

class SuccessGetDocuments extends DocumentState {
  SuccessGetDocuments({@required List<DocumentModel> data})
  : super(data: data);
}

class SuccessInsUpdDocuments extends DocumentState {
  SuccessInsUpdDocuments({@required List<UpdateIdModel> list})
  : super(list: list);
}