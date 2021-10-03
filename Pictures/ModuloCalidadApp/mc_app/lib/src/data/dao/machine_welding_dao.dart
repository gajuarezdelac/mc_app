import 'package:mc_app/src/data/dao/site_dao.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/welding_tab_model.dart';
import 'package:intl/intl.dart';

class MachineWeldingDao {
  DBContext context = DBContext();

  // Me busca la información de la maquina de soldar para mostrar
  //  EXEC [HSEQMC].[st_SelMaquinaSoldar] 'EF-050319129', 'ESH0000000001'
  Future<AddMachineWeldingResponseModel> fetchMachineWelding(
    String noSerie,
    String folioSoldadura,
    int aceptVigencia,
  ) async {
    // Queries
    String validateExistenceMachine;
    String validityMachine;
    String fetchIdequipment;
    String updateIdEquipment;
    String res;

    // Params
    String idEquipo;

    // Se obtiene la fecha actual:
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    validateExistenceMachine = '''
    SELECT EQ.NoSerie FROM Equipos EQ 
    JOIN CertificadosEquipos CER
    ON EQ.IdEquipo = CER.IdEquipo  WHERE EQ.NoSerie = '$noSerie' AND CER.RegBorrado = 0 
    ''';

    validityMachine = '''
    SELECT EQ.NoSerie FROM Equipos EQ JOIN CertificadosEquipos CER
    ON EQ.IdEquipo = CER.IdEquipo  WHERE EQ.NoSerie = '$noSerie'
    AND CER.FechaFinVigencia > '$currentDate' AND CER.RegBorrado = 0 
    ''';

    fetchIdequipment = '''
     SELECT CER.IdEquipo
     FROM Equipos EQ
     INNER JOIN CertificadosEquipos CER
     ON EQ.IdEquipo = CER.IdEquipo
    ''';

    var dbClient = await context.database;

    List<Map<String, dynamic>> existenceMachineRes =
        await dbClient.rawQuery(validateExistenceMachine);

    List<Map<String, dynamic>> validatyMachineRes =
        await dbClient.rawQuery(validityMachine);

    List<Map<String, dynamic>> fetchEquipoRes =
        await dbClient.rawQuery(fetchIdequipment);

    idEquipo = fetchEquipoRes[0]['IdEquipo'];

    updateIdEquipment = '''  
    UPDATE EmpleadosSoldadura
    SET IdEquipo = '$idEquipo',
		SiteModificacion = '',
		FechaModificacion = '$currentDate'
    WHERE FolioSoldadura = '$folioSoldadura'
    AND RegBorrado = 0
    ''';

    res = '''
    SELECT 
		EQ.IdEquipo AS IdEquipo,
		EQ.NoSerie AS EquipoNoSerie,
		EQ.Marca AS EquipoMarca,
    EQ.Material,
    EQ.NoMaterialSAP,
		EQ.Descripcion EquipoDescripcion,
    1 AS Existe,
    1 AS Vigente
	  FROM Equipos EQ 
	  JOIN CertificadosEquipos CER ON EQ.IdEquipo = CER.IdEquipo 
    WHERE EQ.NoSerie = '$noSerie' AND CER.RegBorrado = 0 
   ''';

    // Validamos la existencia
    if (existenceMachineRes.isNotEmpty) {
      // Validaos la fecha
      if (validatyMachineRes.isNotEmpty) {
        await dbClient.rawUpdate(updateIdEquipment);
        List<Map<String, dynamic>> equipoRes = await dbClient.rawQuery(res);
        // Nos devuelve la información en caso de que tenga información.
        if (equipoRes.length > 0) {
          return new AddMachineWeldingResponseModel(
              actionResult: "success",
              mensaje: "Se agrego la maquina de soldar",
              maquina: MachineWeldingModel.fromJson(
                  equipoRes.first, folioSoldadura));
        }
      } else {
        if (aceptVigencia == 1) {
          await dbClient.rawUpdate(updateIdEquipment);
          List<Map<String, dynamic>> equipoRes = await dbClient.rawQuery(res);
          // Nos devuelve la información en caso de que tenga información.
          if (equipoRes.length > 0) {
            return new AddMachineWeldingResponseModel(
                actionResult: "success",
                mensaje: "Se agrego correctamente la maquina de soldar!",
                maquina: MachineWeldingModel.fromJson(
                    equipoRes.first, folioSoldadura));
          }
        }
        List<Map<String, dynamic>> equipoRes = await dbClient.rawQuery(res);

        if (equipoRes.length > 0) {
          return new AddMachineWeldingResponseModel(
              actionResult: "no-vigente",
              mensaje: "Maquina no vigente!",
              maquina: MachineWeldingModel.fromJson({}, folioSoldadura));
          // return MachineWeldingModel.fromJson(equipoRes.first);
        }
        // El certificado de la maquina no es valido.
      }
    } else {
      throw 'existencia';
    }

    return new AddMachineWeldingResponseModel(
        actionResult: "error",
        mensaje: "Algo salio mal!",
        maquina: MachineWeldingModel.fromJson({}, folioSoldadura));
  }

