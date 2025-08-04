import 'package:flutter/material.dart';
import 'package:fitjourney/features/notebook/data/whey_data/whey_model.dart';

class WheyDetailPage extends StatelessWidget {
  final Whey whey;
  const WheyDetailPage({required this.whey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    // Text mặc định 18 cho toàn trang
    final baseText = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 18,
      height: 1.6,
      letterSpacing: 0.1,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(whey.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: DefaultTextStyle.merge( // << tất cả Text bên trong = 18
        style: baseText ?? const TextStyle(fontSize: 18, height: 1.6),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Hero Card =====
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                      color: Colors.black.withOpacity(.06),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // Ảnh + badge
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              whey.imageUrl ?? '',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 120,
                                height: 120,
                                alignment: Alignment.center,
                                color: Colors.black12,
                                child: const Icon(Icons.image_not_supported, size: 40),
                              ),
                            ),
                          ),
                          if (whey.proteinRatio != null && whey.proteinRatio!.isNotEmpty)
                            Positioned(
                              left: 8,
                              bottom: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  whey.proteinRatio!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      // Thông tin nhanh
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              whey.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            _InfoRow(
                              icon: Icons.scale_rounded,
                              label: 'Trọng lượng',
                              value: '${_formatNumber(whey.weight)} g',
                            ),
                            _InfoRow(
                              icon: Icons.fitness_center_rounded,
                              label: 'Protein/serving',
                              value: '${whey.protein} g',
                            ),
                            _InfoRow(
                              icon: Icons.attach_money_rounded,
                              label: 'Giá',
                              value: _formatVND(whey.price),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ===== Thông tin chi tiết =====
              const _SectionTitle('✨ Thông tin sản phẩm'),
              const SizedBox(height: 8),
              _InfoRow(icon: Icons.restaurant_rounded, label: 'Khẩu phần', value: whey.servingSize ?? '—'),
              _InfoRow(icon: Icons.local_fire_department_rounded, label: 'Dinh dưỡng', value: whey.nutritionInfo ?? '—'),
              _InfoRow(icon: Icons.factory_rounded, label: 'Thương hiệu', value: whey.brand ?? '—'),
              _InfoRow(icon: Icons.public_rounded, label: 'Xuất xứ', value: whey.origin ?? '—'),
              _InfoRow(icon: Icons.science_rounded, label: 'Loại protein', value: whey.proteinType ?? '—'),

              const SizedBox(height: 12),

              // ===== Hương vị =====
              if ((whey.flavors ?? '').trim().isNotEmpty) ...[
                const _SectionTitle('🍨 Hương vị'),
                const SizedBox(height: 8),
                _ChipWrap(
                  items: whey.flavors!
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList(),
                ),
                const SizedBox(height: 8),
              ],

              // ===== Ghi chú =====
              const _SectionTitle('📝 Ghi chú'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(.25)),
                ),
                child: Text(whey.note),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------- Widgets phụ ----------

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: primary),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _ChipWrap extends StatelessWidget {
  final List<String> items;
  const _ChipWrap({required this.items});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map((t) => Chip(
        label: Text(t, style: const TextStyle(fontSize: 16)), // chip nhỏ hơn một chút
        side: BorderSide(color: primary.withOpacity(.25)),
        backgroundColor: primary.withOpacity(.06),
        visualDensity: VisualDensity.compact,
      ))
          .toList(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }
}

/// ---------- Helpers ----------
String _formatVND(num v) {
  final s = v.round().toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    b.write(s[i]);
    final left = s.length - i - 1;
    if (left > 0 && left % 3 == 0) b.write('.');
  }
  return '${b.toString()}đ';
}

String _formatNumber(num v) {
  final s = v.round().toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    b.write(s[i]);
    final left = s.length - i - 1;
    if (left > 0 && left % 3 == 0) b.write(',');
  }
  return b.toString();
}
