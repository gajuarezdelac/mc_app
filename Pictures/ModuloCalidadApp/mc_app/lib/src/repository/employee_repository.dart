import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/data/dao/employee_dao.dart';

class EmployeeRepository {
  final employee = EmployeeDao();

  Future fetchEmployeeById({@required int employeeId}) =>
      employee.fetchEmployeeById(employeeId);

  Future fetchEmployeeByFicha({@required int ficha}) =>
      employee.fetchEmployeeByFicha(ficha);
}
