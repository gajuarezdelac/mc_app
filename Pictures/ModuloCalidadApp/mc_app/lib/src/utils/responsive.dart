import 'package:flutter/material.dart';
import 'dart:math' as math;

class Responsive {
  double _width, _height, _diagonal; // ancho del dispositivo

  double get width => _width; // Obtiene el ancho total
  double get height => _height; // Obtiene el alto total
  double get diagonal => _diagonal; // Obtiene la diagonal total

  static Responsive of(BuildContext context) => Responsive(context);

  Responsive(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    this._width = size.width;
    this._height = size.height;

    // Obtenemos la diagonal de una pantalla completa
    this._diagonal = math.sqrt(math.pow(_width, 2) + math.pow(_height, 2));
    // c2 = a2 + b2 => C = Raiz(a2+b2);
  }

  // Porcentajes del ancho, altura y diagonal
  double wp(double porcent) => _width * porcent / 100;
  double hp(double porcent) => _height * porcent / 100;
  double dp(double porcent) => _diagonal * porcent / 100;
}
