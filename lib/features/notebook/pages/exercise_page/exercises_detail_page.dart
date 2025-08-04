import 'package:flutter/material.dart';
import 'package:fitjourney/features/notebook/data/exercises_data/exercises_model.dart';

class ExerciseDetailPage extends StatelessWidget {
  final Exercise exercise;
  const ExerciseDetailPage({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 18); // Toàn bộ font size 18

    return Scaffold(
      appBar: AppBar(title: Text(exercise.name, style: textStyle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (exercise.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: exercise.imageUrl.startsWith('http')
                      ? Image.network(
                    exercise.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 100),
                  )
                      : Image.asset(
                    exercise.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _InfoColumn(title: '${exercise.sets}x', subtitle: 'Sets'),
                  _InfoColumn(title: '${exercise.timePerSet}s', subtitle: 'Thời gian'),
                ],
              ),
              const SizedBox(height: 16),

              Text("📋 Mô tả", style: textStyle.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                exercise.description,
                style: textStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 12),

// --- NHÓM CƠ MINH HOẠ ---
              Text("🧩 Nhóm cơ minh hoạ", style: textStyle.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _getMuscleGroupIcons(exercise.muscles).map((iconPath) {
                  return CircleAvatar(
                    backgroundImage: AssetImage(iconPath),
                    radius: 36,
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              Text("💪 Thông tin bài tập", style: textStyle.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("• Nhóm cơ chính: ${exercise.muscles}", style: textStyle),
              Text("• Nhóm: ${exercise.category}", style: textStyle),
              Row(
                children: [
                  const Text("• Độ khó: ", style: textStyle),
                  DifficultyIndicator(difficulty: exercise.difficulty),
                ],
              ),
              Text("• Thời lượng gợi ý: ${exercise.duration} phút", style: textStyle),
              Text("• Ước tính calo tiêu hao: ${exercise.caloriesBurned}", style: textStyle),

              const SizedBox(height: 16),

              // ---------- HIỂN THỊ NHIỀU THIẾT BỊ ----------
              Text("🛠️ Thiết bị", style: textStyle.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: splitEquipments(exercise.equipment).map((e) {
                  return _SquareImageLabel(
                    label: getEquipmentDisplayName(e),
                    assetPath: getEquipmentIcon(e),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoColumn({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 18);
    return Column(
      children: [
        Container(
          width: 72,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(title, style: textStyle.copyWith(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: textStyle),
      ],
    );
  }
}

class _SquareImageLabel extends StatelessWidget {
  final String label;
  final String assetPath;

  const _SquareImageLabel({required this.label, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            assetPath,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 48),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}

/// ================= Helpers =================

/// "Thảm tập , ghế tập" -> ["thảm tập", "ghế tập"]
List<String> splitEquipments(String equipment) {
  return equipment
      .toLowerCase()
      .split(RegExp(r'[,/|]')) // hỗ trợ dấu phẩy, /, |
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

/// Trả về danh sách ảnh nhóm cơ
List<String> _getMuscleGroupIcons(String muscles) {
  final keys = muscles.toLowerCase().split(',').map((e) => e.trim()).toList();

  return keys.map((key) {
    if (key.contains('bụng')) return 'assets/muscle/abdominal muscles.png';
    if (key.contains('tay')) return 'assets/muscle/arm muscles.webp';
    if (key.contains('ngực')) return 'assets/muscle/Chest Muscles.jpg';
    if (key.contains('lưng')) return 'assets/muscle/Back Muscles.jpg';
    if (key.contains('mông')||key.contains('Mông')) return 'assets/muscle/gluteal muscles.jpg';
    if (key.contains('chân')) return 'assets/muscle/Leg Muscles.jpg';
    if (key.contains('vai')) return 'assets/muscle/Shoulder Muscles.jpg';
    if(key.contains('trap trên')) return 'assets/muscle/trap trên.jpg';
    if(key.contains('rotator cuff')) return 'assets/muscle/rotator cuff.jpg';
    if (key.contains('Cơ Đùi Sau')) return 'assets/muscle/Cơ Đùi Sau.jpg';
    if (key.contains('Cơ Đùi Trước')) return 'assets/muscle/Cơ Đùi Trước.png';
    if (key.contains('brachialis')) return 'assets/muscle/Brachialis.jpg';
    if (key.contains('cẳng tay') || key.contains('cang tay') || key.contains('forearm')) {
      return 'assets/muscle/forearm.jpg';
    }
    if (key.contains('xô') || key.contains('xo') || key.contains('lat') || key.contains('lats') || key.contains('latissimus')) {
      return 'assets/muscle/Latissimus Dorsi.jpg';
    }
    if (key.contains('flexor') || key.contains('flexors') || key.contains('cơ gấp') || key.contains('gap co tay') || key.contains('gấp cổ tay')) {
      return 'assets/muscle/flexor.jpg';
    }
    if (key.contains('extensor') || key.contains('extensors')) { return 'assets/muscle/extensor.webp';}
    if (key.contains('brachioradialis')) {return 'assets/muscle/Brachioradialis.jpg'; }
    if (key.contains('pronator')) {return 'assets/muscle/pronator.png'; }
    if (key.contains('supinator')) {return 'assets/muscle/supinator.webp'; }
    return 'assets/default_body.png';
  }).toList();
}

String getEquipmentIcon(String equipment) {
  final key = equipment.toLowerCase().trim();

  if (key.contains('tạ đơn') ||
      key.contains('ta don') ||
      key.contains('dumbbell')) {
    return 'assets/equipment exercise/dumbbell.webp';
  }
  if (key.contains('ghế') || key.contains('ghe') || key.contains('bench')) {
    return 'assets/equipment exercise/bench.jpg';
  }
  if (key.contains('thảm') || key.contains('tham') || key.contains('mat')) {
    return 'assets/equipment exercise/exercise mat.webp';
  }
  if (key.contains('xà') || key.contains('xa') || key.contains('pull up') || key.contains('pull-up') || key.contains('thanh xa')) {
    return 'assets/equipment exercise/xadon.jpg';
  }
  if (key.contains('bánh xe') || key.contains('banh xe') ||
      key.contains('ab wheel') || key.contains('ab-wheel') ||
      key.contains('roller') || key.contains('ab roller')) {
    return 'assets/equipment exercise/bánh xe.jpg';
  }
  if (key.contains('máy cáp') || key.contains('may cap') ||
      key.contains('cable machine') || key.contains('cable') ||
      key.contains('pulley') || key.contains('crossover') ||
      key.contains('functional trainer')) {
    return 'assets/equipment exercise/máy cáp.webp';
  }
  if (key.contains('chest up') || key.contains('chess up') || // bắt lỗi chính tả
      key.contains('chest press') || key.contains('machine press') ||
      key.contains('pec') || key.contains('pec deck') ||
      key.contains('chest fly machine') || key.contains('máy ngực') || key.contains('may nguc')) {
    return 'assets/equipment exercise/machine Chest Press.jpg';
  }
  if (key.contains('đòn tạ') ||
      key.contains('don ta') ||
      key.contains('tạ đòn') ||
      key.contains('ta don') ||
      key.contains('barbell') ||
      key.contains('olympic bar') ||
      key.contains('straight bar')) {
    return 'assets/equipment exercise/donta.webp';
  }
  if (key.contains('máy cáp') || key.contains('may cap') ||
      key.contains('cable machine') || key.contains('cable') ||
      key.contains('pulley') || key.contains('crossover') ||
      key.contains('functional trainer') || key.contains('rope attachment') ||
      key.contains('lat pulldown') || key.contains('low row')) {
    return 'assets/equipment exercise/Cable.webp';
  }
  if (key.contains('máy chest press') || key.contains('may chest press') ||
      key.contains('chest press machine') || key.contains('seated chest press') ||
      key.contains('machine press') || key.contains('press ngực') ||
      key.contains('máy ngực') || key.contains('may nguc') ||
      key.contains('chest press')) {
    return 'assets/equipment exercise/machine Chest Press.jpg';
  }
  if (key.contains('hyperextension') ||
      key.contains('hyper extension') ||
      key.contains('roman chair') ||
      key.contains('back extension') ||
      key.contains('ghế hyper') || key.contains('ghe hyper') ||
      key.contains('ghế 45')   || key.contains('ghe 45')) {
    return 'assets/equipment exercise/Ghế hyperextension.jpg';
  }
  if (key.contains('wrist ') ||
      key.contains('wrist-roller') ||
      key.contains('roller cổ tay') || key.contains('roller co tay') ||
      key.contains('con lăn cổ tay') || key.contains('con lan co tay') ||
      key.contains('cuộn cổ tay') || key.contains('cuon co tay')) {
    return 'assets/equipment exercise/Wrist Arm Trainer.jpg';
  }
  return 'assets/default_eq.png';
}

String getEquipmentDisplayName(String equipment) {
  final key = equipment.toLowerCase();
  if (key.contains('tạ đơn') ||
      key.contains('ta don') ||
      key.contains('dumbbell')) {
    return 'Tạ đơn';
  }
  if (key.contains('ghế') || key.contains('ghe') || key.contains('bench')) return 'Ghế tập';
  if (key.contains('thảm') || key.contains('tham') || key.contains('mat')) return 'Thảm tập';
  if (key.contains('xà') || key.contains('xa') || key.contains('pull up') || key.contains('pull-up') || key.contains('thanh xa')) return 'Xà đơn';
  if (key.contains('bánh xe') || key.contains('banh xe') ||
      key.contains('ab wheel') || key.contains('ab-wheel') ||
      key.contains('roller') || key.contains('ab roller')) return 'Bánh xe tập bụng';
  if (key.contains('máy cáp') || key.contains('may cap') ||
      key.contains('cable machine') || key.contains('cable') ||
      key.contains('pulley') || key.contains('crossover') ||
      key.contains('functional trainer')) return 'Máy cáp';
  if (key.contains('chest up') || key.contains('chess up') ||
      key.contains('chest press') || key.contains('machine press') ||
      key.contains('pec') || key.contains('pec deck') ||
      key.contains('chest fly machine') || key.contains('máy ngực') || key.contains('may nguc')) {
    return '(Chest press)';
  }
  if (key.contains('đòn tạ') ||
      key.contains('don ta') ||
      key.contains('tạ đòn') ||
      key.contains('ta don') ||
      key.contains('barbell') ||
      key.contains('olympic bar') ||
      key.contains('straight bar')) {
    return 'Đòn tạ';
  }
  if (key.contains('máy cáp') || key.contains('may cap') ||
      key.contains('cable machine') || key.contains('cable') ||
      key.contains('pulley') || key.contains('crossover') ||
      key.contains('functional trainer') || key.contains('rope attachment') ||
      key.contains('lat pulldown') || key.contains('low row')) {
    return 'Máy cáp';
  }
  if (key.contains('máy chest press') || key.contains('may chest press') ||
      key.contains('chest press machine') || key.contains('seated chest press') ||
      key.contains('machine press') || key.contains('press ngực') ||
      key.contains('máy ngực') || key.contains('may nguc') ||
      key.contains('chest press')) {
    return 'Máy Chest Press';
  }
  if (key.contains('hyperextension') ||
      key.contains('hyper extension') ||
      key.contains('roman chair') ||
      key.contains('back extension') ||
      key.contains('ghế hyper') || key.contains('ghe hyper') ||
      key.contains('ghế 45')   || key.contains('ghe 45')) {
    return 'Ghế Hyperextension';
  }
  if (key.contains('wrist') ||
      key.contains('wrist-roller') ||
      key.contains('roller cổ tay') || key.contains('roller co tay') ||
      key.contains('con lăn cổ tay') || key.contains('con lan co tay') ||
      key.contains('cuộn cổ tay') || key.contains('cuon co tay')) {
    return 'Wrist Roller';
  }
  return 'Không xác định';
}

class DifficultyIndicator extends StatelessWidget {
  final String difficulty;

  const DifficultyIndicator({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    int level = 1;
    Color color = Colors.green;
    String label = 'Dễ';

    final lower = difficulty.toLowerCase();

    if (lower.contains('trung')) {
      level = 2;
      color = Colors.orange;
      label = 'Trung bình';
    } else if (lower.contains('khó')) {
      level = 3;
      color = Colors.red;
      label = 'Khó';
    }

    return Row(
      children: [
        Row(
          children: List.generate(3, (index) {
            return Container(
              width: 6,
              height: (index + 1) * 6.0 + 6, // height tăng dần
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index < level ? color : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
