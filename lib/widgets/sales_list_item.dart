import 'package:flutter/material.dart';

import '../models/product_item.dart';

class SalesListItem extends StatelessWidget {
  final ProductItem product;

  const SalesListItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.image),
      ),
      title: Text(product.name),
      subtitle: Text(
        "${product.sold} produk terjual",
      ),
      trailing: Icon(
        product.trend == "up"
            ? Icons.trending_up
            : Icons.trending_down,
        color:
        product.trend == "up"
            ? Colors.green
            : Colors.red,
      ),
    );
  }
}