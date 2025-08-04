class Whey {
  int? id;
  String name;
  double weight;
  double protein;
  double price;
  String note;
  String? servingSize;
  String? proteinRatio;
  String? nutritionInfo;
  String? flavors;
  String? brand;
  String? origin;
  String? proteinType;
  String? imageUrl;

  Whey({
    this.id,
    required this.name,

    required this.weight,
    required this.protein,
    required this.price,
    required this.note,
    this.servingSize,
    this.proteinRatio,
    this.nutritionInfo,
    this.flavors,
    this.brand,
    this.origin,
    this.proteinType,
    this.imageUrl,
  });

  factory Whey.fromMap(Map<String, dynamic> json) => Whey(
    id: json['id'],
    name: json['name'],
    weight: json['weight'],
    protein: json['protein'],
    price: json['price'],
    note: json['note'],
    servingSize: json['servingSize'],
    proteinRatio: json['proteinRatio'],
    nutritionInfo: json['nutritionInfo'],
    flavors: json['flavors'],
    brand: json['brand'],
    origin: json['origin'],
    proteinType: json['proteinType'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,

    'weight': weight,
    'protein': protein,
    'price': price,
    'note': note,
    'servingSize': servingSize,
    'proteinRatio': proteinRatio,
    'nutritionInfo': nutritionInfo,
    'flavors': flavors,
    'brand': brand,
    'origin': origin,
    'proteinType': proteinType,
  };
}
