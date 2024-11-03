// lista_produtos.dart
import 'package:flutter/material.dart';
import 'produto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void mostrarDetalhesProduto(BuildContext context, Produto produto){
  
  showDialog(
    context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        title: Text(produto.description),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Id: ${produto.id}"),
            Text("Preço: ${produto.price}"),
            Text("Quantidade: ${produto.quantity}")
          ]
        )
      );
    }
    );
  
}

class ListaProdutos extends StatelessWidget {
  final String apiUrl = "http://localhost:3000/produtos"; // URL da API

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Produto>>(
      future: fetchProdutos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Nenhum produto encontrado.'));
        } else {
          final produtos = snapshot.data!;
          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(produto.description, style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                      mostrarDetalhesProduto(context, produto);
                  },

                ),
              );
            },
          );
        }
      },
    );
  }
}
