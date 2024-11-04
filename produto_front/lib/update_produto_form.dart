import 'package:flutter/material.dart';
import 'package:produto_front/produto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class UpdateProdutoForm extends StatefulWidget {
  final Produto produto;

  UpdateProdutoForm({required this.produto});

  @override
  _UpdateProdutoFormState createState() => _UpdateProdutoFormState();
}

class _UpdateProdutoFormState extends State<UpdateProdutoForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de entrada
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();

    // Inicializa os controladores com os valores atuais do produto
    _descriptionController = TextEditingController(text: widget.produto.description);
    _priceController = TextEditingController(text: widget.produto.price.toString());
    _quantityController = TextEditingController(text: widget.produto.quantity.toString());
    _dateController = TextEditingController(text: widget.produto.date.toString());
  }

  @override
  void dispose() {
    // Limpa os controladores quando o widget for removido da árvore
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

    void _atualizarProduto() {
      if (_formKey.currentState!.validate()) {
        // Monta o corpo da atualização
        final body = jsonEncode({
          "description": _descriptionController.text,
          "price": _priceController.text,
          "quantity": _quantityController.text,
          "date": _dateController.text,
        });

        final String apiUrl = "http://localhost:3000/produtos/${widget.produto.id}";

        print(body);
        http.put(Uri.parse(apiUrl),
        body: body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atualizar Produto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Descrição"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira a descrição";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Preço"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o preço";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: "Quantidade"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira a quantidade";
                  }
                  if (double.tryParse(value) == null) {
                    return "Insira um número válido";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _atualizarProduto,
                child: Text("Atualizar Produto"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
