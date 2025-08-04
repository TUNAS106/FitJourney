import 'package:flutter/material.dart';
import 'whey_list_page.dart';

class WheyBrandPage extends StatelessWidget {
  final brands = [
    {'title': 'Optimum Nutrition (ON)', 'brand': 'Optimum Nutrition', 'image': 'assets/brands/Optimum Nutrition.jpg'},
    {'title': 'Rule 1 (R1 Protein)', 'brand': 'Rule 1', 'image': 'assets/brands/Rule 1.jpg'},
    {'title': 'Mutant', 'brand': 'Mutant', 'image': 'assets/brands/Mutant.png'},
    {'title': 'Nutrabolics', 'brand': 'Nutrabolics', 'image': 'assets/brands/Nutrabolics.webp'},
    {'title': 'Applied Nutrition', 'brand': 'Applied Nutrition', 'image': 'assets/brands/Applied Nutrition.jpg'},
    {'title': 'Dymatize', 'brand': 'Dymatize', 'image': 'assets/brands/Dymatize.webp'},
    {'title': 'AMIX Nutrition', 'brand': 'Amix', 'image': 'assets/brands/Amix.webp'},
    {'title': 'Labrada Nutrition', 'brand': 'Labrada', 'image': 'assets/brands/Labrada.jpg'},
    {'title': 'BPI Sports', 'brand': 'BPI Sports', 'image': 'assets/brands/BPI Sports.png'},
    {'title': 'VitaXtrong (VX)', 'brand': 'VitaXtrong', 'image': 'assets/brands/VitaXtrong.jpg'},
    {'title': 'BioTech USA', 'brand': 'BiotechUSA', 'image': 'assets/brands/BiotechUSA.webp'},
    {'title': 'PVL (Pure Vita Labs)', 'brand': 'PVL', 'image': 'assets/brands/PVL.webp'},
    {'title': 'Z Nutrition', 'brand': 'Z Nutrition', 'image': 'assets/brands/Z Nutrition.webp'},
    {'title': 'Redcon1', 'brand': 'Redcon1', 'image': 'assets/brands/Redcon1.webp'},
    {'title': 'Warrior', 'brand': 'Warrior', 'image': 'assets/brands/Warrior.jpg'},
    {'title': 'Elite Labs USA', 'brand': 'Elite Labs USA', 'image': 'assets/brands/Elite Labs USA.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn thương hiệu Whey')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.8,
        ),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final item = brands[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WheyListPage(brand: item['brand']!),
                ),
              );
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(item['image']!),
                ),
                const SizedBox(height: 8),
                Text(
                  item['title']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}