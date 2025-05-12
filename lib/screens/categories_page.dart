import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;

  const CategoryPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context, listen: false);

    final Map<String, List<Map<String, dynamic>>> foodItems = {
      'Pizza': [
        {'name': 'Pepperoni Pizza', 'image': 'assets/images/pizza1.jpg', 'price': 89.99},
        {'name': 'Margherita Pizza', 'image': 'assets/images/pizza2.jpg', 'price': 79.99},
      ],
      'Burgers': [
        {'name': 'Cheeseburger', 'image': 'assets/images/burger1.png', 'price': 69.99},
        {'name': 'Chicken Burger', 'image': 'assets/images/burger2.jpg', 'price': 64.99},
      ],
      'Snacks': [
        {'name': 'Doritos', 'image': 'assets/images/snack1.jpg', 'price': 99.99},
        {'name': 'Simba', 'image': 'assets/images/snack2.png', 'price': 94.99},
      ],
      'Drinks': [
        {'name': 'Coke 440ml', 'image': 'assets/images/drink1.jpg', 'price': 24.99},
        {'name': 'Orange Juice', 'image': 'assets/images/drink2.png', 'price': 29.99},
      ],
      'Dessert': [
        {'name': 'Chocolate Cake', 'image': 'assets/images/dessert1.jpg', 'price': 49.99},
        {'name': 'Ice Cream', 'image': 'assets/images/dessert2.jpg', 'price': 39.99},
      ],
    };

    final items = foodItems[categoryName] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Items'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      item['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    children: [
                      Text(
                        item['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'R${item['price'].toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () {
                            cart.addItem(
                              CartItem(
                                name: item['name'],
                                image: item['image'],
                                price: item['price'],
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item['name']} added to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          label: const Text('Add to Cart', style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0, // Optional: update based on current page
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/orders');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/alerts');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/cart');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
            case 5:
              Navigator.pushReplacementNamed(context, '/more');
              break;
          }
        },
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          const NavigationDestination(icon: Icon(Icons.list), label: "Orders"),
          const NavigationDestination(icon: Icon(Icons.notifications), label: "Alerts"),
          // Badge for cart
          NavigationDestination(
            icon: Consumer<CartModel>(
              builder: (context, cart, child) => Badge(
                label: Text('${cart.totalItems}'),
                isLabelVisible: cart.totalItems > 0,
                child: const Icon(Icons.shopping_cart),
              ),
            ),
            label: "Cart",
          ),
          const NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          const NavigationDestination(icon: Icon(Icons.menu), label: "More"),


        ],
      ),
    );
  }
}
