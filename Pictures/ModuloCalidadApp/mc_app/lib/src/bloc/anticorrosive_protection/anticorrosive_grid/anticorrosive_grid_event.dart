import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/params/anticorrosive_grid_params.dart';

@immutable
abstract class AnticorrosiveGridEvent {
  final AnticorrosiveGridParams params;

  AnticorrosiveGridEvent({this.params});
}

class GetAnticorrosiveItems extends AnticorrosiveGridEvent {
  GetAnticorrosiveItems({@required AnticorrosiveGridParams params})
      : super(params: params);
}
