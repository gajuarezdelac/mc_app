import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:mc_app/src/models/column_model.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:dio/dio.dart';
import 'package:mc_app/src/models/synchronization_model.dart';
import 'package:mc_app/src/repository/synchronization_repository.dart';
import 'package:mc_app/src/utils/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mc_app/src/data/database_schema.dart';
import 'package:imei_plugin/imei_plugin.dart';

class SynchronizationProvider with ChangeNotifier {
  String _url;
  String _rootPath;
  String msjAvance = '';
  bool syncFinished = false;
  bool success;
  final _syncRepository = SynchronizationRepository();
  SynchronizationModel _syncModel;
  int _estatus = -1;
  String _tablasNoProcesadas;
  String _ultTablaProcesada;
  String _fechaUltSincronizacion;
  String _urlUpload;
  //List<String> _tablasExcluidas=['User','Employee','PropuestaTecnicaActividadesH','PropuestaTecnicaSubActividadesH','PropuestaTecnicaActividades','PropuestaTecnicaSubActividades','Foto','Empleados','PropuestaTecnica','Trazabilidad','Conceptos','FoliosPropuestaTecnica'];

  void _getPref(
      int estatus,
      String ultTablaProcesada,
      String tablasNoProcesadas,
      String fechaUltimaActualizacion,
      String fechaFin,
      bool sincronizacionInicial,
      String plataformaSeleccionada,
      String siteId) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    _rootPath = documentsDirectory.path;

    _tablasNoProcesadas = tablasNoProcesadas;
    _ultTablaProcesada = ultTablaProcesada;
    success = false;
    _fechaUltSincronizacion = fechaUltimaActualizacion;

    _syncModel = new SynchronizationModel();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _syncModel.regCreadoPor = preferences.getString('user');
    final res = await DBContext.db.executeQuery(
        'SELECT IFNULL(MAX(SincronizacionId),0) FROM Sincronizaciones;');
    _syncModel.sincronizacionId = res.first.values.first;

    _syncModel.nombrePlataforma = plataformaSeleccionada;
    _syncModel.siteId = siteId;
    _syncModel.regFechaCreacion = DateTime.now().toString();
    _syncModel.regBorrado = 0;

    if (sincronizacionInicial) {
      _apiUrl(_syncModel.siteId, true);
      _url += "?RegBorrado=1";
      _syncModel.tipoSincronizacion = 0;
    } else {
      _apiUrl(_syncModel.siteId, false);
      _url += "/" + fechaUltimaActualizacion + "/" + fechaFin;
      _syncModel.tipoSincronizacion = 1;
    }

    if (estatus > -1) _estatus = estatus;

