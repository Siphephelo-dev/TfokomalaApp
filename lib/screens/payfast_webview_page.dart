import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/cart_model.dart';
import 'orders_page.dart';

class PayfastWebViewPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final String address;
  final double totalAmount;

  const PayfastWebViewPage({
    super.key,
    required this.cartItems,
    required this.address,
    required this.totalAmount,
  });

  @override
  State<PayfastWebViewPage> createState() => _PayfastWebViewPageState();
}

class _PayfastWebViewPageState extends State<PayfastWebViewPage> {
  late final WebViewController _controller;

  final String returnUrl = "https://www.yoursite.com/success";
  final String cancelUrl = "https://www.yoursite.com/cancel";

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (url.contains(returnUrl)) {
              _handleSuccess();
            } else if (url.contains(cancelUrl)) {
              Navigator.pop(context); // Go back to OrderConfirmationPage
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(_generatePaymentUrl()));
  }

  String _generatePaymentUrl() {
    final paymentData = {
      'merchant_id': '10038988', // Test Merchant ID
      'merchant_key': 'w8l5atnjmh54d', // Test Key
      'amount': widget.totalAmount.toStringAsFixed(2),
      'item_name': 'Food Order',
      'return_url': returnUrl,
      'cancel_url': cancelUrl,
    };

    final query = paymentData.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return 'https://sandbox.payfast.co.za/eng/process?$query';
  }

  Future<void> _handleSuccess() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final orderData = {
          'userId': user.uid,
          'items': widget.cartItems.map((item) => {
            'name': item.name,
            'quantity': item.quantity,
            'price': item.price,
          }).toList(),
          'deliveryAddress': widget.address,
          'totalAmount': widget.totalAmount,
          'timestamp': DateTime.now(),

        };

        await FirebaseFirestore.instance.collection('orders').add(orderData);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment successful. Order saved!')),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OrdersPage()),
                (route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving order: $e')),
          );
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated.')),
        );
      }
    }
    Provider.of<CartModel>(context, listen: false).clearCart();


  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Processing Payment'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
