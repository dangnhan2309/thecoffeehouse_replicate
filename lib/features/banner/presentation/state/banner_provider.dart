import 'package:flutter/cupertino.dart';
import 'package:nhom2_thecoffeehouse/features/banner/domain/usecases/get_banner.dart';
import 'package:nhom2_thecoffeehouse/features/banner/domain/entities/banner.dart';

class BannerProvider extends ChangeNotifier {
  final GetBannersUseCase getBannersUseCase;

  BannerProvider({required this.getBannersUseCase});

  List<BannerItem> banners = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadBanners() async {
    isLoading = true;
    notifyListeners();

    try {
      banners = await getBannersUseCase();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      banners = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
