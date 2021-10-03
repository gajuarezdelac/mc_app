import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mc_app/src/bloc/blocs.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_partidaPU/dropdown_partidaPU_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_partidaPU/dropdown_partidaPU_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_partidaPU/dropdown_partidaPU_state.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_reprogramation/dropdown_reprogramation_bloc.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_reprogramation/dropdown_reprogramation_event.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_reprogramation/dropdown_reprogramation_state.dart';
import 'package:mc_app/src/bloc/dropdown_activities/dropdown_status/dropdown_status_bloc.dart';
import 'package:mc_app/src/models/activities_dropdown_model.dart';
import 'package:mc_app/src/models/activities_table_model.dart';
import 'package:mc_app/src/models/internal_departure_model.dart';
import 'package:mc_app/src/models/params/welding_control_detail_params.dart';
import 'package:mc_app/src/utils/responsive.dart';
import 'package:mc_app/src/widgets/loading_circular.dart';
import 'package:mc_app/src/widgets/table_initial.dart';
import 'package:mc_app/src/widgets/text_field_widget.dart';

class ActivitiesPage extends StatefulWidget {
  final WeldingControlDetailParams params;
  static String id = "Actividades de la junta";

  ActivitiesPage({Key key, @required this.params}) : super(key: key);

  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  DateTime _del;
  DateTime _al;
  String _status;
  String _anexo;
  String _partidaPU;
  int _folioId;
  String _reprogramacion;
  String _especialidad;
  String _sistema;
  String _planoSubactividad;
  String _primaveraId;
  String _actividadCliente;
  String _partidaInterna;
  DTSActividades dtsActividades;
  bool botonDisabled = false;
  DropDownPartidaPUBloc _dropDownPartidaPUBloc;
  DropDownFolioBloc _dropDownFolioBloc;
  DropDownSpecialityBloc _dropDownSpecialityBloc;
  DropDownSystemBloc _dropDownSystemBloc;
  DropDownPlaneSubactivityBloc _dropDownPlaneSubactivityBloc;
  DropDownPrimaveraIdBloc _dropDownPrimaveraIdBloc;
  DropDownClientActivityBloc _dropDownClientActivityBloc;
  DropDownReprogramationBloc _dropDownReprogramationBloc;
  TableActivityBloc _activityBloc;
  InternalDepartureBloc _internalDepartureBloc;
  // ignore: close_sinks
  RelateJointBloc _relateJointBloc;
  // ignore: close_sinks
  InitialDataJointBloc _initialDataJoint;

  FolioDropdownModel _folio;
  InternalDepartureModel _partida;
  ReprogramacionModel _reprogramacionModel;
  EspecialidadModel _especialidadModel;
  SistemaModel _sistemaModel;
  PlanoSubActividadModel _planoSubActividadModel;
  AnexoModel _anexoModel;
  PartidaPUModel _partidaPUModel;
  ActividadClienteModel _actividadClienteModel;
  PrimaveraIdModel _primaveraIdModel;
  EstatusIdModel _estatusIdModel;

  final formKey = new GlobalKey<FormState>();
  String site = '';

  @override
  void initState() {
    super.initState();
    initialData();
  }

