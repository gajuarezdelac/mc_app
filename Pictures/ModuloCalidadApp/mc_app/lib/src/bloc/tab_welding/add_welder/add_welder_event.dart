import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mc_app/src/models/params/add_card_welder_not_valid_params.dart';
import 'package:mc_app/src/models/params/add_card_welder_params.dart';

@immutable
abstract class AddWelderEvent extends Equatable {
  final AddCardWelderParams addCardWelder;
  final AddCardWelderNotValidParams addCardWelderNotValidParams;
  // final Final String id;

  AddWelderEvent({this.addCardWelder, this.addCardWelderNotValidParams});

  @override
  List<Object> get props => [];
}

// Añade un soldador con WPS valido
class AddWelderWPSValid extends AddWelderEvent {
  AddWelderWPSValid({@required AddCardWelderParams addCardWelder})
      : super(addCardWelder: addCardWelder);
}

// Añade un soldador con WPS no valido
class AddWelderWPSNotValid extends AddWelderEvent {
  AddWelderWPSNotValid(
      {@required AddCardWelderNotValidParams addCardWelderNotValidParams})
      : super(addCardWelderNotValidParams: addCardWelderNotValidParams);
}
