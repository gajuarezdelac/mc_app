import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/tab_forming/qa/qa_event.dart';
import 'package:mc_app/src/bloc/tab_forming/qa/qa_state.dart';
import 'package:mc_app/src/data/dao/employee_dao.dart';
import 'package:mc_app/src/models/employee_model.dart';

class QABloc extends Bloc<QAEvent, QAState> {
  QABloc() : super(InitialQAState());

  final _empoyee = EmployeeDao();

  @override
  Stream<QAState> mapEventToState(QAEvent event) async* {
    if (event is GetQA) {
      yield IsLoadingQA();

      try {
        EmployeeModel qa = await _empoyee.fetchEmployeeById(event.employeeId);

        yield SuccessGetQA(qa: qa);
      } catch (e) {
        yield ErrorQA(error: e.toString());
      }
    }
  }
}
