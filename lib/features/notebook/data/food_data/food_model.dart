class Food {
  int? id;
  String name;
  double calories;
  double protein;
  double fat;
  double carbs;
  String category;
  String? unit;
  String? brand;
  String? origin;
  String? description;
  String? imageUrl;
  String? image;

  Food({
    this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.category,
    this.unit,
    this.brand,
    this.origin,
    this.description,
    this.imageUrl,
    this.image,
  });


  factory Food.fromMap(Map<String, dynamic> json) => Food(
    id: json['id'],
    name: json['name'],
    calories: json['calories'],
    protein: json['protein'],
    fat: json['fat'],
    carbs: json['carbs'],
    category: json['category'],
    unit: json['unit'],
    brand: json['brand'],
    origin: json['origin'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    image: json['image'],
  );


  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'calories': calories,
    'protein': protein,
    'fat': fat,
    'carbs': carbs,
    'category': category,
    'unit': unit,
    'brand': brand,
    'origin': origin,
    'description': description,
    'imageUrl': imageUrl,
    'image': image,
  };
}
