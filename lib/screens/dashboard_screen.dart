import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/product_item.dart';
import '../services/api_service.dart';
import '../widgets/category_filter.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/metric_card.dart';
import '../widgets/product_grid.dart';
import '../widgets/sales_list_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
late Future<List<ProductItem>> futureProducts;

String selectedCategory = "Semua";

@override
void initState() {
super.initState();
futureProducts = ApiService().fetchProducts();
}

void refreshData() {
setState(() {
futureProducts = ApiService().fetchProducts();
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("UMKM Insight Dashboard"),
centerTitle: true,
),
body: FutureBuilder<List<ProductItem>>(
future: futureProducts,
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

if (snapshot.hasError) {
return Center(
child: Text("Error : ${snapshot.error}"),
);
}

final products = snapshot.data!;

final totalProducts = products.length;

final totalSold = products.fold(
0,
(sum, item) => sum + item.sold,
);

final totalPrice = products.fold(
0,
(sum, item) => sum + item.price,
);

final averagePrice =
totalProducts == 0 ? 0 : totalPrice ~/ totalProducts;

final currency = NumberFormat.currency(
locale: 'id_ID',
symbol: 'Rp ',
decimalDigits: 0,
);

final topProducts = [...products];
topProducts.sort((a, b) => b.sold.compareTo(a.sold));

final filteredProducts = selectedCategory == "Semua"
? products
: products
.where((item) => item.category == selectedCategory)
.toList();

return SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
DashboardHeader(
onRefresh: refreshData,
),

const SizedBox(height: 20),

GridView.count(
crossAxisCount: 2,
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
crossAxisSpacing: 12,
mainAxisSpacing: 12,
childAspectRatio: 1.4,
children: [
MetricCard(
icon: Icons.inventory_2,
title: "Total Produk",
value: "$totalProducts",
color: Colors.blue,
),
MetricCard(
icon: Icons.shopping_cart,
title: "Total Terjual",
value: "$totalSold",
color: Colors.green,
),
MetricCard(
icon: Icons.payments,
title: "Rata-rata Harga",
value: currency.format(averagePrice),
color: Colors.orange,
),
MetricCard(
icon: Icons.trending_up,
title: "Trend Naik",
value:
"${products.where((e) => e.trend == "up").length} Produk",
color: Colors.red,
),
],
),

const SizedBox(height: 25),

const Text(
"Kategori",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 10),

CategoryFilter(
selectedCategory: selectedCategory,
onCategorySelected: (category) {
setState(() {
selectedCategory = category;
});
},
),

const SizedBox(height: 25),

const Text(
"Daftar Produk",
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 15),

ProductGrid(
products: filteredProducts,
),

const SizedBox(height: 30),

const Text(
"🏆 Produk Terlaris",
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 10),

  ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: topProducts.length < 3
        ? topProducts.length
        : 3,
    itemBuilder: (context, index) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: SalesListItem(
          product: topProducts[index],
        ),
      );
    },
  ),

],
),
);
},
),
);
}
}