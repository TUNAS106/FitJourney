import 'package:flutter/material.dart';
import 'exercise_list_page.dart';

class ExerciseSubGroupPage extends StatelessWidget {
  final String groupName;
  final List<Map<String, String>> subgroups;

  const ExerciseSubGroupPage({
    super.key,
    required this.groupName,
    required this.subgroups,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(groupName)),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .9,
        ),
        itemCount: subgroups.length,
        itemBuilder: (context, index) {
          final subgroup = subgroups[index];
          final img = subgroup['image'] ?? '';

          Widget imageWidget;
          if (img.startsWith('http')) {
            imageWidget = Image.network(
              img,
              width: 100, height: 100, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 64),
            );
          } else {
            imageWidget = Image.asset(
              img,
              width: 100, height: 100, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 64),
            );
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExerciseListPage(
                    muscleGroup: groupName,
                    subgroupName: subgroup['name']!,
                  ),
                ),
              );
            },
            child: Column(
              children: [
                ClipOval(child: imageWidget),
                const SizedBox(height: 8),
                Text(
                  subgroup['name'] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
