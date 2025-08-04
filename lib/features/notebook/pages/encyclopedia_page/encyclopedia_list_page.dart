import 'package:flutter/material.dart';
import 'package:fitjourney/features/notebook/data/encyclopedia_data/encyclopedia_model.dart';
import 'package:fitjourney/features/notebook/data/encyclopedia_data/encyclopedia_data.dart';
import 'encyclopedia_detail_page.dart';

class EncyclopediaListPage extends StatefulWidget {
  const EncyclopediaListPage({super.key});

  @override
  State<EncyclopediaListPage> createState() => _EncyclopediaListPageState();
}

// --- Chỉ mục đã chuẩn hoá để tìm nhanh và “liên quan” ---
class _Indexed {
  final Encyclopedia e;
  final String title, tags, cat, content; // đã _norm
  _Indexed(this.e, this.title, this.tags, this.cat, this.content);
}

class _EncyclopediaListPageState extends State<EncyclopediaListPage> {
  // KHÔNG rebuild TextField khi gõ
  final TextEditingController _textCtl = TextEditingController();
  final ValueNotifier<String> _queryVN = ValueNotifier<String>(''); // listen query
  final FocusNode _searchFocus = FocusNode(debugLabel: 'ency-search');

  String? _category; // null = all
  bool _avoidOverlay = false; // chừa mép phải (nếu cần)
  static const double _overlayPadRight = 56.0;

  late final List<_Indexed> _index; // chỉ mục dữ liệu
  late final Map<String, List<String>> _synIndex; // << NEW: chỉ mục synonym đã _norm

  List<String> get categories =>
      encyclopediaSamples.map((e) => e.category).toSet().toList();

  @override
  void initState() {
    super.initState();
    _textCtl.addListener(() => _queryVN.value = _textCtl.text);

    // Build index 1 lần để tìm nhanh & tránh _norm lặp lại
    _index = encyclopediaSamples
        .map((e) => _Indexed(
      e,
      _norm(e.title),
      _norm(e.tags ?? ''),
      _norm(e.category),
      _norm(e.content),
    ))
        .toList();

    // ===== Build index cho synonyms (key & value đều đã _norm) =====
    _synIndex = {
      for (final entry in _synVi.entries)
        _norm(entry.key): entry.value.map((v) => _norm(v)).toList(),
    };
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _textCtl.dispose();
    _queryVN.dispose();
    super.dispose();
  }

  // ================== SEARCH HELPERS ==================

  // Bảng mở rộng từ khoá cơ bản (tuỳ ý bổ sung) — viết dễ đọc, có thể có dấu
  final Map<String, List<String>> _synVi = {
    'uống': ['nuoc', 'nước', 'bo sung nuoc', 'bù nước', 'hydration', 'dien giai', 'điện giải'],
    'nước': ['uống', 'hydration', 'dien giai', 'điện giải', 'bo sung nuoc', 'bù nước'],
    'ăn': ['dinh duong', 'bua an', 'meal', 'protein', 'carb', 'fat', 'thuc pham'],
    'cardio': ['hiit', 'chay bo', 'chạy', 'dot mo', 'đốt mỡ', 'tim mach'],
    'ngủ': ['ngu', 'sleep', 'rest', 'phuc hoi', 'hồi phục'],
    'phục hồi': ['phuc hoi', 'rest', 'recovery', 'ngu', 'ngủ', 'massage', 'giãn cơ'],
  };

  // Tách token + mở rộng synonym + thêm cả cụm (tra trên _synIndex đã _norm)
  Set<String> _expandQuery(String q) {
    final base = _norm(q);
    if (base.isEmpty) return {};
    final raw = base.split(RegExp(r'[\s,.;:!?()\-_/]+')).where((t) => t.isNotEmpty);

    final out = <String>{};
    for (final t in raw) {
      out.add(t);
      final syns = _synIndex[t] ?? const [];
      out.addAll(syns);
    }
    if (base.contains(' ')) out.add(base); // thêm cả cụm để match chính xác
    return out;
  }

