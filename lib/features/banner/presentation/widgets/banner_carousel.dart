import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../state/banner_provider.dart';
import 'package:nhom2_thecoffeehouse/appconfig.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.errorMessage != null) {
          return SizedBox(
            height: 180,
            child: Center(
              child: Text(
                'Không tải được banner: ${provider.errorMessage}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (provider.banners.isEmpty) {
          return const SizedBox(
            height: 180,
            child: Center(child: Text('Không có banner nào')),
          );
        }

        return CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration:
            const Duration(milliseconds: 800),
          ),
          items: provider.banners.map((banner) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                "${AppConfig.baseUrl}/static/${banner.imageUrl}",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
