import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More Info"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Settings & Info",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("App Settings"),
            onTap: () {
              // Navigate to settings page
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.group_add),
            title: const Text("Invite Friends"),
            onTap: () {
              // Share invite link
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Help & Support"),
            onTap: () {
              // Navigate to Help & Support
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text("Terms & Conditions"),
            onTap: () {
              // Navigate to T&C page
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About Us"),
            onTap: () {
              // Navigate to About page
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Log Out",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // Handle logout
            },
          ),
        ],
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