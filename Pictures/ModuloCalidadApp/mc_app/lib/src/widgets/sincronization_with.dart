import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mc_app/src/utils/dialogs.dart';
import 'package:mc_app/src/utils/globals.dart' as globals;
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class SincronizationWith extends StatefulWidget {
  @override
  _SincronizationWithState createState() => _SincronizationWithState();
}

class _SincronizationWithState extends State<SincronizationWith> {
  bool _km10 = false;
  bool _atlantis = false;
  bool _neptuno = false;
  bool _iolair = false;
  bool _hercules = false;
  /*String _subtitleKm10 = "Última vez ---------------";
  String _subtitleAtln = "Última vez ---------------";
  String _subtitleIola = "Última vez ---------------";
  String _subtitleNept = "Última vez ---------------";
  String _subtitleHerc = "Última vez ---------------";*/
  String _fechaUltVez = "Última vez ---------------";

  @override
  Widget build(BuildContext context) {
    _selectSwitch();

    return Padding(
      padding: EdgeInsets.only(
        left: 5,
        bottom: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Text(
                    'Sincronizar con...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        tooltip: "Seleccionar Plataforma",
                        icon: Icon(
                          Icons.dns,
                          size: 30.0,
                        ),
                        onPressed: () {
                          _showDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            color: Colors.white60,
            //height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                    globals.plataformaSeleccionada == ''
                        ? Icons.info_outline
                        : (globals.plataformaSeleccionada == 'KM10'
                            ? Icons.apartment_outlined
                            : Icons.anchor_outlined),
                    color: Colors.blue,
                    size: 55),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      globals.plataformaSeleccionada == ""
                          ? "No hay plataforma seleccionada"
                          : globals.plataformaSeleccionada,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24.0,
                      ),
                    ),
                    Text(
                      _fechaUltVez,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectSwitch() {
    switch (globals.plataformaSeleccionada) {
      case 'Neptuno':
        _neptuno = true;
        globals.siteId = 'NEPT';
        _fechaUltVez = 'Última vez ' + globals.fechaUltSincro;
        break;
      case 'Iolair':
        _iolair = true;
        globals.siteId = 'IOLA';
        _fechaUltVez = 'Última vez ' + globals.fechaUltSincro;
        break;
      case 'Atlantis':
        _atlantis = true;
        globals.siteId = 'ATLN';
        _fechaUltVez = 'Última vez ' + globals.fechaUltSincro;
        break;
      case 'Hércules':
        _hercules = true;
        globals.siteId = 'HERC';
        _fechaUltVez = 'Última vez ' + globals.fechaUltSincro;
        break;
      case 'KM10':
        _km10 = true;
        globals.siteId = 'KM10';
        _fechaUltVez = 'Última vez ' + globals.fechaUltSincro;
        break;
      default:
        //print('No implementado');
        break;
    }
  }

  bool _existePlataformaSeleccionada() {
    if (_neptuno == true ||
        _hercules == true ||
        _atlantis == true ||
        _iolair == true ||
        _km10 == true) {
      return true;
    }
    return false;
  }

  void desactivarPlataformas() {
    _neptuno = false;
    _hercules = false;
    _atlantis = false;
    _iolair = false;
    _km10 = false;
  }

  Icon iconSelect(bool plataformaSeleccionada, IconData icon) {
    if (plataformaSeleccionada == true) {
      return Icon(icon, color: Colors.blue);
    }
    return Icon(icon, color: Colors.grey);
  }

  TextStyle textStyleSelect(bool plataformaSeleccionada) {
    if (plataformaSeleccionada == true) {
      return TextStyle(color: Colors.blue);
    }
    return TextStyle(color: Colors.black);
  }

  void _showDialog() {
    slideDialog.showSlideDialog(
      context: context,
      child: Expanded(
        // color: Colors.white60,
        //height: 290,
        child: ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text(
                'Neptuno',
                style: textStyleSelect(_neptuno),
              ),
              //subtitle: Text(_subtitleNept),
              value: _neptuno,
              activeColor: Colors.blue,
              onChanged: (bool value) {
                if (globals.isButtonDisabled) {
                  Dialogs.alert(context,
                      title: 'Acción no permitida',
                      description:
                          'Espere a que finalice el proceso de sincronización.');
                  return;
                }
                if (_existePlataformaSeleccionada() == true) {
                  if (_neptuno == true) {
                    Dialogs.alert(context,
                        title: 'Acción no permitida',
                        description:
                            'Se requiere una plataforma seleccionada.');
                  } else {
                    Dialogs.confirm(context,
                        title: 'Cambio de Plataforma',
                        description: 'Se suplantarán los datos al sincronizar.',
                        onConfirm: () {
                      Navigator.pop(context);
                      setState(() {
                        if (value == true) {
                          globals.plataformaSeleccionada = 'Neptuno';
                          globals.siteId = 'NEPT';
                          globals.fechaUltSincro = '---------------';
                          desactivarPlataformas();
                        }
                        _neptuno = value;
                      });
                      Navigator.pop(context);
                    });
                  }
                } else {
                  setState(() {
                    if (value == true) {
                      globals.plataformaSeleccionada = 'Neptuno';
                      globals.siteId = 'NEPT';
                      globals.fechaUltSincro = '---------------';
                      desactivarPlataformas();
                    }
                    _neptuno = value;
                  });
                  Navigator.pop(context);
                }
              },
              secondary: iconSelect(_neptuno, Icons.anchor_outlined),
            ),
            SwitchListTile(
              title: Text(
                'Atlantis',
                style: textStyleSelect(_atlantis),
              ),
              //subtitle: Text(_subtitleAtln),
              value: _atlantis,
              activeColor: Colors.blue,
              onChanged: (bool value) {
                if (globals.isButtonDisabled) {
                  Dialogs.alert(context,
                      title: 'Acción no permitida',
                      description:
                          'Espere a que finalice el proceso de sincronización.');
                  return;
                }
                if (_existePlataformaSeleccionada() == true) {
                  if (_atlantis == true) {
                    Dialogs.alert(context,
                        title: 'Acción no permitida',
                        description:
                            'Se requiere una plataforma seleccionada.');
                  } else {
                    Dialogs.confirm(context,
                        title: 'Cambio de Plataforma',
                        description: 'Se suplantarán los datos al sincronizar.',
                        onConfirm: () {
                      Navigator.pop(context);
                      setState(() {
                        if (value == true) {
                          globals.plataformaSeleccionada = 'Atlantis';
                          globals.siteId = 'ATLN';
                          globals.fechaUltSincro = '---------------';
                          desactivarPlataformas();
                        }
                        _atlantis = value;
                      });
                      Navigator.pop(context);
                    });
                  }
                } else {
                  setState(() {
                    if (value == true) {
                      globals.plataformaSeleccionada = 'Atlantis';
                      globals.siteId = 'ATLN';
                      globals.fechaUltSincro = '---------------';
                      desactivarPlataformas();
                    }
                    _atlantis = value;
                  });
                  Navigator.pop(context);
                }
              },
              secondary: iconSelect(_atlantis, Icons.anchor_outlined),
            ),
            SwitchListTile(
              title: Text(
                'Iolair',
                style: textStyleSelect(_iolair),
              ),
              //subtitle: Text(_subtitleIola),
              value: _iolair,
              activeColor: Colors.blue,
              onChanged: (bool value) {
                if (globals.isButtonDisabled) {
                  Dialogs.alert(context,
                      title: 'Acción no permitida',
                      description:
                          'Espere a que finalice el proceso de sincronización.');
                  return;
                }
                if (_existePlataformaSeleccionada() == true) {
                  if (_iolair == true) {
                    Dialogs.alert(context,
                        title: 'Acción no permitida',
                        description:
                            'Se requiere una plataforma seleccionada.');
                  } else {
                    Dialogs.confirm(context,
                        title: 'Cambio de Plataforma',
                        description: 'Se suplantarán los datos al sincronizar.',
                        onConfirm: () {
                      Navigator.pop(context);
                      setState(() {
                        if (value == true) {
                          globals.plataformaSeleccionada = 'Iolair';
                          globals.siteId = 'IOLA';
                          globals.fechaUltSincro = '---------------';
                          desactivarPlataformas();
                        }
                        _iolair = value;
                      });
                      Navigator.pop(context);
                    });
                  }
                } else {
                  setState(() {
                    if (value == true) {
                      globals.plataformaSeleccionada = 'Iolair';
                      globals.siteId = 'IOLA';
                      globals.fechaUltSincro = '---------------';
                      desactivarPlataformas();
                    }
                    _iolair = value;
                  });
                  Navigator.pop(context);
                }
              },
              secondary: iconSelect(_iolair, Icons.anchor_outlined),
            ),
            SwitchListTile(
              title: Text(
                'Hercules',
                style: textStyleSelect(_hercules),
              ),
              //subtitle: Text(_subtitleHerc),
              value: _hercules,
              activeColor: Colors.blue,
              onChanged: (bool value) {
                if (globals.isButtonDisabled) {
                  Dialogs.alert(context,
                      title: 'Acción no permitida',
                      description:
                          'Espere a que finalice el proceso de sincronización.');
                  return;
                }
                if (_existePlataformaSeleccionada() == true) {
                  if (_hercules == true) {
                    Dialogs.alert(context,
                        title: 'Acción no permitida',
                        description:
                            'Se requiere una plataforma seleccionada.');
                  } else {
                    Dialogs.confirm(context,
                        title: 'Cambio de Plataforma',
                        description: 'Se suplantarán los datos al sincronizar.',
                        onConfirm: () {
                      Navigator.pop(context);
                      setState(() {
                        if (value == true) {
                          globals.plataformaSeleccionada = 'Hércules';
                          globals.siteId = 'HERC';
                          globals.fechaUltSincro = '---------------';
                          desactivarPlataformas();
                        }
                        _hercules = value;
                      });
                      Navigator.pop(context);
                    });
                  }
                } else {
                  setState(() {
                    if (value == true) {
                      globals.plataformaSeleccionada = 'Hércules';
                      globals.siteId = 'HERC';
                      globals.fechaUltSincro = '---------------';
                      desactivarPlataformas();
                    }
                    _hercules = value;
                  });
                  Navigator.pop(context);
                }
              },
              secondary: iconSelect(_hercules, Icons.anchor_outlined),
            ),
            SwitchListTile(
              title: Text(
                'KM10',
                style: textStyleSelect(_km10),
              ),
              //subtitle: Text(_subtitleKm10),
              value: _km10,
              activeColor: Colors.blue,
              onChanged: (bool value) {
                if (globals.isButtonDisabled) {
                  Dialogs.alert(context,
                      title: 'Acción no permitida',
                      description:
                          'Espere a que finalice el proceso de sincronización.');
                  return;
                }
                if (_existePlataformaSeleccionada() == true) {
                  if (_km10 == true) {
                    Dialogs.alert(context,
                        title: 'Acción no permitida',
                        description:
                            'Se requiere una plataforma seleccionada.');
                  } else {
                    Dialogs.confirm(context,
                        title: 'Cambio de Plataforma',
                        description: 'Se suplantarán los datos al sincronizar.',
                        onConfirm: () {
                      Navigator.pop(context);
                      setState(() {
                        if (value == true) {
                          globals.plataformaSeleccionada = 'KM10';
                          globals.siteId = 'KM10';
                          globals.fechaUltSincro = '---------------';
                          desactivarPlataformas();
                        }
                        _km10 = value;
                      });
                      Navigator.pop(context);
                    });
                  }
                } else {
                  setState(() {
                    if (value == true) {
                      globals.plataformaSeleccionada = 'KM10';
                      globals.siteId = 'KM10';
                      globals.fechaUltSincro = '---------------';
                      desactivarPlataformas();
                    }
                    _km10 = value;
                  });
                  Navigator.pop(context);
                }
              },
              secondary: iconSelect(_km10, Icons.apartment_outlined),
            ),
          ],
        ),
      ),
      barrierColor: Colors.white.withOpacity(0.7),
      pillColor: Colors.grey,
      backgroundColor: Colors.white,
    );
  }
}
