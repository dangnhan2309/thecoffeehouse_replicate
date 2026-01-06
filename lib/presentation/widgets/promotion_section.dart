import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/promotion.dart';
import '../models/product.dart';
import '../data/datasources/remote/api_service.dart';
import '../core/appconfig.dart';
import '../pages/product_detail_page.dart';

class PromotionSection extends StatefulWidget {
  final List<Promotion> promotions;
  final List<Product>? allProducts;

  const PromotionSection({
    super.key,
    required this.promotions,
    this.allProducts,
  });

  @override
  State<PromotionSection> createState() => _PromotionSectionState();
}

class _PromotionSectionState extends State<PromotionSection> {
  final Map<int, List<Product>> promoProducts = {};
  final Map<int, bool> loading = {};
  final Map<int, String?> errors = {};

  @override
  void initState() {
    super.initState();
    if (widget.promotions.isNotEmpty) {
      _loadAllProducts();
    }
  }

  Future<void> _loadAllProducts() async {
    final api = ApiService();
    for (var promo in widget.promotions) {
      if (!mounted) return;

      setState(() {
        loading[promo.id] = true;
        errors[promo.id] = null;
      });

      try {
        List<Product> products = [];
        if (widget.allProducts != null && widget.allProducts!.isNotEmpty) {
          products = widget.allProducts!
              .where((p) => promo.productIds.contains(p.id))
              .toList();
        }

        if (products.isEmpty) {
          final productIds = await api.getProductIdsByPromotion(promo.id);
          if (productIds.isNotEmpty) {
            products = await api.getProductsByIds(productIds);
          }
        }

        if (mounted) {
          setState(() {
            promoProducts[promo.id] = products;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            errors[promo.id] = 'Không tải được sản phẩm khuyến mãi';
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            loading[promo.id] = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.promotions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.promotions.map((promo) {
        final products = promoProducts[promo.id] ?? [];
        final isLoading = loading[promo.id] ?? false;
        final error = errors[promo.id];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header với tên promotion và nút xem thêm
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tên promotion với icon
                    Row(
                      children: [
                        Text(
                          promo.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Countdown timer chuyên nghiệp
              if (promo.startDate != null && promo.endDate != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _buildProfessionalCountdown(promo.startDate!, promo.endDate!),
                ),

              // Carousel sản phẩm
              SizedBox(
                height: 250,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                    : error != null
                    ? Center(
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                    : products.isEmpty
                    ? const Center(
                  child: Text(
                    'Chưa có sản phẩm khuyến mãi',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(products[index], context);
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Countdown timer chuyên nghiệp với thiết kế hiện đại
  Widget _buildProfessionalCountdown(DateTime start, DateTime end) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final isUpcoming = now.isBefore(start);
        final isActive = !isUpcoming && now.isBefore(end);
        final isEnded = now.isAfter(end);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isActive
                  ? [Colors.red.shade50, Colors.orange.shade50]
                  : isUpcoming
                  ? [Colors.blue.shade50, Colors.lightBlue.shade50]
                  : [Colors.grey.shade100, Colors.grey.shade200],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? Colors.red.shade100
                  : isUpcoming
                  ? Colors.blue.shade100
                  : Colors.grey.shade300,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status và label
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.red
                          : isUpcoming
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isActive
                              ? Icons.flash_on
                              : isUpcoming
                              ? Icons.schedule
                              : Icons.notifications_off,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isActive
                              ? 'ĐANG DIỄN RA'
                              : isUpcoming
                              ? 'SẮP DIỄN RA'
                              : 'ĐÃ KẾT THÚC',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.access_time,
                    color: isActive
                        ? Colors.red
                        : isUpcoming
                        ? Colors.blue
                        : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isActive
                        ? 'Kết thúc sau'
                        : isUpcoming
                        ? 'Bắt đầu sau'
                        : 'Đã kết thúc',
                    style: TextStyle(
                      color: isActive
                          ? Colors.red.shade800
                          : isUpcoming
                          ? Colors.blue.shade800
                          : Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Time boxes
              if (!isEnded)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeBox(
                      value: isUpcoming
                          ? start.difference(now).inDays.toString()
                          : end.difference(now).inDays.toString(),
                      label: 'NGÀY',
                      isActive: isActive,
                      isUrgent: isActive && end.difference(now).inHours < 24,
                    ),
                    _buildTimeBox(
                      value: (isUpcoming
                          ? start.difference(now).inHours % 24
                          : end.difference(now).inHours % 24)
                          .toString()
                          .padLeft(2, '0'),
                      label: 'GIỜ',
                      isActive: isActive,
                      isUrgent: isActive && end.difference(now).inHours < 24,
                    ),
                    _buildTimeBox(
                      value: (isUpcoming
                          ? start.difference(now).inMinutes % 60
                          : end.difference(now).inMinutes % 60)
                          .toString()
                          .padLeft(2, '0'),
                      label: 'PHÚT',
                      isActive: isActive,
                      isUrgent: isActive && end.difference(now).inHours < 24,
                    ),
                    _buildTimeBox(
                      value: (isUpcoming
                          ? start.difference(now).inSeconds % 60
                          : end.difference(now).inSeconds % 60)
                          .toString()
                          .padLeft(2, '0'),
                      label: 'GIÂY',
                      isActive: isActive,
                      isUrgent: isActive && end.difference(now).inHours < 1,
                    ),
                  ],
                )
              else
                Center(
                  child: Text(
                    'Chương trình đã kết thúc',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // Progress bar (chỉ hiển thị khi đang diễn ra)
              if (isActive)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thời gian còn lại',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${end.difference(now).inHours.toString().padLeft(2, '0')}:${(end.difference(now).inMinutes % 60).toString().padLeft(2, '0')}:${(end.difference(now).inSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: (end.difference(now).inSeconds / end.difference(start).inSeconds).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        end.difference(now).inHours < 1 ? Colors.red : Colors.orange,
                      ),
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  // Widget cho mỗi ô thời gian
  Widget _buildTimeBox({
    required String value,
    required String label,
    required bool isActive,
    required bool isUrgent,
  }) {
    return Column(
      children: [
        // Box hiển thị số
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isActive
                  ? isUrgent
                  ? [Colors.red, Colors.orange]
                  : [Colors.red.shade400, Colors.orange.shade400]
                  : [Colors.blue.shade400, Colors.lightBlue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? Colors.red.withOpacity(0.3)
                    : Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                value,
                key: ValueKey(value),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'RobotoMono', // Font hiển thị số đẹp hơn
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isActive
                ? isUrgent
                ? Colors.red
                : Colors.red.shade800
                : Colors.blue.shade800,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  // Card sản phẩm với CachedNetworkImage
  Widget _buildProductCard(Product product, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
      ),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: "${AppConfig.baseUrl}/static/${product.imageUrl ?? 'placeholder.jpg'}",
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 130,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 130,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, height: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat.currency(locale: 'vi', symbol: 'đ', decimalDigits: 0).format(product.price ?? product.priceSmall ?? 0),
                      style: const TextStyle(fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã thêm ${product.name} vào giỏ'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6F00),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          minimumSize: const Size(double.infinity, 36),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Thêm vào giỏ',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
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

  @override
  void dispose() => super.dispose();
}