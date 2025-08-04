import 'package:flutter/material.dart';

/// Hiển thị nội dung Encyclopedia đẹp, gọn:
/// - Heading: dòng kết thúc bằng ":" -> nhãn capsule
/// - Bullet 2 cấp: "•" và "-" / "–"
/// - Callout: "TIP:" / "LƯU Ý:" / "CẢNH BÁO:"
class EncyclopediaBeautifulContent extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const EncyclopediaBeautifulContent({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final lines = text.trimRight().split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((raw) {
        final line = raw.trimRight();
        if (line.isEmpty) return const SizedBox(height: 8);

        // Callout
        if (line.startsWith('TIP:') ||
            line.startsWith('LƯU Ý:') ||
            line.startsWith('CẢNH BÁO:')) {
          return _Callout(line: line, style: style);
        }

        // Heading (kết thúc bằng ":")
        final isHeading = line.endsWith(':') &&
            !line.startsWith('•') &&
            !line.startsWith('-') &&
            !line.startsWith('–');
        if (isHeading) {
          final title = line.substring(0, line.length - 1).trim();
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: primary.withOpacity(0.22)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark_rounded, size: 16, color: primary),
                      const SizedBox(width: 6),
                      Text(title, style: style?.copyWith(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Bullet cấp 1
        if (line.startsWith('•')) {
          return _BulletLine(text: line.substring(1).trim(), level: 0, style: style);
        }

        // Bullet cấp 2
        if (line.startsWith('-') || line.startsWith('–')) {
          return _BulletLine(text: line.substring(1).trim(), level: 1, style: style);
        }

        // Dòng thường
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text(line, style: style),
        );
      }).toList(),
    );
  }
}

class _BulletLine extends StatelessWidget {
  final String text;
  final int level; // 0 | 1
  final TextStyle? style;
  const _BulletLine({required this.text, required this.level, this.style});

  @override
  Widget build(BuildContext context) {
    final dotColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: EdgeInsets.only(left: level == 0 ? 2 : 26, top: 3, bottom: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 7, height: 7,
            margin: const EdgeInsets.only(top: 12, right: 12),
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          Expanded(child: Text(text, style: style)),
        ],
      ),
    );
  }
}

class _Callout extends StatelessWidget {
  final String line;
  final TextStyle? style;
  const _Callout({required this.line, this.style});

  @override
  Widget build(BuildContext context) {
    final prefix = line.split(':').first;
    final txt = line.substring(prefix.length + 1).trim();

    Color bg; IconData icon;
    switch (prefix) {
      case 'CẢNH BÁO':
        bg = Colors.red.withOpacity(.08);
        icon = Icons.warning_amber_rounded;
        break;
      case 'LƯU Ý':
        bg = Colors.amber.withOpacity(.12);
        icon = Icons.info_outline_rounded;
        break;
      default: // TIP
        bg = Colors.green.withOpacity(.10);
        icon = Icons.lightbulb_outline_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(txt, style: style)),
        ],
      ),
    );
  }
}