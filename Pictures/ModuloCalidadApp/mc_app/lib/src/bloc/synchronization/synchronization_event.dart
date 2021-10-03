import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/synchronization_model.dart';

@immutable
abstract class SynchronizationEvent {
  final SynchronizationModel sync;
  final String query;

  SynchronizationEvent({this.sync, this.query});
}

class GetSynchronizations extends SynchronizationEvent {
  GetSynchronizations({String query}) : super(query: query);
}

class GetLastSynchronization extends SynchronizationEvent {
  GetLastSynchronization({String query}) : super(query: query);
}

class InsertSynchronization extends SynchronizationEvent {
  InsertSynchronization({SynchronizationModel sync}) : super(sync: sync);
}

class ExecSynchronization extends SynchronizationEvent {
  ExecSynchronization({String query}) : super(query: query);
}
