import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';

import '../models/store.dart';
import '../utils/open_google_map.dart';
import 'store_map_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  Position? userPosition;
  bool isLoadingLocation = true;
  String locationStatus = 'Đang lấy vị trí của bạn...';

  final List<Store> allStores = [
    Store(
      id: 1,
      name: 'THE COFFEE HOUSE Cao Thắng',
      address: '86-88 Cao Thắng, Phường 4, Quận 3, TP.HCM',
      lat: 10.7695,
      lng: 106.6816,
    ),
    Store(
      id: 2,
      name: 'THE COFFEE HOUSE Võ Văn Tần',
      address: '249 Võ Văn Tần, Phường 5, Quận 3, TP.HCM',
      lat: 10.7719,
      lng: 106.6901,
    ),
    Store(
      id: 3,
      name: 'THE COFFEE HOUSE Sư Vạn Hạnh',
      address: 'Sư Vạn Hạnh Mall, 11 Sư Vạn Hạnh, Quận 10, TP.HCM',
      lat: 10.7703,
      lng: 106.6679,
    ),
    Store(
      id: 4,
      name: 'THE COFFEE HOUSE Nguyễn Thái Bình',
      address: '141 Nguyễn Thái Bình, Quận 1, TP.HCM',
      lat: 10.7710,
      lng: 106.6980,
    ),
    Store(
      id: 5,
      name: 'THE COFFEE HOUSE Lê Duẩn',
      address: '31 Lê Duẩn, Quận 1, TP.HCM',
      lat: 10.7800,
      lng: 106.6990,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    setState(() {
      isLoadingLocation = true;
      locationStatus = 'Đang lấy vị trí của bạn...';
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationStatus = 'Vui lòng bật dịch vụ định vị';
        isLoadingLocation = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationStatus = 'Bạn đã từ chối quyền truy cập vị trí';
          isLoadingLocation = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationStatus = 'Quyền vị trí bị từ chối vĩnh viễn. Vui lòng bật trong Cài đặt';
        isLoadingLocation = false;
      });
      return;
    }

    try {
      userPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        locationStatus = 'Không thể lấy vị trí. Vui lòng thử lại';
        isLoadingLocation = false;
      });
    }
  }

  List<Store> getNearbyStores() {
    if (userPosition == null) return [];

    final List<Store> sorted = List.from(allStores);
    sorted.sort((a, b) {
      final distA = Geolocator.distanceBetween(
        userPosition!.latitude,
        userPosition!.longitude,
        a.lat,
        a.lng,
      );
      final distB = Geolocator.distanceBetween(
        userPosition!.latitude,
        userPosition!.longitude,
        b.lat,
        b.lng,
      );
      return distA.compareTo(distB);
    });

    return sorted.where((store) {
      final distance = Geolocator.distanceBetween(
        userPosition!.latitude,
        userPosition!.longitude,
        store.lat,
        store.lng,
      );
      return distance <= 10000; // 10km
    }).toList();
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }

  @override
  Widget build(BuildContext context) {
    final nearbyStores = getNearbyStores();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Tìm cửa hàng',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6F00),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded),
            onPressed: () {
              if (nearbyStores.isEmpty && userPosition == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng chờ lấy vị trí để xem bản đồ')),
                );
                return;
              }
              // Sửa lỗi: chỉ truyền stores (vì StoreMapPage hiện chỉ nhận stores)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StoreMapPage(stores: nearbyStores.isEmpty ? allStores : nearbyStores),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: TypeAheadField<Store>(
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Tìm tên cửa hàng hoặc địa chỉ...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.clear), onPressed: () => controller.clear())
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                );
              },
              suggestionsCallback: (pattern) async {
                if (pattern.isEmpty) return [];
                return allStores.where((s) =>
                s.name.toLowerCase().contains(pattern.toLowerCase()) ||
                    s.address.toLowerCase().contains(pattern.toLowerCase())
                ).toList();
              },
              itemBuilder: (_, store) => ListTile(
                leading: const Icon(Icons.location_on, color: Color(0xFFFF6F00)),
                title: Text(store.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(store.address, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              onSelected: (store) => openGoogleMap(store),
              // Sửa lỗi: dùng emptyBuilder thay vì noItemsFoundBuilder
              emptyBuilder: (_) => const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Không tìm thấy cửa hàng nào'),
              ),
            ),
          ),

          // Phần cửa hàng gần bạn
          Expanded(
            child: isLoadingLocation
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Color(0xFFFF6F00)),
                  const SizedBox(height: 16),
                  Text(locationStatus, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _getLocation,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6F00)),
                  ),
                ],
              ),
            )
                : nearbyStores.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off_rounded, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    userPosition == null ? 'Không thể lấy vị trí' : 'Không có cửa hàng gần bạn',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text('Thử tìm kiếm thủ công ở thanh trên', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: nearbyStores.length,
              itemBuilder: (context, index) {
                final store = nearbyStores[index];
                final distance = Geolocator.distanceBetween(
                  userPosition!.latitude,
                  userPosition!.longitude,
                  store.lat,
                  store.lng,
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFFFF6F00).withOpacity(0.1),
                      child: const Icon(Icons.coffee_rounded, size: 28, color: Color(0xFFFF6F00)),
                    ),
                    title: Text(
                      store.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(store.address, style: TextStyle(color: Colors.grey[700])),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              _formatDistance(distance),
                              style: TextStyle(color: Colors.orange[700], fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.directions_rounded, color: Color(0xFFFF6F00), size: 30),
                      onPressed: () => openGoogleMap(store),
                    ),
                    onTap: () => openGoogleMap(store),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}