    if (_estatus < 0) {
      _syncModel.sincronizacionId += 1;
      // ignore: await_only_futures
      await _saveEstatusProcess(0, '', '');
      _estatus = 0;
    }
  }

  Future<void> _downloadData() async {
    try {
      if (_estatus < 1) {
        if (Directory(_rootPath + '/synchronization/').existsSync())
          await Directory(_rootPath + '/synchronization/')
              .delete(recursive: true);
        await Directory(_rootPath + '/synchronization/').create();
        if (File(_rootPath + "/data.zip").existsSync())
          await File(_rootPath + "/data.zip").delete();

        //Descargar archivo remoto
        var dio = new Dio();
        String progressString;

        _notify('Generando información...', false);
        // queryParameters: _params,
        await dio.download(_url, _rootPath + "/data.zip",
            onReceiveProgress: (rec, total) {
          progressString = ((rec / total) * 100).toStringAsFixed(0) + '%';
          _notify('Descargando información...' + progressString, false);
        });

        _saveEstatusProcess(1, '', '');
        _estatus = 1;
      }

      final zipFile = File(_rootPath + "/data.zip");
      final destinationDir = Directory(_rootPath + "/synchronization");
      if (_estatus < 2) {
        _notify('Extrayendo información...', false);
        //Se descomprime el archivo
        ZipFile.extractToDirectory(
                zipFile: zipFile, destinationDir: destinationDir)
            .whenComplete(() => _processFiles(destinationDir));
        _saveEstatusProcess(2, '', '');
        _estatus = 2;
      } else {
        await _processFiles(destinationDir);
      }
    } catch (e) {
      //on DioError e.mesage
      print(e);
      _notify('Error: No se pudo completar el proceso (download).', true);
    }
  }

  Future<void> _processFiles(Directory destinationDir) async {
    _notify('Procesando información...', false);
    try {
      final dbc = await DBContext.db.database;

      if (_syncModel.tipoSincronizacion == 0) {
        //carga inicial
        //cerrar conexión
        await DBContext.db.closeDB();

        //mover el archivo
        var databasesPath = await getDatabasesPath();
        await File(databasesPath + '/SpectrumCalidad.db').delete();
        await File(_rootPath + '/synchronization/SpectrumCalidad.db')
            .copy(databasesPath + '/SpectrumCalidad.db');
        await File(_rootPath + '/synchronization/SpectrumCalidad.db').delete();

        //abrir conexion
        await DBContext.db.database;
        //crear tablas y triggers de sincronización
        initScript.forEach(
            (script) async => await DBContext.db.executeRawQuery(script));
        importScript.forEach(
            (script) async => await DBContext.db.executeRawQuery(script));

        //insertar IMEI
        String imei = await ImeiPlugin.getImei();
        await DBContext.db.executeRawQuery(
            "UPDATE VariablesSistema SET Valor='$imei' WHERE VariableSistemaId='DISPOSITIVO';");

        //Guardar registro de sincronización
        _syncModel.sincronizacionId = 1;
        // ignore: await_only_futures
        await _saveEstatusProcess(0, '', '');

        globals.seHizoCargaInicial = true;
        _tablasNoProcesadas = '';
      } else {
        //sincronizacion diferencial

        //procesar archivos descargados
        List<FileSystemEntity> fileList = await destinationDir.list().toList();
        int index = 0;

        if (_estatus == 3 && _tablasNoProcesadas != '') {
          for (int i = fileList.length; i == 0; i--) {
            if (!_tablasNoProcesadas.contains(
                fileList[i].path.split('/').last.split('.').first.trim())) {
              fileList[i].delete();
            }
          }
          _tablasNoProcesadas = '';
        }

        if (_estatus < 3 && _ultTablaProcesada != '') {
          for (int i = 0; i < fileList.length; i++) {
            if (_ultTablaProcesada ==
                fileList[i].path.split('/').last.split('.').first.trim()) {
              index = i + 1;
              break;
            }
          }
        }

        for (int i = index; i < fileList.length; i++) {
          String fileContents = await new File(fileList[i].path).readAsString();
          List<dynamic> valores = json.decode(fileContents);
          fileContents = null;

          String tabla =
              fileList[i].path.split('/').last.split('.').first.trim();
          /* .replaceFirst('_HUB', '')
            .replaceFirst('_HUB', '')
            .replaceFirst('_KM10', '')
            .replaceFirst('_NEPT', '')
            .replaceFirst('_IOLA', '')
            .replaceFirst('_HERC', '')
            .replaceFirst('_ATLN', '');*/
          if (valores.isEmpty) // || _tablasExcluidas.contains(tabla)
            continue;

          ColumnModelList columnas =
              ColumnModelList.fromJsonList(valores); //jsonData

          _notify(
              'Procesando información...' +
                  (i + 1).toString() +
                  ' de ' +
                  fileList.length.toString(),
              false);

          bool existsColumnDisp = await DBContext.db
              .existsColumnInTable(tabla, 'RegIdEnDispositivo');

          var rawQuery = "INSERT OR REPLACE INTO " +
              tabla +
              "(" +
              columnas.toString() +
              (existsColumnDisp ? ",RegDispositivo" : "") +
              ")";
          String strValues = '';
          columnas.columns.forEach((element) {
            strValues += ',?';
          });
          if (existsColumnDisp) strValues += ',?';

          rawQuery += ' VALUES(' + strValues.substring(1) + ');';
          columnas = null;
          bool tablaProcesada = true;

          await dbc.transaction((txn) async {
            for (int j = 0; j < valores.length; j++) {
              Map<String, dynamic> dataRow = valores[j];
              if (existsColumnDisp)
                dataRow.addAll({"RegDispositivo": "SERVER"});
              try {
                await txn.rawInsert(rawQuery, dataRow.values.toList());
              } on Exception {
                tablaProcesada = false;
                break;
              }
            }

            valores = null;
          });

          if (tablaProcesada) {
            _ultTablaProcesada = tabla;
            _tablasNoProcesadas =
                _tablasNoProcesadas.replaceFirst(tabla + ',', '');
            _saveEstatusProcess(2, tabla, _tablasNoProcesadas);
            print('Tabla actualizada: ' + tabla);
          } else {
            _tablasNoProcesadas = _tablasNoProcesadas + tabla + ',';
            _saveEstatusProcess(
                2, _syncModel.ultTablaProcesada, _tablasNoProcesadas);
          }

          tabla = null;
        }
      }

      success = true;

      if (_tablasNoProcesadas == '') {
        _saveEstatusProcess(3, '', '');
        _estatus = 3;
        _notify('Sincronización finalizada satisfactoriamente.', true);
        await Directory(_rootPath + '/synchronization/')
            .delete(recursive: true);
        await File(_rootPath + "/data.zip").delete();
      } else {
        _saveEstatusProcess(3, '', _tablasNoProcesadas);
        _estatus = 3;
        _notify(
            'No se pudo procesar toda la información, reintente o comuniquese con el administrador del sistema.',
            true);
      }
    } catch (e) {
      //on DioError e.mesage
      print(e);
      _notify('Error: No se pudo completar el proceso (files).', true);
    }
  }

  Future<bool> _uploadData() async {
    //solo para diferencial
    try {
      if (_estatus < 1) {
        //Generar archivos locales
        _notify('Generando información...', false);
        if (Directory(_rootPath + '/uploadsync/').existsSync())
          await Directory(_rootPath + '/uploadsync/').delete(recursive: true);
        await Directory(_rootPath + '/uploadsync/').create();
        await Directory(_rootPath + '/uploadsync/data/').create();

        //Por cada tabla
        List<Map<String, dynamic>> tblList =
            await DBContext.db.getTableNameList();
        String tblName;
        bool existsColumn;
        bool hayArchivosPorenviar = false;
        List<String> listTablesModif = [
          'Junta',
          'AvanceJunta',
          'PlanoDetalle',
          'PlanInspeccionD'
        ];

        for (int i = 0; i < tblList.length; i++) {
          _notify(
              'Generando información...' +
                  (i + 1).toString() +
                  ' de ' +
                  tblList.length.toString(),
              false);
          tblName = tblList[i].values.first.toString();
          existsColumn = await DBContext.db
              .existsColumnInTable(tblName, 'RegIdEnDispositivo');

          // if(tblName=='ReporteInspeccionActividad')
          //   existsColumn=false;

          if (existsColumn || listTablesModif.contains(tblName)) {
            Map<String, String> columnsInfo =
                await DBContext.db.getColumnsInfo(tblName);
            String strCampos = "";
            columnsInfo.forEach((col, tipo) {
              if (col == "RegCreadoPor") {
                strCampos +=
                    ",'\"'||REPLACE(RegCreadoPor,'\\','\\\\')||'\"' AS RegCreadoPor";
              } else {
                if (tipo == "TEXT" || tipo == "BLOB")
                  strCampos += ",'\"'||" + col + "||'\"' AS " + col;
                else
                  strCampos += "," + col;
              }
            });
            //print(strCampos);
            strCampos = strCampos.substring(1);

            /*if(tblName=="Foto")
                _fechaUltSincronizacion='2021-02-03 00:00:00.000';//de prueba
              else
                _fechaUltSincronizacion='2020-12-15 00:00:00.000';//de prueba*/

            //Buscar informacion con la fecha de ult sincro
            List<Map<String, dynamic>> content = await DBContext.db
                .executeQuery("SELECT " +
                    strCampos +
                    " FROM " +
                    tblName +
                    " WHERE date(RegFechaRev)>=date('" +
                    _fechaUltSincronizacion +
                    "') ORDER BY RegFechaRev ASC ");
            if (content.isNotEmpty) {
              hayArchivosPorenviar = true;
              //  Guardar en file .json
              await File(_rootPath + '/uploadsync/data/' + tblName + '.json')
                  .create();
              await File(_rootPath + '/uploadsync/data/' + tblName + '.json')
                  .writeAsString(content.toString());
            }
          }
        }

        if (hayArchivosPorenviar) {
          _notify('Comprimiendo información...', false);
          //crear archivo zip local para enviar
          await ZipFile.createFromDirectory(
              sourceDir: Directory(_rootPath + '/uploadsync/data'),
              zipFile: File(_rootPath + '/uploadsync/data.zip'));

          _notify('Procesando información...', false);
          //subir archivos locales
          var dio = new Dio();
          String progressString;

          FormData formData = new FormData.fromMap({
            "myFile": await MultipartFile.fromFile(
                _rootPath + "/uploadsync/data.zip",
                filename: "data.zip")
          });
          Response response = await dio.post(_urlUpload, data: formData,
              onSendProgress: (rec, total) {
            progressString = ((rec / total) * 100).toStringAsFixed(0) + '%';
            _notify('Procesando información...' + progressString, false);
          });
          var resp = response.data; //json.decode(response.data);

          //Limpiar tablas subidas
          for (int i = 0; i < tblList.length; i++) {
            _notify(
                'Procesando información...' +
                    (i + 1).toString() +
                    ' de ' +
                    tblList.length.toString(),
                false);
            tblName = tblList[i].values.first.toString();
            if (resp["archivoSincronizados"]
                .toString()
                .contains(tblName + '.json')) {
              existsColumn = await DBContext.db
                  .existsColumnInTable(tblName, 'RegIdEnDispositivo');
              if (existsColumn) {
                //Buscar informacion con la fecha de ult sincro
                await DBContext.db.executeRawQuery("DELETE FROM " +
                    tblName +
                    " WHERE IFNULL(RegDispositivo,'')<>'' AND date(RegFechaRev)>=date('" +
                    _fechaUltSincronizacion +
                    "')");
              }
            }
          }

          await Directory(_rootPath + '/uploadsync/').delete(recursive: true);
          if (resp["descripcionError"] != null &&
              resp["descripcionError"] != "") {
            print(resp["descripcionError"]);
            _notify('Error: ' + resp["descripcionError"], true);
            throw (resp["descripcionError"]);
          }
          /* {
          "archivoSincronizados": "AvanceJunta.json",
          "archivosError": "No se Enconctro Ningun Archivo Con Error",
          "numeroActualizados": 1,
          "descripcionError": ""
          }*/
        }
      }
      return true;
    } catch (e) {
      print(e);
      _notify('Error: No se pudo completar el proceso (upload).', true);
      return false;
    }
  }

  void _saveEstatusProcess(
      int estatus, String utlTablaProcesada, String tablasNoProcesadas) {
    _syncModel.estatus = estatus;
    _syncModel.fechaUltimaActualizacion = DateTime.now().toString();
    _syncModel.ultTablaProcesada = utlTablaProcesada;
    _syncModel.tablasNoProcesadas = tablasNoProcesadas;

    if (estatus == 0)
      _syncRepository.insertSynchronization(sync: _syncModel);
    else
      _syncRepository.updateSynchronization(sync: _syncModel);
  }

  Future<void> synchronize(
      String fechaUltimaActualizacion,
      int estatus,
      String ultTablaProcesada,
      String tablasNoProcesadas,
      bool sincronizacionInicial,
      String plataformaSeleccionada,
      String siteId) async {
    // ignore: await_only_futures
    await _getPref(
        estatus,
        ultTablaProcesada,
        tablasNoProcesadas,
        fechaUltimaActualizacion,
        DateTime.now().toString(),
        sincronizacionInicial,
        plataformaSeleccionada,
        siteId);
    if (_syncModel.tipoSincronizacion == 0) {
      //carga inicial
      await _downloadData();
    } else {
      bool success = await _uploadData();
      if (success) {
        await _downloadData();
      }
    }
  }

  void _notify(String msj, bool finished) {
    syncFinished = finished;
    msjAvance = msj;
    notifyListeners();
  }

  //Descomentar para Dev
  void _apiUrl(String siteId, bool initialSync) {
    switch (siteId) {
      case 'KM10':
        _urlUpload =
            'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/Syncoffline/SincronizacionMergeOffline';
        if (initialSync)
          _url =
              'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/Syncoffline/CreateDataBaseFileSchemaSqlite'; //'http://192.168.1.84:9095/ZipDownload/ZipFile/data.zip'
        else
          _url =
              'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/sincronizacion';
        break;
      case 'NEPT':
        _urlUpload =
            'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/Syncoffline/SincronizacionMergeOffline';
        if (initialSync)
          _url =
              'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/Syncoffline/CreateDataBaseFileSchemaSqlite';
        else
          _url =
              'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/sincronizacion';
        break;
      case 'IOLA':
        _urlUpload =
            'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/Syncoffline/SincronizacionMergeOffline';
        if (initialSync)
          _url =
              'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/Syncoffline/CreateDataBaseFileSchemaSqlite';
        else
          _url =
              'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/sincronizacion';
        break;
      case 'ATLN':
        _urlUpload =
            'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/Syncoffline/SincronizacionMergeOffline';
        if (initialSync)
          _url =
              'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/Syncoffline/CreateDataBaseFileSchemaSqlite';
        else
          _url =
              'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/sincronizacion';
        break;
      case 'HERC':
        _urlUpload =
            'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/Syncoffline/SincronizacionMergeOffline';
        if (initialSync)
          _url =
              'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/Syncoffline/CreateDataBaseFileSchemaSqlite';
        else
          _url =
              'https://appsdev.cotemar.com.mx/HSEQMCApiKm10/api/sincronizacion';
        break;
      default:
        _urlUpload = '';
        _url = '';
        break;
    }
  }

  // //Descomentar para QAs
  // void _apiUrl(String siteId, bool initialSync) {
  //   switch (siteId) {
  //     case 'KM10':
  //       _urlUpload =
  //           'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/Syncoffline/SincronizacionMergeOffline';
  //       if (initialSync)
  //         _url =
  //             'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/Syncoffline/CreateDataBaseFileSchemaSqlite'; //'http://192.168.1.84:9095/ZipDownload/ZipFile/data.zip'
  //       else
  //         _url =
  //             'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/sincronizacion';
  //       break;
  //     case 'NEPT':
  //       _urlUpload =
  //           'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/Syncoffline/SincronizacionMergeOffline';
  //       if (initialSync)
  //         _url =
  //             'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/Syncoffline/CreateDataBaseFileSchemaSqlite';
  //       else
  //         _url =
  //             'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/sincronizacion';
  //       break;
  //     case 'IOLA':
  //       _urlUpload =
  //           'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/Syncoffline/SincronizacionMergeOffline';
  //       if (initialSync)
  //         _url =
  //             'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/Syncoffline/CreateDataBaseFileSchemaSqlite';
  //       else
  //         _url =
  //             'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/sincronizacion';
  //       break;
  //     case 'ATLN':
  //       _urlUpload =
  //           'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/Syncoffline/SincronizacionMergeOffline';
  //       if (initialSync)
  //         _url =
  //             'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/Syncoffline/CreateDataBaseFileSchemaSqlite';
  //       else
  //         _url =
  //             'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/sincronizacion';
  //       break;
  //     case 'HERC':
  //       _urlUpload =
  //           'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/Syncoffline/SincronizacionMergeOffline';
  //       if (initialSync)
  //         _url =
  //             'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/Syncoffline/CreateDataBaseFileSchemaSqlite';
  //       else
  //         _url =
  //             'https://spectrumcalidadqa.cotemar.net:4333/HSEQMCApi/api/sincronizacion';
  //       break;
  //     default:
  //       _urlUpload = '';
  //       _url = '';
  //       break;
  //   }
  // }

  //Descomentar para PRD
  // void _apiUrl(String siteId, bool initialSync) {
  //   switch (siteId) {
  //     case 'KM10':
  //       _urlUpload =
  //           'https://spectrumcalidad.cotemar.com.mx/ModuloCalidadAPI/api/Syncoffline/SincronizacionMergeOffline';
  //       if (initialSync)
  //         _url =
  //             'https://spectrumcalidad.cotemar.com.mx/ModuloCalidadAPI/api/Syncoffline/CreateDataBaseFileSchemaSqlite'; //'http://192.168.1.84:9095/ZipDownload/ZipFile/data.zip'
  //       else
  //         _url =
  //             'https://spectrumcalidad.cotemar.com.mx/ModuloCalidadAPI/api/sincronizacion';
  //       break;
  //     case 'NEPT':
  //       _urlUpload =
  //           'https://spectrumcalidad-nep.cotemar.net/ModuloCalidadAPI/api/Syncoffline/SincronizacionMergeOffline';
  //       if (initialSync)
  //         _url =
  //             'https://spectrumcalidad-nep.cotemar.net/ModuloCalidadAPI/api/Syncoffline/CreateDataBaseFileSchemaSqlite';
  //       else
  //         _url =
  //             'https://spectrumcalidad-nep.cotemar.net/ModuloCalidadAPI/api/sincronizacion';
  //       break;
  //     case 'IOLA':
  //       _urlUpload =
  //           'https://spectrumcalidad-iol.cotemar.net/ModuloCalidadAPI/api/Syncoffline/SincronizacionMergeOffline';
  //       if (initialSync)
  //         _url =
  //             'https://spectrumcalidad-iol.cotemar.net/ModuloCalidadAPI/api/Syncoffline/CreateDataBaseFileSchemaSqlite';
  //       else
  //         _url =
  //             'https://spectrumcalidad-iol.cotemar.net/ModuloCalidadAPI/api/sincronizacion';
  //       break;
  //     case 'ATLN':
  //       _urlUpload =
  //           'https://spectrumcalidad-ats.cotemar.net/ModuloCalidadAPI/api/Syncoffline/SincronizacionMergeOffline';
  //       if (initialSync)
  //         _url =
  //             'https://spectrumcalidad-ats.cotemar.net/ModuloCalidadAPI/api/Syncoffline/CreateDataBaseFileSchemaSqlite';
  //       else
  //         _url =
  //             'https://spectrumcalidad-ats.cotemar.net/ModuloCalidadAPI/api/sincronizacion';
  //       break;
  //     case 'HERC':
  //       _urlUpload =
  //           'https://spectrumcalidad-her.cotemar.net/ModuloCalidadAPI/api/Syncoffline/SincronizacionMergeOffline';
  //       if (initialSync)
  //         _url =
  //             'https://spectrumcalidad-her.cotemar.net/ModuloCalidadAPI/api/Syncoffline/CreateDataBaseFileSchemaSqlite';
  //       else
  //         _url =
  //             'https://spectrumcalidad-her.cotemar.net/ModuloCalidadAPI/api/sincronizacion';
  //       break;
  //     default:
  //       _urlUpload = '';
  //       _url = '';
  //       break;
  //   }
  // }
}
