import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_item.dart';

class ApiService {
  static const String baseUrl =
      'https://6a460431a268c8be2ce70b76.mockapi.io/products';

  Future<List<ProductItem>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      return jsonData
          .map((item) => ProductItem.fromJson(item))
          .toList();
    } else {
      throw Exception('Gagal mengambil data produk');
    }
  }
}