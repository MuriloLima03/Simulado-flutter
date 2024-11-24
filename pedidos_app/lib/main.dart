import 'package:flutter/material.dart';
import 'package:pedidos_app/models/product.dart';
import 'package:pedidos_app/screens/product_details.dart';
import 'package:provider/provider.dart';

import 'screens/product_screen.dart';
import 'screens/cart.dart';
import 'screens/client_selection_screen.dart';
import 'providers/data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dataProvider = DataProvider();
  dataProvider.loadData();

  runApp(
    ChangeNotifierProvider(
      create: (_) => dataProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pedidos App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/client-selection',
      routes: {
        '/client-selection': (context) => const ClientSelectionScreen(),
        '/products': (context) {
          final clientId = ModalRoute.of(context)?.settings.arguments as int?;
          if (clientId == null) {
            return const Scaffold(
              body: Center(
                child: Text('Erro: clientId não foi fornecido.'),
              ),
            );
          }
          return ProductsScreen(clientId: clientId);
        },
        '/cart': (context) => const CartScreen(),
        '/product-detail': (context) {
          final product = ModalRoute.of(context)?.settings.arguments as Product?;
          if (product == null) {
            return const Scaffold(
              body: Center(
                child: Text('Erro: Produto não fornecido.'),
              ),
            );
          }
          return ProductDetailScreen(product: product);
        },
      },
    );
  }
}
