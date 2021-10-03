import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/document_model.dart';
import 'package:mc_app/src/models/params/documents_params.dart';

@immutable
abstract class DocumentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetDocuments extends DocumentEvent {
  final DocumentsParams params;

  GetDocuments({this.params});

  List<Object> get props => [params];
}

class InsUpdDocument extends DocumentEvent {
  final List<DocumentModel> params;
  final String identificadorTabla;
  final String nombreTabla;

  InsUpdDocument({this.params, this.identificadorTabla, this.nombreTabla});

  List<Object> get props => [params, identificadorTabla, nombreTabla];
}