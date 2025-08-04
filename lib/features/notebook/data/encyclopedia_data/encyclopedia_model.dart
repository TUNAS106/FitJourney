class Encyclopedia {
  int? id;
  String title;         // Tiêu đề mẹo/kiến thức
  String content;       // Nội dung chi tiết
  String category;      // Chủ đề: ví dụ "Tập luyện", "Dinh dưỡng", "Phục hồi"
  String? imageUrl;     // Ảnh minh hoạ (nếu có)
  String? source;       // Nguồn tham khảo (nếu có)
  String? tags;         // Các thẻ như "cardio, protein, ngủ nghỉ"

  Encyclopedia({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
    this.source,
    this.tags,
  });

  factory Encyclopedia.fromMap(Map<String, dynamic> json) => Encyclopedia(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    category: json['category'],
    imageUrl: json['imageUrl'],
    source: json['source'],
    tags: json['tags'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'category': category,
    'imageUrl': imageUrl,
    'source': source,
    'tags': tags,
  };
}