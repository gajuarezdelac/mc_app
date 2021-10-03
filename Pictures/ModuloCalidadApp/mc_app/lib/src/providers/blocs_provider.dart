import 'package:mc_app/src/bloc/anticorrosive_protection/report_anticorrosive_protection/rpt_prueba_bloc.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/document/document_bloc.dart';
import 'package:mc_app/src/bloc/existing_element/existing_element_bloc.dart';
import 'package:mc_app/src/bloc/materials_corrosion/bloc.dart';
import 'package:mc_app/src/bloc/materials_corrosion/report_send_materials_corrosion/rpt_materials_corrosion_bloc.dart';
import 'package:mc_app/src/bloc/non_compliant_output/bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/anticorrosive_ipa/anticorrosive_ipa_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/coating_aplication/coating_aplication_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/coating_system/coating_system_bloc.dart';
import 'package:mc_app/src/bloc/modal_inspection_pa/equipment/equipment_bloc.dart';
import 'package:mc_app/src/bloc/non_compliant_output/report_non_compliant_output/rpt_non_compliant_output_bloc.dart';
import 'package:mc_app/src/bloc/user_rol/user_rol_bloc.dart';
import 'package:mc_app/src/bloc/non_compliant_output/non_compliant_output_bloc.dart';

List<BlocProvider> blocsProvider(String fichaEmpleado) {
  return [
    BlocProvider<ContractCSBloc>(
      create: (context) => ContractCSBloc()..add(GetContractsCS()),
    ),
    BlocProvider<WorkCSBloc>(create: (context) => WorkCSBloc()),
    BlocProvider<DropDownContractBloc>(
      create: (context) => DropDownContractBloc()..add(GetContracts()),
    ),
    BlocProvider<AvatarBloc>(
      create: (context) =>
          AvatarBloc()..add(GetInfoAvatar(ficha: fichaEmpleado)),
    ),
    BlocProvider<UserPermissionBloc>(
      create: (context) => UserPermissionBloc(),
    ),
    BlocProvider<DropDownWorkBloc>(
      create: (context) => DropDownWorkBloc(),
    ),
    BlocProvider<DropDownPlainDetailBloc>(
      create: (context) => DropDownPlainDetailBloc(),
    ),
    BlocProvider<DropDownFrontBloc>(
      create: (context) => DropDownFrontBloc(),
    ),
    BlocProvider<DropDownStatusBloc>(
      create: (context) => DropDownStatusBloc()..add(GetStatus()),
    ),
    BlocProvider<DropDownAnexoBloc>(
      create: (context) => DropDownAnexoBloc()..add(GetAnexo()),
    ),
    BlocProvider<DropDownPartidaPUBloc>(
      create: (context) => DropDownPartidaPUBloc(),
    ),
    BlocProvider<DropDownSystemBloc>(
      create: (context) => DropDownSystemBloc(),
    ),
    BlocProvider<DropDownSystemBloc>(
      create: (context) => DropDownSystemBloc(),
    ),
    BlocProvider<InternalDepartureBloc>(
      create: (context) => InternalDepartureBloc(),
    ),
    BlocProvider<DropDownSpecialityBloc>(
      create: (context) => DropDownSpecialityBloc(),
    ),
    BlocProvider<RelateJointBloc>(
      create: (context) => RelateJointBloc(),
    ),
    BlocProvider<DropDownPlaneSubactivityBloc>(
      create: (context) => DropDownPlaneSubactivityBloc(),
    ),
    BlocProvider<DropDownFolioBloc>(
      create: (context) => DropDownFolioBloc(),
    ),
    BlocProvider<InitialDataJointBloc>(
      create: (context) => InitialDataJointBloc(),
    ),
    BlocProvider<JointActivityBloc>(
      create: (context) => JointActivityBloc(),
    ),
    BlocProvider<DropDownPrimaveraIdBloc>(
      create: (context) => DropDownPrimaveraIdBloc(),
    ),
    BlocProvider<DropDownClientActivityBloc>(
      create: (context) => DropDownClientActivityBloc(),
    ),
    BlocProvider<DropDownReprogramationBloc>(
      create: (context) => DropDownReprogramationBloc(),
    ),
    BlocProvider<TableActivityBloc>(
      create: (context) => TableActivityBloc(),
    ),
    BlocProvider<SynchronizationBloc>(
      create: (context) =>
          SynchronizationBloc()..add(GetLastSynchronization(query: "")),
    ),
    BlocProvider<WeldingListBloc>(
      create: (context) => WeldingListBloc(),
    ),
    BlocProvider<TraceabilityBloc>(
      create: (context) => TraceabilityBloc(),
    ),
    BlocProvider<TraceabilityOneBloc>(
      create: (context) => TraceabilityOneBloc(),
    ),
    BlocProvider<TraceabilityTwoBloc>(
      create: (context) => TraceabilityTwoBloc(),
    ),
    BlocProvider<TraceabilityOneRemoveBloc>(
      create: (context) => TraceabilityOneRemoveBloc(),
    ),
    BlocProvider<TraceabilityOneAddBloc>(
      create: (context) => TraceabilityOneAddBloc(),
    ),
    BlocProvider<TraceabilityTwoRemoveBloc>(
      create: (context) => TraceabilityTwoRemoveBloc(),
    ),
    BlocProvider<TraceabilityTwoAddBloc>(
      create: (context) => TraceabilityTwoAddBloc(),
    ),
    BlocProvider<PipefitterBloc>(
      create: (context) => PipefitterBloc(),
    ),
    BlocProvider<PipefitterRemoveBloc>(
      create: (context) => PipefitterRemoveBloc(),
    ),
    BlocProvider<PipefitterAddBloc>(
      create: (context) => PipefitterAddBloc(),
    ),
    BlocProvider<PipefitterSignBloc>(
      create: (context) => PipefitterSignBloc(),
    ),
    BlocProvider<NDTProgressBloc>(
      create: (context) => NDTProgressBloc(),
    ),
    BlocProvider<PanelRegisterBloc>(
      create: (context) => PanelRegisterBloc(),
    ),
    BlocProvider<EvidencePhotographicBloc>(
        create: (context) => EvidencePhotographicBloc()),
    BlocProvider<DatesBloc>(
      create: (context) => DatesBloc(),
    ),
    BlocProvider<OverseerBloc>(
      create: (context) => OverseerBloc(),
    ),
    BlocProvider<AddWelderBloc>(
      create: (context) => AddWelderBloc(),
    ),
    BlocProvider<QABloc>(
      create: (context) => QABloc(),
    ),
    BlocProvider<EvidenceFNBloc>(
      create: (context) => EvidenceFNBloc(),
    ),
    BlocProvider<EvidencePhotographicWeldingBloc>(
      create: (context) => EvidencePhotographicWeldingBloc(),
    ),
    BlocProvider<UserRolBloc>(
      create: (context) => UserRolBloc(),
    ),
    BlocProvider<QualifyCaboNormBloc>(
      create: (context) => QualifyCaboNormBloc(),
    ),
    BlocProvider<EvidenceFNWeldingBloc>(
      create: (context) => EvidenceFNWeldingBloc(),
    ),
    BlocProvider<JointTraceabilityBloc>(
      create: (context) => JointTraceabilityBloc(),
    ),
    BlocProvider<ContractsInspectionPlanBloc>(
      create: (context) =>
          ContractsInspectionPlanBloc()..add(GetContractsInspectionPlan()),
    ),
    BlocProvider<WorksInspectionPlanBloc>(
      create: (context) => WorksInspectionPlanBloc(),
    ),
    BlocProvider<ListActivitiesBloc>(
      create: (context) => ListActivitiesBloc(),
    ),
    BlocProvider<MaterialsCorrosionBloc>(
      create: (context) => MaterialsCorrosionBloc(),
    ),
    BlocProvider<SpoolDetalleProteccionBloc>(
      create: (context) => SpoolDetalleProteccionBloc(),
    ),
    BlocProvider<ActivitiesInspectionPlanBloc>(
      create: (context) => ActivitiesInspectionPlanBloc(),
    ),
    BlocProvider<TableActivitiesIPBloc>(
      create: (context) => TableActivitiesIPBloc(),
    ),
    BlocProvider<ListMaterialsBloc>(
      create: (context) => ListMaterialsBloc(),
    ),
    BlocProvider<EvidencePhotographicIPBloc>(
      create: (context) => EvidencePhotographicIPBloc(),
    ),
    BlocProvider<AnticorrosiveGridBloc>(
      create: (context) => AnticorrosiveGridBloc(),
    ),
    BlocProvider<RptMaterialsCorrosionBloc>(
      create: (context) => RptMaterialsCorrosionBloc(),
    ),
    BlocProvider<WelderPlanBloc>(
      create: (context) => WelderPlanBloc(),
    ),
    BlocProvider<ListMaterialsBloc>(
      create: (context) => ListMaterialsBloc(),
    ),
    BlocProvider<EvidencePhotographicIPBloc>(
      create: (context) => EvidencePhotographicIPBloc(),
    ),
    BlocProvider<AnticorrosiveGridBloc>(
      create: (context) => AnticorrosiveGridBloc(),
    ),
    BlocProvider<HeaderBloc>(create: (context) => HeaderBloc()),
    BlocProvider<CoatingSystemBloc>(
      create: (context) => CoatingSystemBloc(),
    ),
    BlocProvider<InfoGeneralBloc>(
      create: (context) => InfoGeneralBloc(),
    ),
    BlocProvider<EquipmentBloc>(
      create: (context) => EquipmentBloc(),
    ),
    BlocProvider<EnvironmentalConditionsBloc>(
      create: (context) => EnvironmentalConditionsBloc(),
    ),
    BlocProvider<CoatingAplicationBloc>(
      create: (context) => CoatingAplicationBloc(),
    ),
    BlocProvider<DocumentBloc>(
      create: (context) => DocumentBloc(),
    ),
    BlocProvider<WorksSNCOutputBloc>(
      create: (context) => WorksSNCOutputBloc(),
    ),
    BlocProvider<ContractsSNCOutputBloc>(
      create: (context) => ContractsSNCOutputBloc(),
    ),
    BlocProvider<PlainDetailSNCBloc>(
      create: (context) => PlainDetailSNCBloc(),
    ),
    BlocProvider<TypeSNCOutputBloc>(
      create: (context) => TypeSNCOutputBloc(),
    ),
    BlocProvider<PaginatorSNCBloc>(
      create: (context) => PaginatorSNCBloc(),
    ),
    BlocProvider<RptNonCompliantOutputBloc>(
      create: (context) => RptNonCompliantOutputBloc(),
    ),
    BlocProvider<RptInspectionBloc>(
      create: (context) => RptInspectionBloc(),
    ),
    BlocProvider<NonCompliantOutputIdBloc>(
      create: (context) => NonCompliantOutputIdBloc(),
    ),
    BlocProvider<EmployeeBloc>(
      create: (context) => EmployeeBloc(),
    ),
    BlocProvider<NonCompliantOutputBloc>(
      create: (context) => NonCompliantOutputBloc(),
    ),
    BlocProvider<PlannedResourcesBloc>(
      create: (context) => PlannedResourcesBloc(),
    ),
    BlocProvider<RptPruebaBloc>(
      create: (context) => RptPruebaBloc(),
    ),
    BlocProvider<RptAnticorrosiveProtectionBloc>(
      create: (context) => RptAnticorrosiveProtectionBloc(),
    ),
    BlocProvider<StageMaterialIPABloc>(
        create: (context) => StageMaterialIPABloc()),
    BlocProvider<MaterialsIPABloc>(create: (context) => MaterialsIPABloc()),
    BlocProvider<MaterialStagesDIPABloc>(
        create: (context) => MaterialStagesDIPABloc()),
    BlocProvider<ACCBloc>(create: (context) => ACCBloc()),
    BlocProvider<ACSBloc>(create: (context) => ACSBloc()),
    BlocProvider<MachinesWelderBloc>(create: (context) => MachinesWelderBloc()),
    BlocProvider<WorkTraceabilityBloc>(create: (_) => WorkTraceabilityBloc()),
    BlocProvider<ExistingElementBloc>(create: (_) => ExistingElementBloc())
  ];
}

// RptAnticorrosiveProtectionBloc
