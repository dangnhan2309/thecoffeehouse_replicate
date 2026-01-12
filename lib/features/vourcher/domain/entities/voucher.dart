class Voucher {
  final int id;
  final String code;
  final String title;
  final String? description;
  final double discountAmount;
  final double minOrderValue;
  final DateTime expiryDate;

  Voucher({
    required this.id,
    required this.code,
    required this.title,
    this.description,
    required this.discountAmount,
    required this.minOrderValue,
    required this.expiryDate,
  });

  /// Logic nghiệp vụ: Kiểm tra điều kiện áp dụng mã
  Map<String, dynamic> checkApplicability(double currentOrderTotal) {
    // 1. Kiểm tra giá trị đơn hàng tối thiểu
    if (currentOrderTotal < minOrderValue) {
      return {
        'isMet': false,
        'error': 'Đơn tối thiểu ${minOrderValue.toInt()}đ'
      };
    }

    // 2. Kiểm tra voucher cuối tuần (WEEKEND10)
    if (code == 'WEEKEND10') {
      final now = DateTime.now();
      final isWeekend = now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
      if (!isWeekend) {
        return {
          'isMet': false,
          'error': 'Chỉ áp dụng vào Thứ 7, Chủ Nhật'
        };
      }
    }

    // 3. Các điều kiện khác có thể thêm ở đây...

    return {'isMet': true, 'error': null};
  }
}