  // Lọc theo query mở rộng + ranking (title=3, tags/category=2, content=1)
  List<Encyclopedia> _filteredWith(String query) {
    final tokens = _expandQuery(query);
    final cat = _category;

    if (tokens.isEmpty) {
      return _index
          .where((x) => cat == null || x.e.category == cat)
          .map((x) => x.e)
          .toList();
    }

    int score(_Indexed x) {
      int s = 0;
      for (final t in tokens) {
        if (x.title.contains(t)) s += 3;
        if (x.tags.contains(t) || x.cat.contains(t)) s += 2;
        if (x.content.contains(t)) s += 1;
      }
      return s;
    }

    final hits = <(_Indexed, int)>[];
    for (final x in _index) {
      if (cat != null && x.e.category != cat) continue;
      final sc = score(x);
      if (sc > 0) hits.add((x, sc));
    }

    hits.sort((a, b) {
      final d = b.$2.compareTo(a.$2);
      if (d != 0) return d;
      return a.$1.e.title.length.compareTo(b.$1.e.title.length);
    });

    return hits.map((p) => p.$1.e).toList();
  }

  // Chuẩn hoá: bỏ dấu + lowercase + trim
  String _norm(String s) => _stripDiacritics(s).toLowerCase().trim();

  String _stripDiacritics(String str) {
    const from =
        'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩ'
        'òóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ'
        'ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨ'
        'ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ';
    const to =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd'
        'AAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIII'
        'OOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYĐ';
    var r = str;
    for (var i = 0; i < from.length; i++) {
      r = r.replaceAll(from[i], to[i]);
    }
    return r;
  }

  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư viện kiến thức Gym'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: _avoidOverlay ? 'Tắt chừa mép phải' : 'Chừa mép phải (tránh menu nổi)',
            icon: Icon(_avoidOverlay ? Icons.border_style : Icons.space_bar),
            onPressed: () => setState(() => _avoidOverlay = !_avoidOverlay),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ===== Thanh tìm kiếm: KHÔNG rebuild TextField khi gõ =====
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextField(
                    key: const ValueKey('ency-search-field'),
                    focusNode: _searchFocus,
                    controller: _textCtl,
                    maxLines: 1,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: true,
                    autocorrect: true,
                    smartDashesType: SmartDashesType.disabled,
                    smartQuotesType: SmartQuotesType.disabled,
                    enableIMEPersonalizedLearning: true,
                    decoration: InputDecoration(
                      hintText: 'Tìm theo tiêu đề, nội dung hoặc từ khóa…',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                    ),
                    onSubmitted: (_) => _searchFocus.requestFocus(),
                  ),
                  Positioned(
                    right: 4,
                    child: ValueListenableBuilder<String>(
                      valueListenable: _queryVN,
                      builder: (_, q, __) {
                        final show = q.isNotEmpty;
                        return AnimatedOpacity(
                          opacity: show ? 1 : 0,
                          duration: const Duration(milliseconds: 120),
                          child: IgnorePointer(
                            ignoring: !show,
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                tooltip: 'Xóa',
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _textCtl.clear();
                                  _searchFocus.requestFocus();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ===== Chip lọc + Đếm kết quả =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: const Text('Tất cả'),
                            selected: _category == null,
                            onSelected: (_) => setState(() => _category = null),
                          ),
                          const SizedBox(width: 6),
                          ...categories.map((cat) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: FilterChip(
                              label: Text(cat),
                              selected: _category == cat,
                              onSelected: (_) =>
                                  setState(() => _category = cat),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ValueListenableBuilder<String>(
                    valueListenable: _queryVN,
                    builder: (_, q, __) {
                      final count = _filteredWith(q).length;
                      return Text('$count mục',
                          style: TextStyle(color: Colors.grey[600]));
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // ===== Danh sách kết quả =====
            Expanded(
              child: Padding(
                padding:
                EdgeInsets.only(right: _avoidOverlay ? _overlayPadRight : 0),
                child: ValueListenableBuilder<String>(
                  valueListenable: _queryVN,
                  builder: (context, q, _) {
                    final results = _filteredWith(q);
                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final entry = results[index];
                        final isAsset =
                        !(entry.imageUrl?.startsWith('http') ?? false);
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          elevation: 2,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: isAsset
                                  ? Image.asset(
                                entry.imageUrl ?? '',
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                const Icon(Icons.menu_book, size: 40),
                              )
                                  : Image.network(
                                entry.imageUrl ?? '',
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                const Icon(Icons.menu_book, size: 40),
                              ),
                            ),
                            title: Text(
                              entry.title,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              entry.category,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EncyclopediaDetailPage(entry: entry),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
