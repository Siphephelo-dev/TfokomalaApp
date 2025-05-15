import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import 'DeliveryAddressPage.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  leading: Image.asset(item.image, width: 60, fit: BoxFit.cover),
                  title: Text(item.name),
                  subtitle: Text('R${item.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => cart.decreaseQuantity(item),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cart.increaseQuantity(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => cart.removeItem(item),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: R${cart.totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Delivery Address Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeliveryAddressPage(),
                      ),
                    );
                  },
                  child: const Text("Checkout"),
                )
              ],
            ),
          )
        ],
      ),

    );
  }
}
