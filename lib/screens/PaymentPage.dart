import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Choose Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate payment success
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Payment Successful"),
                    content: const Text("Thank you for your order!"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
                        child: const Text("OK"),
                      )
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Pay Now", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
