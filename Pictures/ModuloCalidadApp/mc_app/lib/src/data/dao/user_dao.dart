import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/user_avatar_model.dart';
import 'package:mc_app/src/models/user_off_model.dart';
import 'package:mc_app/src/models/user_permission_model.dart';

class UserDao {
  DBContext con = DBContext();
  //insertion
  Future<int> saveUser(UserModelOff user) async {
    var dbClient = await con.database;
    int res = await dbClient.insert("Empleados", user.toMap());
    return res;
  }

  //deletion
  Future<int> deleteUser(UserModelOff user) async {
    var dbClient = await con.database;
    int res = await dbClient.delete("Empleados");
    return res;
  }

  Future<UserModelOff> getLogin(
      String ficha, String email, String fechaIngreso) async {
    var dbClient = await con.database;
    var res = await dbClient.rawQuery('''
       SELECT * FROM Employee
	     LEFT JOIN User ON User.Ficha = Employee.Ficha
	     INNER JOIN UserRoles ON User.UserId = UserRoles.UserId 
	     INNER JOIN Role ON UserRoles.RoleId = Role.RoleId
	     INNER JOIN Application ON Role.ApplicationId = Application.ApplicationId 
	     WHERE Employee.Ficha = '$ficha' and User.Email = '$email' and Employee.FechaAntiguedad = '$fechaIngreso' LIMIT 1
        ''');

    if (res.length > 0) {
      return new UserModelOff.fromMap(res.first);
    }
    return null;
  }

  Future<UserAvatarModel> fetchInfoAvatar(String ficha) async {
    var dbClient = await con.database;
    var res = await dbClient.rawQuery('''
       SELECT 
       Employee.PrettyName AS Nombre,
       User.Email AS Email,
       User.Ficha AS Ficha,
       Employee.Puesto As PuestoDescripcion,
	     Role.NameRole AS Rol
       FROM Employee
	     LEFT JOIN User ON User.Ficha = Employee.Ficha
	     INNER JOIN UserRoles ON User.UserId = UserRoles.UserId 
	     INNER JOIN Role ON UserRoles.RoleId = Role.RoleId
	     INNER JOIN Application ON Role.ApplicationId = Application.ApplicationId 
	     WHERE Employee.Ficha = '$ficha' 
        ''');

    if (res.length > 0) {
      return new UserAvatarModel.fromJson(
        res.first,
      );
    }
    return null;
  }

  Future<UserGeneral> getUserGeneral(int ficha) async {
    final db = await con.database;

    final res = await db.query(
      'Empleados',
      columns: [
        'Nombre',
        'Ficha',
        'PuestoDescripcion',
      ],
      where: 'EmpleadoId = ? AND RegBorrado = ?',
      whereArgs: [ficha, 0],
      limit: 1,
    );

    UserGeneral userGeneral = res.isNotEmpty
        ? UserGeneral.fromJson(res.first)
        : UserGeneral(nombre: null, ficha: null, puesto: null);

    return userGeneral;
  }

  Future<UserPermissionModel> fetchUserPermission(int card) async {
    String sql;
    UserPermissionModel permissions = UserPermissionModel();

    if (card != 0) {
      final db = await con.database;

      sql = '''
      SELECT R.ResourceId, R.NameResource, R.Description
      FROM Employee
      LEFT JOIN User ON User.Ficha = Employee.Ficha
      INNER JOIN UserRoles ON User.UserId = UserRoles.UserId AND UserRoles.RegBorrado=0
      INNER JOIN Role ON UserRoles.RoleId = Role.RoleId
      INNER JOIN Application ON Role.ApplicationId = Application.ApplicationId 
      INNER JOIN Resource R ON R.ApplicationId = Application.ApplicationId
      INNER JOIN RoleResource RR ON Role.RoleId=RR.RoleId AND R.ResourceId=RR.ResourceId
      WHERE User.Ficha = ? AND RR.IsDenied=0
      ORDER BY R.ResourceId
    ''';

      List<Map<String, dynamic>> response = await db.rawQuery(sql, [card]);

      if (response.isNotEmpty) {
        response.forEach((item) {
          switch (item['NameResource']) {
            case 'InspectionPlanBtnView':
              permissions.inspectionPlanBtnView = true;
              break;
            case 'InspectionPlanBtnPrint':
              permissions.inspectionPlanBtnPrint = true;
              break;
            case 'InspectionPlanActivityInspectionLog':
              permissions.inspectionPlanActivityInspectionLog = true;
              break;
            case 'NonCompliantOutPutCCA':
              permissions.nonCompliantOutPutTrayFilters = true;
              break;
            case 'NonCompliantOutPutUpload':
              permissions.nonCompliantOutPutUpload = true;
              break;
            case 'NonCompliantOutPutPrint':
              permissions.nonCompliantOutPutPrint = true;
              break;
            case 'NonCompliantOutPutDD':
              permissions.nonCompliantOutPutDD = true;
              break;
            case 'NonCompliantOutPutSNC':
              permissions.nonCompliantOutPutSNC = true;
              break;
            case 'WeldingControlBtnRegistrosPnd':
              permissions.weldingControlBtnRegistrosPnd = true;
              break;
            case "WeldingControlBtnSolicitudesPnd":
              permissions.weldingControlBtnSolicitudesPnd = true;
              break;
            case "WeldingControlDefinirInspecVisSoldadura":
              permissions.weldingControlDefinirInspecVisSoldadura = true;
              break;
            case "WeldingControlChangeMaterials":
              permissions.weldingControlChangeMaterials = true;
              break;
            case "WeldingControlEditTabConformado":
              permissions.weldingControlEditTabConformado = true;
              break;
            case "WeldingControlInspVisualConformado":
              permissions.weldingControlInspVisualConformado = true;
              break;
            case "WeldingControlRelateActivityJoint":
              permissions.weldingControlRelateActivityJoint = true;
              break;
            case "WeldingControlTabSoldadura":
              permissions.weldingControlTabSoldadura = true;
              break;
            case "WeldingControlVisualizarTabPnd":
              permissions.weldingControlVisualizarTabPnd = true;
              break;
            default:
              break;
          }
        });
      }
    }

    return permissions;
  }
}
