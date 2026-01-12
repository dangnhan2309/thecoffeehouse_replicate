import '../entities/voucher.dart';
import '../repositories/voucher_repository.dart';

class GetVouchersUseCase {
  final VoucherRepository repository;

  GetVouchersUseCase(this.repository);

  Future<List<Voucher>> call() async {
    return await repository.getVouchers();
  }
}
