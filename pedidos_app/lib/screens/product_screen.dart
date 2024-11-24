import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';

class ProductsScreen extends StatelessWidget {
  final int clientId;

  const ProductsScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos Disponíveis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/cart',
                arguments: dataProvider.cart,
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dataProvider.products.length,
        itemBuilder: (context, index) {
          final product = dataProvider.products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/product-detail',
                arguments: product,
              );
            },
          );
        },
      ),
    );
  }
}
