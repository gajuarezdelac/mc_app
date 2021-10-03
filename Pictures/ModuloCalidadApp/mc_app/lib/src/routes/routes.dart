import 'package:flutter/cupertino.dart';
import 'package:mc_app/src/pages/activities_page.dart';
import 'package:mc_app/src/pages/anticorrosive_protection/anticorrosive_protection.dart';
import 'package:mc_app/src/pages/inspection_plan/inspection_plan_page.dart';
import 'package:mc_app/src/pages/inspection_plan/widgets/activities_inspection_plan.dart';
import 'package:mc_app/src/pages/inspection_plan/widgets/register_inspection_plan.dart';
import 'package:mc_app/src/pages/login_page.dart';
import 'package:mc_app/src/pages/send_corrosion_material/send_corrosion_material.dart';
import 'package:mc_app/src/pages/sincronization_page.dart';
import 'package:mc_app/src/pages/splash_page.dart';
import 'package:mc_app/src/pages/welding_control.dart';
import 'package:mc_app/src/pages/welding_control_detail_page.dart';
import 'package:mc_app/src/pages/non_compliant_output/non_compliant_output.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    LoginPage.id: (BuildContext context) => LoginPage(),
    SincronizationPage.id: (BuildContext context) => SincronizationPage(),
    WeldingControl.id: (BuildContext context) => WeldingControl(),
    WeldingControlDetailPage.id: (BuildContext context) =>
        WeldingControlDetailPage(params: null),
    ActivitiesPage.id: (BuildContext context) => ActivitiesPage(params: null),
    SplashPage.id: (_) => SplashPage(),
    SendCorrosionMaterial.id: (BuildContext context) => SendCorrosionMaterial(),
    AnticorrosiveProtection.id: (BuildContext context) =>
        AnticorrosiveProtection(),
    InspectionPlanPage.id: (BuildContext context) => InspectionPlanPage(),
    NonCompliantOutput.id: (BuildContext context) => NonCompliantOutput(),
    ActivitiesInspectionPlan.id: (BuildContext context) =>
        ActivitiesInspectionPlan(),
    RegisterInspectionPlan.id: (BuildContext context) =>
        RegisterInspectionPlan(),
  };
}
