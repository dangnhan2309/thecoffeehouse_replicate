import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/data/datasources/remote/api_service.dart';
import 'package:nhom2_thecoffeehouse/core/appconfig.dart';
import '../models/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  SizeOption selectedSize = SizeOption.medium;
  IceOption selectedIce = IceOption.normal;
  SugarOption selectedSugar = SugarOption.normal;
  int quantity = 1;
  List<Product> toppings = [];
  List<int> selectedToppingIds = [];
  final api = ApiService();

  // Combo
  Product? selectedComboDrink;
  List<Product> comboDrinkOptions = [];

  final Set<int> drinkCategoryIds = {3, 4, 5, 6, 7, 8, 9, 10, 11};

  final Map<String, int> comboDrinkKeywords = {
    'americano': 3,
    'espresso': 4,
    'latte': 5,
    'cà phê phin': 6,
    'cà phê': 6,
    'phin': 6,
    'cold brew': 7,
    'coldbrew': 7,
    'matcha': 8,
    'frappe': 9,
    'trà trái cây': 11,
    'trà sữa': 10,
    'trasua': 10,
  };

  @override
  void initState() {
    super.initState();
    fetchToppings();
    checkAndLoadComboOptions();
  }

  Future<void> fetchToppings() async {
    List<Product> fetchedToppings = await api.getProductsByCategory(12);
    if (mounted) setState(() => toppings = fetchedToppings);
  }

  Future<void> checkAndLoadComboOptions() async {
    final nameLower = widget.product.name.toLowerCase();
    if (nameLower.contains('combo')) {
      for (final entry in comboDrinkKeywords.entries) {
        if (nameLower.contains(entry.key)) {
          final products = await api.getProductsByCategory(entry.value);
          if (products.isNotEmpty && mounted) {
            setState(() {
              comboDrinkOptions = products;
              selectedComboDrink = products.first;
            });
          }
          break;
        }
      }
    }
  }

  bool get isDrink =>  drinkCategoryIds.contains(widget.product.categoryId);
  bool get isCombo => comboDrinkOptions.isNotEmpty;

  double get currentPrice {
    final Product baseProduct = isCombo ? selectedComboDrink! : widget.product;
    return switch (selectedSize) {
      SizeOption.small => baseProduct.priceSmall ?? baseProduct.price ?? 0,
      SizeOption.medium => baseProduct.priceMedium ?? baseProduct.price ?? 0,
      SizeOption.large => baseProduct.priceLarge ?? baseProduct.price ?? 0,
    };
  }

  double get totalPrice {
    double toppingPrice = toppings
        .where((t) => selectedToppingIds.contains(t.id))
        .fold(0, (sum, t) => sum + (t.price ?? 0));
    return (currentPrice + toppingPrice) * quantity;
  }

  String formatPrice(double price) {
    return '${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ';
  }

  void _showOrderSummaryModal() {
    final selectedToppings = toppings.where((t) => selectedToppingIds.contains(t.id)).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tóm tắt đơn hàng", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text("${widget.product.name} x$quantity", style: const TextStyle(fontSize: 16)),
            if (isCombo) Text("→ Loại: ${selectedComboDrink!.name}", style: const TextStyle(fontSize: 15)),
            Text("→ Size: ${selectedSize == SizeOption.small ? 'Nhỏ' : selectedSize == SizeOption.medium ? 'Vừa' : 'Lớn'}",
                style: const TextStyle(fontSize: 15)),
            Text("→ Đá: ${selectedIce == IceOption.normal ? 'Bình thường' : selectedIce == IceOption.much ? 'Nhiều' : 'Ít'}",
                style: const TextStyle(fontSize: 15)),
            Text("→ Đường: ${selectedSugar == SugarOption.normal ? 'Bình thường' : selectedSugar == SugarOption.less ? 'Ít' : 'Nhiều'}",
                style: const TextStyle(fontSize: 15)),
            if (selectedToppings.isNotEmpty) ...[
              const Text("→ Topping:", style: TextStyle(fontSize: 15)),
              ...selectedToppings.map((t) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text("• ${t.name} (+${formatPrice(t.price ?? 0)})", style: const TextStyle(fontSize: 14)),
              )),
            ],
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tổng cộng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(formatPrice(totalPrice),
                    style: TextStyle(fontSize: 20, color: Colors.orange[700], fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã thêm vào giỏ hàng!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("Xác nhận thêm vào giỏ", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = (widget.product.imageUrl != null && widget.product.imageUrl!.isNotEmpty)
        ? "${AppConfig.baseUrl}/static/${widget.product.imageUrl!}"
        : 'https://via.placeholder.com/400';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // SliverAppBar với ảnh lớn và collapsing
              SliverAppBar(
                expandedHeight: 360,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product_${widget.product.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) =>
                          progress == null ? child : const Center(child: CircularProgressIndicator(color: Colors.white)),
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported, size: 100, color: Colors.white70),
                          ),
                        ),
                        // Gradient overlay nhẹ
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                              stops: [0.6, 1.0],
                            ),
                          ),
                        ),
                        if (widget.product.isBestSeller)
                          Positioned(
                            top: 100,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(30)),
                              child: const Text("BEST SELLER",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                      ],
                    ),
                  ),
                  title: Text(
                    widget.product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black54)],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  titlePadding: const EdgeInsetsDirectional.only(start: 60, bottom: 16, end: 100),
                  collapseMode: CollapseMode.parallax,
                ),
              ),

              // Nội dung chi tiết
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 120), // Để chỗ cho bottom bar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.name,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(formatPrice(totalPrice),
                          style: TextStyle(fontSize: 26, color: Colors.orange[700], fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Text(widget.product.description ?? "Không có mô tả chi tiết.",
                          style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87)),

                      const SizedBox(height: 32),

                      // Combo selection
                      if (isCombo) ...[
                        const Text("Chọn loại đồ uống", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: comboDrinkOptions.map((drink) {
                            bool selected = selectedComboDrink?.id == drink.id;
                            return FilterChip(
                              label: Text(drink.name),
                              selected: selected,
                              onSelected: (val) {
                                if (val) setState(() => selectedComboDrink = drink);
                              },
                              backgroundColor: Colors.grey[100],
                              selectedColor: Colors.orange[100],
                              labelStyle: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // Các tùy chọn đồ uống
                      if (isDrink || isCombo) ...[
                        // Size
                        if ((isCombo ? selectedComboDrink?.hasSizeOptions() : widget.product.hasSizeOptions()) ?? false)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Chọn Size", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    if ((isCombo ? selectedComboDrink?.priceSmall : widget.product.priceSmall) != null)
                                      _sizeButton("Nhỏ", isCombo ? selectedComboDrink!.priceSmall! : widget.product.priceSmall!, SizeOption.small),
                                    if ((isCombo ? selectedComboDrink?.priceMedium : widget.product.priceMedium) != null)
                                      _sizeButton("Vừa", isCombo ? selectedComboDrink!.priceMedium! : widget.product.priceMedium!, SizeOption.medium),
                                    if ((isCombo ? selectedComboDrink?.priceLarge : widget.product.priceLarge) != null)
                                      _sizeButton("Lớn", isCombo ? selectedComboDrink!.priceLarge! : widget.product.priceLarge!, SizeOption.large),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),

                        // Đá & Đường
                        _optionSection("Lượng đá", ["Bình thường", "Nhiều", "Ít"],
                            selectedIce, (val) => setState(() => selectedIce = val)),
                        const SizedBox(height: 32),
                        _optionSection("Độ ngọt", ["Bình thường", "Ít", "Nhiều"],
                            selectedSugar, (val) => setState(() => selectedSugar = val)),
                        const SizedBox(height: 32),

                        // Topping
                        if (toppings.isNotEmpty) ...[
                          const Text("Chọn Topping", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: toppings.map((topping) {
                              bool selected = selectedToppingIds.contains(topping.id);
                              return FilterChip(
                                label: Text("${topping.name} +${formatPrice(topping.price ?? 0)}"),
                                selected: selected,
                                onSelected: (val) {
                                  setState(() {
                                    if (val) {
                                      selectedToppingIds.add(topping.id);
                                    } else {
                                      selectedToppingIds.remove(topping.id);
                                    }
                                  });
                                },
                                selectedColor: Colors.orange[100],
                                checkmarkColor: Colors.orange[700],
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ],

                      // Ghi chú
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Thêm ghi chú",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.orange[700]!),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom bar cố định
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, -5))],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1),
                            icon: const Icon(Icons.remove, size: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text("$quantity", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          IconButton(
                            onPressed: () => setState(() => quantity++),
                            icon: const Icon(Icons.add, size: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showOrderSummaryModal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6F00),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          formatPrice(totalPrice),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sizeButton(String label, double price, SizeOption value) {
    bool selected = selectedSize == value;
    return GestureDetector(
      onTap: () => setState(() => selectedSize = value),
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? Colors.orange[50] : Colors.grey[50],
          border: Border.all(color: selected ? const Color(0xFFFF6F00) : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 15, fontWeight: selected ? FontWeight.bold : FontWeight.w600)),
            const SizedBox(height: 4),
            Text(formatPrice(price), style: TextStyle(fontSize: 14, color: Colors.orange[700], fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _optionSection(String title, List<String> options, dynamic selectedValue, Function(dynamic) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: options.asMap().entries.map((entry) {
            int idx = entry.key;
            String text = entry.value;
            bool isSelected = selectedValue == (idx == 0 ? IceOption.normal : idx == 1 ? IceOption.much : IceOption.less) ||
                selectedValue == (idx == 0 ? SugarOption.normal : idx == 1 ? SugarOption.less : SugarOption.more);
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(idx == 0 ? (title.contains("đá") ? IceOption.normal : SugarOption.normal)
                    : idx == 1 ? (title.contains("đá") ? IceOption.much : SugarOption.less)
                    : (title.contains("đá") ? IceOption.less : SugarOption.more)),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange[50] : Colors.grey[50],
                    border: Border.all(color: isSelected ? const Color(0xFFFF6F00) : Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(text, textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}