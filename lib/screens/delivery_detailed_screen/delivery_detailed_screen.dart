// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sm_delivery/api/order_delivery_status.dart';
import 'package:sm_delivery/api/order_details.dart';
import 'package:sm_delivery/api/update_quantity.dart';
import 'package:sm_delivery/models/order_response.dart';
import 'package:sm_delivery/screens/delivery_screen/delivery_screen.dart';
import '../../api/address.dart';
import '../../components/basic_text.dart';
import '../../core/theme/base_color.dart';
import '../../models/address_response.dart';
import '../../models/order_details_response.dart';

class delivery_detailed_screen extends StatefulWidget {
  const delivery_detailed_screen({super.key, required this.orderresponse});
  final Order orderresponse;

  @override
  State<delivery_detailed_screen> createState() =>
      _delivery_detailed_screenState();
}

class _delivery_detailed_screenState extends State<delivery_detailed_screen> {
  late Future<orderDetailedResponse> orderDetailedresponse;
  Set<int> updateIndices = {};
  int new_quan = 1;
  int adder(int quantity) {
    new_quan = quantity + 1;
    return new_quan;
  }

  int subtract(int quantity) {
    if (new_quan > 1) {
      new_quan = quantity - 1;
    }
    return new_quan;
  }

  Future<void> _refreshOrder() async {
    setState(() {
      orderDetailedresponse = order_detailed_api()
          .order_detailed(order_id: widget.orderresponse.orderId);
    });
  }

  var deliveryCharges = 0;

  @override
  void initState() {
    orderDetailedresponse = order_detailed_api()
        .order_detailed(order_id: widget.orderresponse.orderId);
    // setState(() {
    //   deliveryCharges = int.parse(widget.orderresponse.shippingCharge!);
    // });
    super.initState();
  }

