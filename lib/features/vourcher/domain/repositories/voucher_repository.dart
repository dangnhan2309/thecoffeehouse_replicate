import '../entities/voucher.dart';

abstract class VoucherRepository {
  Future<List<Voucher>> getVouchers();
}
