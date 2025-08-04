import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitjourney/features/notebook/data/encyclopedia_data/encyclopedia_model.dart';

// import 2 widget dùng chung
import 'package:fitjourney/features/notebook/pages/encyclopedia_page/encyclopedia_beautifull_content.dart';
import 'package:fitjourney/features/notebook/pages/encyclopedia_page/encyclopedia_content_card.dart';

class EncyclopediaDetailPage extends StatelessWidget {
  final Encyclopedia entry;
  const EncyclopediaDetailPage({super.key, required this.entry});

  bool get _isAsset => !(entry.imageUrl?.startsWith('http') ?? false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    // Text style toàn trang: cỡ 18, giãn dòng thoáng
    final bodyStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 18,
      height: 1.65,
      letterSpacing: 0.1,
    );

    final double topInset = MediaQuery.of(context).padding.top;
    const double horizontal = 16.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            expandedHeight: 260,
            foregroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.white),
            actionsIconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              title: Text(
                entry.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (entry.imageUrl != null)
                    _isAsset
                        ? Image.asset(entry.imageUrl!, fit: BoxFit.cover)
                        : Image.network(
                      entry.imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, p) => p == null
                          ? child
                          : const ColoredBox(
                        color: Color(0x11000000),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0x22000000)),
                    )
                  else
                    const ColoredBox(color: Color(0x22000000)),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                  if ((entry.category ?? '').isNotEmpty)
                    Positioned(
                      left: horizontal + kToolbarHeight, // chừa nút back
                      top: horizontal + topInset,
                      child: Chip(
                        avatar: Icon(Icons.category, size: 18, color: primary),
                        label: Text(entry.category!),
                        backgroundColor: Colors.white.withOpacity(0.85),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Card nội dung dùng chung =====
                  EncyclopediaContentCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.local_library, size: 18, color: primary),
                            const SizedBox(width: 8),
                            Text(
                              'Chủ đề: ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            Text(entry.category ?? '—', style: bodyStyle),
                          ],
                        ),
                        const SizedBox(height: 10),

                        if ((entry.tags ?? '').trim().isNotEmpty) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.sell, size: 18, color: primary),
                              const SizedBox(width: 8),
                              Expanded(child: _TagWrap(tags: entry.tags!)),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: Color(0x15000000)),
                        ),

                        // ===== Renderer nội dung đẹp dùng chung =====
                        EncyclopediaBeautifulContent(
                          text: entry.content,
                          style: bodyStyle,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== Action =====
                  Row(
                    children: [
                      _ActionButton(
                        icon: Icons.copy_all_rounded,
                        label: 'Sao chép',
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: '${entry.title}\n\n${entry.content}'),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đã sao chép nội dung')),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      if ((entry.source ?? '').isNotEmpty)
                        _ActionButton(
                          icon: Icons.link,
                          label: 'Nguồn',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(entry.source!)),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagWrap extends StatelessWidget {
  final String tags;
  const _TagWrap({required this.tags});

  @override
  Widget build(BuildContext context) {
    final list = tags
        .split(RegExp(r'[;,]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (list.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: list
          .map(
            (t) => Chip(
          label: Text(t, style: const TextStyle(fontSize: 16)),
          visualDensity: VisualDensity.compact,
        ),
      )
          .toList(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: primary, size: 22),
        label: Text(label, style: TextStyle(color: primary, fontSize: 18)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: primary.withOpacity(0.35)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
