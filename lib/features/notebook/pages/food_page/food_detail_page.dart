import 'package:flutter/material.dart';
import 'package:fitjourney/features/notebook/data/food_data/food_model.dart';

class FoodDetailPage extends StatelessWidget {
  final Food food;
  const FoodDetailPage({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(food.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh chính
            if (food.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  food.image!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else if (food.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  food.imageUrl!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Center(child: Icon(Icons.fastfood, size: 100)),

            const SizedBox(height: 16),

            // Thông tin dinh dưỡng
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "🍽️ thông tin dinh dưỡng",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.local_fire_department, "calo", "${food.calories} kcal", Colors.orange),
                    _buildInfoRow(Icons.fitness_center, "protein", "${food.protein}g", Colors.blue),
                    _buildInfoRow(Icons.oil_barrel, "chất béo", "${food.fat}g", Colors.amber),
                    _buildInfoRow(Icons.rice_bowl, "carbs", "${food.carbs}g", Colors.green),
                    _buildInfoRow(Icons.category, "phân loại", food.category, Colors.purple),
                    if (food.unit != null)
                      _buildInfoRow(Icons.scale, "đơn vị", food.unit!, Colors.teal),
                    if (food.brand != null)
                      _buildInfoRow(Icons.factory, "thương hiệu", food.brand!, Colors.brown),
                    if (food.origin != null)
                      _buildInfoRow(Icons.flag, "xuất xứ", food.origin!, Colors.red),
                  ],
                ),
              ),
            ),

            // Mô tả
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.description, color: Colors.deepPurple),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "mô tả",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            food.description ?? "(không có mô tả)",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
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
  }

  // Hàm tiện ích tạo dòng thông tin có icon + màu + size chuẩn
  Widget _buildInfoRow(IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 18, color: Colors.black),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
