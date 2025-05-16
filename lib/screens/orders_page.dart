import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: userId == null
          ? const Center(child: Text('User not logged in'))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs;

          // Sort orders client-side by timestamp
          orders.sort((a, b) {
            final timeA = (a['timestamp'] as Timestamp?)?.toDate() ?? DateTime(1970);
            final timeB = (b['timestamp'] as Timestamp?)?.toDate() ?? DateTime(1970);
            return timeB.compareTo(timeA);
          });

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = List<Map<String, dynamic>>.from(order['items']);
              final totalAmount = order['totalAmount'] ?? 0.0;
              final address = order['deliveryAddress'] ?? 'N/A';
              final timestamp = (order['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
              final orderId = order.id;

              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #$orderId',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Placed on: ${timestamp.toLocal()}',
                          style: const TextStyle(fontSize: 14)),
                      const Divider(),
                      ...items.map((item) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['name'] ?? 'Unknown'),
                          Text('x${item['quantity'] ?? 0}'),
                        ],
                      )),
                      const Divider(),
                      Text('Delivery Address: $address'),
                      Text('Total: R ${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

    );
  }
}
