import 'package:mc_app/src/data/dao/joint_dao.dart';
import 'package:mc_app/src/data/dao/site_dao.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:intl/intl.dart';
import 'package:mc_app/src/models/acceptance_criteria_model.dart';
import 'package:mc_app/src/models/qualify_norm_model.dart';
import 'package:mc_app/src/models/welding_tab_model.dart';

class OverseerDao {
  DBContext context = DBContext();

  // st_CalificarCaboNorma - Calificar soldadura de (cabo/sobrestante) dentro de norma o fuera de norma y actualizar el campo Norma de HSEQMC.Soldadura
  Future<QualifyNormModel> qualifyCaboNorm(
    String folioSoldadura,
    int inspectorCCAId,
    String norma,
    String motivoFN,
    String juntaId,
    List<AcceptanceCriteriaWeldingModel> listACS,
    String nombreTabla,
  ) async {
    // Consultas
    String validarEmpleadoId;
    String updateEmpleadoNorma;
    String selectEstadoPND;
    String selectTotalEmpleados;
    String selectTotalDN;
    String selectTotalFN;
    String selectPendientes;

    String updateDentroNorma;
    String updateEstadoPND;
    String updateEstadoLiberada;
    String updateSoldaduraPendienteFN;
    String updateSoldaduraPendiente;
    String criterios = '';
    List<String> cAList = [];

    // Pametros
    int totalEmpleados;
    int totalDN;
    int totalFN;
    int totalPendientes;
    String estadoPND = '';
    int empleadoId;
    String siteIdG;

    // Se obtiene la fecha actual:
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    var dbClient = await context.database;
    final siteDao = SiteDao();
    final jointDao = JointDao();

    //Obtiene el SiteId
    siteIdG = await siteDao.getSiteId();

    // Nos ayuda a separar esta lista en una sublista
    if (listACS.isNotEmpty) {
      listACS.forEach((element) {
        cAList.add(element.criterioAceptacionId);
      });
      criterios = cAList.join("|");
    }

    // Nos valida si el empleado existe
    validarEmpleadoId = '''
    SELECT EmpleadoId,Ficha,Nombre,PuestoDescripcion FROM Empleados
    WHERE Ficha = '$inspectorCCAId' AND RegBorrado = 0 LIMIT 1 
    ''';

    // Se obtiene el empleadoId
    List<Map<String, dynamic>> topEmpleadoIdRes =
        await dbClient.rawQuery(validarEmpleadoId);

    String nombreQA = topEmpleadoIdRes[0]['Nombre'];
    String puestoDescripcion = topEmpleadoIdRes[0]['PuestoDescripcion'];

    // Se asigna el valor al empleado ID dependiendo de la consulta
    if (topEmpleadoIdRes.isNotEmpty) {
      empleadoId = topEmpleadoIdRes[0]['EmpleadoId'];
    } else {
      empleadoId = inspectorCCAId;
    }

    updateEmpleadoNorma = '''    
	  UPDATE EmpleadosSoldadura
	  SET Norma = '$norma', MotivoFN = '$motivoFN',
    CriteriosAceptacionId = '$criterios',
		InspectorCCAId = '$empleadoId',
		SiteModificacion = '$siteIdG',
		FechaModificacion = '$currentDate'
	  WHERE FolioSoldadura = '$folioSoldadura'
    ''';

    if (norma == 'F/N') {
      listACS.forEach((element) {
        dbClient.rawInsert(
            '''INSERT INTO CriterioAceptacionAsignacion  (CriterioAceptacionId, NombreTabla, IdentificadorTabla)
        VALUES('${element.criterioAceptacionId}','$nombreTabla', '$folioSoldadura') ''');
      });
    }

    selectEstadoPND = '''
    SELECT EstadoPND FROM Junta
	  WHERE JuntaId = '$juntaId' AND RegBorrado = 0
    ''';

    selectTotalEmpleados = '''
    SELECT COUNT(*) AS totalEmpleados FROM EmpleadosSoldadura ES
	  INNER JOIN Soldadura S ON S.SoldaduraId = ES.SoldaduraId AND S.RegBorrado = 0
	  WHERE S.JuntaId = '$juntaId' AND ES.RegBorrado = 0
    ''';

    selectTotalDN = '''
    SELECT COUNT(*) AS TotalDN FROM EmpleadosSoldadura ES
	  INNER JOIN Soldadura S ON S.SoldaduraId = ES.SoldaduraId AND S.RegBorrado = 0
  	WHERE ES.Norma = 'D/N' AND S.JuntaId = '$juntaId' AND ES.RegBorrado = 0
    ''';

    selectTotalFN = '''
    	SELECT COUNT(*) AS TotalFN FROM EmpleadosSoldadura ES
	    INNER JOIN Soldadura S ON S.SoldaduraId = ES.SoldaduraId AND S.RegBorrado = 0
	    WHERE ES.Norma = 'F/N' AND S.JuntaId = '$juntaId' AND ES.RegBorrado = 0
    ''';

    selectPendientes = '''
    SELECT COUNT(*) AS TotalPendientes FROM EmpleadosSoldadura ES
	  INNER JOIN Soldadura S ON S.SoldaduraId = ES.SoldaduraId AND S.RegBorrado = 0
	  WHERE ES.Norma = 'PENDIENTE' AND S.JuntaId = '$juntaId' AND ES.RegBorrado = 0
    ''';

    updateDentroNorma = '''
    UPDATE Soldadura
		SET Norma = 'D/N',
		CambioMaterial = 'NO APLICA',
		SiteModificacion = '$siteIdG',
		FechaModificacion = '$currentDate'
		WHERE JuntaId = '$juntaId'
    ''';

    updateEstadoPND = '''
    UPDATE Junta
		SET Estado = 'PND',
	  SiteModificacion = '$siteIdG',
		FechaModificacion = '$currentDate'
		WHERE JuntaId = '$juntaId'
    ''';

    updateEstadoLiberada = '''
    	UPDATE Junta
			SET Estado = 'LIBERADA',
			SiteModificacion = '$siteIdG',
		  FechaModificacion = '$currentDate'
		  WHERE JuntaId = '$juntaId'
    ''';

    updateSoldaduraPendienteFN = '''
     UPDATE Soldadura
		 SET Norma = 'F/N',
		 CambioMaterial = 'PENDIENTE',
		 SiteModificacion = '$siteIdG',
		 FechaModificacion = '$currentDate'
		 WHERE JuntaId = '$juntaId'
    ''';

    updateSoldaduraPendiente = '''
    	UPDATE Soldadura
		  SET Norma = 'PENDIENTE',
		  SiteModificacion = '$siteIdG',
		  FechaModificacion = '$currentDate'
		  WHERE JuntaId = '$juntaId'
    ''';

    // Consulta pricipal
    // Actualizamos el registro del empleado
    await dbClient.rawUpdate(updateEmpleadoNorma);

    // Recuperaramos el estado de la junta
    List<Map<String, dynamic>> estadoPNDRes =
        await dbClient.rawQuery(selectEstadoPND);
    estadoPND = estadoPNDRes[0]['EstadoPND'];

    // Recuperamos el total de empleados trabajando en la junta
    List<Map<String, dynamic>> totalEmpleadosRes =
        await dbClient.rawQuery(selectTotalEmpleados);
    totalEmpleados = totalEmpleadosRes[0]['totalEmpleados'];

    // Recuperamos el total de empleados con FN
    List<Map<String, dynamic>> totalEmpleadosFNRes =
        await dbClient.rawQuery(selectTotalFN);
    totalFN = totalEmpleadosFNRes[0]['TotalFN'];

    // Recuperamos el total de empleados con soldadura DN
    List<Map<String, dynamic>> totalEmpleadosDNRes =
        await dbClient.rawQuery(selectTotalDN);
    totalDN = totalEmpleadosDNRes[0]['TotalDN'];

    // Recuperamos el total de empleados con soldadura pendiente
    List<Map<String, dynamic>> totalEmpleadosPendientesRes =
        await dbClient.rawQuery(selectPendientes);
    totalPendientes = totalEmpleadosPendientesRes[0]['TotalPendientes'];

    // Total de empleados igual a total de empleados dentro de norma?
    if (totalEmpleados == totalDN) {
      // Actualizamos
      await dbClient.rawUpdate(updateDentroNorma);

      // No liberada
      if (estadoPND == 'APLICA') {
        await dbClient.rawUpdate(updateEstadoPND);
      }
      // Liberada
      if (estadoPND == 'NO_APLICA') {
        await dbClient.rawUpdate(updateEstadoLiberada);
      }

      await jointDao.updateProgressJoint(juntaId);
    }

    if (totalFN > 0) {
      await dbClient.rawUpdate(updateSoldaduraPendienteFN);
    }

    if (totalPendientes > 0) {
      await dbClient.rawUpdate(updateSoldaduraPendiente);
    }

    return QualifyNormModel(
        ficha: inspectorCCAId,
        nombre: nombreQA,
        puesto: puestoDescripcion,
        folioSoldadura: folioSoldadura,
        norma: norma == 'D/N' ? 'dentro' : 'fuera');
  }

