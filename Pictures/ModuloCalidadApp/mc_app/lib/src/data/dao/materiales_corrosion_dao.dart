import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/models/materiales_corrosion_model.dart';
import 'package:mc_app/src/models/params/get_materials_corrosion_params.dart';

class MaterialesCorrosionDao {
  DBContext context = DBContext();

  Future<List<MaterialesCorrosionModel>> fetchGetAllMaterialsC(
      GetMaterialsCorrisionParamsModel params) async {
    String sql;
    sql = '''
        SELECT 
          EMC.NoEnvio,
          IFNULL(EMC.NoRegistroInspeccion,'-----') NoRegistroInspeccion,	
          C.ContratoId,
          C.ContratoNombre || ' - ' || C.Nombre AS Contrato,		
          O.ObraId,
          O.OT || ' - ' || O.Nombre AS Obra,
          EMC.Destino,
          EMC.DeptoSolicitante,
          EMC.Observaciones,
          EMC.Fecha
        FROM		EnvioMaterialesCorrosion EMC
        INNER JOIN	Obras O ON O.ObraId = EMC.ObraId AND O.RegBorrado = 0
        INNER JOIN	Contratos C ON C.ContratoId = O.ContratoId AND C.RegBorrado = 0
        WHERE		EMC.RegBorrado = 0
              AND(EMC.NoEnvio = ? OR COALESCE(?, '') = '')
              AND(EMC.NoRegistroInspeccion = ? OR COALESCE(?, '') = '')
              AND(C.ContratoId = ? OR COALESCE(?, '') = '')
              AND(O.ObraId = ? OR COALESCE(?, '') = '')
              AND(EMC.Destino = ? OR COALESCE(?, '') = '')
              AND(EMC.DeptoSolicitante = ? OR COALESCE(?, '') = '')
              AND(EMC.Observaciones = ? OR COALESCE(?, '') = '')
              AND(EMC.Fecha >= ? OR COALESCE(?,'')='')
              AND(EMC.Fecha <= ? OR COALESCE(?,'')='')
          ''';

    var parmsSql = [
      params.noEnvio,
      params.noEnvio,
      params.noRegistroInspeccion,
      params.noRegistroInspeccion,
      params.contratoId,
      params.contratoId,
      params.obraId,
      params.obraId,
      params.deptoSolicitante,
      params.deptoSolicitante,
      params.observaciones,
      params.observaciones,
      params.fechaInicio,
      params.fechaInicio,
      params.fechaFin,
      params.fechaFin,
    ];

    final db = await context.database;
    final res = await db.rawQuery(sql, parmsSql);

    List<MaterialesCorrosionModel> list = res.isNotEmpty
        ? res.map((e) => MaterialesCorrosionModel.fromJson(e)).toList()
        : [];

    return list;
  }

