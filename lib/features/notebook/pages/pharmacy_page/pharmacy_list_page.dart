import 'package:flutter/material.dart';
import 'package:fitjourney/features/notebook/data/pharmacy_data/pharmacy_model.dart';
import 'package:fitjourney/features/notebook/data/pharmacy_data/pharmacy_data.dart';
import 'pharmacy_detail_page.dart';

class PharmacyListPage extends StatelessWidget {
  final String? category;

  const PharmacyListPage({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final List<Pharmacy> filtered = (category == null || category!.trim().isEmpty)
        ? pharmacySamples
        : pharmacySamples
        .where((p) => p.category?.toLowerCase() == category!.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách thuốc' + (category != null ? ' – $category' : '')),
      ),
      body: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final p = filtered[index];
          Widget leading;

          if (p.imageUrl != null) {
            final imgWidget = p.imageUrl!.startsWith('assets/')
                ? Image.asset(p.imageUrl!, fit: BoxFit.cover)
                : Image.network(
              p.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            );

            leading = ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(width: 100, height: 100, child: imgWidget),
            );
          } else {
            leading = const Icon(Icons.medication_outlined, size: 60);
          }

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: leading,
              title: Text(
                p.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${_formatPrice(p.price)} • ${p.brand ?? "—"}',
                style: const TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.chevron_right, size: 28),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PharmacyDetailPage(pharmacy: p),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}đ';
  }
}
