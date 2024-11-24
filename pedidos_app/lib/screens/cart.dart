import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/data_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // Função para calcular o total do carrinho
  double calculateTotal(List<Map<String, dynamic>> cart) {
    double total = 0.0;
    for (var item in cart) {
      final product = item['product']; // Aqui, product é do tipo Product
      final quantity = item['quantity'];
      final discount = item['discount'];
      total += (product.price * quantity) * (1 - discount / 100);
    }
    return total;
  }

  // Função para finalizar o pedido
  Future<void> finalizeOrder(
      BuildContext context, DataProvider dataProvider) async {
    final cart = dataProvider.cart;

    // Criando os dados do pedido
    final orderData = cart.map((item) {
      final product = item['product'];
      return {
        'idProduto': product.id,
        'idCliente': dataProvider.selectedClientId,
        'quantidade': item['quantity'],
        'desconto': item['discount'],
        'valor': (product.price * item['quantity']) *
            (1 - item['discount'] / 100),
      };
    }).toList();

    try {
      // Enviando os dados do pedido para o endpoint do Mockable
      final response = await http.post(
        Uri.parse('http://demo4527643.mockable.io'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        // Pedido finalizado com sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pedido finalizado com sucesso!')),
        );
        dataProvider.clearCart();
        Navigator.pop(context);
      } else {
        throw Exception('Erro ao enviar pedido: ${response.reasonPhrase}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao finalizar pedido: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final cart = dataProvider.cart;

    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: Column(
        children: [
          // Lista de itens no carrinho
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                final product = item['product']; // Product é um objeto
                final quantity = item['quantity'];
                final discount = item['discount'];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                      'Quantidade: $quantity | Desconto: $discount% | Total: R\$ ${(product.price * quantity * (1 - discount / 100)).toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      dataProvider.removeFromCart(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Item removido do carrinho')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          // Total e botão de finalizar pedido
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total: R\$ ${calculateTotal(cart).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => finalizeOrder(context, dataProvider),
                  child: const Text('Finalizar Pedido'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