  Future<List<SpoolDetalleProteccionModel>> fetchGetSpoolDetalleProteccion(
      String noEnvio, bool isReport) async {
    final db = await context.database;

    String partidasSql = '''
            SELECT 
                  M.MaterialId,
                  IFNULL(J.JuntaId, '') JuntaId
            FROM		Materiales M
            LEFT JOIN	Junta J ON J.SpoolEstructura = M.NombreElemento AND J.Estado = 'LIBERADA' AND J.RegBorrado = 0
            WHERE		M.NoEnvio = '$noEnvio' AND 
                    M.RegBorrado = 0
      ''';

    //Trazabilidad 1
    String detalle1Sql = '''
        SELECT
          '0' as Partida,
          M.NombreElemento || ' J - ' || J.JuntaNo NombreElemento,	
          FPT.Folio,
          P.Descripcion as Plataforma,
          PD.NumeroPlano || ' Rev. ' || PD.Revision || ' Hoja ' || PD.Hoja Plano,
          VT.CantidadUsada Cantidad,
          (
              SELECT    UM
							FROM			Trazabilidad
							WHERE			IdTrazabilidad = VT.IdTrazabilidad 
              LIMIT 1
          ) UM,
          (
              SELECT    MaterialDescrBreve
							FROM			Trazabilidad
							WHERE			IdTrazabilidad = VT.IdTrazabilidad 
              LIMIT 1
          ) Descripcion,
          VT.IdTrazabilidad,
          1 EsSpool,
          1 Primero,
          J.JuntaId,
          M.MaterialId
      FROM		Junta J
      INNER JOIN	PlanoDetalle PD ON PD.PlanoDetalleId = J.PlanoDetalleId AND PD.RegBorrado = 0	
      INNER JOIN	Conformado C ON C.JuntaId = J.JuntaId AND C.RegBorrado = 0
      INNER JOIN	VolumenTrazabilidad VT ON VT.ConformadoId = C.ConformadoId AND VT.Trazabilidad1 = 1 AND VT.RegBorrado = 0
      INNER JOIN	Materiales M ON M.NombreElemento = J.SpoolEstructura AND M.NoEnvio = '$noEnvio' AND M.TrazabilidadId = ''
      LEFT JOIN FoliosPropuestaTecnica FPT ON FPT.SiteId = J.SiteId AND FPT.PropuestaTecnicaId = J.PropuestaTecnicaId AND FPT.RegBorrado = 0 AND ifnull(FPT.EmpleadoId,0) <> 0
      LEFT JOIN	PropuestaTecnicaActividadesH PTACT 
      ON			PTACT.SiteId = J.SiteId AND 
            PTACT.PropuestaTecnicaId = J.PropuestaTecnicaId AND 
            PTACT.ActividadId = J.ActividadId AND 
            ifnull(PTACT.ReprogramacionOTId,0) = (
                                                  SELECT ifnull(ReprogramacionOTId,0)
                                                    FROM			PropuestaTecnicaSubActividadesH
                                                    WHERE			SiteId = J.SiteId AND
                                                            PropuestaTecnicaId = J.PropuestaTecnicaId AND 
                                                            ActividadId = J.ActividadId AND 
                                                            SubActividadId = J.SubActividadId AND 
                                                            RegBorrado = 0
                                                    ORDER BY		PropuestaTecnicaId
                                                    LIMIT 1
                                                )
            AND PTACT.RegBorrado = 0
      LEFT JOIN	Plataformas P ON P.PlataformaId = PTACT.PlataformaId AND P.RegBorrado = 0 
      WHERE		J.Estado = 'LIBERADA' AND
              J.RegBorrado = 0;
      ''';

    //Trazabilidad 2
    String detalle2Sql = '''
        SELECT		'0' as Partida,
                  M.NombreElemento || ' J - ' || J.JuntaNo NombreElemento,
                  FPT.Folio,
                  P.Descripcion Plataforma,
                  PD.NumeroPlano || ' Rev. ' ||  PD.Revision || ' Hoja ' || PD.Hoja Plano,
                  VT.CantidadUsada Cantidad,
                  (
                      SELECT    UM
                      FROM			Trazabilidad
                      WHERE			IdTrazabilidad = VT.IdTrazabilidad 
                      LIMIT 1
                  ) UM,
                  (
                      SELECT    MaterialDescrBreve
                      FROM			Trazabilidad
                      WHERE			IdTrazabilidad = VT.IdTrazabilidad 
                      LIMIT 1
                  ) Descripcion,
                  VT.IdTrazabilidad,
                  1 EsSpool,
                  0 Primero,
                  J.JuntaId,
                  M.MaterialId
        FROM		Junta J
        INNER JOIN	PlanoDetalle PD ON PD.PlanoDetalleId = J.PlanoDetalleId AND PD.RegBorrado = 0
        INNER JOIN	Conformado C ON C.JuntaId = J.JuntaId AND C.RegBorrado = 0
        INNER JOIN	VolumenTrazabilidad VT ON VT.ConformadoId = C.ConformadoId AND VT.Trazabilidad1 = 0 AND VT.RegBorrado = 0
        INNER JOIN	Materiales M ON M.NombreElemento = J.SpoolEstructura AND M.NoEnvio = '$noEnvio' AND M.TrazabilidadId = '' AND M.RegBorrado = 0
        LEFT JOIN	FoliosPropuestaTecnica FPT ON FPT.SiteId = J.SiteId AND FPT.PropuestaTecnicaId = J.PropuestaTecnicaId AND FPT.RegBorrado = 0 AND ifnull(FPT.EmpleadoId,0) <> 0
        LEFT JOIN	PropuestaTecnicaActividadesH PTACT 
        ON			PTACT.SiteId = J.SiteId AND 
              PTACT.PropuestaTecnicaId = J.PropuestaTecnicaId AND 
              PTACT.ActividadId = J.ActividadId AND 
              ifnull(PTACT.ReprogramacionOTId,0) = (
                                                  SELECT ifnull(ReprogramacionOTId,0)
                                                    FROM			PropuestaTecnicaSubActividadesH
                                                    WHERE			SiteId = J.SiteId AND
                                                            PropuestaTecnicaId = J.PropuestaTecnicaId AND 
                                                            ActividadId = J.ActividadId AND 
                                                            SubActividadId = J.SubActividadId AND 
                                                            RegBorrado = 0
                                                    ORDER BY		PropuestaTecnicaId
                                                    LIMIT 1
                                                )
              AND PTACT.RegBorrado = 0 
        LEFT JOIN	Plataformas P ON P.PlataformaId = PTACT.PlataformaId AND P.RegBorrado = 0
        WHERE		J.Estado = 'LIBERADA' AND
                J.RegBorrado = 0
      ''';

    //Piezas sueltas.
    String detalle3Sql = '''
          SELECT		'0' as Partida,
                    M.NombreElemento,
                    FPT.Folio,
                    P.Descripcion Plataforma,
                    PD.NumeroPlano || ' Rev. ' || PD.Revision || ' Hoja ' || PD.Hoja Plano,
                    VTP.CantidadUsada Cantidad,
                    T.UM,
                    T.MaterialDescrBreve Descripcion,
                    T.IdTrazabilidad,
                    0 EsSpool,
                    0 Primero,
                    '' as JuntaId,
                    M.MaterialId
          FROM		Materiales M
          INNER JOIN	FoliosPropuestaTecnica FPT ON FPT.SiteId = M.SiteId AND FPT.FolioId = M.FolioId AND FPT.PropuestaTecnicaId = M.PropuestaTecnicaId AND FPT.RegBorrado = 0
          INNER JOIN	Plataformas P ON P.PlataformaId = M.PlataformaId AND P.RegBorrado = 0
          INNER JOIN	PlanoDetalle PD ON PD.PlanoDetalleId = M.PlanoDetalleId AND PD.RegBorrado = 0
          INNER JOIN	Trazabilidad T ON T.IdTrazabilidad = M.TrazabilidadId AND T.SiteId <> '' AND T.RegBorrado = 0
          INNER JOIN	VolumenTrazabilidadPS VTP ON VTP.MaterialId = M.MaterialId AND VTP.IdTrazabilidad = M.TrazabilidadId --AND VTP.RegBorrado = 0
          WHERE		M.NoEnvio = '$noEnvio' AND
                  M.TrazabilidadId <> '' AND
                  M.RegBorrado = 0
      ''';

    List<Map<String, dynamic>> tblPartidas = await db.rawQuery(partidasSql);
    List<Map<String, dynamic>> tblDetalle = await db.rawQuery(detalle1Sql);
    List<Map<String, dynamic>> tblDetalle2 = await db.rawQuery(detalle2Sql);
    List<Map<String, dynamic>> tblDetalle3 = await db.rawQuery(detalle3Sql);

    List<PartidasModel> partidas = tblPartidas.isNotEmpty
        ? tblPartidas.map((e) => PartidasModel.fromJson(e)).toList()
        : [];

    int contadorPartidas = 1;

    List<PartidasModel> lstPartidas = [];
    partidas.forEach((p) {
      p.partida = contadorPartidas;
      contadorPartidas++;
      lstPartidas.add(p);
    });

    List<SpoolDetalleProteccionModel> detalle1 = tblDetalle.isNotEmpty
        ? tblDetalle
            .map((e) => SpoolDetalleProteccionModel.fromJson(e, isReport))
            .toList()
        : [];

    List<SpoolDetalleProteccionModel> lstDetalle2 = tblDetalle2.isNotEmpty
        ? tblDetalle2
            .map(
              (e) => SpoolDetalleProteccionModel.fromJson(e, isReport),
            )
            .toList()
        : [];

    List<SpoolDetalleProteccionModel> lstDetalle3 = tblDetalle3.isNotEmpty
        ? tblDetalle3
            .map((e) => SpoolDetalleProteccionModel.fromJson(e, isReport))
            .toList()
        : [];

    List<SpoolDetalleProteccionModel> lstDetalle1 = [];

    detalle1.forEach((x) {
      var registro = lstPartidas.firstWhere(
          (j) => j.juntaId == x.juntaId && j.materialId == x.materialId);

      if (registro != null) {
        x.partida = registro.partida;
        lstDetalle1.add(x);
      }
    });

    lstDetalle2.forEach((x) {
      var registro = lstPartidas.firstWhere(
          (j) => j.juntaId == x.juntaId && j.materialId == x.materialId);

      if (registro != null) {
        x.partida = registro.partida;
        lstDetalle1.add(x);
      }
    });

    lstDetalle3.forEach((x) {
      var exist = lstPartidas
          .indexWhere((j) => j.juntaId == '' && j.materialId == x.materialId);

      if (exist != -1) {
        var registro = lstPartidas
            .firstWhere((j) => j.juntaId == '' && j.materialId == x.materialId);

        x.partida = registro.partida;
        lstDetalle1.add(x);
      }
    });

    return lstDetalle1;
  }
}
