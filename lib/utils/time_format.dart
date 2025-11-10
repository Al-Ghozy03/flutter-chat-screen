import 'package:intl/intl.dart';

String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();

  final isToday = timestamp.year == now.year &&
      timestamp.month == now.month &&
      timestamp.day == now.day;

  if (isToday) {
    return DateFormat.Hm().format(timestamp);
  } else {
    return DateFormat('dd MMM').format(timestamp);
  }
}
