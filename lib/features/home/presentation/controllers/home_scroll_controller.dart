import 'package:flutter/cupertino.dart';

class HomeScrollController {
  final ScrollController scrollController = ScrollController();

  final Map<int, GlobalKey> categoryKeys = {};

  void registerCategory(int categoryId) {
    categoryKeys[categoryId] = GlobalKey();
  }

  void scrollToCategory(int categoryId) {
    final key = categoryKeys[categoryId];
    if (key == null) return;

    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
