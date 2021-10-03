import 'package:flutter/cupertino.dart';

@immutable
abstract class CoatingSystemEvent {
  final String noRegistro;

  CoatingSystemEvent({this.noRegistro});
}

class GetStagesCoatingSystem extends CoatingSystemEvent {
  GetStagesCoatingSystem({@required String noRegistro})
      : super(noRegistro: noRegistro);
}
