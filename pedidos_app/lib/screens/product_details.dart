import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _quantityController = TextEditingController();
  final _discountController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _addToCart() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final discount = double.tryParse(_discountController.text) ?? 0.0;

    if (quantity > 0) {
      Provider.of<DataProvider>(context, listen: false).addToCart(
        widget.product,
        quantity,
        discount,
      );

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto adicionado ao carrinho!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira uma quantidade válida.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preço: R\$ ${widget.product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _discountController,
              decoration: const InputDecoration(labelText: 'Desconto (%)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addToCart,
              child: const Text('Adicionar ao Carrinho'),
            ),
          ],
        ),
      ),
    );
  }
}
