import 'package:flutter/material.dart';
import 'package:fitjourney/features/notebook/data/food_data/food_model.dart';
import 'package:fitjourney/features/notebook/data/food_data/food_data.dart';
import 'food_detail_page.dart';

class FoodListPage extends StatelessWidget {
  final String? categoryFilter;
  const FoodListPage({super.key, this.categoryFilter});

  @override
  Widget build(BuildContext context) {
    final foods = categoryFilter == null
        ? foodSamples
        : foodSamples.where((f) => f.category == categoryFilter).toList();

    return Scaffold(
      appBar: AppBar(title: Text(categoryFilter ?? 'Danh sách món ăn')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FoodDetailPage(food: food),
                ),
              );
            },
            child: Container(
              height: 140,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: food.image != null
                      ? AssetImage(food.image!) as ImageProvider
                      : const AssetImage('assets/placeholder_food.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Lớp phủ mờ
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black.withOpacity(0.45),
                      ),
                    ),
                  ),
                  // Nội dung chữ
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            food.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${food.calories.toStringAsFixed(0)} kcal • ${food.protein.toStringAsFixed(1)}g protein',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}