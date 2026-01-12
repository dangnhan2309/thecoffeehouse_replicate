// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../models/store_model.dart';
//
// class StoreMapPage extends StatefulWidget {
//   final List<Store> stores;
//
//   const StoreMapPage({super.key, required this.stores});
//
//   @override
//   State<StoreMapPage> createState() => _StoreMapPageState();
// }
//
// class _StoreMapPageState extends State<StoreMapPage> {
//   final Set<Marker> _markers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _addStoreMarkers();
//   }
//
//   void _addStoreMarkers() {
//     for (var store in widgets.stores) {
//       _markers.add(
//         Marker(
//           markerId: MarkerId(store.id.toString()),
//           position: LatLng(store.lat, store.lng),
//           infoWindow: InfoWindow(title: store.name, snippet: store.address),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Bản đồ cửa hàng')),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: widgets.stores.isNotEmpty
//               ? LatLng(widgets.stores.first.lat, widgets.stores.first.lng)
//               : const LatLng(10.7769, 106.7009), // TP.HCM mặc định
//           zoom: 12,
//         ),
//         markers: _markers,
//         myLocationEnabled: true, // Hiển thị vị trí user + nút định vị
//         myLocationButtonEnabled: true,
//       ),
//     );
//   }
// }