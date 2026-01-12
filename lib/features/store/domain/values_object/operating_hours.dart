class OperatingHours {
  final int dayOfWeek; // 0: Sunday, 6: Saturday
  final String openTime; // "07:00"
  final String closeTime; // "22:30"
  final bool isClosed;

  OperatingHours({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    this.isClosed = false,
  });
}