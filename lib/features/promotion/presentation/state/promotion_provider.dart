import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/domain/entities/promotion.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/domain/usecases/get_promotions.dart';

class PromotionProvider extends ChangeNotifier {
  final GetPromotionsUseCase loadPromotionData;

  PromotionProvider({required this.loadPromotionData});

  bool isLoading = false;
  String? error;
  List<Promotion> promotions = [];

  Future<void> load() async {
    try {
      isLoading = true;
      notifyListeners();

      promotions = await loadPromotionData();
      error = null; // reset error khi load thành công
    } catch (e) {
      error = e.toString();
      promotions = []; // reset list khi lỗi
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
