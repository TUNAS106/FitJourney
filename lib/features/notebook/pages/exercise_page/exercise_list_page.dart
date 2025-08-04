import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitjourney/features/notebook/data/exercises_data/exercises_model.dart';
import 'package:fitjourney/features/notebook/data/exercises_data/exercises_data.dart';
import 'exercises_detail_page.dart';

enum SortOrder { none, easyToHard, hardToEasy }
enum SugType { exercise, tag }

class _Suggestion {
  final String label;
  final SugType type;
  _Suggestion({required this.label, required this.type});
}

class ExerciseListPage extends StatefulWidget {
  final String muscleGroup;
  final String? subgroupName;

  const ExerciseListPage({
    super.key,
    required this.muscleGroup,
    this.subgroupName,
  });

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  SortOrder _sortOrder = SortOrder.none;

  // ===== Search + Overlay state =====
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  final _link = LayerLink();
  OverlayEntry? _overlay;
  Timer? _debounce;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() {
      if (_searchFocus.hasFocus && _query.isNotEmpty) _showOverlay();
      if (!_searchFocus.hasFocus) _hideOverlay();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _hideOverlay();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<Exercise> get _all => [
    ...armExercises,
    ...legExercises,
    ...gluteExercises,
    ...chestExercises,
    ...coreExercises,
  ];

  // ===== Filtering =====
  List<Exercise> _getFilteredExercises() {
    // 1) Group / subgroup
    final base = (widget.muscleGroup.toLowerCase() == 'all')
        ? _all
        : _all.where((e) {
      final muscle = (e.muscles ?? '').toLowerCase().trim();
      final category = (e.category ?? '').toLowerCase().trim();
      final sub = widget.subgroupName?.toLowerCase().trim();
      final group = widget.muscleGroup.toLowerCase().trim();
      return (sub != null && sub.isNotEmpty)
          ? (category.contains(sub) || muscle.contains(sub))
          : (category.contains(group) || muscle.contains(group));
    }).toList();

    // 2) Query
    final q = _query.toLowerCase().trim();
    final filtered = q.isEmpty
        ? base
        : base.where((e) {
      final name = e.name.toLowerCase();
      final muscles = (e.muscles ?? '').toLowerCase();
      final equip = (e.equipment ?? '').toLowerCase();
      final cat = (e.category ?? '').toLowerCase();
      return name.contains(q) ||
          muscles.contains(q) ||
          equip.contains(q) ||
          cat.contains(q);
    }).toList();

    // 3) Sort by difficulty
    int lvl(String d) {
      d = d.toLowerCase();
      if (d.contains('khó')) return 3;
      if (d.contains('trung')) return 2;
      return 1;
    }
    switch (_sortOrder) {
      case SortOrder.easyToHard:
        filtered.sort((a, b) => lvl(a.difficulty).compareTo(lvl(b.difficulty)));
        break;
      case SortOrder.hardToEasy:
        filtered.sort((a, b) => lvl(b.difficulty).compareTo(lvl(a.difficulty)));
        break;
      case SortOrder.none:
        break;
    }
    return filtered;
  }

  // ===== Suggestions =====
  List<_Suggestion> _buildSuggestions(String q) {
    if (q.isEmpty) return [];
    q = q.toLowerCase();

    final nameSugs = _all
        .map((e) => e.name)
        .where((n) => n.toLowerCase().contains(q))
        .toSet()
        .take(6)
        .map((n) => _Suggestion(label: n, type: SugType.exercise))
        .toList();

    final tagPool = <String>{
      ..._all.expand((e) => (e.muscles ?? '')
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)),
      ..._all.map((e) => (e.equipment ?? '').trim()).where((s) => s.isNotEmpty),
      ..._all.map((e) => (e.category ?? '').trim()).where((s) => s.isNotEmpty),
    };

    final tagSugs = tagPool
        .where((t) => t.toLowerCase().contains(q))
        .take(6)
        .map((t) => _Suggestion(label: t, type: SugType.tag))
        .toList();

    return [
      ...nameSugs,
      ...tagSugs.where((t) =>
          nameSugs.every((n) => n.label.toLowerCase() != t.label.toLowerCase())),
    ].take(8).toList();
  }

  // ===== Overlay helpers =====
  void _showOverlay() {
    final sugs = _buildSuggestions(_query);
    if (sugs.isEmpty) {
      _hideOverlay();
      return;
    }
    _overlay?.remove();
    _overlay = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          offset: const Offset(0, 56), // bám ngay dưới ô tìm
          child: _SuggestionBox(
            items: sugs,
            onTap: (s) {
              _searchCtrl.text = s;
              _searchCtrl.selection = TextSelection.fromPosition(
                TextPosition(offset: _searchCtrl.text.length),
              );
              setState(() => _query = s);
              _hideOverlay();
              _searchFocus.unfocus();
            },
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _hideOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _onQueryChanged(String val) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      setState(() => _query = val);
      if (_searchFocus.hasFocus && _query.isNotEmpty) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _getFilteredExercises();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bài tập', style: TextStyle(fontSize: 18)),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(.10),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('${items.length}',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: cs.primary)),
            ),
          ),
          PopupMenuButton<SortOrder>(
            icon: const Icon(Icons.sort_rounded),
            onSelected: (v) => setState(() => _sortOrder = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: SortOrder.none, child: Text('Chưa sắp xếp')),
              PopupMenuItem(value: SortOrder.easyToHard, child: Text('Từ dễ đến khó')),
              PopupMenuItem(value: SortOrder.hardToEasy, child: Text('Từ khó đến dễ')),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: CompositedTransformTarget(
              link: _link,
              child: TextField(
                controller: _searchCtrl,
                focusNode: _searchFocus,
                onChanged: _onQueryChanged,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: cs.surface,
                  hintText: 'Tìm theo tên / nhóm cơ / thiết bị…',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(.55),
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isEmpty
                      ? IconButton(
                    icon: const Icon(Icons.tune_rounded),
                    onPressed: () {},
                  )
                      : IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _searchCtrl.clear();
                      _onQueryChanged('');
                      _searchFocus.requestFocus();
                    },
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: cs.primary.withOpacity(.55), width: 1.4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: cs.primary, width: 2),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => ExerciseCard(
          exercise: items[i],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ExerciseDetailPage(exercise: items[i])),
          ),
        ),
      ),

      backgroundColor: cs.surfaceVariant.withOpacity(.24),
    );
  }
}

