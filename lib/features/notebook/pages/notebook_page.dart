import 'package:fitjourney/features/notebook/pages/pharmacy_page/pharmacy_category_page.dart';
import 'package:flutter/material.dart';
import 'encyclopedia_page/encyclopedia_list_page.dart';
import 'whey_page/whey_list_page.dart';
import 'package:fitjourney/features/notebook/data/exercises_data/exercises_model.dart';
import 'exercise_page/exercise_list_page.dart';
import 'package:fitjourney/features/notebook/pages/exercise_page/exercise_group_page.dart';
import 'food_page/food_list_page.dart';
import 'package:fitjourney/features/notebook/pages/whey_page/whey_brand_page.dart';
import 'food_page/food_group_page.dart';
import 'package:fitjourney/features/notebook/data/pharmacy_data/pharmacy_model.dart';
import 'package:fitjourney/features/notebook/data/encyclopedia_data/encyclopedia_model.dart';
import 'package:fitjourney/features/notebook/pages/pharmacy_page/pharmacy_category_page.dart';
class NotebookScreen extends StatelessWidget {
  const NotebookScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final notebookItems = [
      {
        'title': 'Các bài tập',
        'image': 'assets/workout.jpg',
        'onTap': (BuildContext ctx) {
          Navigator.push(
            ctx,
              MaterialPageRoute(
            builder: (_) =>const ExerciseGroupPage(),
              ),
          );
        },
      },
      {
        'title': 'Dinh dưỡng thể thao',
        'image': 'assets/whey.png',
        'onTap': (BuildContext ctx) {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => WheyBrandPage()),
          );
        },
      },
      {
        'title': 'Danh sách thức ăn và dinh dưỡng',
        'image': 'assets/nutrition.png',
        'onTap': (BuildContext ctx) {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) =>  FoodGroupPage()),
          );
        },
      },
      {
        'title': 'Dược lý học (Thuốc)',
        'image': 'assets/pharmacy.png',
        'onTap': (BuildContext ctx) {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => PharmacyCategoryPage()),
          );
        },
      },
      {
        'title': 'Bách khoa toàn thư',
        'image': 'assets/encyclopedia.png',
        'onTap': (BuildContext ctx) {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => const EncyclopediaListPage()),
          );
        },
      },
    ];


    return Scaffold(

      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemCount: notebookItems.length,
          itemBuilder: (context, index) {
            final item = notebookItems[index];
            return GestureDetector(
              onTap: () {
                final callback = item['onTap'] as void Function(BuildContext);
                callback(context);
              },
              child: Container(
                height: 140,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Stack(
                    children: [
                // Ảnh nền
                Positioned.fill(
                child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  item['image'] as String,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Lớp phủ đen mờ
            Positioned.fill(
            child: Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black.withOpacity(0.5), // tăng nếu vẫn mờ
            ),
            ),
            ),
            // Chữ
            Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
            item['title'] as String,
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
      ),
    );
  }
}
