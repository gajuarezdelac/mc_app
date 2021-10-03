import 'package:intl/intl.dart';

String getCurrentDate() {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss.S');
  String currentDate = formatter.format(now);

  return currentDate;
}
