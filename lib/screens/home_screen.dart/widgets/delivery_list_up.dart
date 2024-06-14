import 'package:flutter/material.dart';
import 'package:sm_delivery/models/order_response.dart';
import 'package:sm_delivery/screens/delivery_detailed_screen/delivery_detailed_screen.dart';
import '../../../api/order_details.dart';
import '../../../components/basic_text.dart';
import '../../../core/theme/base_color.dart';
import '../../../models/order_details_response.dart';

class delivery_list_up extends StatefulWidget {
  const delivery_list_up({
    super.key,
    required this.order,
  });
  final Order order;

  @override
  State<delivery_list_up> createState() => _delivery_list_upState();
}

class _delivery_list_upState extends State<delivery_list_up> {
  late Future<orderDetailedResponse> orderDetailedresponse;
  var deliveryCharges = 0;
  @override
  void initState() {
    orderDetailedresponse =
        order_detailed_api().order_detailed(order_id: widget.order.orderId);
    // setState(() {
    //   deliveryCharges = int.parse(widget.order.shippingCharge ?? '0');
    // });

    super.initState();
  }

  int calculateTotal(List<orderDetails> cartItems) {
    int total = 0;

    for (var item in cartItems) {
      print("item price: ${item.price}, quantity: ${item.qty}");
      try {
        final price = double.tryParse(item.price) ?? 0.0;
        final quantity = int.tryParse(item.qty) ?? 0;
        final couponAmount = int.tryParse(item.couponAmnt) ?? 0;

        if (price > 0 && quantity > 0) {
          total += (price * quantity).toInt();
        } else {}
      } catch (e) {}
    }

    final couponAmount = int.tryParse(cartItems[0].couponAmnt) ?? 0;
    total = total - couponAmount;

    print('Final total after applying coupon: $total');
    return total;
  }

  int finalPrice(int actualPrice) {
    int finalPrice = 0;
    finalPrice = finalPrice + deliveryCharges + actualPrice;
    return finalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => delivery_detailed_screen(
                  orderresponse: widget.order,
                )));
      },
      child: widget.order.status == '5'
          ? Container()
          : Container(
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
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                      ),
                      basic_text(
                        title: widget.order.status == '5'
                            ? 'Order Delivered'
                            : 'Processing order',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: widget.order.status == '5'
                                ? Colors.green
                                : AppColors.red,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.order.paymentMode,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: orderDetailedresponse,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        orderDetailedResponse response = snapshot.data;
                        return Text(
                          '₹${finalPrice(calculateTotal(response.data))}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
