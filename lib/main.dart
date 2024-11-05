import 'package:flutter/material.dart';
import 'package:produto_front/lista_produtos.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text("Produto-Front"),
        centerTitle: true,
      ),
      body: const ListaProdutos(),
    ),

  ));
}