  // Nos remueva la maquina de soldar
  Future<RemoveMachineWeldingResponseModel> removeWeldingMachine(
      String folioSoldadura) async {
    // Params
    String siteIdG;
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);

    var dbClient = await context.database;

    final siteDao = SiteDao();
    //Obtiene el SiteId
    siteIdG = await siteDao.getSiteId();

    var result = await dbClient.update(
      'EmpleadosSoldadura',
      {
        'IdEquipo': null,
        'SiteModificacion': siteIdG,
        'FechaModificacion': currentDate,
      },
      where: 'FolioSoldadura = ?',
      whereArgs: [folioSoldadura],
    );

    if (result == 1) {
      return RemoveMachineWeldingResponseModel(
        mensaje: 'Maquina removida correctamente!',
        rowsAffected: result,
        actionResult: 'success',
        folioSoldaduraId: folioSoldadura,
      );
    }

    return RemoveMachineWeldingResponseModel(
      mensaje: 'Upps!, al parecer hubo un problema',
      rowsAffected: result,
      actionResult: 'error',
      folioSoldaduraId: folioSoldadura,
    );
  }

  // Busca la información de la maquina de soldar para mostrar
  // EXEC [HSEQMC].[st_SelMaquinaSoldar] 'EF-050319129', 'ESH0000000001'
  Future<AddMachineWeldingListResponseModel> fetchMachineWeldingV2(
    String noSerie,
    String folioSoldadura,
  ) async {
    var dbClient = await context.database;
    List<MachineWeldingModel> machineList = [];

    //Me determina si la maquina de soldar existe dentro de la tabla certificadosEquipos.
    List<Map<String, dynamic>> existenceMachineRes =
        await dbClient.rawQuery('''	SELECT	EQ.NoSerie 
		FROM	Equipos EQ
		INNER JOIN	CertificadosEquipos CER ON EQ.IdEquipo = CER.IdEquipo AND CER.RegBorrado = 0
		WHERE	EQ.NoSerie = '$noSerie' AND
				EQ.RegBorrado = 0
		UNION ALL 
		SELECT	EQE.NoSerie 
		FROM	EquiposExternos EQE
		JOIN	CertificadosEquipos CER ON EQE.IdEquipoExterno = CER.IdEquipo AND CER.RegBorrado = 0
		WHERE	EQE.NoSerie = '$noSerie' AND
				EQE.RegBorrado = 0''');

    if (existenceMachineRes.isNotEmpty) {
      List<Map<String, dynamic>> machineCountBySerie =
          await dbClient.rawQuery('''	
		SELECT COUNT(U.NoSerie)
			FROM 
			(SELECT	EQ.NoSerie
			FROM	Equipos EQ
			WHERE	EQ.RegBorrado = 0
			UNION ALL
			SELECT	EQE.NoSerie
			FROM	EquiposExternos EQE
			WHERE	EQE.RegBorrado = 0) U
			WHERE U.NoSerie = '$noSerie' ''');

      if (machineCountBySerie.isNotEmpty &&
          machineCountBySerie.first.values.first > 1) {
        List<Map<String, dynamic>> equipoRes = await dbClient.rawQuery('''
        SELECT	CAST(EQ.IdEquipo AS TEXT) IdEquipo,
					EQ.NoSerie EquipoNoSerie,
					EQ.Material,
					EQ.Marca EquipoMarca,
					EQ.Descripcion EquipoDescripcion,
					EQ.NoMaterialSAP,
					(CASE IFNULL(CE.IdEquipo,'') WHEN '' THEN 0 ELSE 1 END) AS Existe,
					(CASE IFNULL(CV.IdEquipo,'') WHEN '' THEN 0 ELSE 1 END) AS Vigente
			FROM	Equipos EQ
      LEFT JOIN CertificadosEquipos CE ON CE.IdEquipo = EQ.IdEquipo AND CE.RegBorrado = 0
      LEFT JOIN CertificadosEquipos CV ON CV.IdEquipo = EQ.IdEquipo AND date(CV.FechaFinVigencia) > datetime('now', 'localtime') AND CV.RegBorrado = 0
			WHERE	EQ.NoSerie = '$noSerie' AND
					EQ.RegBorrado = 0
			UNION ALL
			SELECT	CAST(EQE.IdEquipoExterno AS TEXT) IdEquipo,
					EQE.NoSerie EquipoNoSerie,
					EQE.Material,
					EQE.Marca EquipoMarca,
					EQE.Descripcion EquipoDescripcion,
					NULL NoMaterialSAP,
					(CASE IFNULL(CE.IdEquipo,'') WHEN '' THEN 0 ELSE 1 END) AS Existe,
					(CASE IFNULL(CV.IdEquipo,'') WHEN '' THEN 0 ELSE 1 END) AS Vigente
			FROM	EquiposExternos EQE
      LEFT JOIN		CertificadosEquipos CE ON CE.IdEquipo = EQE.IdEquipoExterno AND CE.RegBorrado = 0
      LEFT JOIN 	CertificadosEquipos CV ON CV.IdEquipo = EQE.IdEquipoExterno AND date(CV.FechaFinVigencia) > datetime('now', 'localtime') AND CV.RegBorrado = 0
			WHERE	EQE.NoSerie = '$noSerie' AND
					EQE.RegBorrado = 0
          ''');

        equipoRes.forEach((element) {
          machineList
              .add(MachineWeldingModel.fromJson(element, folioSoldadura));
        });

        return new AddMachineWeldingListResponseModel(
            actionResult: "success",
            mensaje: "Más de una máquina con el mismo número de serie!",
            maquinas: machineList);
      } else {
        List<Map<String, dynamic>> machineCountBySerie =
            await dbClient.rawQuery('''	
		    SELECT U.NoSerie, U.IdEquipo
				FROM
					(SELECT	EQ.NoSerie, EQ.IdEquipo 
					FROM	Equipos EQ  
					JOIN	CertificadosEquipos CER ON EQ.IdEquipo = CER.IdEquipo 
					WHERE	EQ.NoSerie = '$noSerie' AND date(CER.FechaFinVigencia) > datetime('now', 'localtime') AND CER.RegBorrado = 0
					UNION ALL 
					SELECT	EQE.NoSerie, EQE.IdEquipoExterno AS IdEquipo
					FROM	EquiposExternos EQE 
					JOIN	CertificadosEquipos CER ON EQE.IdEquipoExterno = CER.IdEquipo
					WHERE	EQE.NoSerie = '$noSerie' AND date(CER.FechaFinVigencia) > datetime('now', 'localtime') AND CER.RegBorrado = 0) U ''');

        if (machineCountBySerie.isNotEmpty) {
          machineList.add(MachineWeldingModel(
              idEquipo: machineCountBySerie.first["IdEquipo"],
              folioSoldaduraId: folioSoldadura,
              vigente: 1));

          return new AddMachineWeldingListResponseModel(
              actionResult: 'success', mensaje: '', maquinas: machineList);
        } else {
          //buscamos el registro aunque tenga el certificado vencido
          machineCountBySerie = await dbClient.rawQuery('''	
		    SELECT U.NoSerie, U.IdEquipo
				FROM
					(SELECT	EQ.NoSerie, EQ.IdEquipo 
					FROM	Equipos EQ  
					JOIN	CertificadosEquipos CER ON EQ.IdEquipo = CER.IdEquipo 
					WHERE	EQ.NoSerie = '$noSerie' AND CER.RegBorrado = 0
					UNION ALL 
					SELECT	EQE.NoSerie, EQE.IdEquipoExterno AS IdEquipo 
					FROM	EquiposExternos EQE 
					JOIN	CertificadosEquipos CER ON EQE.IdEquipoExterno = CER.IdEquipo
					WHERE	EQE.NoSerie = '$noSerie' AND CER.RegBorrado = 0) U ''');

          if (machineCountBySerie.isNotEmpty) {
            machineList.add(MachineWeldingModel(
                idEquipo: machineCountBySerie.first["IdEquipo"],
                folioSoldaduraId: folioSoldadura,
                vigente: 0));

            return new AddMachineWeldingListResponseModel(
                actionResult: 'success', mensaje: '', maquinas: machineList);
          } else {
            //no tiene Existe, Material y NoMaterialSAP
            MachineWeldingModel machine = MachineWeldingModel(
                idEquipo: '',
                equipoNoSerie: '',
                equipoMarca: '',
                equipoDescripcion: '',
                folioSoldaduraId: '',
                existe: 0,
                vigente: 0);
            machineList.add(machine);
            return new AddMachineWeldingListResponseModel(
                actionResult: "sin-certificado",
                mensaje:
                    "El Material no existe o no cuenta con ningún certificado!",
                maquinas: machineList);
          }
        }
      }
    } else {
      return new AddMachineWeldingListResponseModel(
          actionResult: "sin-certificado",
          mensaje: "El Material no existe o no cuenta con ningún certificado!",
          maquinas: machineList);
    }
  }

  // Agrega el registro de la máquina por id de equipo
  //  EXEC [HSEQMC].[st_InsMaquinaSoldar] @IdEquipo UNIQUEIDENTIFIER, @FolioSoldadura VARCHAR(30)
  Future<AddMachineWeldingResponseModel> addMachineWeldingV2(
      String idEquipo, String folioSoldadura) async {
    String siteId;
    String updateIdEquipment;
    String fetchIdequipment;
    final siteDao = SiteDao();
    var dbClient = await context.database;

    // Se obtiene la fecha actual:
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);
    //Obtiene el SiteId
    siteId = await siteDao.getSiteId();

    updateIdEquipment = '''  
    UPDATE EmpleadosSoldadura
    SET IdEquipo = '$idEquipo',
		SiteModificacion = '$siteId',
		FechaModificacion = '$currentDate'
    WHERE FolioSoldadura = '$folioSoldadura'
    AND RegBorrado = 0
    ''';

    fetchIdequipment = '''
     	SELECT		1 AS Vigente,
				CAST(EQ.IdEquipo AS TEXT) IdEquipo,
				EQ.NoSerie EquipoNoSerie,
				EQ.Material,
				EQ.Marca EquipoMarca,
				EQ.Descripcion EquipoDescripcion,
				EQ.NoMaterialSAP,
				1 Existe
	FROM		Equipos EQ
	WHERE		EQ.IdEquipo = '$idEquipo' AND
				EQ.RegBorrado = 0
  UNION ALL
	  SELECT 1 AS Vigente,
							CAST(EQE.IdEquipoExterno AS TEXT) IdEquipo,
							EQE.NoSerie EquipoNoSerie,
							EQE.Material,
							EQE.Marca EquipoMarca,
							EQE.Descripcion EquipoDescripcion,
							NULL AS NoMaterialSAP,
							1 Existe
	  FROM					EquiposExternos EQE
	  JOIN					CertificadosEquipos CER ON EQE.IdEquipoExterno = CER.IdEquipo 
    WHERE		EQE.IdEquipoExterno = '$idEquipo' AND
				EQE.RegBorrado = 0
    ''';

    await dbClient.rawUpdate(updateIdEquipment);

    List<Map<String, dynamic>> fetchEquipoRes =
        await dbClient.rawQuery(fetchIdequipment);

    return new AddMachineWeldingResponseModel(
        actionResult: "success",
        mensaje: "Se agregó la máquina de soldar",
        maquina:
            MachineWeldingModel.fromJson(fetchEquipoRes.first, folioSoldadura));
  }

  // [HSEQMC].[st_InsUpdMaquinaSoldador] -- Se llama cuando la maquina de soldar es vigente
  Future<AddMachineWeldingResponseModel> addMachineWeldingVigent(
      String noSerie, String folioSoldadura, bool isVigente) async {
    // Params
    String idEquipo = '';
    String validateExistenceMachineSql;
    String equipoExternosSql;
    String equipoInternoSql;
    String siteId;

    final siteDao = SiteDao();
    var dbClient = await context.database;

    // Se obtiene la fecha actual:
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
    String currentDate = formatter.format(now);
    //Obtiene el SiteId
    siteId = await siteDao.getSiteId();

    equipoExternosSql = '''
        SELECT  CER.IdEquipo FROM EquiposExternos EQE INNER JOIN CertificadosEquipos CER
     		ON EQE.IdEquipoExterno = CER.IdEquipo
		    WHERE '$noSerie' = EQE.NoSerie AND CER.RegBorrado = 0
    ''';

    equipoInternoSql = '''
     SELECT  CER.IdEquipo AS IdEquipo FROM Equipos EQ
		  INNER JOIN CertificadosEquipos CER ON EQ.IdEquipo = CER.IdEquipo
		  WHERE '$noSerie' = EQ.NoSerie AND CER.RegBorrado = 0
    ''';

    validateExistenceMachineSql = '''
    ELECT CER.IdEquipo AS IdEquipo FROM Equipos EQ 
    INNER JOIN CertificadosEquipos CER ON EQ.IdEquipo = CER.IdEquipo
     WHERE '$noSerie' = NoSerie AND CER.RegBorrado = 0
    ''';

    List<Map<String, dynamic>> fetchMachineWelding =
        await dbClient.rawQuery(validateExistenceMachineSql);

    if (fetchMachineWelding.isNotEmpty) {
      List<Map<String, dynamic>> resInterno =
          await dbClient.rawQuery(equipoInternoSql);

      idEquipo = resInterno[0]["IdEquipo"];
    } else {
      List<Map<String, dynamic>> resExterno =
          await dbClient.rawQuery(equipoExternosSql);

      idEquipo = resExterno[0]["IdEquipo"];
    }

    await dbClient.rawUpdate('''
    UPDATE EmpleadosSoldadura
    SET IdEquipo = '$idEquipo',
		SiteModificacion = '$siteId',
		FechaModificacion = '$currentDate'
    WHERE FolioSoldadura = '$folioSoldadura'
    AND RegBorrado = 0
    ''');

    var res = await dbClient.rawQuery('''
           SELECT * FROM (
	   SELECT 0 AS Vigente,
							CAST(EQ.IdEquipo AS TEXT) IdEquipo,
							EQ.NoSerie EquipoNoSerie,
							EQ.Material,
							EQ.Marca EquipoMarca,
							EQ.Descripcion EquipoDescripcion,
							EQ.NoMaterialSAP,
							0 Existe
	  FROM					Equipos EQ 
	  JOIN					CertificadosEquipos CER ON EQ.IdEquipo = CER.IdEquipo 
      WHERE					'$noSerie' = EQ.NoSerie AND CER.RegBorrado = 0 LIMIT 1
	   )
	  UNION ALL
	  SELECT * FROM (
	  SELECT  0 AS Vigente,
							CAST(EQE.IdEquipoExterno AS TEXT) IdEquipo,
							EQE.NoSerie EquipoNoSerie,
							EQE.Material,
							EQE.Marca EquipoMarca,
							EQE.Descripcion EquipoDescripcion,
							NULL NoMaterialSAP,
							0 Existe
	  FROM					EquiposExternos EQE
	  JOIN					CertificadosEquipos CER ON EQE.IdEquipoExterno = CER.IdEquipo 
      WHERE					'$noSerie' = EQE.NoSerie AND CER.RegBorrado = 0 LIMIT 1
	  )
    ''');

    return new AddMachineWeldingResponseModel(
        actionResult: "success",
        mensaje: "Se agregó la máquina de soldar",
        maquina: MachineWeldingModel.fromJson(res.first, folioSoldadura));
  }
}
