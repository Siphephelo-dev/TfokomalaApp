import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import 'OrderConfirmationPage.dart'; // Make sure this path is correct

class DeliveryAddressPage extends StatefulWidget {
  const DeliveryAddressPage({super.key});

  @override
  State<DeliveryAddressPage> createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  TextEditingController addressController = TextEditingController();
  String _deliveryOption = 'pickup'; // Default option is pickup

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery or Pickup'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Order Option:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Radio buttons for pickup or delivery
            RadioListTile<String>(
              title: const Text('Pickup (Collect from store)'),
              value: 'pickup',
              groupValue: _deliveryOption,
              onChanged: (value) {
                setState(() {
                  _deliveryOption = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Delivery (Enter your address)'),
              value: 'delivery',
              groupValue: _deliveryOption,
              onChanged: (value) {
                setState(() {
                  _deliveryOption = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // Show address input only if delivery is selected
            if (_deliveryOption == 'delivery') ...[
              const Text('Delivery Address:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Enter your delivery address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
            ],

            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_deliveryOption == 'delivery' && addressController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a delivery address")),
                    );
                    return;
                  }

                  // Use entered address or "Pickup"
                  String finalAddress = _deliveryOption == 'pickup' ? 'Pickup' : addressController.text;

                  // Navigate to confirmation page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderConfirmationPage(
                        address: finalAddress,
                        totalAmount: Provider.of<CartModel>(context, listen: false).totalPrice,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Proceed to Payment', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
