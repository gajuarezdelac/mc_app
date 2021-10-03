import 'package:flutter/cupertino.dart';

@immutable
abstract class ExistingElementEvent {
  final String idElementoExistente;

  ExistingElementEvent({this.idElementoExistente});
}

class GetExistingElement extends ExistingElementEvent {
  GetExistingElement({@required String idElementoExistente}) : super(idElementoExistente: idElementoExistente);
}
