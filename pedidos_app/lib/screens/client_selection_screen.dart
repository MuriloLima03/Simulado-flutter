import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';

class ClientSelectionScreen extends StatelessWidget {
  const ClientSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clients = Provider.of<DataProvider>(context).clients;

    return Scaffold(
      appBar: AppBar(title: const Text('Selecione um Cliente')),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];

          // Validar as propriedades do cliente antes de exibi-las
          final clientName = client['name'] ?? 'Nome não disponível';
          final clientAddress = client['address'] ?? 'Endereço não disponível';

          return ListTile(
            title: Text(clientName),
            subtitle: Text(clientAddress),
            onTap: () {
              final clientId = client['id'];
              if (clientId != null) {
                // Selecionar cliente e navegar
                Provider.of<DataProvider>(context, listen: false)
                    .selectClient(clientId);
                Navigator.pushNamed(context, '/products', arguments: clientId);
              } else {
                // Tratar caso o ID do cliente seja nulo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cliente inválido.')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
