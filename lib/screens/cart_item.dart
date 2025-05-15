class CartItem {
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      name: map['name'],
      price: map['price'].toDouble(),
      quantity: map['quantity'],
    );
  }
}