  int calculateTotalPrice(List<orderDetails> cartItems) {
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
    return total;
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: kToolbarHeight,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        title: basic_text(
            title: widget.orderresponse.orderId,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.white)),
        backgroundColor: AppColors.primarycolor2,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrder,
        child: FutureBuilder(
          future: orderDetailedresponse,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              orderDetailedResponse orderDetails = snapshot.data;
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: orderDetails.data.length,
                        itemBuilder: (context, index) {
                          bool isUpdating = updateIndices.contains(index);
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          'http://odishasweets.in/jumbotail/uploads/${orderDetails.data[index].img}',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.13,
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          child: Text(
                                            orderDetails
                                                .data[index].productName,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    overflow:
                                                        TextOverflow.clip),
                                          ),
                                        ),
                                        !isUpdating
                                            ? basic_text(
                                                title:
                                                    'Quantity: ${orderDetails.data[index].qty}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Colors.grey[400],
                                                        fontWeight:
                                                            FontWeight.w500),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              subtract(
                                                                  new_quan);
                                                            });
                                                          },
                                                          icon: Icon(
                                                              Icons.remove)),
                                                      Text(new_quan.toString()),
                                                      IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              adder(new_quan);
                                                            });
                                                          },
                                                          icon:
                                                              Icon(Icons.add)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      new_quan.toString() !=
                                                              orderDetails
                                                                  .data[index]
                                                                  .qty
                                                          ? TextButton(
                                                              onPressed:
                                                                  () async {
                                                                final result = await update_quantity_api().update_quantity(
                                                                    orders_id: orderDetails
                                                                        .data[
                                                                            index]
                                                                        .ordersId,
                                                                    qty: new_quan
                                                                        .toString());
                                                                if (result
                                                                    .message
                                                                    .isNotEmpty) {
                                                                  _refreshOrder();
                                                                }
                                                              },
                                                              child: basic_text(
                                                                  title:
                                                                      'Update',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                          color:
                                                                              AppColors.primarycolor2)))
                                                          : Container(),
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              updateIndices
                                                                  .remove(
                                                                      index);
                                                            });
                                                          },
                                                          child: basic_text(
                                                              title: 'Cancel',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .red))),
                                                    ],
                                                  )
                                                ],
                                              ),
                                        !isUpdating
                                            ? Text(
                                                '₹' +
                                                    orderDetails
                                                        .data[index].price,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontSize: 18,
                                                      color: AppColors
                                                          .primarycolor2,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              )
                                            : Container(),
                                        orderDetails.data[0].status == '5'
                                            ? Container()
                                            : !isUpdating
                                                ? ElevatedButton.icon(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (updateIndices
                                                            .contains(index)) {
                                                          updateIndices
                                                              .remove(index);
                                                        }
                                                        updateIndices
                                                            .add(index);
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: AppColors
                                                          .primarycolor2,
                                                    ),
                                                    label: Text(
                                                      'Edit',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: AppColors
                                                                  .primarycolor2),
                                                    ),
                                                  )
                                                : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            basic_text(
                                title: 'Payment Mode',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: AppColors.primarycolor2,
                                        fontWeight: FontWeight.w600)),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.grey,
                                    child: CircleAvatar(
                                      radius: 6,
                                      backgroundColor: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    orderDetails.data[0].paymentMode,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            basic_text(
                                title: 'Delivery Address:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: AppColors.primarycolor2,
                                        fontWeight: FontWeight.w600)),
                            FutureBuilder<AddressResponse>(
                              future: view_address_api().view_address(
                                  user_id: orderDetails.data[0].userId),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData) {
                                  return Center(
                                      child: Text('Address unavailable'));
                                } else {
                                  AddressResponse address_data = snapshot.data;
                                  return Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        basic_text(
                                            title: address_data
                                                    .data[0].firstName +
                                                ' ' +
                                                address_data.data[0].lastName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    overflow:
                                                        TextOverflow.clip)),
                                        basic_text(
                                            title: address_data
                                                    .data[0].address1 +
                                                ', ' +
                                                address_data.data[0].adress2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    overflow:
                                                        TextOverflow.clip)),
                                        basic_text(
                                            title: address_data
                                                    .data[0].cityname +
                                                ', ' +
                                                address_data.data[0].state! +
                                                '-' +
                                                address_data.data[0].pincode,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    overflow:
                                                        TextOverflow.clip)),
                                        basic_text(
                                            title: address_data.data[0].number,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color:
                                                        AppColors.primarycolor2,
                                                    fontWeight: FontWeight.w500,
                                                    overflow:
                                                        TextOverflow.clip)),
                                        orderDetails.data[0].status == '5'
                                            ? Container()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.white),
                                                      onPressed: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DeliveryScreen(
                                                                          lat: double.parse(
                                                                              '20.3040'),
                                                                          lng: double.parse(
                                                                              '85.8395'),
                                                                        )));
                                                      },
                                                      child: basic_text(
                                                          title:
                                                              'Start Delivery',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .primarycolor2,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))),
                                                ],
                                              )
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              basic_text(
                                title: 'Price Details',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  basic_text(
                                    title:
                                        'Price (${orderDetails.data.length} items)',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.black),
                                  ),
                                  basic_text(
                                    title: '₹' +
                                        calculateTotalPrice(orderDetails.data)
                                            .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  basic_text(
                                    title: 'Coupon Discount',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.black),
                                  ),
                                  basic_text(
                                    title:
                                        '-₹${orderDetails.data[0].couponAmnt}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.green),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  basic_text(
                                    title: 'Delivery Charges',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.black),
                                  ),
                                  basic_text(
                                    title: '₹' + deliveryCharges.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(height: 0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  basic_text(
                                    title: 'Total Amount',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.black),
                                  ),
                                  basic_text(
                                    title: '₹' +
                                        finalPrice(calculateTotal(
                                                orderDetails.data))
                                            .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: widget.orderresponse.status == '5'
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Order Delivered',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: AppColors.primarycolor2),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Cancel Your Delivery'),
                                content: Text(
                                    'Are you sure you want to cancel the delivery?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final result =
                                          await order_delivery_status_api()
                                              .order_delivery_status(
                                                  orderid: widget
                                                      .orderresponse.orderId,
                                                  status: '3');
                                      if (result.messages.status ==
                                          'Order Deliverey Succesfully') {
                                        Navigator.pop(context);
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: basic_text(
                            title: 'Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primarycolor2),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirm Your Delivery'),
                                content: Text(
                                    'Are you sure you want to confirm the delivery?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final result =
                                          await order_delivery_status_api()
                                              .order_delivery_status(
                                                  orderid: widget
                                                      .orderresponse.orderId,
                                                  status: '5');
                                      if (result.messages.status ==
                                          'Order Deliverey Succesfully') {
                                        Navigator.pop(context);
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: basic_text(
                            title: 'Confirm',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                      )),
                ],
              ),
      ),
    );
  }
}
