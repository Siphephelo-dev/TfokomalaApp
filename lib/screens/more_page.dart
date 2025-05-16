import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  void _showAboutUs(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "About Us",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                "Welcome to Tfokomala Hotel App!\n\n"
                    "We are committed to providing our guests with a seamless and enjoyable food ordering experience. "
                    "With our app, you can explore menus, place orders, and track deliveries — all in one place.\n\n"
                    "Thank you for choosing us!",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(alertContext).pop(), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(alertContext).pop(); // Close dialog
                try {
                  await FirebaseAuth.instance.signOut();
                  Provider.of<CartModel>(context, listen: false).clearCart();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logout failed: ${e.toString()}')),
                  );
                }
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

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
            onTap: () => _showAboutUs(context),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Log Out",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }
}
