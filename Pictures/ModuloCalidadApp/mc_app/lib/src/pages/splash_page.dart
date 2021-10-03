import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/avatar/bloc.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/database/db_context.dart';
import 'package:mc_app/src/pages/login_page.dart';
import 'package:mc_app/src/pages/welding_control.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);
  static String id = "Splash";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Widget
      getPref();
      DBContext.db.database;
    });
  }

  getPref() async {
    await Future.delayed(Duration(seconds: 2));
    var fichaEm;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    fichaEm = preferences.getString('user');

    if (fichaEm != null) {
      BlocProvider.of<AvatarBloc>(context).add(GetInfoAvatar(ficha: fichaEm));
      BlocProvider.of<UserPermissionBloc>(context)
          .add(GetPermission(ficha: int.parse(fichaEm)));
      Navigator.pushReplacementNamed(context, WeldingControl.id);
    } else {
      Navigator.pushReplacementNamed(context, LoginPage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
        body: Container(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/img/banner.png',
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          Image.asset(
            'assets/img/logo.png',
            color: Colors.white30,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: responsive.dp(4)),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                backgroundColor: Colors.white30,
              ),
            ),
          )
        ],
      ),
      // Aqui termina el banner del login
    ));
  }
}