/* ===== Hộp gợi ý bám thanh tìm kiếm ===== */
class _SuggestionBox extends StatelessWidget {
  final List<_Suggestion> items;
  final ValueChanged<String> onTap;
  const _SuggestionBox({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (items.isEmpty) return const SizedBox.shrink();

    return Material(
      elevation: 12,
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 280),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withOpacity(.06)),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 6),
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: Colors.black.withOpacity(.06)),
            itemBuilder: (_, i) {
              final s = items[i];
              final isTag = s.type == SugType.tag;
              return ListTile(
                dense: true,
                leading: Icon(
                  isTag ? Icons.sell_rounded : Icons.fitness_center_rounded,
                  size: 20,
                  color: isTag ? Colors.indigo : Colors.teal,
                ),
                title: Text(s.label),
                onTap: () => onTap(s.label),
              );
            },
          ),
        ),
      ),
    );
  }
}

/* ================= Card Đẹp ================= */

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;
  const ExerciseCard({super.key, required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(.04)),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(.06),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Hero(
              tag: 'ex-${exercise.name}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: exercise.imageUrl.startsWith('http')
                    ? Image.network(
                  exercise.imageUrl,
                  width: 96, height: 72, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 42),
                )
                    : Image.asset(
                  exercise.imageUrl,
                  width: 96, height: 72, fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      DifficultyChip(exercise.difficulty),
                      const SizedBox(width: 8),
                      _Tiny(icon: Icons.timer_outlined, text: '${exercise.timePerSet}s'),
                      const SizedBox(width: 8),
                      _Tiny(icon: Icons.repeat, text: '${exercise.sets}x'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _muscleIcons(exercise.muscles).map((p) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: primary.withOpacity(.10),
                          backgroundImage: AssetImage(p),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: theme.iconTheme.color?.withOpacity(.6)),
          ],
        ),
      ),
    );
  }
}

/* =============== Chip độ khó =============== */

class DifficultyChip extends StatelessWidget {
  final String difficulty;
  const DifficultyChip(this.difficulty, {super.key});

  @override
  Widget build(BuildContext context) {
    final d = difficulty.toLowerCase();
    late Color c;
    late String label;
    if (d.contains('khó')) {
      c = Colors.red; label = 'Khó';
    } else if (d.contains('trung')) {
      c = Colors.orange; label = 'Trung bình';
    } else {
      c = Colors.green; label = 'Dễ';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.equalizer_rounded, size: 14, color: c),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: c, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/* =============== Tiny info row =============== */

class _Tiny extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Tiny({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }
}

/* =============== Icon nhóm cơ =============== */

List<String> _muscleIcons(String muscles) {
  final keys = muscles.toLowerCase().split(',').map((e) => e.trim()).toList();
  return keys.map((k) {
    if (k.contains('bụng')) return 'assets/muscle/abdominal muscles.png';
    if (k.contains('tay')) return 'assets/muscle/arm muscles.webp';
    if (k.contains('ngực')) return 'assets/muscle/Chest Muscles.jpg';
    if (k.contains('lưng')) return 'assets/muscle/Back Muscles.jpg';
    if (k.contains('mông')||k.contains('Mông')) return 'assets/muscle/gluteal muscles.jpg';
    if (k.contains('chân')) return 'assets/muscle/Leg Muscles.jpg';
    if (k.contains('vai')) return 'assets/muscle/Shoulder Muscles.jpg';
    if (k.contains('trap trên') || k.contains('trap tren')) return 'assets/muscle/trap trên.jpg';
    if (k.contains('rotator cuff')) return 'assets/muscle/rotator cuff.jpg';
    if (k.contains('Cơ Đùi Sau')) return 'assets/muscle/Cơ Đùi Sau.jpg';
    if (k.contains('Cơ Đùi Trước')) return 'assets/muscle/Cơ Đùi Trước.png';
    if (k.contains('brachialis')) return 'assets/muscle/Brachialis.jpg';
    if (k.contains('cẳng tay') || k.contains('cang tay') || k.contains('forearm')) {
      return 'assets/muscle/forearm.jpg';
    }
    if (k.contains('xô') || k.contains('xo') || k.contains('lat') || k.contains('lats') || k.contains('latissimus')) {
      return 'assets/muscle/Latissimus Dorsi.jpg';
    }
    if (k.contains('flexor') || k.contains('flexors') || k.contains('cơ gấp') || k.contains('gap co tay') || k.contains('gấp cổ tay')) {
      return 'assets/muscle/flexor.jpg';
    }
    if (k.contains('extensor') || k.contains('extensors'))  {return 'assets/muscle/extensor.webp';}
    if (k.contains('brachioradialis')) {return 'assets/muscle/Brachioradialis.jpg'; }
    if (k.contains('pronator')) {return 'assets/muscle/pronator.png'; }
    if (k.contains('supinator')) {return 'assets/muscle/supinator.webp'; }
    return 'assets/default_body.png';
  }).toList();
}