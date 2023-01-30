import 'package:intl/intl.dart';

extension StringExtensions on String{
  DateTime toDate(){
    return DateFormat('yyyy-MM-dd').parse(this);
  }
}