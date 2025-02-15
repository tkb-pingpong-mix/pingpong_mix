import 'package:logger/logger.dart';

class LogUtil {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  static void d(String message, {String tag = 'DEBUG'}) {
    _logger.d("[$tag] $message");
  }

  static void e(String message, {String tag = 'ERROR', dynamic error, StackTrace? stackTrace}) {
    _logger.e("[$tag] $message", error: error, stackTrace: stackTrace);
  }
}
