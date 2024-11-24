import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class DataProvider extends ChangeNotifier {
  final List<Product> _products = [];
  final List<Map<String, dynamic>> _clients = [];
  final List<Map<String, dynamic>> _cart = [];
  int? _selectedClientId;

  List<Product> get products => _products;
  List<Map<String, dynamic>> get clients => _clients;
  List<Map<String, dynamic>> get cart => _cart;
  int? get selectedClientId => _selectedClientId;

  // Carregar dados de uma API externa
  Future<void> loadData() async {
    const apiUrl = 'https://demo4527643.mockable.io/muriloteste';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Atualizar clientes
        _clients.clear();
        for (var client in data['clients']) {
          _clients.add(client);
        }

        // Atualizar produtos
        _products.clear();
        for (var product in data['products']) {
          _products.add(Product(
            id: product['id'],
            name: product['name'],
            price: product['price'],
          ));
        }
        notifyListeners();
      } else {
        throw Exception('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Erro ao carregar dados: $error');
      }
    }
  }

  // Selecionar cliente
  void selectClient(int clientId) {
    _selectedClientId = clientId;
    notifyListeners();
  }

  // Adicionar produto ao carrinho
  void addToCart(Product product, int quantity, double discount) {
    final index = _cart.indexWhere((item) => item['product'].id == product.id);

    if (index != -1) {
      _cart[index]['quantity'] += quantity;
      _cart[index]['discount'] = discount;
    } else {
      _cart.add({
        'product': product,
        'quantity': quantity,
        'discount': discount,
      });
    }
    notifyListeners();
  }

  // Remover produto do carrinho
  void removeFromCart(int index) {
    _cart.removeAt(index);
    notifyListeners();
  }

  // Limpar carrinho e cliente selecionado
  void clearCart() {
    _cart.clear();
    _selectedClientId = null;
    notifyListeners();
  }

  // Enviar pedido para API (POST)
  Future<void> sendOrder(List<Map<String, dynamic>> orderData) async {
    if (_cart.isEmpty || _selectedClientId == null) {
      throw Exception('Carrinho vazio ou cliente não selecionado.');
    }

    const apiUrl = 'https://demo4527643.mockable.io/testpost';
    final orderData = _cart.map((item) {
      return {
        'idProduto': item['product'].id,
        'idCliente': _selectedClientId,
        'quantidade': item['quantity'],
        'desconto': item['discount'],
        'valor': item['product'].price * item['quantity'] * (1 - item['discount'] / 100),
      };
    }).toList();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        clearCart();
        notifyListeners();
        if (kDebugMode) {
          print('Pedido enviado com sucesso: ${response.body}');
        }
      } else {
        throw Exception('Erro ao enviar pedido: ${response.statusCode}');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Erro ao enviar pedido: $error');
      }
      rethrow;
    }
  }
}
