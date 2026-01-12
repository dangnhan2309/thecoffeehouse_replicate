import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/store/domain/usecases/get_stores.dart';
import 'package:nhom2_thecoffeehouse/features/store/store.dart';

class StoreProvider extends ChangeNotifier {
  final GetStoresUseCase loadStoreData;

  StoreProvider({required this.loadStoreData});

  bool isLoading = false;
  String? error;
  List<Store> stores = [];

  Future<void> load() async {
    try {
      isLoading = true;
      notifyListeners();
      stores = await loadStoreData();
      error = null; // reset error khi load thành công
    } catch (e) {
      error = e.toString();
      stores = []; // reset list khi lỗi
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
