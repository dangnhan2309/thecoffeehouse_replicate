import 'package:flutter/material.dart';
import 'package:nhom2_thecoffeehouse/core/constants/enum.dart';
import 'package:nhom2_thecoffeehouse/features/product/presentation/state/product_detail_provider.dart';

Widget buildSectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );
}

Widget buildSizeButton(
    ProductDetailProvider provider,
    String label,
    double price,
    SizeOption value,
    ) {
  final selected = provider.selectedSize == value;

  return GestureDetector(
    onTap: () => provider.setSize(value),
    child: Container(
      width: 160, // Tăng chiều rộng một chút để đủ chỗ cho hàng ngang
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: selected ? Colors.orange[50] : Colors.grey[50],
        border: Border.all(
          color: selected ? const Color(0xFFFF6F00) : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Căn giữa
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight:
                  selected ? FontWeight.bold : FontWeight.w600)),
          const SizedBox(width: 8), // Khoảng cách giữa chữ và giá
          Text(
            provider.formatPrice(price),
            style: TextStyle(
                color: Colors.orange[700], fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}

Widget buildOptionSection({
  required String title,
  required List<String> labels,
  required dynamic selected,
  required Function(dynamic) onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(labels.length, (index) {
            final value = title.contains("đá")
                ? IceOption.values[index]
                : SugarOption.values[index];
            final isSelected = selected == value;

            return GestureDetector(
              onTap: () => onTap(value),
              child: Container(
                width: 70,
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.orange[50]
                      : Colors.grey[50],
                  border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFF6F00)
                          : Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600),
                ),
              ),
            );
          }),
        ),
      ),
    ],
  );
}
