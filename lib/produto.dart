class Produto {
  final int id;
  final String description;
  final double price;
  final int quantity;
  final DateTime date;

  Produto({required this.id, required this.description, required this.price, required this.quantity, required this.date});

  factory Produto.fromJson(Map<String, dynamic> json){
    return Produto(
      id: json['id'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      quantity: json['quantity'],
      date: DateTime.parse(json['date']),

    );
  }

}
