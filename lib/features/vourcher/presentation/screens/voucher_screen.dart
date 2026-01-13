import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/vourcher/presentation/state/vourcher_provider.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';
import 'package:nhom2_thecoffeehouse/features/auth/presentation/state/auth_provider.dart';
import 'package:nhom2_thecoffeehouse/features/auth/presentation/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/voucher.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key, this.isSelectionMode = false});

  final bool isSelectionMode;

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthProvider>().isAuthenticated) {
        context.read<VoucherProvider>().loadVouchers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            title: const Text(
              "Mã ưu đãi",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize:20),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          body: !authProvider.isAuthenticated
              ? _buildLoginPrompt(context)
              : _buildVoucherList(context),
        );
      },
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.confirmation_num_outlined, size: 100, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              'Sử dụng app để tích điểm và đổi những ưu đãi chỉ dành riêng cho thành viên bạn nhé!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF26522),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('ĐĂNG NHẬP NGAY', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherList(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    
    return Consumer<VoucherProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFF26522)));
        }

        if (provider.vouchers.isEmpty) {
          return const Center(child: Text("Hiện tại chưa có ưu đãi nào", style: TextStyle(color: Colors.grey)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.vouchers.length,
          itemBuilder: (context, index) {
            final voucher = provider.vouchers[index];
            // Gọi logic nghiệp vụ từ Entity
            final status = voucher.checkApplicability(orderProvider.selectedTotal);
            
            return _VoucherCard(
              voucher: voucher,
              isMet: status['isMet'],
              errorMsg: status['error'],
              onUse: () {
                orderProvider.applyVoucher(voucher);
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}

class _VoucherCard extends StatelessWidget {
  final Voucher voucher;
  final bool isMet;
  final String? errorMsg;
  final VoidCallback onUse;

  const _VoucherCard({
    required this.voucher,
    required this.isMet,
    this.errorMsg,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7E6),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              ),
              child: const Center(child: Icon(Icons.confirmation_num_outlined, color: Color(0xFFF26522), size: 32)),
            ),
            CustomPaint(size: const Size(1, double.infinity), painter: _DashedLinePainter()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(voucher.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1),
                    const SizedBox(height: 4),
                    Text("Mã: ${voucher.code}", style: const TextStyle(color: Color(0xFFF26522), fontWeight: FontWeight.bold, fontSize: 13)),
                    const Spacer(),
                    if (errorMsg != null) Text(errorMsg!, style: const TextStyle(color: Colors.red, fontSize: 11)),
                    Text("Hết hạn: ${DateFormat('dd/MM/yyyy').format(voucher.expiryDate)}", style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: ElevatedButton(
                  onPressed: isMet ? onUse : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF26522),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    minimumSize: const Size(60, 32),
                    elevation: 0,
                  ),
                  child: const Text("Dùng", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()..color = Colors.grey[300]!..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