  // El cabo pueda liberar la soldadura.
  Future<ReleaseWeldingResponseModel> releaseCaboOfWelding(
    int employeeId,
    String weldingId,
  ) async {
    // Queries
    String validateEmployeeIdSql;
    String fetchJointIdSql;
    int totalRegisterAffected;

    // Params

    String jointId;
    int varEmployeeId;
    String siteIdG;

    // Obtiene la fecha actual
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    var dbClient = await context.database;
    final siteDao = SiteDao();
    final jointDao = JointDao();

    //Obtiene el SiteId
    siteIdG = await siteDao.getSiteId();

    // fetch the employeed based in this query
    validateEmployeeIdSql = '''
    SELECT EmpleadoId FROM Empleados
    WHERE Ficha = '$employeeId' AND RegBorrado = 0 LIMIT 1 
    ''';

    // Se obtiene el empleadoId
    List<Map<String, dynamic>> topEmpleadoIdRes =
        await dbClient.rawQuery(validateEmployeeIdSql);

    // Se asigna el valor al empleado ID dependiendo de la consulta
    if (topEmpleadoIdRes.isNotEmpty) {
      varEmployeeId = topEmpleadoIdRes[0]['EmpleadoId'];
    } else {
      varEmployeeId = employeeId;
    }

    // Search Joint Id
    fetchJointIdSql = '''
	  SELECT JuntaId 
	  FROM Soldadura 
	  WHERE SoldaduraId = '$weldingId';
    ''';

    // Save JuntaId in JointId <String>
    List<Map<String, dynamic>> jointIdRes =
        await dbClient.rawQuery(fetchJointIdSql);
    jointId = jointIdRes[0]['JuntaId'];

    int updateOverseerSql = await dbClient.update(
      'EmpleadosSoldadura',
      {
        'CaboId': varEmployeeId,
        'SiteModificacion': siteIdG,
        'FechaModificacion': currentDate,
      },
      where: 'SoldaduraId = ?',
      whereArgs: [weldingId],
    );

    int updateWeldingSql = await dbClient.update(
      'Soldadura',
      {
        'Liberado': 1,
        'CaboId': varEmployeeId,
        'SiteModificacion': siteIdG,
        'FechaModificacion': currentDate,
      },
      where: 'SoldaduraId = ?',
      whereArgs: [weldingId],
    );

    int updateJointSql = await dbClient.update(
      'Junta',
      {
        'Estado': 'INSPECCION_SOLDADURA',
        'SiteModificacion': siteIdG,
        'FechaModificacion': currentDate,
      },
      where: 'JuntaId = ?',
      whereArgs: [jointId],
    );

    totalRegisterAffected =
        updateOverseerSql + updateJointSql + updateWeldingSql;

    if (totalRegisterAffected >= 4) {
      return ReleaseWeldingResponseModel(
          message: 'El proceso de soldadura ha sido liberado!',
          actionResult: 'success',
          rowsAffected: totalRegisterAffected);
    }

    await jointDao.updateProgressJoint(jointId);

    return null;
  }
}
