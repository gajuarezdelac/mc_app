import 'package:flutter/material.dart';
import 'package:mc_app/src/utils/globals.dart' as globals;
import 'package:mc_app/src/utils/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:mc_app/src/providers/synchronization_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/synchronization/bloc.dart';
import 'package:mc_app/src/bloc/synchronization/synchronization_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SincronizationProgress extends StatefulWidget {
  SincronizationProgress({Key key}) : super(key: key);

  @override
  _SincronizationProgressState createState() => _SincronizationProgressState();
}

class _SincronizationProgressState extends State<SincronizationProgress> {
  String txtSincronizando = '';
  bool _ejecutandoSync = false;
  String _fechaUltimaActualizacion;
  int _estatus = -1;
  String _tablasNoProcesadas = '';
  String _ultTablaProcesada = '';

  signOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    /*await Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.id, (_) => false);*/
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5,
        bottom: 5,
      ),
      child: Column(
        children: [
          Container(
            color: Colors.black12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(txtSincronizando,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      )),
                ),
                BlocBuilder<SynchronizationBloc, SynchronizationState>(
                  builder: (context, state) {
                    if (state is SuccessLastSynchronization) {
                      if (state.syncs != null) {
                        if (globals.plataformaSeleccionada.isEmpty) {
                          globals.plataformaSeleccionada =
                              state.syncs.first.nombrePlataforma;
                        }
                        if (state.syncs.first.tipoSincronizacion == 0 &&
                            state.syncs.first.estatus < 3)
                          globals.plataformaActual = '';
                        else
                          globals.plataformaActual =
                              state.syncs.first.nombrePlataforma;
                        globals.siteId = state.syncs.first.siteId;
                        _fechaUltimaActualizacion =
                            state.syncs.first.fechaUltimaActualizacion;
                        _tablasNoProcesadas =
                            state.syncs.first.tablasNoProcesadas;
                        _estatus = state.syncs.first.estatus;
                        _ultTablaProcesada =
                            state.syncs.first.ultTablaProcesada;
                        if (state.syncs.first.estatus == 3 &&
                            _tablasNoProcesadas == '') {
                          _estatus = -1;
                        }
                      }
                    }
                    if (state is ErrorLastSynchronization) {
                      return Text(state.message);
                    }
                    return Text('');
                  },
                ),
              ],
            ),
          ),
          Container(
              width: double.infinity,
              color: Colors.white60,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ChangeNotifierProvider<SynchronizationProvider>(
                    create: (context) => SynchronizationProvider(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _progressIndicatorAnimation(),
                        Builder(builder: (context) {
                          final sync = Provider.of<SynchronizationProvider>(
                              context,
                              listen: false);

                          return TextButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: globals.isButtonDisabled
                                  ? null
                                  : RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(5.0)),
                            ),
                            child: Text(
                              "SINCRONIZAR",
                              style: TextStyle(
                                  color: globals.isButtonDisabled
                                      ? Colors.grey
                                      : Colors.green),
                            ),
                            onPressed: globals.isButtonDisabled
                                ? null
                                : () {
                                    if (globals.plataformaSeleccionada == '') {
                                      Dialogs.alert(context,
                                          title: 'Aviso',
                                          description:
                                              'Se requiere seleccionar la plataforma.');
                                      return;
                                    }
                                    Dialogs.confirm(context,
                                        title: 'Sincronizar con ' +
                                            globals.plataformaSeleccionada,
                                        description:
                                            'Para sincronizar es necesario que tengas el dispositivo con energía suficiente, no apagar el dispositivo, ni dejar que entre en modo suspensión mientras esté en proceso de sincronización.',
                                        onConfirm: () {
                                      setState(() {
                                        txtSincronizando =
                                            'Sincronizando con ' +
                                                globals.plataformaSeleccionada;
                                        _ejecutandoSync = true;
                                        globals.isButtonDisabled = true;
                                      });
                                      Navigator.pop(context);
                                      sync.addListener(() {
                                        if (sync.syncFinished) {
                                          setState(() {
                                            txtSincronizando = '';
                                            _ejecutandoSync = false;
                                            globals.isButtonDisabled = false;
                                          });

                                          if (sync.success) {
                                            Dialogs.modalConfirmOkOnly(context,
                                                title:
                                                    'Es necesario reiniciar la aplicación',
                                                description:
                                                    'Para ingresar nuevamente utilice su cuenta personal.',
                                                buttonText: 'Enterado',
                                                onConfirm: () {
                                              Navigator.of(context).pop();
                                              signOut();
                                              Phoenix.rebirth(context);
                                            });
                                          }
                                        }
                                      });
                                      sync.synchronize(
                                          _fechaUltimaActualizacion,
                                          _estatus,
                                          _ultTablaProcesada,
                                          _tablasNoProcesadas,
                                          globals.plataformaSeleccionada !=
                                              globals.plataformaActual,
                                          globals.plataformaSeleccionada,
                                          globals.siteId);
                                    });
                                  },
                          );
                        }),
                        Consumer<SynchronizationProvider>(
                          builder: (context, sync, child) => Text(
                            '${sync.msjAvance}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _progressIndicatorAnimation() {
    if (_ejecutandoSync == true) {
      return Padding(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        child: SizedBox(
          child: CircularProgressIndicator(
            backgroundColor: Colors.green,
            strokeWidth: 7,
          ),
          height: 50.0,
          width: 50.0,
        ),
      );
    } else {
      return Icon(
        Icons.sync,
        size: 70,
        color: Colors.green,
      );
    }
  }
}
