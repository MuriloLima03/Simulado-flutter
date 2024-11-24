import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<void> sendOrder(List<Map<String, dynamic>> order) async {
  final url = Uri.parse('https://api.exemplo.com/finalizar_pedido');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(order),
  );

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print('Pedido enviado com sucesso!');
    }
  } else {
    if (kDebugMode) {
      print('Erro ao enviar pedido: ${response.body}');
    }
  }
}
