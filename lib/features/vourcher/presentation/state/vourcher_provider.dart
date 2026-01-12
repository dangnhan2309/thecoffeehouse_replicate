import 'package:flutter/material.dart';
import '../../domain/entities/voucher.dart';
import '../../domain/usecases/get_vouchers.dart';

class VoucherProvider extends ChangeNotifier {
  final GetVouchersUseCase getVouchersUseCase;

  VoucherProvider({required this.getVouchersUseCase});

  List<Voucher> _vouchers = [];
  bool _isLoading = false;
  String? _error;

  List<Voucher> get vouchers => _vouchers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadVouchers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _vouchers = await getVouchersUseCase();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
