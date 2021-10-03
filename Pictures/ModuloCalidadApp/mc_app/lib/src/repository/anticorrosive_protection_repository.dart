import 'package:flutter/material.dart';
import 'package:mc_app/src/data/dao/anticorrosive_protection_dao.dart';
import 'package:mc_app/src/models/anticorrosive_ipa_model.dart';
import 'package:mc_app/src/models/coating_aplication_model.dart';
import 'package:mc_app/src/models/equipment_model.dart';
import 'package:mc_app/src/models/material_stages_d_ipa_model.dart';
import 'package:mc_app/src/models/materials_table_ipa_model.dart';
import 'package:mc_app/src/models/params/anticorrosive_grid_params.dart';
import 'package:mc_app/src/models/params/environmental_conditions_params.dart';
import 'package:mc_app/src/models/stage_materials_ipa_model.dart';

class AnticorrosiveProtectionRepository {
  final anticorrosiveDao = AnticorrosiveProtectionDao();

  //Tab Anticorrosivo
  Future getPaginatorAnticorrosive(
          {@required AnticorrosiveGridParams params}) =>
      anticorrosiveDao.selPaginadorProteccionAnticorrosiva(params);

  Future selAnticorrosiveHeader(String noRegistro) => 
      anticorrosiveDao.selAnticorrosiveHeader(noRegistro);

  Future selStagesCoatingSystem(String noRegistro) => 
      anticorrosiveDao.selEtapasSistemaRecubrimiento(noRegistro);

  Future selInfoGeneral(String noRegistro) => 
      anticorrosiveDao.selAnticorrosivoIPA(noRegistro);

  Future insUpdInfoGeneral(String noRegistro, AnticorrosiveIPAModel anticorrosiveIPAModel) => 
      anticorrosiveDao.insUpdInfoGeneral(noRegistro, anticorrosiveIPAModel);

  Future selEquipment(String noRegistro) => 
      anticorrosiveDao.selEquipos(noRegistro);

  Future selEnvironmentalConditions(String noRegistro) => 
      anticorrosiveDao.selCondicionesAmbientales(noRegistro);

  Future selCoatingAplication(String noRegistro) => 
      anticorrosiveDao.selAplicacionRecubrimiento(noRegistro);

  Future insUpdEnvironmentalConditions(String noRegistro, List<EnvironmentalConditionsParams> param) => 
      anticorrosiveDao.insUpdCondicionesAmbientales(noRegistro, param);

  Future insUpdCoatingApplication(List<CoatingAplicationModel> params, String noRegistro) => 
      anticorrosiveDao.insUpdCoatingApplication(params, noRegistro);

  Future insUpdEquipment(String noRegistro, List<EquipmentModel> params) => 
      anticorrosiveDao.insUpdEquipment(noRegistro, params);

  //Tab Materiales
  Future selStageMaterialsIPA(String noRegistro) =>
      anticorrosiveDao.selEtapaMaterialIPA(noRegistro);

  Future insUpdStagesMaterialIPA(List<StageMaterialsIPAModel> params) => 
      anticorrosiveDao.insUpdStagesMaterialIPA(params);

  Future selMaterialsByRecordNo(String noRegistro) => 
      anticorrosiveDao.selMaterialsByRecordNo(noRegistro);

  Future selMaterialStagesDIPA(String noRegistro) => 
      anticorrosiveDao.selMaterialStagesDIPA(noRegistro);

  Future insUpdMaterialsIPA(List<MaterialsTableIPAModel> params, String noRegistro) =>
      anticorrosiveDao.insUpdMaterialsIPA(params, noRegistro);

  Future insUpdMaterialsStagesDIPA(List<MaterialStagesDIPAModel> params) =>
      anticorrosiveDao.insUpdMaterialsStagesDIPA(params);
}
