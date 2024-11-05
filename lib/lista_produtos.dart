// lista_produtos.dart
import 'package:flutter/material.dart';
import 'package:produto_front/create_produto_form.dart';
import 'package:produto_front/update_produto_form.dart';
import 'produto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void mostrarDetalhesProduto(BuildContext context, Produto produto) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return UpdateProdutoForm(produtoId: produto.id);
    },
  );
}

class ListaProdutos extends StatefulWidget {
  const ListaProdutos({super.key});

  @override
  _ListaProdutosState createState() => _ListaProdutosState();
}

class _ListaProdutosState extends State<ListaProdutos> {
  final String apiUrl = "http://localhost:3000/produtos"; // URL da API
  late Future<List<Produto>> futureProdutos;

  @override
  void initState() {
    super.initState();
    futureProdutos = fetchProdutos(); // Carrega os produtos inicialmente
  }

  // Função para buscar produtos na API
  Future<List<Produto>> fetchProdutos() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> dadosJson = json.decode(response.body);
      return dadosJson.map((json) => Produto.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }

  // Função para atualizar a lista de produtos
  void _refreshProdutos() {
    setState(() {
      futureProdutos = fetchProdutos(); // Atualiza a lista de produtos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProdutoForm(),
                ),
              ).then((_) {
                // Se você estiver utilizando FutureBuilder, pode chamar uma função aqui
                _refreshProdutos(); // Atualiza a lista de produtos após adicionar
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProdutos, // Chama a função de atualizar
          ),
        ],
      ),
      body: FutureBuilder<List<Produto>>(
        future: futureProdutos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          } else {
            final produtos = snapshot.data!;
            return ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      produto.description,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      mostrarDetalhesProduto(context, produto);
                      _refreshProdutos(); // Atualiza a lista após fechar o dialog
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
