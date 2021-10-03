import 'bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/models/synchronization_model.dart';
import 'package:mc_app/src/repository/synchronization_repository.dart';

class SynchronizationBloc
    extends Bloc<SynchronizationEvent, SynchronizationState> {
  SynchronizationBloc() : super(InitialSynchronizationState());

  final _syncRepository = SynchronizationRepository();
  /*@override
  DropDownContractState get initialState => InitialDropDownContractState();*/

  @override
  Stream<SynchronizationState> mapEventToState(
      SynchronizationEvent event) async* {
    yield IsLoadingLastSynchronization();
    print(event.runtimeType);
    if (event is GetLastSynchronization) {
      try {
        List<SynchronizationModel> syncs =
            await _syncRepository.getLastSynchronization(query: event.query);

        yield SuccessLastSynchronization(syncs: syncs);
      } catch (e) {
        yield ErrorLastSynchronization(errorMessage: e.toString());
      }
    }

    /*switch(event.runtimeType){
      case GetSynchronizations:{
        try {
          List<SynchronizationModel> syncs =
          await _syncRepository.getSynchronizations(query: event.query);

          yield Success(syncs: syncs);
        } catch (e) {
          yield Error(errorMessage: e.toString());
        }
      }
      break;
      case GetLastSynchronization:{
        try {
          List<SynchronizationModel> syncs =
          await _syncRepository.getLastSynchronization(query: event.query);

          yield Success(syncs: syncs);
        } catch (e) {
          yield Error(errorMessage: e.toString());
        }
      }
      break;
      case InsertSynchronization:{
        try {
          event.sync.SincronizacionId =
          await _syncRepository.insertSynchronization(sync: event.sync);
          List<SynchronizationModel> syncs=new List<SynchronizationModel>();
          syncs.add(event.sync);
          yield Success(syncs: syncs);
        } catch (e) {
          yield Error(errorMessage: e.toString());
        }
      }
      break;
      default: {
        print('no implementado');
        /*try {
          await _syncProvider.synchronize();
          List<SynchronizationModel> syncs=new List<SynchronizationModel>();
          yield Success(syncs: syncs);
        } catch (e) {
          yield Error(errorMessage: e.toString());
        }*/
      }
      break;
    }*/
  }
}
