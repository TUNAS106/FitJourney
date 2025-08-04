class Pharmacy {
  int? id;
  String name;
  String type;
  double quantity;
  double price;
  String usage;
  String note;


  // --- Thêm chi tiết ---
  String? brand;
  String? origin;
  String? ingredient;
  String? effect;
  String? sideEffects;
  String? storage;
  String? expiryDate;
  String? imageUrl;
  String? category;


  Pharmacy({
    this.id,
    required this.name,
    required this.type,
    required this.quantity,
    required this.price,
    required this.usage,
    required this.note,
    this.brand,
    this.origin,
    this.ingredient,
    this.effect,
    this.sideEffects,
    this.storage,
    this.expiryDate,
    this.imageUrl,
    this.category, // ✅ MỚI THÊM
  });


  factory Pharmacy.fromMap(Map<String, dynamic> json) => Pharmacy(
    id: json['id'],
    name: json['name'],
    type: json['type'],
    quantity: json['quantity'],
    price: json['price'],
    usage: json['usage'],
    note: json['note'],
    brand: json['brand'],
    origin: json['origin'],
    ingredient: json['ingredient'],
    effect: json['effect'],
    sideEffects: json['sideEffects'],
    storage: json['storage'],
    expiryDate: json['expiryDate'],
    imageUrl: json['imageUrl'],
    category: json['category'],
  );


  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'type': type,
    'quantity': quantity,
    'price': price,
    'usage': usage,
    'note': note,
    'brand': brand,
    'origin': origin,
    'ingredient': ingredient,
    'effect': effect,
    'sideEffects': sideEffects,
    'storage': storage,
    'expiryDate': expiryDate,
    'imageUrl': imageUrl,
    'category': category,
  };
}
