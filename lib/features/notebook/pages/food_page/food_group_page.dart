import 'package:flutter/material.dart';
import 'food_list_page.dart';

class FoodGroupPage extends StatelessWidget {
  const FoodGroupPage({super.key});

  final List<Map<String, dynamic>> foodGroups = const [
    {
      "name": "Thịt & Trứng",
      "category": "Thịt",
      "image": "assets/foods/thit_trung.jpg",
    },
    {
      "name": "Hải sản",
      "category": "Hải sản",
      "image": "assets/foods/haisan.jpg",
    },
    {
      "name": "Tinh bột",
      "category": "Tinh bột",
      "image": "assets/foods/tinhbot.jpg",
    },
    {
      "name": "Rau củ",
      "category": "Rau củ",
      "image": "assets/foods/raucu.png",
    },
    {
      "name": "Ngũ cốc",
      "category": "Ngũ cốc",
      "image": "assets/foods/ngucoc.jpg",
    },
    {
      "name": "Sữa & chế phẩm",
      "category": "Sữa & chế phẩm",
      "image": "assets/foods/sua.webp",
    },
    {
      "name": "Trái cây",
      "category": "Trái cây",
      "image": "assets/foods/Trái cây.webp",
    },
    {
      "name": "Thực vật",
      "category": "Thực vật",
      "image": "assets/foods/thucvat.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nhóm thực phẩm")),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: foodGroups.length,
        itemBuilder: (context, index) {
          final group = foodGroups[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FoodListPage(categoryFilter: group["category"]),
                ),
              );
            },
            child: Container(
              height: 140,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(group["image"]),
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
                  // Tên nhóm
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        group["name"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
