import 'package:flutter/material.dart';

class CanchasPage extends StatelessWidget {
  final List<String> canchas = [
    'SportMania',
    'Maracana Palenque',
    'Los Castaños',
    'Taki Take',
    'Campisa'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canchas Disponibles'),
        backgroundColor: Colors.green.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: canchas.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  canchas[index],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.green.shade600,
                ),
                onTap: () {
                  // Aquí puedes agregar la lógica para mostrar más detalles de la cancha seleccionada
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('¡Seleccionaste ${canchas[index]}!')),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
