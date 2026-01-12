import 'package:nhom2_thecoffeehouse/features/store/domain/values_object/operating_hours.dart';
import 'package:nhom2_thecoffeehouse/features/store/domain/values_object/store_location.dart';


class StoreEntity {
  final String id;
  final String name;
  final String code;
  final String addressLine;
  final String district;
  final String city;
  final String phoneNumber;
  final StoreLocation location;
  final List<OperatingHours> operatingHours;
  final List<String> images;
  final List<String> amenities;
  final bool isActive;

  StoreEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.addressLine,
    required this.district,
    required this.city,
    required this.phoneNumber,
    required this.location,
    required this.operatingHours,
    required this.images,
    required this.amenities,
    this.isActive = true,
  });

  // Business Logic: Kiểm tra cửa hàng có đang mở cửa hay không
  bool isOpenNow() {
    final now = DateTime.now();
    final today = now.weekday == 7 ? 0 : now.weekday; // Chuyển đổi weekday của Dart sang 0-6

    final todayHours = operatingHours.firstWhere(
          (h) => h.dayOfWeek == today,
      orElse: () => OperatingHours(dayOfWeek: today, openTime: "00:00", closeTime: "00:00", isClosed: true),
    );

    if (todayHours.isClosed) return false;

    // Logic so sánh giờ (đơn giản hóa)
    final currentTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    return currentTime.compareTo(todayHours.openTime) >= 0 &&
        currentTime.compareTo(todayHours.closeTime) <= 0;
  }

  // Business Logic: Lấy địa chỉ đầy đủ
  String get fullAddress => "$addressLine, $district, $city";
}