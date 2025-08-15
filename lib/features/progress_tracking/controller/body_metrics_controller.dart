import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../more/pages/more_page.dart';
import '../data/models/body_metric.dart';


class BodyMetricsController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;


  String getBmiAdvice(double bmi) {
    if (bmi < 16) {
      return '''
⚠️ Bạn bị gầy độ III (rất gầy).
- Nguy cơ: Suy dinh dưỡng nặng, hệ miễn dịch yếu, dễ mắc bệnh, loãng xương, thiếu máu.
- Nguyên nhân thường gặp: Chế độ ăn thiếu dinh dưỡng, bệnh mãn tính, rối loạn ăn uống.
- Lời khuyên: Khám bác sĩ ngay để kiểm tra sức khỏe tổng quát. Ăn nhiều bữa nhỏ giàu đạm (thịt, cá, trứng, sữa), bổ sung vitamin, ngủ đủ giấc và tập luyện nhẹ nhàng.
''';
    } else if (bmi < 17) {
      return '''
Bạn bị gầy độ II.
- Nguy cơ: Thiếu năng lượng, chóng mặt, mệt mỏi, giảm khả năng tập trung.
- Nguyên nhân thường gặp: Ăn uống không đủ chất, stress, bệnh lý tiêu hóa.
- Lời khuyên: Tăng khẩu phần ăn giàu dinh dưỡng, bổ sung các loại hạt, sữa nguyên kem, tập các bài tăng cơ để cải thiện cân nặng.
''';
    } else if (bmi < 18.5) {
      return '''
Bạn bị gầy độ I.
- Nguy cơ: Sức đề kháng yếu, dễ nhiễm bệnh, ảnh hưởng tiêu hóa.
- Lời khuyên: Ăn đủ 3 bữa chính và 2-3 bữa phụ mỗi ngày, uống sinh tố trái cây + sữa, kết hợp tập gym để tăng cơ, tránh chỉ tăng mỡ.
''';
    } else if (bmi < 20) {
      return '''
Bạn ở mức bình thường nhưng hơi thấp.
- Lời khuyên: Duy trì chế độ ăn lành mạnh, tăng thêm thực phẩm giàu đạm và tinh bột tốt để đạt BMI lý tưởng (20-22).
''';
    } else if (bmi < 24) {
      return '''
🎯 BMI hoàn hảo!
- Lời khuyên: Tiếp tục duy trì chế độ ăn cân bằng (50% tinh bột, 25% đạm, 25% chất béo tốt), tập luyện đều đặn và ngủ đủ giấc.
''';
    } else if (bmi < 25) {
      return '''
Bạn ở mức bình thường cao.
- Nguy cơ: Nếu không kiểm soát, dễ chuyển sang thừa cân.
- Lời khuyên: Tăng vận động hằng ngày, hạn chế thức ăn nhanh và đồ uống có đường.
''';
    } else if (bmi < 27) {
      return '''
Bạn bị thừa cân nhẹ.
- Nguy cơ: Tăng nguy cơ cao huyết áp, mỡ máu.
- Lời khuyên: Giảm khẩu phần tinh bột tinh chế (cơm trắng, bánh mì trắng), ăn nhiều rau xanh, tập cardio ít nhất 150 phút/tuần.
''';
    } else if (bmi < 30) {
      return '''
Bạn thừa cân độ I.
- Nguy cơ: Khó thở khi vận động, đau khớp, tăng nguy cơ tiểu đường type 2.
- Lời khuyên: Áp dụng chế độ ăn ít đường, tăng tập luyện sức bền (chạy bộ, đạp xe, bơi), ngủ sớm để ổn định hormone.
''';
    } else if (bmi < 35) {
      return '''
Béo phì độ I.
- Nguy cơ: Tăng nguy cơ bệnh tim mạch, gan nhiễm mỡ, tiểu đường.
- Lời khuyên: Tham khảo chuyên gia dinh dưỡng, ăn nhiều rau quả, giảm tối đa nước ngọt, tập thể dục kết hợp cardio và tạ.
''';
    } else if (bmi < 40) {
      return '''
Béo phì độ II (nguy cơ cao).
- Nguy cơ: Tăng nguy cơ đột quỵ, huyết áp cao, ngưng thở khi ngủ.
- Lời khuyên: Bắt đầu kế hoạch giảm cân nghiêm túc dưới sự hướng dẫn của bác sĩ. Kết hợp ăn kiêng khoa học và tập luyện cường độ phù hợp.
''';
    } else {
      return '''
🚨 Béo phì độ III (rất nguy hiểm).
- Nguy cơ: Nguy hiểm đến tính mạng, biến chứng tim mạch, tiểu đường, suy hô hấp.
- Lời khuyên: Gặp bác sĩ ngay để lập kế hoạch điều trị y khoa. Có thể cần can thiệp y tế (thuốc hoặc phẫu thuật giảm cân) kết hợp chế độ ăn và vận động.
''';
    }
  }

  Future<void> submitMetrics({
    required BuildContext context,
    required double weight,
    required double height,
    required int age,
  }) async {
    try {
      final bmi = _calculateBMI(weight, height);
      final metrics = BodyMetrics(
        weight: weight,
        height: height,
        age: age,
        bmi: bmi,
        timestamp: DateTime.now(),
      );

      await _showBMIDialog(context, bmi);

      final user = _auth.currentUser;
      if (user == null) {
        _showErrorDialog(context, "Bạn chưa đăng nhập.");
        return;
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('body_metrics')
          .add(metrics.toMap());
      Navigator.pop(context); // Thêm dòng này
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  double _calculateBMI(double weight, double heightCm) {
    final heightM = heightCm / 100;
    return weight / (heightM * heightM);
  }

  Future<void> _showBMIDialog(BuildContext context, double bmi) async {
    String advice = getBmiAdvice(bmi);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.health_and_safety, color: Colors.teal, size: 28),
            SizedBox(width: 8),
            Text(
              'Chỉ số BMI của bạn',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${bmi.toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 12),
            Text(
              advice,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Đóng"),
          ),
        ],
      ),
    );
  }
  Future<List<BodyMetrics>> fetchBodyMetrics(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('body_metrics')
        .orderBy('timestamp')
        .get();

    final metrics = snapshot.docs
        .map((doc) => BodyMetrics.fromFirestore(doc.data()))
        .toList();

    return metrics;
  }
  Future<void> checkUserBmiReminder(String userId, BuildContext context) async {
    final metrics = await fetchBodyMetrics(userId);
    if (metrics.isEmpty) {
      // Chưa có dữ liệu BMI lần nào → bắt buộc nhập ngay
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Nhập chỉ số BMI'),
          content: const Text('Bạn chưa nhập chỉ số BMI lần nào. Vui lòng nhập để theo dõi sức khỏe.'),
          actions: [
            TextButton(
              child: const Text('Để sau'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Nhập ngay'),
              onPressed: () {
                //Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BodyMetricsFormPage(onProgressUpdated: () {  },)));
              },
            ),
          ],
        ),
        barrierDismissible: false, // Không cho tắt dialog khi bấm ngoài
      );
      return;
    }
    final lastMetrics = metrics.last;
    // Lấy chỉ số BMI gần nhất (theo timestamp cuối cùng)
    final daysSinceLast = DateTime.now().difference(lastMetrics.timestamp).inDays;
    //final hoursSinceLast = DateTime.now().difference(lastMetrics.timestamp).inHours;
    //final secondsSinceLast = DateTime.now().difference(lastMetrics.timestamp).inSeconds;
    //final minutesSinceLast = DateTime.now().difference(lastMetrics.timestamp).inMinutes;
    if (daysSinceLast  >=7) {
      // Hiển thị dialog nhắc nhở
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Nhắc nhở chỉ số BMI'),
          content: const Text('Đã 7 ngày kể từ lần nhập BMI trước. Hãy nhập lại để cập nhật sức khỏe.'),
          actions: [
            TextButton(
              child: const Text('Để sau'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Nhập ngay'),
              onPressed: () {
                Navigator.pop(context);
                // Điều hướng tới màn nhập BMI
                Navigator.push(context, MaterialPageRoute(builder: (_) => BodyMetricsFormPage(onProgressUpdated: () {  },)));
              },
            ),
          ],
        ),
      );
    }
  }
}

