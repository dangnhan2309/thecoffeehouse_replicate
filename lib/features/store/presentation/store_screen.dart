import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
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

    /// Gọi load store lần đầu sau khi widget build xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<StoreProvider>();
      provider.loadStores(); // hoặc load theo city mặc định
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StoreProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cửa Hàng'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.local_offer),
            onPressed: ()
            {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                DropdownButton<CityEnum>(
                  value: provider.selectedCity,
                  dropdownColor: Colors.orange,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  items: CityEnum.values.map((city) {
                    return DropdownMenuItem(
                      value: city,
                      child: Text(
                        city.displayName,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (CityEnum? city) {
                    if (city != null) {
                      provider.selectCity(city);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: provider.stores.length,
        itemBuilder: (context, index) {
          return StoreCard(store: provider.stores[index]);
        },
      ),
    );
  }
}
