import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final Set<int> _favoriteProductIds = {};

  FavoriteProvider({required this.sharedPreferences}) {
    _loadFavorites();
  }

  Set<int> get favoriteProductIds => _favoriteProductIds;

  void _loadFavorites() {
    final favorites = sharedPreferences.getStringList('favorite_products');
    if (favorites != null) {
      _favoriteProductIds.addAll(favorites.map((e) => int.parse(e)));
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    await sharedPreferences.setStringList(
      'favorite_products',
      _favoriteProductIds.map((e) => e.toString()).toList(),
    );
  }

  bool isFavorite(int productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleFavorite(int productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    _saveFavorites();
    notifyListeners();
  }
}
