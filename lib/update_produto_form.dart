import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:produto_front/produto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateProdutoForm extends StatefulWidget {
  final int produtoId; // ID do produto passado ao abrir a tela

  const UpdateProdutoForm({super.key, required this.produtoId});

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

    // Inicializa os controladores
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _dateController = TextEditingController();

    // Carrega os dados do produto e preenche os controladores
    fetchProdutoById();
  }

  // Função para buscar o produto pela ID
  Future<void> fetchProdutoById() async {
    final String apiUrl = "http://localhost:3000/produtos/${widget.produtoId}";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final dadosJson = json.decode(response.body);
      final produtoData = dadosJson is List ? dadosJson.first : dadosJson;
      final produto = Produto.fromJson(produtoData);

      setState(() {
        _descriptionController.text = produto.description;
        _priceController.text = produto.price.toString();
        _quantityController.text = produto.quantity.toString();

        final dateFormat = DateFormat('yyyy-MM-dd'); // Formato desejado
        _dateController.text =
            dateFormat.format(DateTime.parse(produto.date.toString()));
      });
    } else {
      throw Exception('Falha ao carregar os dados do produto');
    }
  }

  // Função para deletar um produto
  Future<void> deleteProduto(int id) async {
    final String apiUrl = "http://localhost:3000/produtos/$id";
    final response = await http.delete(Uri.parse(apiUrl));

    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar produto');
    }
  }

  // Função para atualizar o produto
  void _atualizarProduto() {
    if (_formKey.currentState!.validate()) {
      final String apiUrl =
          "http://localhost:3000/produtos/${widget.produtoId}";
      final body = jsonEncode({
        "description": _descriptionController.text,
        "price": _priceController.text,
        "quantity": _quantityController.text,
        "date": _dateController.text,
      });

      http.put(
        Uri.parse(apiUrl),
        body: body,
        headers: {"Content-Type": "application/json"},
      );
    }
  }

  // Função para mostrar o diálogo de confirmação
  Future<void> showConfirmationDialog(
      BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atualizar Produto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                _atualizarProduto();
                Navigator.of(context).pop(); // Fecha o diálogo
                Navigator.of(context).pop(); // Fecha a tela de atualização
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deletar Produto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                deleteProduto(widget.produtoId);
                Navigator.of(context).pop(); // Fecha o diálogo
                Navigator.of(context).pop(); // Fecha a tela de deleção
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Limpa os controladores quando o widget for removido
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = pickedDate
            .toLocal()
            .toIso8601String()
            .split('T')[0]; // Formato YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Produto"),
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
                  if (double.tryParse(value) == null) {
                    return "Insira um número válido";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: "Data"),
                onTap: () {
                  _selectDate(context);
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showConfirmationDialog(context, "Você tem certeza?");
                      },
                      child: const Text('Atualizar'),
                    ),
                    const SizedBox(width: 10), // Espaçamento entre os botões
                    ElevatedButton(
                      onPressed: () async {
                        showDeleteConfirmationDialog(
                            context, "Você tem certeza?");
                      },
                      child: const Text('Deletar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
