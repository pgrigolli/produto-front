import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProdutoForm extends StatefulWidget {
  @override
  _AddProdutoFormState createState() => _AddProdutoFormState();
}

class _AddProdutoFormState extends State<AddProdutoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _createProduto() async {
    if (_formKey.currentState!.validate()) {
      final String apiUrl = "http://localhost:3000/produtos"; // URL da sua API
      final body = jsonEncode({
        "description": _descriptionController.text,
        "price": double.parse(_priceController.text),
        "quantity": int.parse(_quantityController.text),
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 201) {
        // Produto criado com sucesso
        Navigator.of(context).pop(); // Fecha o formulário
      } else {
        // Lida com o erro de criação
        throw Exception('Falha ao criar produto');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Produto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Descrição"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira a descrição";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Preço"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o preço";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: "Quantidade"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira a quantidade";
                  }
                  if (int.tryParse(value) == null) {
                    return "Insira um número válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createProduto,
                child: const Text('Adicionar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
