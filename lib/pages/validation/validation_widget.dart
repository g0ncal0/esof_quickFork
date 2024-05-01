import 'package:flutter/material.dart';

class ValidationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validador de Senhas'),
      ),
      body: Center(
        child: Text(
          'Página de Validador de Senhas',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
