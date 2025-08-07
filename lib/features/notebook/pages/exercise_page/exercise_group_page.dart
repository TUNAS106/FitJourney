import 'package:flutter/material.dart';
import 'exercise_list_page.dart';
import 'exercise_subgroup_page.dart';

class ExerciseGroupPage extends StatelessWidget {
  const ExerciseGroupPage({super.key});

  final List<Map<String, dynamic>> muscleGroups = const [
    {
      'name': 'Cơ Bụng',
      'image': 'assets/muscle/abdominal muscles.png',
    },
    {
      'name': 'Cơ Chân',
      'image': 'assets/muscle/Leg Muscles.jpg',
      'subgroups':[
        {
          'name': 'Cơ Đùi Sau',
          'image': 'assets/muscle/Cơ Đùi Sau.jpg',
        },
        {
          'name': 'Cơ Đùi Trước',
          'image': 'assets/muscle/Cơ Đùi Trước.png',
        },
        {
          'name': 'Cơ Bắp Chân',
          'image': 'assets/muscle/calf muscles.jpg',
        }
      ]
    },

    {
      'name': 'Cơ Lưng',
      'image': 'assets/muscle/Back Muscles.jpg',
    },
    {
      'name': 'Cơ Mông',
      'image': 'assets/muscle/gluteal muscles.jpg',
    },
    {
      'name': 'Cơ Ngực',
      'image': 'assets/muscle/Chest Muscles.jpg',
    },
    {
      'name': 'Cơ Tay',
      'image': 'assets/muscle/arm muscles.webp',
      'subgroups': [
        {
          'name': 'Cơ Tay Trước',
          'image': 'assets/muscle/Biceps Muscles.jpg'
        },
        {
          'name': 'Cơ Tay Sau',
          'image': 'assets/muscle/Triceps.jpg'
        },
        {
          'name': 'Cơ Cẳng Tay',
          'image': 'assets/muscle/Forearm Muscles.jpg',
        }
      ]
    },

    {
      'name': 'Cơ Vai',
      'image': 'assets/muscle/Shoulder Muscles.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài tập bộ phận')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: muscleGroups.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final item = muscleGroups[index];

            return GestureDetector(
              onTap: () {
                final name = item['name'] as String;
                final image = item['image'] as String;
                final subgroups = item['subgroups'] as List<Map<String, String>>?;

                if (subgroups != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseSubGroupPage(
                        groupName: name,
                        subgroups: subgroups,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseListPage(
                        muscleGroup: name,
                      ),
                    ),
                  );
                }
              },
              child: Column(
                children: [
                  ClipOval(
                    child: item['image'].toString().startsWith('http')
                        ? Image.network(
                      item['image'],
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.fitness_center, size: 50),
                    )
                        : Image.asset(
                      item['image'],
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(item['name'], textAlign: TextAlign.center),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
