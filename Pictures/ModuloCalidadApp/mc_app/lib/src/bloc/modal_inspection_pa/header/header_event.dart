import 'package:flutter/cupertino.dart';

@immutable
abstract class HeaderEvent {
  final String noRegistro;

  HeaderEvent({
    this.noRegistro
  });
}

class GetHeader extends HeaderEvent {
  GetHeader({
    @required String noRegistro
  }) : super(noRegistro: noRegistro);
}