import 'package:mc_app/src/data/dao/site_dao.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/user_off_model.dart';
import 'package:mc_app/src/models/welding_tab_model.dart';
import 'package:intl/intl.dart';

class WeldingTabDao {
  DBContext context = DBContext();

  //  [HSEQMC].[st_SelActividadesSoldadura]
  Future<List<ActividadesSoldaduraModel>> fetchRegisterWelding(
      String jointId) async {
    var dbClient = await context.database;
    var res = await dbClient.rawQuery('''
 		SELECT	
		J.JuntaId,
		ES.FolioSoldadura,
		ES.Firmado,
		ES.IdEquipo,
		IFNULL(EQ.NoSerie,IFNULL(EQE.NoSerie,'')) AS EquipoNoSerie,
		IFNULL(EQ.Marca,IFNULL(EQE.Marca,'')) AS EquipoMarca,
		IFNULL(EQ.Descripcion,IFNULL(EQE.Descripcion,'')) AS EquipoDescripcion,
		ES.Norma,
		ES.RegistroSoldaduraId,
		ES.FechaReporteRSI,
		ES.NoTarjeta,
    ES.InspectorCCAId,
    IFNULL(EEE.Foto , '') AS InspectorCCAFoto,
		IFNULL(EEE.Nombre , '') AS InspectorCCANombre,
		IFNULL(EEE.Ficha, 0) AS InspectorCCAFicha,
    IFNULL(EEE.PuestoDescripcion, '') AS InspectorCCAPuestoDescripcion,
		ES.MotivoFN,
    IFNULL(ES.CriteriosAceptacionId,'') AS CriteriosAceptacionId,
		S.CambioMaterial,
		RS.LongitudSoldada,
		RS.Observaciones,
		RS.OtrosElementos,
		RS.CuadranteSoldaduraId,
		RS.ZonaSoldaduraId,
		E.EmpleadoId,
		SO.SoldadorId,  
		CASE  WHEN ZS.ZonaA > 0 THEN 'ZA,' ELSE '' END ||
		CASE  WHEN ZS.ZonaB > 0 THEN 'ZB,' ELSE '' END ||
		CASE  WHEN ZS.ZonaC > 0 THEN 'ZC,' ELSE '' END ||
		CASE  WHEN ZS.ZonaD > 0 THEN 'ZD,' ELSE '' END ||
		CASE  WHEN ZS.ZonaE > 0 THEN 'ZE,' ELSE '' END ||
		CASE  WHEN ZS.ZonaF > 0 THEN 'ZF,' ELSE '' END ||
		CASE  WHEN ZS.ZonaG > 0 THEN 'ZG,' ELSE '' END ||
		CASE  WHEN ZS.ZonaH > 0 THEN 'ZH,' ELSE '' END ||
		CASE  WHEN ZS.ZonaV > 0 THEN 'ZV,' ELSE '' END  AS Zona,
		CASE  WHEN CS.Cuadrante1 > 0 THEN 'C1,' ELSE '' END ||
		CASE  WHEN CS.Cuadrante1 > 0 THEN 'C1,' ELSE '' END ||
		CASE  WHEN CS.Cuadrante2 > 0 THEN 'C2,' ELSE '' END ||
		CASE  WHEN CS.Cuadrante3 > 0 THEN 'C3,' ELSE '' END ||
		CASE  WHEN CS.Cuadrante4 > 0 THEN 'C4,' ELSE '' END AS Cuadrante,
		CASE  WHEN RS.Fondeo > 0 THEN 'F,' ELSE '' END ||
		CASE  WHEN RS.PasoCaliente > 0 THEN 'PC,' ELSE '' END || 
		CASE  WHEN RS.Refresco1 > 0 THEN 'R1,' ELSE '' END ||  
		CASE  WHEN RS.Refresco2 > 0 THEN 'R2,' ELSE '' END || 
		CASE  WHEN RS.Refresco3 > 0 THEN 'R3,' ELSE '' END ||
		CASE  WHEN RS.Refresco4 > 0 THEN 'R4,' ELSE '' END || 
		CASE  WHEN RS.Refresco5 > 0 THEN 'R5,' ELSE '' END || 
		CASE  WHEN RS.Refresco6 > 0 THEN 'R6,' ELSE '' END  ||
		CASE  WHEN RS.Vista > 0 THEN 'V' ELSE '' END AS EtapaRealizada,
		CASE  WHEN IFNULL(E.EmpleadoId, 0) <> 0 THEN 
		CASE WHEN  E.Apellidos IS NOT NULL THEN E.Nombre || ' ' || E.Apellidos
		ELSE E.Nombre END
		ELSE EE.Nombre END AS NombreSoldador,		
		CASE  WHEN IFNULL(E.EmpleadoId, 0) <> 0 THEN E.Ficha ELSE EE.Ficha END AS Ficha,
		CASE  WHEN IFNULL(E.EmpleadoId, 0) <> 0 THEN E.PuestoDescripcion  ELSE PE.Puesto END AS Categoria,
    RS.FechaInicio,
    RS.FechaFin
		FROM EmpleadosSoldadura ES
				INNER JOIN RegistroSoldadura RS ON RS.RegistroSoldaduraId = ES.RegistroSoldaduraId AND RS.RegBorrado = 0
				INNER JOIN CuadranteSoldadura CS ON CS.CuadranteSoldaduraId = RS.CuadranteSoldaduraId AND CS.RegBorrado = 0
				INNER JOIN ZonaSoldadura ZS ON ZS.ZonaSoldaduraId = RS.ZonaSoldaduraId AND ZS.RegBorrado = 0
				INNER JOIN Soldadura S ON S.SoldaduraId = ES.SoldaduraId AND S.RegBorrado = 0 AND S.Activo = 1
				INNER JOIN Soldador SO ON SO.SoldadorId = ES.SoldadorId AND SO.RegBorrado = 0
				LEFT JOIN EmpleadoExterno EE ON EE.EmpleadoExternoId = SO.EmpleadoId AND EE.RegBorrado = 0
				LEFT JOIN Empleados E ON E.EmpleadoId = IFNULL(SO.EmpleadoId,0) AND E.RegBorrado=0
				LEFT JOIN PuestoExterno PE ON PE.PuestoExternoId = EE.PuestoExternoId AND PE.RegBorrado = 0
				LEFT JOIN Empleados EEE ON EEE.EmpleadoId = ES.InspectorCCAId AND EEE.RegBorrado = 0
				LEFT JOIN Equipos EQ ON EQ.IdEquipo = ES.IdEquipo AND EQ.RegBorrado = 0
        LEFT JOIN EquiposExternos EQE ON EQE.IdEquipoExterno = ES.IdEquipo AND EQE.RegBorrado = 0
				INNER JOIN Junta J ON J.JuntaId = S.JuntaId AND J.RegBorrado = 0
		WHERE	J.JuntaId = '$jointId' AND J.RegBorrado = 0 AND ES.RegBorrado = 0
    ''');

    List<ActividadesSoldaduraModel> list = res.isNotEmpty
        ? res.map((c) => ActividadesSoldaduraModel.fromJson(c)).toList()
        : [];

    return list;
  }

