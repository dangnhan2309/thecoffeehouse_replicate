import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/store/domain/entities/store.dart';
import 'package:nhom2_thecoffeehouse/features/store/domain/usecases/get_nearest_stores.dart';
import 'package:nhom2_thecoffeehouse/features/store/domain/usecases/get_stores.dart';
import 'package:nhom2_thecoffeehouse/features/store/domain/usecases/get_stores_by_city.dart';
import 'package:flutter/material.dart';

class StoreProvider extends ChangeNotifier {
  final GetStoresUseCase getStoresUseCase;
  final GetStoresByCityUseCase getStoresByCityUseCase;
  final GetNearestStoresUseCase getNearestStoresUseCase;

  StoreProvider({
    required this.getStoresUseCase,
    required this.getStoresByCityUseCase,
    required this.getNearestStoresUseCase,
  });

  List<Store> stores = [];
  bool isLoading = false;
  CityEnum _selectedCity = CityEnum.hcm;

  CityEnum get selectedCity => _selectedCity;



  Future<void> loadStores() async {
    isLoading = true;
    notifyListeners();

    stores = await getStoresUseCase();

    isLoading = false;
    notifyListeners();
  }


  Future<void> loadNearestStores(double lat, double lng) async {
    isLoading = true;
    notifyListeners();

    stores = await getNearestStoresUseCase(lat, lng);

    isLoading = false;
    notifyListeners();
  }

  Future<void> selectCity(CityEnum city) async {
    if (_selectedCity == city) return;

    _selectedCity = city;
    notifyListeners(); // ✅ update dropdown UI

    await loadStoresByCity(); // ✅ fetch lại data
  }

  Future<void> loadStoresByCity() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await getStoresByCityUseCase(_selectedCity);

      stores = result; // ✅ THAY LIST
    } catch (e) {
      debugPrint('Load store error: $e');
    }

    isLoading = false;
    notifyListeners(); // ✅ QUAN TRỌNG
  }
}
