import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';

extension CityEnumExtension on CityEnum {
  String get apiValue {
    switch (this) {
      case CityEnum.hcm:
        return 'HCM';
      case CityEnum.hn:
        return 'HN';
      case CityEnum.dn:
        return 'DN';
    }
  }

  String get displayName {
    switch (this) {
      case CityEnum.hcm:
        return 'TP. Hồ Chí Minh';
      case CityEnum.hn:
        return 'Hà Nội';
      case CityEnum.dn:
        return 'Đà Nẵng';
    }
  }
}