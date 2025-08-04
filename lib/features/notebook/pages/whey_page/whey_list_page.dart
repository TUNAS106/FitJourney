import 'package:flutter/material.dart';
import 'package:fitjourney/features/notebook/data/whey_data/whey_data.dart';
import 'package:fitjourney/features/notebook/data/whey_data/whey_model.dart';
import 'whey_detail_page.dart';

class WheyListPage extends StatelessWidget {
  final String? type;   // 'concentrate', 'isolate', 'hydrolyzed', 'blend'
  final String? brand;

  const WheyListPage({super.key, this.type, this.brand});

  // --- Lọc theo loại ---
  List<Whey> filterByType(String type) {
    return wheySamples.where((w) {
      final pType = w.proteinType?.toLowerCase() ?? '';
      switch (type) {
        case 'isolate':
          return pType.contains('isolate') &&
              !pType.contains('concentrate') &&
              !pType.contains('hydro');
        case 'hydrolyzed':
          return pType.contains('hydro');
        case 'blend':
          return (pType.contains(' + ') ||
              (pType.contains('isolate') && pType.contains('concentrate')) ||
              (pType.contains('isolate') && pType.contains('hydro')));
        case 'concentrate':
          return pType.contains('concentrate') &&
              !pType.contains('isolate') &&
              !pType.contains('hydro');
        default:
          return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    // --- Dữ liệu sau lọc ---
    List<Whey> filtered = wheySamples;
    if (type != null) {
      final byType = filterByType(type!);
      filtered = filtered.where((w) => byType.contains(w)).toList();
    }
    if (brand != null) {
      filtered = filtered.where((w) => w.brand == brand).toList();
    }

    // --- Tiêu đề ---
    String title = 'Danh sách Whey';
    if (type != null && brand != null) {
      title = 'Whey ${_cap(type!)} của $brand';
    } else if (type != null) {
      title = 'Whey loại ${_cap(type!)}';
    } else if (brand != null) {
      title = 'Whey hãng $brand';
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: filtered.isEmpty
          ? const Center(child: Text('Không có sản phẩm nào', style: TextStyle(fontSize: 18)))
          : ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) => _WheyCard(item: filtered[i], primary: primary),
      ),
    );
  }
}

/// =======================
/// Card to, đẹp cho Whey
/// =======================
class _WheyCard extends StatelessWidget {
  final Whey item;
  final Color primary;
  const _WheyCard({required this.item, required this.primary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => WheyDetailPage(whey: item)));
      },
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 18, offset: const Offset(0, 8))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ảnh to + Hero
              Hero(
                tag: 'whey:${item.name}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item.imageUrl ?? '',
                    width: 72,  // to hơn
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 72, height: 72, alignment: Alignment.center, color: Colors.black12,
                      child: const Icon(Icons.image_not_supported, size: 28),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Nội dung
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),

                    // Brand + origin (nhỏ hơn xíu)
                    Row(
                      children: [
                        Icon(Icons.store_rounded, size: 18, color: primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${item.brand ?? '—'} • ${item.origin ?? '—'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, color: theme.textTheme.bodySmall?.color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Chips: protein & price
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _chip(icon: Icons.fitness_center_rounded, text: '${item.protein}g protein/serving', primary: primary),
                        _chip(icon: Icons.attach_money_rounded, text: _vnd(item.price), primary: primary),
                        if ((item.proteinRatio ?? '').isNotEmpty)
                          _chip(icon: Icons.percent_rounded, text: item.proteinRatio!, primary: primary),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip({required IconData icon, required String text, required Color primary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withOpacity(.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primary.withOpacity(.22)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: primary),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

/// =======================
/// Helpers
/// =======================
String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

String _vnd(num v) {
  final n = v.round().toString();
  final b = StringBuffer();
  for (int i = 0; i < n.length; i++) {
    final idx = n.length - i;
    b.write(n[i]);
    if (idx > 1 && idx % 3 == 1) b.write('.');
  }
  return '${b.toString()}đ';
}
