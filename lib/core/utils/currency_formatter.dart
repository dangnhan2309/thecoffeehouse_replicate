// decimalDigits: không hiểm thị phần thập phân
// formatVND(15000.75);
// decimalDigits: 0 => 15.001đ
// decimalDigits: 1 => 15.000,8đ
// decimalDigits: 2 => 15.000,75đ
import 'package:intl/intl.dart';
class CurrencyFormatter {
  static String formatVND(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ', // kí hiệu
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

}
