import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/avatar/avatar_bloc.dart';
import 'package:mc_app/src/bloc/avatar/avatar_event.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/models/user_off_model.dart';
import 'package:mc_app/src/pages/welding_control.dart';
import 'package:mc_app/src/utils/login_response.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class LoginPage extends StatefulWidget {
  static String id = "login_modern";
  static bool isSwitched = true;

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> implements LoginCallBack {
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  DateTime _dateTime;

  String _ficha, _email;
  LoginResponse _response;
  _LoginPageState() {
    _response = new LoginResponse(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() {
        form.save();
        _response.doLogin(_ficha, _email, _dateTime.toString());
      });
    }
  }

  void _showSnackBar(String text) {
    // ignore: deprecated_member_use
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    var loginForm = Container(
      child: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            children: <Widget>[
              TextFormField(
                onSaved: (val) => _email = val,
                validator: (value) {
                  if (value.isEmpty) {
                    return '[El correo es necesario]';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "[Correo electrónico]",
                  labelText: "Correo electrónico:",
                  border: InputBorder.none,
                  filled: true,
                  suffixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                onSaved: (val) => _ficha = val,
                validator: (value) {
                  if (value.isEmpty) {
                    return '[La ficha es necesaria]';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "[Escriba su ficha completa]",
                  labelText: "Ficha",
                  border: InputBorder.none,
                  filled: true,
                  suffixIcon: Icon(Icons.account_box_outlined),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    label: Text(
                      'Seleccionar Fecha de ingreso',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: _dateTime == null
                                  ? DateTime.now()
                                  : _dateTime,
                              firstDate: DateTime(2001),
                              lastDate: DateTime(2022))
                          .then((date) {
                        setState(() {
                          _dateTime = date;
                        });
                      });
                    },
                  ),
                  Text(
                    _dateTime == null
                        ? 'Sin fecha de ingreso'
                        : DateFormat('dd/MM/yyyy').format(_dateTime),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                  child: Text(
                    "Iniciar Sesión",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    var viewResponsive = GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: responsive.height,
          child: OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return Container(
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                      image: new ExactAssetImage('assets/img/banner.png'),
                      fit: BoxFit.cover,
                    )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/img/logo.png',
                          color: Colors.white30,
                          width: responsive.width * .3,
                          height: responsive.height * .2,
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                              // top: responsive.hp(5),
                              left: responsive.wp(5),
                              right: responsive.wp(5),
                              bottom: responsive.hp(10),
                            ),
                            child: Container(
                                color: Colors.white,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                      top: responsive.hp(6),
                                      left: responsive.wp(5),
                                      right: responsive.wp(5),
                                      bottom: responsive.hp(10),
                                    ),
                                    child: Wrap(children: [
                                      _header(),
                                      loginForm,
                                      _footer(),
                                    ])))),
                      ],
                    ));
              } else {
                return Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                        top: responsive.hp(7),
                        left: responsive.wp(2),
                        right: responsive.wp(2),
                      ),
                      child: Wrap(children: [
                        _header(),
                        loginForm,
                        _footer(),
                      ]),
                    )),
                    bannerLogin(context),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );

    return new Scaffold(
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: viewResponsive,
        ),
      ),
    );
  }

  Widget bannerLogin(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Expanded(
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
              child: Text(
                "Spectrum Calidad",
                style: TextStyle(
                  fontSize: responsive.dp(2.4),
                  color: Colors.white30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      // Aqui termina el banner del login
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        bottom: 10,
      ),
      child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                "Bienvenido",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
              Text(
                "Use una cuenta local para acceder:",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              )
            ],
          )),
    );
  }

  Widget _footer() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40),
        child: Text(
          "Cotemar 2020",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  savePref(int value, String ficha, String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("user", ficha);
      preferences.setString("pass", email);
      // ignore: deprecated_member_use
      preferences.commit();
    });
  }

  @override
  void onLoginError(String error) {
    _showSnackBar(error);
  }

  @override
  void onLoginSuccess(UserModelOff user) async {
    if (user != null) {
      savePref(1, user.ficha, user.email);

      BlocProvider.of<AvatarBloc>(context)
          .add(GetInfoAvatar(ficha: user.ficha));
      BlocProvider.of<UserPermissionBloc>(context)
          .add(GetPermission(ficha: int.parse(user.ficha)));

      Navigator.pushReplacementNamed(context, WeldingControl.id);
    } else {
      _showSnackBar('Datos incorrectos');
    }
  }
}
