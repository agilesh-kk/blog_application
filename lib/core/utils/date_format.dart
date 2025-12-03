import 'package:intl/intl.dart';

String formatDateddMMMYYYY(DateTime dateTime){
  //eg: 3 Dec, 2025  
  return DateFormat("d MMM, yyyy").format(dateTime);
}