import 'package:intl/intl.dart';

extension DateExtensions on DateTime{
  
  String toRawString(){
    var formattedDate = DateFormat('yyyy-MM-dd').format(this);
    return formattedDate;
  }
}