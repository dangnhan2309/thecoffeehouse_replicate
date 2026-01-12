import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nhom2_thecoffeehouse/features/promotion/presentation/state/promotion_provider.dart';
import 'package:intl/intl.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PromotionProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Ưu đãi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Consumer<PromotionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.promotions.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFF26522)));
          }

          if (provider.error != null && provider.promotions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Lỗi: ${provider.error}'),
                  TextButton(onPressed: () => provider.load(), child: const Text('Thử lại')),
                ],
              ),
            );
          }

          final promotions = provider.promotions;

          if (promotions.isEmpty) {
            return const Center(
              child: Text('Hiện tại không có ưu đãi nào'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: promotions.length,
            itemBuilder: (context, index) {
              final promotion = promotions[index];
              return _buildPromotionCard(promotion);
            },
          );
        },
      ),
    );
  }

  Widget _buildPromotionCard(dynamic promotion) {
    final expiryDate = DateFormat('dd/MM/yyyy').format(promotion.endDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left part (Image/Icon)
            Container(
              width: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7E6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.confirmation_num_outlined,
                  size: 40,
                  color: const Color(0xFFF26522).withOpacity(0.8),
                ),
              ),
            ),
            // Divider (Ticket look)
            const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            // Right part (Content)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      promotion.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hết hạn: $expiryDate',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Áp dụng voucher hoặc xem chi tiết
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF26522),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                        ),
                        child: const Text('Sử dụng', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
