import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:yummy/screens/categories_page.dart';
import 'package:yummy/screens/orders_page.dart';
import 'package:yummy/screens/alerts_page.dart';
import 'package:yummy/screens/cart_page.dart';
import 'package:yummy/screens/profile_page.dart';
import 'package:yummy/screens/more_page.dart';

import 'models/cart_model.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.changeTheme,
    required this.changeColor,
    required this.appTitle,
  });

  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;
  final String appTitle;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tab = 0;
  String searchText = "";
  String firstName = "";

  final List<Map<String, String>> foodCategories = [
    {'name': 'Pizza', 'image': 'assets/images/categories/pizza.jpg'},
    {'name': 'Burgers', 'image': 'assets/images/categories/burgers.jpg'},
    {'name': 'Drinks', 'image': 'assets/images/categories/drinks.jpg'},
    {'name': 'Snacks', 'image': 'assets/images/categories/snacks.png'},
    {'name': 'Dessert', 'image': 'assets/images/categories/dessert.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      firstName = user?.displayName?.split(' ').first ?? "there";
    });
  }

  Widget _buildHomeContent() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredCategories = foodCategories
        .where((cat) =>
        cat['name']!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi $firstName 👋",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "What would you like to eat today?",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              style: TextStyle(color: theme.textTheme.bodyLarge!.color),
              decoration: const InputDecoration(
                hintText: "Search for food, drinks...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            "Explore Categories",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CategoryPage(categoryName: category['name']!),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          category['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.textTheme.bodyLarge!.color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (tab) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const OrdersPage();
      // case 2:
      //   return const AlertsPage();
      case 2:
        return const CartPage();
      case 3:
        return const ProfilePage();
      case 4:
        return const MorePage();
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false, // 💥 No back button
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          title: const Text(
            "Home of Flavor",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          actions: [
            Row(
              children: [
                const Text("🌞"),
                Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    widget.changeTheme(!value);
                  },
                ),
                const Text("🌙"),
                const SizedBox(width: 12),
              ],
            ),
          ],
        ),
      ),
      body: _buildCurrentTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (index) {
          setState(() {
            tab = index;
          });
        },
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          const NavigationDestination(icon: Icon(Icons.list), label: "Orders"),
          // const NavigationDestination(icon: Icon(Icons.notifications), label: "Alerts"),
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
