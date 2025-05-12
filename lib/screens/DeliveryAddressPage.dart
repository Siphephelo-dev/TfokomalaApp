import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // For the map
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class DeliveryAddressPage extends StatefulWidget {
  const DeliveryAddressPage({super.key});

  @override
  State<DeliveryAddressPage> createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  TextEditingController addressController = TextEditingController();
  late GoogleMapController mapController;
  LatLng _pinLocation = LatLng(37.42796133580664, -122.085749655962); // Default location (use user's location ideally)

  // Save the user's location when the user taps on the map
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onTap(LatLng location) {
    setState(() {
      _pinLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Delivery Address'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(  // Wrap the entire body in a SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Address input field
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Enter Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Google Map for location selection
              Container(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _pinLocation,
                    zoom: 14,
                  ),
                  onMapCreated: _onMapCreated,
                  onTap: _onTap,
                  markers: {
                    Marker(
                      markerId: const MarkerId('deliveryPin'),
                      position: _pinLocation,
                    ),
                  },
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (addressController.text.isNotEmpty) {
                    // Add logic for proceeding to payment with the entered address and location
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Proceeding to payment...")),
                    );
                    // Example: You could use Navigator.pushNamed to proceed to the payment page.
                  } else {
                    // Show a warning if the address is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a delivery address")),
                    );
                  }
                },
                child: const Text('Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
