class BodyMetrics {
  final double weight;
  final double height;
  final int age;
  final double bmi;
  final DateTime timestamp;

  BodyMetrics({
    required this.weight,
    required this.height,
    required this.age,
    required this.bmi,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'height': height,
      'age': age,
      'bmi': bmi,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  factory BodyMetrics.fromFirestore(Map<String, dynamic> data) {
    return BodyMetrics(
      weight: (data['weight'] as num).toDouble(),
      height: (data['height'] as num).toDouble(),
      age: (data['age'] as int),
      bmi: (data['bmi'] as num).toDouble(),
      timestamp: DateTime.parse(data['timestamp']),
    );
  }

}
