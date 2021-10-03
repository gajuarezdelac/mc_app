import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/models/synchronization_model.dart';

@immutable
abstract class SynchronizationState {
  final List<SynchronizationModel> syncs;
  final String message;

  SynchronizationState({this.syncs, this.message});
}

class InitialSynchronizationState extends SynchronizationState {}

class IsLoadingLastSynchronization extends SynchronizationState {}

class ErrorLastSynchronization extends SynchronizationState {
  ErrorLastSynchronization({@required String errorMessage})
      : super(message: errorMessage);
}

class SuccessLastSynchronization extends SynchronizationState {
  SuccessLastSynchronization({@required List<SynchronizationModel> syncs})
      : super(syncs: syncs);
}
