import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Passando um ID fictício para a próxima tela
            Navigator.pushNamed(
                context,
                '/products',
                arguments: 1, // Substitua '1' por um ID válido de cliente.
              );
          },
          child: const Text('Ir para Produtos'),
        ),
      ),
    );
  }
}
