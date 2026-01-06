import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nhom2_thecoffeehouse/data/datasources/remote/api_service.dart';
import 'package:nhom2_thecoffeehouse/core/appconfig.dart';
import 'package:nhom2_thecoffeehouse/models/banner.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final ApiService _apiService = ApiService();

  List<BannerModel> banners = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    try {
      final fetchedBanners = await _apiService.getBanners();
      if (mounted) {
        setState(() {
          banners = fetchedBanners;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: isLoading
          ? const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      )
          : errorMessage != null
          ? SizedBox(
        height: 180,
        child: Center(
          child: Text(
            'Không tải được banner: $errorMessage',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : banners.isEmpty
          ? const SizedBox(
        height: 180,
        child: Center(child: Text('Không có banner nào')),
      )
          : CarouselSlider(
        options: CarouselOptions(
          height: 180,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 1.0,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
        ),
        items: banners.map((banner) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              "${AppConfig.baseUrl}/static/${banner.imageUrl}",
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}