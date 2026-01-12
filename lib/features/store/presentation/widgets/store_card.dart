import 'package:flutter/material.dart';
import '../../domain/entities/store.dart';

class StoreCard extends StatelessWidget {
  final Store store;

  const StoreCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(store.name),
        subtitle: Text(store.address),
        trailing: const Icon(Icons.location_on),
      ),
    );
  }
}
