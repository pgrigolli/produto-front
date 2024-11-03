import 'package:flutter/material.dart';
import 'package:produto_front/produto.dart';
import 'package:http/http.dart' as http;

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
      final body = {
        "description": _descriptionController.text,
        "price": double.tryParse(_priceController.text) ?? 0.0,
        "quantity": int.tryParse(_quantityController.text) ?? 0,
        "date": DateTime.tryParse(_dateController.text),
      };
      final String apiUrl = "http://localhost:3000/produtos";
      // Chame a função para enviar os dados para a API
      // Exemplo:
      // atualizarProdutoAPI(widget.produto.id, body);
      http.put(url)
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
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o nome";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: "Descrição"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira a descrição";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precoController,
                decoration: InputDecoration(labelText: "Preço"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira o preço";
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
