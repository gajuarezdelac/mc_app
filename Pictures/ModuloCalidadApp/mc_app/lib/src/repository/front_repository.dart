import 'package:flutter/material.dart';
import 'package:mc_app/src/data/dao/front_dao.dart';

class FrontRepository {
  final frontDao = FrontDao();

  Future getFronts() => frontDao.fetchFronts();

  Future getFrontCS({@required String planDetailId}) =>
      frontDao.fetchFrontCS(planDetailId);
}