  void initialData() {
    _dropDownFolioBloc = BlocProvider.of<DropDownFolioBloc>(context);
    _dropDownPartidaPUBloc = BlocProvider.of<DropDownPartidaPUBloc>(context);
    _dropDownSpecialityBloc = BlocProvider.of<DropDownSpecialityBloc>(context);
    _dropDownSystemBloc = BlocProvider.of<DropDownSystemBloc>(context);
    _dropDownPlaneSubactivityBloc =
        BlocProvider.of<DropDownPlaneSubactivityBloc>(context);
    _dropDownPrimaveraIdBloc =
        BlocProvider.of<DropDownPrimaveraIdBloc>(context);
    _dropDownClientActivityBloc =
        BlocProvider.of<DropDownClientActivityBloc>(context);
    _dropDownReprogramationBloc =
        BlocProvider.of<DropDownReprogramationBloc>(context);
    _internalDepartureBloc = BlocProvider.of<InternalDepartureBloc>(context);
    _relateJointBloc = BlocProvider.of<RelateJointBloc>(context);
    _initialDataJoint = BlocProvider.of<InitialDataJointBloc>(context);

    _dropDownPrimaveraIdBloc =
        BlocProvider.of<DropDownPrimaveraIdBloc>(context);
    _dropDownFolioBloc.add(GetFolio(
      contractId: widget.params.contractSelection,
      obraId: widget.params.workSelection,
      site: widget.params.joint.siteId == "HUB"
          ? 'KM10'
          : widget.params.joint.siteId,
    ));
    _dropDownReprogramationBloc
        .add(GetReprogramation(workId: widget.params.workSelection));
    _internalDepartureBloc.add(GetInternalDeparture(
      siteId: widget.params.joint.siteId == "HUB"
          ? 'KM10'
          : widget.params.joint.siteId,
      contractId: widget.params.contractSelection,
      workId: widget.params.workSelection,
    ));

    _dropDownPrimaveraIdBloc.add(GetPrimaveraId(
        contractId: widget.params.contractSelection,
        obraId: widget.params.workSelection));
  }

  // BuildContext
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Actividades de la junta'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _del = null;
                  _al = null;
                  _status = null;
                  _anexo = null;
                  _partidaPU = null;
                  _folioId = null;
                  _reprogramacion = null;
                  _especialidad = null;
                  _sistema = null;
                  _planoSubactividad = null;
                  _primaveraId = null;
                  _actividadCliente = null;
                  _partidaInterna = null;