  // Remueve la activdad.
  Future<RemoveWeldingActivityModel> removeWelderActivity(
    String folioSoldadura,
    String registroSoldaduraId,
    String cuadranteSoldaduraId,
    String zonaSoldaduraId,
  ) async {
    // Params
    int totalRegisterUpdate;
    String siteIdG;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    var dbClient = await context.database;

    final siteDao = SiteDao();
    //Obtiene el SiteId
    siteIdG = await siteDao.getSiteId();

    int updateEmployeesWelding = await dbClient.update(
      'EmpleadosSoldadura',
      {
        'RegBorrado': -1,
        'SiteModificacion': siteIdG,
        'FechaModificacion': currentDate,
      },
      where: 'FolioSoldadura = ?',
      whereArgs: [folioSoldadura],
    );

    int updateRegisterWelding = await dbClient.update(
      'CuadranteSoldadura',
      {
        'RegBorrado': -1,
        'SiteModificacion': siteIdG,
        'FechaModificacion': currentDate,
      },
      where: 'CuadranteSoldaduraId = ?',
      whereArgs: [cuadranteSoldaduraId],
    );

    int updateCuadrantWelding = await dbClient.update(
      'ZonaSoldadura',
      {
        'RegBorrado': -1,
        'SiteModificacion': siteIdG,
        'FechaModificacion': currentDate,
      },
      where: 'ZonaSoldaduraId = ?',
      whereArgs: [zonaSoldaduraId],
    );

    int updateZoneWelding = await dbClient.update(
      'RegistroSoldadura',
      {
        'RegBorrado': -1,
        'SiteModificacion': siteIdG,
        'FechaModificacion': currentDate,
      },
      where: 'RegistroSoldaduraId = ?',
      whereArgs: [registroSoldaduraId],
    );

    totalRegisterUpdate = updateRegisterWelding +
        updateEmployeesWelding +
        updateZoneWelding +
        updateCuadrantWelding;

    if (totalRegisterUpdate < 4) {
      return RemoveWeldingActivityModel(
          actionResult: 'Ups!, al parecer algo salio mal',
          mensaje: '',
          rowsAffected: totalRegisterUpdate);
    }

    return RemoveWeldingActivityModel(
        actionResult: 'success',
        mensaje: 'Se ha removido correctamente al soldador!',
        rowsAffected: totalRegisterUpdate);
  }

  Future<QAWeldingUserModel> getUserQA(int ficha) async {
    final db = await context.database;

    final res = await db.query(
      'Empleados',
      columns: [
        'Nombre',
        'Ficha',
        'PuestoDescripcion',
      ],
      where: 'Ficha = ? AND RegBorrado = ?',
      whereArgs: [ficha, 0],
      limit: 1,
    );

    QAWeldingUserModel userGeneral = res.isNotEmpty
        ? QAWeldingUserModel.fromJson(res.first)
        : QAWeldingUserModel(nombre: null, ficha: null, puesto: null);

    return userGeneral;
  }
}
