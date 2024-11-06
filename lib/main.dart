import 'package:flutter/material.dart';
import 'package:produto_front/lista_produtos.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(215, 71, 52, 105),
        title: const Text(
          "PRODUTO-FRONT",
          style: TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const ListaProdutos(),
    ),
  ));
}