                  _folio = null;
                  _partida = null;
                  _reprogramacionModel = null;
                  _especialidadModel = null;
                  _sistemaModel = null;
                  _planoSubActividadModel = null;
                  _anexoModel = null;
                  _partidaPUModel = null;
                  _actividadClienteModel = null;
                  _primaveraIdModel = null;
                  _estatusIdModel = null;
                });
              },
              icon: Icon(
                Icons.cleaning_services_outlined,
                color: Colors.white,
                size: 34,
              ),
              tooltip: 'Salir',
            ),
          )
        ],
      ),
      body: GestureDetector(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            width: double.infinity,
            height: responsive.height,
            child: Form(
              key: formKey,
              child: Container(
                //height: 825,
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: TextFieldWidget(
                            label:
                                '${widget.params.contract.contratoId}-${widget.params.contract.nombre}',
                            habilitado: false,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFieldWidget(
                            label:
                                '${widget.params.work.oT}-(${widget.params.work.nombre})',
                            habilitado: false,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFieldWidget(
                            label: '${widget.params.front.descripcion}',
                            habilitado: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: BlocBuilder<DropDownFolioBloc,
                                DropDownFolioState>(
                              builder: (context, state) {
                                if (state is SuccessFolio) {
                                  return DropdownSearch<FolioDropdownModel>(
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Campo requerido';
                                      }
                                      return null;
                                    },
                                    showSearchBox: true,
                                    itemAsString: (FolioDropdownModel u) =>
                                        u.folio,
                                    mode: Mode.MENU,
                                    hint: 'Seleccione un folio',
                                    label: 'Folio *',
                                    items: state.folioModel,
                                    selectedItem: _folio,
                                    onChanged: (obj) {
                                      setState(() {
                                        _folio = obj;
                                        _folioId = obj.folioId;

                                        botonDisabled = true;
                                      });
                                      _dropDownPartidaPUBloc.add(GetPartidaPU(
                                          contractId:
                                              widget.params.contractSelection));
                                      _dropDownSpecialityBloc.add(GetSpeciality(
                                          contractId:
                                              widget.params.contractSelection,
                                          folioId: _folioId));
                                      _dropDownSystemBloc.add(GetSystem(
                                          contractId:
                                              widget.params.contractSelection,
                                          folioId: _folioId));
                                      _dropDownPlaneSubactivityBloc.add(
                                          GetPlaneSubactivity(
                                              contractId: widget
                                                  .params.contractSelection,
                                              folioId: _folioId));
                                    },
                                  );
                                } else if (state is ErrorFolio) {
                                  return _dropDownSearchError(
                                      'Folio', 'Folio fallido', state.message);
                                } else if (state is InitialDropDownFolioState) {
                                  return _dropDownSearchError(
                                    'Folio',
                                    'Seleccione un folio',
                                    '',
                                  );
                                }
                                return _dropDownSearchError(
                                  'Folio',
                                  'Cargando...',
                                  'Cargando...',
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: BlocBuilder<InternalDepartureBloc,
                                InternalDepartureState>(
                              builder: (context, state) {
                                if (state is SuccessInternalDeparture) {
                                  return DropdownSearch<InternalDepartureModel>(
                                    showSearchBox: true,
                                    itemAsString: (InternalDepartureModel u) =>
                                        u.partidaInterna,
                                    mode: Mode.MENU,
                                    hint: 'Seleccione una Partida',
                                    label: 'Partida Interna',
                                    items: state.internalDepartureModel,
                                    selectedItem: _partida,
                                    onChanged: (obj) {
                                      setState(() {
                                        _partida = obj;
                                        _partidaInterna = obj.partidaInterna;
                                      });
                                    },
                                  );
                                } else if (state is ErrorInternalDeparture) {
                                  return _dropDownSearchError(
                                    'Partida',
                                    'Seleccione una Partida',
                                    state.message,
                                  );
                                } else if (state
                                    is InitialInternalDepartureState) {
                                  return _dropDownSearchError(
                                    'Partida',
                                    'Seleccione una Partida',
                                    '',
                                  );
                                }
                                return _dropDownSearchError(
                                  'Partida',
                                  'Cargando...',
                                  'Cargando...',
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: BlocBuilder<DropDownReprogramationBloc,
                                DropDownReprogramationState>(
                              builder: (context, state) {
                                if (state is SuccessReprogramation) {
                                  return DropdownSearch<ReprogramacionModel>(
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Campo requerido';
                                      }
                                      return null;
                                    },
                                    showSearchBox: true,
                                    itemAsString: (ReprogramacionModel u) =>
                                        u.value,
                                    mode: Mode.MENU,
                                    hint: 'Seleccione una Reprogramación',
                                    label: 'Reprogramación *',
                                    items: state.reprogramationModel,
                                    selectedItem: _reprogramacionModel,
                                    onChanged: (obj) {
                                      setState(() {
                                        _reprogramacionModel = obj;
                                        _reprogramacion = obj.value;
                                      });
                                      _dropDownClientActivityBloc.add(
                                          GetClienActivity(
                                              contractId: widget
                                                  .params.contractSelection,
                                              workId:
                                                  widget.params.workSelection));
                                    },
                                  );
                                } else if (state is ErrorReprogramation) {
                                  return _dropDownSearchError(
                                    'Reprogramación',
                                    'Seleccione una Reprogramación',
                                    state.message,
                                  );
                                } else if (state
                                    is InitialDropDownReprogramationState) {
                                  return _dropDownSearchError(
                                    'Reprogramación',
                                    'Seleccione una Reprogramación',
                                    '',
                                  );
                                }
                                return _dropDownSearchError(
                                  'Reprogramación',
                                  'Cargando...',
                                  'Cargando...',
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: BlocBuilder<DropDownSpecialityBloc,
                                DropDownSpecialtyState>(
                              builder: (context, state) {
                                if (state is SuccessSpecialty) {
                                  return DropdownSearch<EspecialidadModel>(
                                    showSearchBox: true,
                                    itemAsString: (EspecialidadModel u) =>
                                        u.value,
                                    mode: Mode.MENU,
                                    hint: 'Seleccione una Especialidad',
                                    label: 'Especialidad',
                                    items: state.specialtyModel,
                                    selectedItem: _especialidadModel,
                                    onChanged: (obj) {
                                      setState(() {
                                        _especialidad = obj.value;
                                      });
                                      if (botonDisabled) {
                                        setState(() {
                                          _especialidadModel = obj;
                                          _especialidad = obj.value;
                                        });
                                      }
                                    },
                                  );
                                } else if (state is ErrorSpecialty) {
                                  return _dropDownSearchError(
                                    'Especialidad',
                                    'Error!!',
                                    state.message,
                                  );
                                } else if (state
                                    is InitialDropDownspecialtyState) {
                                  return _dropDownSearchError(
                                    'Especialidad',
                                    'Seleccione una Especialidad',
                                    '',
                                  );
                                }

                                return _dropDownSearchError(
                                  'Especialidad',
                                  'Cargando...',
                                  'Cargando...',
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: BlocBuilder<DropDownSystemBloc,
                                DropDownSystemState>(
                              builder: (context, state) {
                                if (state is SuccessSystem) {
                                  return DropdownSearch<SistemaModel>(
                                    showSearchBox: true,
                                    itemAsString: (SistemaModel u) => u.value,
                                    mode: Mode.MENU,
                                    hint: 'Seleccione un sistema',
                                    label: 'Sistema',
                                    items: state.systemModel,
                                    selectedItem: _sistemaModel,
                                    onChanged: (obj) {
                                      setState(() {
                                        _sistemaModel = obj;
                                      });
                                      if (botonDisabled) {
                                        _sistemaModel = obj;
                                        _sistema = obj.value;
                                      }
                                    },
                                  );
                                } else if (state is ErrorWorks) {
                                  return _dropDownSearchError(
                                    'Sistema',
                                    'Seleccione un Sistema',
                                    state.message,
                                  );
                                } else if (state is InitialDropDownWorkState) {
                                  return _dropDownSearchError(
                                    'Sistema',
                                    'Seleccione una Sistema',
                                    '',
                                  );
                                }

                                return _dropDownSearchError(
                                  'Sistema',
                                  'Seleccione una Sistema',
                                  '',
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: BlocBuilder<DropDownPlaneSubactivityBloc,
                                DropDownPlaneSubactivityState>(
                              builder: (context, state) {
                                if (state is SuccessPlaneSubactivity) {
                                  return DropdownSearch<PlanoSubActividadModel>(
                                    showSearchBox: true,
                                    itemAsString: (PlanoSubActividadModel u) =>
                                        u.value,
                                    mode: Mode.MENU,
                                    hint: 'Seleccione un Planosubactividad',
                                    label: 'Plano Subactividad',
                                    items: state.planeSubactivityModel,
                                    selectedItem: _planoSubActividadModel,
                                    onChanged: (obj) {
                                      setState(() {
                                        _planoSubActividadModel = obj;
                                        _planoSubactividad = obj.value;
                                      });
                                    },
                                  );
                                } else if (state is ErrorPlaneSubactivity) {
                                  return _dropDownSearchError(
                                    'Plano subactividad',
                                    'Seleccione un Planosubactividad',
                                    state.message,
                                  );
                                } else if (state
                                    is InitialDropDownPlaneSubactivityState) {
                                  return _dropDownSearchError(
                                    'Plano subactividad',
                                    'Seleccione un Planosubactividad',
                                    '',
                                  );
                                }
                                return _dropDownSearchError(
                                  'Plano subactividad',
                                  'Seleccione un Planosubactividad',
                                  '',
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: BlocBuilder<DropDownAnexoBloc,
                                DropDownAnexoState>(
                              builder: (context, state) {
                                if (state is SuccessAnexo) {
                                  return DropdownSearch<AnexoModel>(
                                    showSearchBox: true,
                                    itemAsString: (AnexoModel u) => u.anexo,
                                    mode: Mode.MENU,
                                    hint: 'Seleccione un Anexo',
                                    label: 'Anexo',
                                    items: state.anexo,
                                    selectedItem: _anexoModel,
                                    onChanged: (obj) {
                                      setState(() {
                                        _anexo = obj.anexo;
                                        _anexoModel = obj;
                                      });
                                    },
                                  );
                                } else if (state is ErrorAnexo) {
                                  return _dropDownSearchError(
                                    'Anexo',
                                    'Seleccione un Anexo',
                                    state.message,
                                  );
                                } else if (state is InitialDropDownAnexoState) {
                                  return _dropDownSearchError(
                                    'Anexo',
                                    'Seleccione un Anexo',
                                    '',
                                  );
                                }
                                return _dropDownSearchError(
                                  'Anexo',
                                  'Cargando...',
                                  'Cargando...',
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: BlocBuilder<DropDownPartidaPUBloc,
                                DropDownPartidaPUState>(
                              builder: (context, state) {
                                if (state is SuccessPartidaPU) {
                                  return DropdownSearch<PartidaPUModel>(
                                    showSearchBox: true,
                                    itemAsString: (PartidaPUModel u) =>
                                        u.partidaPU,
                                    mode: Mode.MENU,
                                    hint: 'Seleccione una partida PU',
                                    label: 'Partida PU',
                                    items: state.partidaPU,
                                    selectedItem: _partidaPUModel,
                                    onChanged: (obj) {
                                      setState(() {
                                        _partidaPUModel = obj;
                                        _partidaPU = obj.partidaPU;
                                      });
                                    },
                                  );
                                } else if (state is ErrorPartidaPU) {
                                  return _dropDownSearchError(
                                    'partida PU',
                                    'Seleccione una partidaPU',
                                    state.message,
                                  );
                                } else if (state is InitialDropDownWorkState) {
                                  return _dropDownSearchError(
                                    'Partida PU',
                                    'Seleccione una partidaPU',
                                    '',
                                  );
                                }

                                return _dropDownSearchError(
                                  'Partida PU',
                                  'Cargando...',
                                  'Cargando...',
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: BlocBuilder<DropDownClientActivityBloc,
                                DropDownClientActivityState>(
                              builder: (context, state) {
                                if (state is SuccessClientActivity) {
                                  return DropdownSearch<ActividadClienteModel>(
                                    showSearchBox: true,
                                    itemAsString: (ActividadClienteModel u) =>
                                        u.actividadCliente,
                                    mode: Mode.MENU,
                                    hint: 'Seleccione una Actividad Cliente',
                                    label: 'Actividad Cliente',
                                    items: state.activityClientModel,
                                    selectedItem: _actividadClienteModel,
                                    onChanged: (obj) {
                                      setState(() {
                                        _actividadClienteModel = obj;
                                        _actividadCliente =
                                            obj.actividadCliente;
                                      });
                                    },
                                  );
                                } else if (state is ErrorClientActivity) {
                                  return _dropDownSearchError(
                                    'Actividad Cliente',
                                    'Seleccione una Actividad Cliente',
                                    state.message,
                                  );
                                } else if (state
                                    is InitialDropDownClientActivityState) {
                                  return _dropDownSearchError(
                                    'Actividad Cliente',
                                    'Seleccione una Actividad Cliente',
                                    '',
                                  );
                                }
                                return _dropDownSearchError(
                                  'Actividad Cliente',
                                  'Cargando...',
                                  'Cargando...',
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: BlocBuilder<DropDownPrimaveraIdBloc,
                                DropDownPrimaveIdState>(
                              builder: (context, state) {
                                if (state is SuccessPrimaveraId) {
                                  return DropdownSearch<PrimaveraIdModel>(
                                    showSearchBox: true,
                                    itemAsString: (PrimaveraIdModel u) =>
                                        u.primaveraId,
                                    mode: Mode.MENU,
                                    hint: 'Seleccione un Primavera Id',
                                    label: 'Primavera Id',
                                    items: state.primaveraModel,
                                    selectedItem: _primaveraIdModel,
                                    onChanged: (obj) {
                                      _primaveraIdModel = obj;
                                      _primaveraId = obj.primaveraId;
                                    },
                                  );
                                } else if (state is ErrorPrimaveraId) {
                                  return _dropDownSearchError(
                                    'PrimaveraId',
                                    'Seleccione un PrimaveraId',
                                    state.message,
                                  );
                                } else if (state
                                    is InitialDropDownPrimaveraIdState) {
                                  return _dropDownSearchError(
                                    'PrimaveraId',
                                    'Seleccione un PrimaveraId',
                                    '',
                                  );
                                }
                                return _dropDownSearchError(
                                  'PrimaveraId',
                                  'Cargando...',
                                  'Cargando...',
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: BlocBuilder<DropDownStatusBloc,
                              DropDownStatusState>(
                            builder: (context, state) {
                              if (state is SuccessStatus) {
                                return DropdownSearch<EstatusIdModel>(
                                  showSearchBox: true,
                                  itemAsString: (EstatusIdModel u) =>
                                      u.descripcionCorta,
                                  mode: Mode.MENU,
                                  hint: 'Seleccione un Estatus',
                                  label: 'Estatus',
                                  items: state.estatus,
                                  selectedItem: _estatusIdModel,
                                  onChanged: (obj) {
                                    setState(() {
                                      _estatusIdModel = obj;
                                      _status = obj.descripcionCorta;
                                    });
                                  },
                                );
                              } else if (state is ErrorStatus) {
                                return _dropDownSearchError(
                                  'Estatus',
                                  'Error con el estatus',
                                  state.message,
                                );
                              } else if (state is InitialDropDownWorkState) {
                                return _dropDownSearchError(
                                  'Estatus',
                                  'Seleccione un Estatus',
                                  '',
                                );
                              }
                              return _dropDownSearchError(
                                'Estatus',
                                'Cargando...',
                                'Cargando...',
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(14, 161, 240, .7),
                            padding: EdgeInsets.fromLTRB(30, 20, 40, 15),
                          ),
                          label: Text(
                            _del == null
                                ? 'Del'
                                : _del.toString().substring(0, 11),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate:
                                        _del == null ? DateTime.now() : _del,
                                    firstDate: DateTime(2001),
                                    lastDate: DateTime(2022))
                                .then((date) {
                              setState(() {
                                _del = date;
                              });
                            });
                          },
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: Icon(Icons.calendar_today),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(255, 99, 71, .7),
                            padding: EdgeInsets.fromLTRB(30, 20, 40, 15),
                          ),
                          label: Text(
                            _al == null
                                ? 'Al'
                                : _al.toString().substring(0, 11),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate:
                                        _al == null ? DateTime.now() : _al,
                                    firstDate: DateTime(2001),
                                    lastDate: DateTime(2022))
                                .then((date) {
                              setState(() {
                                _al = date;
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Divider(
                      thickness: 2.0,
                      color: Colors.black12,
                    ),
                    SingleChildScrollView(),
                    BlocBuilder<TableActivityBloc, ActivitiesTableState>(
                      builder: (context, state) {
                        if (state is SuccessTableActivity) {
                          dtsActividades = DTSActividades(
                              state.activitiesTableModel,
                              context,
                              _relateJointBloc,
                              widget.params,
                              _initialDataJoint);
                          return PaginatedDataTable(
                            rowsPerPage: 10,
                            showCheckboxColumn: false,
                            header: Text('Actividades'),
                            source: dtsActividades ?? [],
                            columns: [
                              DataColumn(
                                  label: Text('SiteId',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('PropuestaTecnicaId',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('ActividadId',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('SubActividadId',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Anexo',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Partida',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('PrimaveraId',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('NoActividadCliente',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Folio',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Reprogramacion',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Plano Subactividad',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Descripción',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Especialidad',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Sistema',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Frente',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('fecha Inicio',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('fecha Fin',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Estatus',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ],
                          );
                        } else if (state is IsLoadingTableActivity) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                  child: Center(
                                    child: loadingCircular(),
                                  )),
                            ],
                          );
                        } else if (state is ErrorTableActivity) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child:
                                      Text('Parece que ha ocurrido un error')),
                            ],
                          );
                        }
                        return TableInitial();
                      },
                    ),
                    SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: new Icon(Icons.search),
        isExtended: true,
        backgroundColor: Color.fromRGBO(3, 157, 252, .9),
        onPressed: () {
          final form = formKey.currentState;
          if (form.validate()) {
            _activityBloc = BlocProvider.of<TableActivityBloc>(context);
            _activityBloc.add(GetTableActivity(
              contractId: widget.params.contractSelection.toString() ?? null,
              folioId: widget.params.work.oT ?? null,
              obraId: widget.params.workSelection.toString() ?? null,
              reprogramacionOT: _reprogramacion ?? null,
              especialidad: _especialidad == null ? '' : _especialidad,
              sistema: _sistema == null ? '' : _sistema,
              frenteId: widget.params.frontSelection,
              plano: _planoSubactividad == null ? '' : _planoSubactividad,
              anexo: _anexo == null ? '' : _anexo,
              partidaPU: _partidaPU == null ? '' : _partidaPU,
              primaveraId: _primaveraId == null ? '' : _primaveraId,
              noActividadCliente:
                  _actividadCliente == null ? '' : _actividadCliente,
              estatusId: _status == null ? '' : _status,
              fechaInicio: _del == null ? '' : _del.toString(),
              fechaFin: _al == null ? '' : _al.toString(),
              partidaFilter: _partidaInterna == null ? '' : _partidaInterna,
            ));
          }
        },
      ),
    );
  }

  Widget _dropDownSearchError(String title, String hintTitle, String message) {
    return DropdownSearch<String>(
        mode: Mode.MENU,
        hint: hintTitle,
        label: title,
        items: message == "" ? [] : [message]);
  }
}

class DTSActividades extends DataTableSource {
  final List<ActivitiesTableModel> _list;
  BuildContext context;
  RelateJointBloc _relateJointBloc;
  WeldingControlDetailParams _params;
  InitialDataJointBloc _initialDataJoint;

  DTSActividades(this._list, this.context, this._relateJointBloc, this._params,
      this._initialDataJoint);

  @override
  DataRow getRow(int index) {
    final element = _list[index];

    return DataRow.byIndex(
      selected: element.selected,
      onSelectChanged: (bool selected) {
        element.selected = selected;
        showAlertDialog(context, element.actividadCliente, _params, element);
        element.selected = false;
        notifyListeners();
      },
      index: index,
      cells: <DataCell>[
        DataCell(Text(element.siteId)), //Extracting from Map element the value
        DataCell(Text(element.propuestaTecnicaId == null
            ? 'Sin propuesta'
            : element.propuestaTecnicaId.toInt().toString())),
        DataCell(Text(element.actividadId.toInt().toString())),
        DataCell(Text(element.subActividadId.toInt().toString())),
        DataCell(Text(element.anexo)),
        DataCell(Text(element.partida ?? 'Sin partida')),
        DataCell(Text(element.idPrimavera)),
        DataCell(Text(element.actividadCliente)),
        DataCell(Text(element.folio)),
        DataCell(Text(element.reprogramacion)),
        DataCell(Text(element.planoSubactividad)),
        DataCell(Text(
            element.propuestaTecnicaActividadesH.toString().substring(0, 20))),
        DataCell(Text(element.especialidad)),
        DataCell(Text(element.sistema)),
        DataCell(Text(element.frente)),
        DataCell(Text(element.fechaInicio)),
        DataCell(Text(element.fechaFin)),
        DataCell(Text(element.estatus)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _list.length ?? 0;

  @override
  int get selectedRowCount => 0;

  showAlertDialog(BuildContext context, text, WeldingControlDetailParams params,
      ActivitiesTableModel element) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Atras",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.red,
      ),
    );
    Widget continueButton = TextButton(
      child: Text(
        "Continuar",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        _relateJointBloc.add(PutRelateJoint(
          siteId: params.joint.siteId == 'HUB' ? 'KM10' : params.joint.siteId,
          propuestaTecnicaId: element.propuestaTecnicaId,
          actividadId: element.actividadId,
          subActividadId: element.subActividadId,
          juntaId: params.joint.juntaId,
        ));
        Navigator.pop(context);
        _initialDataJoint
            .add(GetInitialDataJoint(juntaId: params.joint.juntaId));
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
      ),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Actividad $text"),
      content: Text("Estas seguro que deseas seleccionar la actividad $text?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
