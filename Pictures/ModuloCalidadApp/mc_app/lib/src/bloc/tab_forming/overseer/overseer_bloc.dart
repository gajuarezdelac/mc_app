import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/overseer/overseer_event.dart';
import 'package:mc_app/src/bloc/tab_forming/overseer/overseer_state.dart';
import 'package:mc_app/src/data/dao/employee_dao.dart';
import 'package:mc_app/src/models/employee_model.dart';

class OverseerBloc extends Bloc<OverseerEvent, OverseerState> {
  OverseerBloc() : super(InitialOverseerState());

  final _empoyee = EmployeeDao();

  @override
  Stream<OverseerState> mapEventToState(OverseerEvent event) async* {
    if (event is GetOverseer) {
      yield IsLoadingOverseer();

      try {
        EmployeeModel overseer = await _empoyee.fetchEmployeeById(
          event.employeeId,
        );

        yield SuccessGetOverseer(overseer: overseer);
      } catch (e) {
        yield ErrorOverseer(error: e.toString());
      }
    }
  }
}

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(InitialEmployeeState());

  final _empoyee = EmployeeDao();

  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    if (event is GetEmployeeByFicha) {
      yield IsLoadingEmployee();

      try {
        EmployeeModel employee = await _empoyee.fetchEmployeeByFicha(
          event.ficha,
        );

        yield SuccessEmployee(employee: employee);
      } catch (e) {
        yield ErrorEmployee(error: e.toString());
      }
    }

    if (event is GetEmployeeMakesByFicha) {
      yield IsLoadingEmployee();

      try {
        EmployeeModel employee = await _empoyee.fetchEmployeeByFicha(
          event.ficha,
        );

        yield SuccessEmployeeMakes(employee: employee);
      } catch (e) {
        yield ErrorEmployee(error: e.toString());
      }
    }

      if (event is GetEmployeeAuthByFicha) {
      yield IsLoadingEmployee();

      try {
        EmployeeModel employee = await _empoyee.fetchEmployeeByFicha(
          event.ficha,
        );

        yield SuccessEmployeeAuth(employee: employee);
      } catch (e) {
        yield ErrorEmployee(error: e.toString());
      }
    }
  }
}