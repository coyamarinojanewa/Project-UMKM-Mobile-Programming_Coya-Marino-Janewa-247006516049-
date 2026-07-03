class ProductItem {
  final String id;
  final String name;
  final String category;
  final int price;
  final int stock;
  final int sold;
  final String trend;
  final String image;

  ProductItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.sold,
    required this.trend,
    required this.image,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: json['price'] as int,
      stock: json['stock'] as int,
      sold: json['sold'] as int,
      trend: json['trend'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'sold': sold,
      'trend': trend,
      'image': image,
    };
  }
}