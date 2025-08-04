import 'package:flutter/material.dart';
import 'pharmacy_list_page.dart';

class PharmacyCategoryPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {
      'title': 'Vitamin & Khoáng chất',
      'image': 'assets/pharmacy/vitamin.webp',
      'type': 'Vitamin & Khoáng chất',
    },
    {
      'title': 'Đốt mỡ - Giảm cân',
      'image': 'assets/pharmacy/fatburn.webp',
      'type': 'Đốt mỡ - Giảm cân',
    },
    {
      'title': 'Hỗ trợ hiệu suất',
      'image': 'assets/pharmacy/performance.jpg',
      'type': 'Hỗ trợ hiệu suất',
    },
    {
      'title': 'Phục hồi cơ',
      'image': 'assets/pharmacy/recovery.webp',
      'type': 'Phục hồi cơ',
    },
    {
      'title': 'Xương khớp',
      'image': 'assets/pharmacy/jointsup.webp',
      'type': 'Xương khớp',
    },
    {
      'title': 'Giảm đau - Hồi phục',
      'image': 'assets/pharmacy/pain.webp',
      'type': 'Giảm đau - Hồi phục',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chọn loại thuốc')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final item = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PharmacyListPage(category: item['type']!),
                ),
              );
            },
            child: Container(
              height: 140,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        item['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item['title']!,
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