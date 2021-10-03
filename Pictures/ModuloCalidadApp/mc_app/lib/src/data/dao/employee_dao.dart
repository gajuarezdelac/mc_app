import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/employee_model.dart';

class EmployeeDao {
  DBContext context = DBContext();
  EmployeeModel employee;

  Future<EmployeeModel> fetchEmployeeById(int employeeId) async {
    final db = await context.database;

    final res = await db.query(
      'Empleados',
      columns: [
        'EmpleadoId',
        'Foto',
        'Nombre',
        'Ficha',
        'PuestoDescripcion',
      ],
      where: 'EmpleadoId = ? AND RegBorrado = ?',
      whereArgs: [employeeId, 0],
      limit: 1,
    );

    employee = res.isNotEmpty ? EmployeeModel.fromJson(res.first) : null;

    return employee;
  }

  Future<EmployeeModel> fetchEmployeeByFicha(int ficha) async {
    final db = await context.database;

    final res = await db
        .rawQuery('''SELECT		IFNULL(Nombre || ' ' || Apellidos, Nombre) Nombre,
						EmpleadoId,
            Ficha,
            Foto,
						PuestoDescripcion
			FROM		Empleados
			WHERE		Ficha = $ficha AND
						RegBorrado = 0;''');

    employee = res.isNotEmpty ? EmployeeModel.fromJson(res.first) : null;

    return employee;
  }
}
