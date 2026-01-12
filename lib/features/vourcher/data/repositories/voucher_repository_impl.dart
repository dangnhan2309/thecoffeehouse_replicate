import '../../domain/entities/voucher.dart';
import '../../domain/repositories/voucher_repository.dart';
import '../datasources/remote/voucher_remote_datasource.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  final VoucherRemoteDataSource remoteDataSource;

  VoucherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Voucher>> getVouchers() async {
    return await remoteDataSource.getVouchers();
  }
}
