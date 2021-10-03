import '../front_dropdown_model.dart';
import '../joint_wc_model.dart';
import '../plain_detail_dropdown_model.dart';
import '../work_dropdown_model.dart';
import 'package:mc_app/src/models/contract_cs_dropdown_model.dart';

class WeldingControlDetailParams {
  String contractSelection;
  String workSelection;
  String plainDetailSelection;
  String stateFiltered;
  int frontSelection;
  JointWCModel joint;
  ContractCSDropdownModel contract;
  WorkDropDownModel work;
  PlainDetailDropDownModel plainDetail;
  FrontDropdownModel front;

  WeldingControlDetailParams({
    this.contractSelection,
    this.workSelection,
    this.plainDetailSelection,
    this.stateFiltered,
    this.frontSelection,
    this.joint,
    this.contract,
    this.work,
    this.plainDetail,
    this.front,
  });
}
