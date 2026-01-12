import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/screens/home_screen.dart';
import 'package:nhom2_thecoffeehouse/features/home/presentation/widgets/bottom_navigation.dart';
import 'package:nhom2_thecoffeehouse/features/order/presentation/order_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Dùng PageStorageKey để giữ trạng thái của mỗi tab
  final List<Widget> _pages = [
    const HomeScreen(key: PageStorageKey('HomePage')),
    const OrderScreen(key: PageStorageKey('OrderPage')),
    //const StorePage(key: PageStorageKey('StorePage')),
    Container(
      key: const PageStorageKey('PromoPage'),
      color: Colors.white,
      child: const Center(child: Text("Ưu đãi")),
    ),
    Container(
      key: const PageStorageKey('OtherPage'),
      color: Colors.white,
      child: const Center(child: Text("Khác")),
    ),
  ];

  // Giữ scroll position của mỗi tab
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex ,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
