import 'package:flutter/material.dart';
import 'package:mc_app/src/providers/blocs_provider.dart';
import 'package:mc_app/src/routes/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/pages/splash_page.dart';
import 'package:mc_app/src/bloc/bloc_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var value;
  String fichaEmpleado;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      fichaEmpleado = preferences.getString('user');
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocsProvider(fichaEmpleado),
      child: MaterialApp(
        title: "HSEQMC",
        home: SplashPage(),
        theme: ThemeData(
          primaryColor: Color(0xFF001D85),
          accentColor: Colors.black26,
        ),
        routes: getApplicationRoutes(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
