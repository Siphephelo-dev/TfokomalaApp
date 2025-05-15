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

    );
  }
}