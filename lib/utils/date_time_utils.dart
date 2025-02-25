import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final localDateTime = dateTime.toLocal();
  final difference = now.difference(localDateTime).inDays;

  String dayDescription;
  if (difference == 0) {
    dayDescription = '今日';
  } else if (difference == 1) {
    dayDescription = '昨日';
  } else if (difference == 2) {
    dayDescription = '一昨日';
  } else {
    dayDescription = DateFormat('yyyyMMdd').format(localDateTime);
  }

  final time = DateFormat('HH:mm').format(localDateTime);
  return '$dayDescription $time';
}
