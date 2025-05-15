// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../screens/cart_item.dart';
//
//
// class OrderModel {
//   final String orderId;
//   final String userId;
//   final List<CartItem> items;
//   final double total;
//   final String address;
//   final Timestamp orderDate;
//
//   OrderModel({
//     required this.orderId,
//     required this.userId,
//     required this.items,
//     required this.total,
//     required this.address,
//     required this.orderDate,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'orderId': orderId,
//       'userId': userId,
//       'items': items.map((item) => item.toMap()).toList(),
//       'total': total,
//       'address': address,
//       'orderDate': orderDate,
//     };
//   }
//
//   factory OrderModel.fromMap(Map<String, dynamic> map) {
//     return OrderModel(
//       orderId: map['orderId'],
//       userId: map['userId'],
//       items: (map['items'] as List).map((item) => CartItem.fromMap(item)).toList(),
//       total: map['total'].toDouble(),
//       address: map['address'],
//       orderDate: map['orderDate'],
//     );
//   }
// }
