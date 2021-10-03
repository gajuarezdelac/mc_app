import 'package:flutter/material.dart';
import 'package:mc_app/src/bloc/synchronization/bloc.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:mc_app/src/widgets/sincronization_progress.dart';
import 'package:mc_app/src/widgets/sincronization_with.dart';
import 'package:mc_app/src/utils/dialogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/synchronization/synchronization_bloc.dart';
import 'package:mc_app/src/utils/globals.dart' as globals;

class SincronizationPage extends StatefulWidget {
  static String id = "Sincronizacion";
  @override
  _SincronizationPageState createState() => _SincronizationPageState();
}

class _SincronizationPageState extends State<SincronizationPage> {
  String value;
  List items = ["Neptuno", "Atlantis", "Iolair", "Km10", "Hercules"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1));
      if (globals.plataformaSeleccionada == '') {
        Dialogs.alert(context,
            title: 'Completar información',
            description:
                'No has seleccionado la plataforma, para completar la configuración inicial es necesario que seleccione la plataforma.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sincronización'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: responsive.hp(3),
          ),
          child: Container(
            width: double.infinity,
            height: responsive.height,
            child: OrientationBuilder(builder: (context, orientation) {
              if (orientation == Orientation.portrait) {
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: responsive.hp(1),
                            left: responsive.wp(1),
                            right: responsive.wp(1)),
                        child: Wrap(
                          children: <Widget>[
                            BlocBuilder<SynchronizationBloc,
                                SynchronizationState>(
                              builder: (context, state) {
                                if (state is SuccessLastSynchronization) {
                                  if (state.syncs != null) {
                                    globals.plataformaSeleccionada =
                                        state.syncs.first.nombrePlataforma;
                                  }
                                }
                                if (state is ErrorLastSynchronization) {
                                  return Text(state.message);
                                }
                                return SincronizationWith();
                              },
                            ),
                            //SincronizationWith(),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                          top: responsive.hp(1),
                          left: responsive.wp(1),
                          right: responsive.wp(1)),
                      child: Wrap(
                        children: <Widget>[
                          SincronizationProgress(),
                        ],
                      ),
                    ))
                  ],
                );
              } else {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: responsive.hp(1),
                            left: responsive.wp(1),
                            right: responsive.wp(1)),
                        child: SincronizationWith(),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                          top: responsive.hp(1),
                          left: responsive.wp(1),
                          right: responsive.wp(1)),
                      child: SincronizationProgress(),
                    ))
                  ],
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
