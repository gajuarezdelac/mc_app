import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/avatar/bloc.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/bloc/welding_list/welding_list_event.dart';
import 'package:mc_app/src/pages/anticorrosive_protection/anticorrosive_protection.dart';
import 'package:mc_app/src/pages/inspection_plan/inspection_plan_page.dart';
import 'package:mc_app/src/pages/login_page.dart';
import 'package:mc_app/src/pages/non_compliant_output/non_compliant_output.dart';
import 'package:mc_app/src/pages/send_corrosion_material/send_corrosion_material.dart';
import 'package:mc_app/src/pages/sincronization_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strings/strings.dart';
import 'package:package_info/package_info.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  signOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    BlocProvider.of<WeldingListBloc>(context).add(GetJointsWC(
      plainDetailId: '',
      frontId: 0,
      state: '',
      clear: true,
    ));
    await Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.id, (_) => false);
  }

  Route _createRoute(page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  String versionName;
  getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionName = packageInfo.version;
    setState(() {
      versionName = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    getVersionInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            BlocBuilder<AvatarBloc, AvatarState>(builder: (context, state) {
              if (state is Success) {
                return UserAccountsDrawerHeader(
                  accountName: Text(
                    camelize(state.userAvatarModel.nombre),
                    style: TextStyle(fontSize: 17),
                  ),
                  accountEmail: Column(
                    children: [
                      Text(
                        state.userAvatarModel.email,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "Versión: $versionName",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 13.5),
                      ),
                    ],
                  ),
                  arrowColor: Colors.amber,
                  currentAccountPicture: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        state.userAvatarModel.email
                            .substring(0, 2)
                            .toUpperCase(),
                        style: TextStyle(fontSize: 30.0, color: Colors.white),
                      ),
                    ),
                  ),
                );
              } else if (state is Error) {}
              print(state.userAvatarModel);
              return CircularProgressIndicator();
            }),
            ListTile(
              title: Text("Control de Soldadura"),
              leading: Icon(
                Icons.sort_outlined,
                size: 25,
                color: Colors.blueAccent,
              ),
              onTap: () {
                //Navigator.pushReplacementNamed(context, WeldingControl.id);
              },
            ),
            Divider(
              thickness: 2.0,
              color: Colors.blueAccent,
            ),
            ListTile(
              title: Text("Sincronización"),
              leading: Icon(
                Icons.download_outlined,
                size: 25,
              ),
              onTap: () {
                // Navigator.pushNamed(context, SincronizationPage.id);
                Navigator.of(context).push(_createRoute(SincronizationPage()));
              },
            ),
            ListTile(
              title: Text(SendCorrosionMaterial.id),
              leading: Icon(
                Icons.send_and_archive,
                size: 25,
              ),
              onTap: () {
                // Navigator.pushNamed(context, SendCorrosionMaterial.id);
                Navigator.of(context)
                    .push(_createRoute(SendCorrosionMaterial()));
                /*Navigator.pushReplacementNamed(
                  context,
                  SendCorrosionMaterial.id,
                );*/
              },
            ),
            ListTile(
              title: Text(AnticorrosiveProtection.id),
              leading: Icon(
                Icons.verified_user,
                size: 25,
              ),
              onTap: () {
                // Navigator.pushNamed(context, AnticorrosiveProtection.id);
                Navigator.of(context)
                    .push(_createRoute(AnticorrosiveProtection()));
                /*Navigator.pushReplacementNamed(
                  context,
                  SendCorrosionMaterial.id,
                );*/
              },
            ),
            ListTile(
              title: Text(InspectionPlanPage.id),
              leading: Icon(
                Icons.calendar_today_outlined,
                size: 25,
              ),
              onTap: () {
                // Navigator.pushNamed(context, InspectionPlanPage.id);
                Navigator.of(context).push(_createRoute(InspectionPlanPage()));
              },
            ),
            ListTile(
              title: Text(NonCompliantOutput.id),
              leading: Icon(
                Icons.cancel_schedule_send,
                size: 25,
              ),
              onTap: () {
                // Navigator.pushNamed(context, NonCompliantOutput.id);
                Navigator.of(context).push(_createRoute(NonCompliantOutput()));
              },
            ),
            ListTile(
              title: Text("Salir"),
              leading: Icon(
                Icons.exit_to_app_sharp,
                size: 25,
                color: Colors.red,
              ),
              onTap: () {
                signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
