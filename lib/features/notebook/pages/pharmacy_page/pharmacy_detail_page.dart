import 'package:flutter/material.dart';
import 'package:fitjourney/features/notebook/data/pharmacy_data/pharmacy_model.dart';

class PharmacyDetailPage extends StatelessWidget {
  final Pharmacy pharmacy;
  const PharmacyDetailPage({required this.pharmacy, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pharmacy.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh sản phẩm bo góc
            if (pharmacy.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: pharmacy.imageUrl!.startsWith('assets/')
                    ? Image.asset(
                  pharmacy.imageUrl!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  pharmacy.imageUrl!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 100),
                ),
              )
            else
              const Center(child: Icon(Icons.medication_liquid, size: 100)),

            const SizedBox(height: 16),

            // Thông tin chính
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("🧴 Thông tin thuốc",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.category, "Loại", pharmacy.type, Colors.blueGrey),
                    _buildInfoRow(Icons.format_list_numbered, "Số lượng", "${pharmacy.quantity}", Colors.teal),
                    _buildInfoRow(Icons.price_check, "Giá", "${pharmacy.price}đ", Colors.green),
                    if (pharmacy.brand != null)
                      _buildInfoRow(Icons.factory, "Thương hiệu", pharmacy.brand!, Colors.brown),
                    if (pharmacy.origin != null)
                      _buildInfoRow(Icons.flag, "Xuất xứ", pharmacy.origin!, Colors.red),
                    if (pharmacy.expiryDate != null)
                      _buildInfoRow(Icons.event, "Hạn sử dụng", pharmacy.expiryDate!, Colors.deepOrange),
                    if (pharmacy.category != null)
                      _buildInfoRow(Icons.medical_information, "Phân loại", pharmacy.category!, Colors.purple),
                  ],
                ),
              ),
            ),

            // Chi tiết công dụng & thành phần
            if (pharmacy.ingredient != null || pharmacy.effect != null || pharmacy.sideEffects != null)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("💊 Thành phần & Công dụng",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      if (pharmacy.ingredient != null)
                        _buildInfoRow(Icons.science, "Thành phần", pharmacy.ingredient!, Colors.indigo),
                      if (pharmacy.effect != null)
                        _buildInfoRow(Icons.health_and_safety, "Công dụng", pharmacy.effect!, Colors.green),
                      if (pharmacy.sideEffects != null)
                        _buildInfoRow(Icons.warning, "Tác dụng phụ", pharmacy.sideEffects!, Colors.redAccent),
                    ],
                  ),
                ),
              ),

            // Hướng dẫn dùng & bảo quản
            if (pharmacy.usage.isNotEmpty || pharmacy.storage != null || pharmacy.note.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("📋 Hướng dẫn sử dụng",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      if (pharmacy.usage.isNotEmpty)
                        _buildInfoRow(Icons.check, "Cách dùng", pharmacy.usage, Colors.blue),
                      if (pharmacy.storage != null)
                        _buildInfoRow(Icons.thermostat, "Bảo quản", pharmacy.storage!, Colors.brown),
                      if (pharmacy.note.isNotEmpty)
                        _buildInfoRow(Icons.note, "Ghi chú", pharmacy.note, Colors.deepPurple),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Hàm tiện ích tạo dòng thông tin có icon + nhấn mạnh label
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
                style: const TextStyle(fontSize: 16, color: Colors.black),
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