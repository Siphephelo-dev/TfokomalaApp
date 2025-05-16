import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/cart_item.dart';


class OrderModel {
  final String id;
  final List<dynamic> items;
  final String address;
  final double totalAmount;
  final DateTime timestamp;

  OrderModel({
    required this.id,
    required this.items,
    required this.address,
    required this.totalAmount,
    required this.timestamp,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String documentId) {
    return OrderModel(
      id: documentId,
      items: data['items'] ?? [],
      address: data['address'] ?? '',
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
