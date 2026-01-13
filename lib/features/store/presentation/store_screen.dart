import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/screens/cart_screen.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/state/order_provider.dart';
import 'package:nhom2_thecoffeehouse/features/store/presentation/state/store_provider.dart';
import 'package:nhom2_thecoffeehouse/features/store/presentation/utils/city_enum_extension.dart';
import 'package:nhom2_thecoffeehouse/features/store/presentation/widgets/store_card.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<StoreProvider>();
      provider.loadStores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StoreProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            centerTitle: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Cửa hàng',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, color: Colors.black87),
                    Consumer<OrderProvider>(
                      builder: (context, order, _) {
                        final count = order.cartItemCount;
                        if (count == 0) return const SizedBox.shrink();
                        return Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Color(0xFFF26522), shape: BoxShape.circle),
                            constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                            child: Text(
                              '$count',
                              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black87),
                onPressed: () {},
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<CityEnum>(
                            value: provider.selectedCity,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                            items: CityEnum.values.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(
                                  city.displayName,
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              );
                            }).toList(),
                            onChanged: (CityEnum? city) {
                              if (city != null) {
                                provider.selectCity(city);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (provider.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: Color(0xFFF26522))),
            )
          else if (provider.stores.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('Không có cửa hàng nào')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return StoreCard(store: provider.stores[index]);
                  },
                  childCount: provider.stores.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
