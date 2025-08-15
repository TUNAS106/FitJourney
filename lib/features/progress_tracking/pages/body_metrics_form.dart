import 'package:flutter/material.dart';
import '../controller/body_metrics_controller.dart';

class BodyMetricsForm extends StatefulWidget {
  final VoidCallback? onSubmitted;
  const BodyMetricsForm({Key? key, this.onSubmitted}) : super(key: key);

  @override
  _BodyMetricsFormState createState() => _BodyMetricsFormState();
}

class _BodyMetricsFormState extends State<BodyMetricsForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = BodyMetricsController();

  double? _weight;
  double? _height;
  int? _age;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nhập chỉ số cơ thể',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Cân nặng (kg)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.blue.shade50,
              ),
              keyboardType: TextInputType.number,
              onSaved: (val) => _weight = double.tryParse(val ?? ''),
              validator: (val) => val == null || val.isEmpty ? "Vui lòng nhập cân nặng" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Chiều cao (cm)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.blue.shade50,
              ),
              keyboardType: TextInputType.number,
              onSaved: (val) => _height = double.tryParse(val ?? ''),
              validator: (val) => val == null || val.isEmpty ? "Vui lòng nhập chiều cao" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Tuổi",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.blue.shade50,
              ),
              keyboardType: TextInputType.number,
              onSaved: (val) => _age = int.tryParse(val ?? ''),
              validator: (val) => val == null || val.isEmpty ? "Vui lòng nhập tuổi" : null,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Tính BMI và Lưu",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      if (_weight != null && _height != null && _age != null) {
        await _controller.submitMetrics(
          context: context,
          weight: _weight!,
          height: _height!,
          age: _age!,
        );
        if (widget.onSubmitted != null) {
          widget.onSubmitted!();
        }
        //Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin hợp lệ")),
        );
      }
    }
  }
}