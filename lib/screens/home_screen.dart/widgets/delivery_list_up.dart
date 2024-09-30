// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sm_delivery/components/skeletal_text.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';
import 'package:sm_delivery/models/order_response.dart';
import 'package:sm_delivery/screens/delivery_detailed_screen/delivery_detailed_screen.dart';
import '../../../api/order_details.dart';
import '../../../components/basic_text.dart';
import '../../../core/theme/base_color.dart';
import '../../../models/order_details_response.dart';

class delivery_list_up extends StatefulWidget {
  const delivery_list_up(
      {super.key, required this.order, required this.userDetail});
  final Order order;
  final userResponse userDetail;

  @override
  State<delivery_list_up> createState() => _delivery_list_upState();
}

class _delivery_list_upState extends State<delivery_list_up> {
  late Future<orderDetailedResponse> orderDetailedresponse;
  var deliveryCharges = 0;
  @override
  void initState() {
    orderDetailedresponse = order_detailed_api().order_detailed(
        order_id: widget.order.orderId, user_id: widget.order.userId);
    super.initState();
  }

  int calculateTotal(List<orderDetails> cartItems) {
    int total = 0;

    for (var item in cartItems) {
      print("item price: ${item.price}, quantity: ${item.qty}");
      for (var item in cartItems) {
        try {
          final price = double.tryParse(item.price) ?? 0.0;
          final quantity = int.tryParse(item.qty) ?? 0;
          final couponAmount = int.tryParse(item.couponAmount) ?? 0;

          if (price > 0 && quantity > 0) {
            total += (price * quantity).toInt();
          } else {}
        } catch (e) {}
      }

      final couponAmount = int.tryParse(cartItems[0].couponAmount) ?? 0;
      total = total - couponAmount;

      print('Final total after applying coupon: $total');
      return total;
    }

    final couponAmount = int.tryParse(cartItems[0].couponAmount) ?? 0;
    total = total - couponAmount;

    print('Final total after applying coupon: $total');
    return total;
  }

  int finalPrice(int actualPrice) {
    int finalPrice = 0;
    finalPrice = finalPrice + deliveryCharges + actualPrice;
    return finalPrice;
  }

  String getOrderStatus(String status) {
    switch (status) {
      case '0':
        return "New order";
      case '1':
        return "Processing order";
      case '2':
        return "Completed Order";
      case '3':
        return "Canceled Order";
      case '4':
        return "Out of Delivery";
      case '5':
        return "Order Delivered";
      default:
        return "Unknown Status";
    }
  }

  Color getOrderStatusColor(String status) {
    switch (status) {
      case '0':
        return Colors.blue;
      case '1':
        return Colors.orange;
      case '2':
        return Colors.yellow;
      case '3':
        return Colors.red;
      case '4':
        return Colors.amber;
      case '5':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: orderDetailedresponse,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SkeletonLoader());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          orderDetailedResponse response = snapshot.data;
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => delivery_detailed_screen(
                        orderresponse: widget.order,
                        userDetails: widget.userDetail,
                      )));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      basic_text(
                        title: widget.order.orderId,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      basic_text(
                        title: getOrderStatus(widget.order.status),
                        style: TextStyle(
                            fontSize: 14,
                            color: getOrderStatusColor(widget.order.status),
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.order.paymentMode == '1'
                            ? 'Cash on Delivery'
                            : 'Online Payment',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Text(
                    '₹${finalPrice(calculateTotal(response.data))}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
