import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy/screens/payfast_webview_page.dart';
import '../models/cart_model.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String address;
  final double totalAmount;

  const OrderConfirmationPage({
    super.key,
    required this.address,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<CartModel>(context).items;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: theme.colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review Your Order',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Items list
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.separated(
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Qty: ${item.quantity}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Delivery Info
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Address:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    address,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Total + Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'R ${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Confirm & Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PayfastWebViewPage(
                        cartItems: cartItems,
                        address: address,
                        totalAmount: totalAmount,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                ),
                icon: const Icon(Icons.payment),
                label: const Text("Confirm & Pay", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
