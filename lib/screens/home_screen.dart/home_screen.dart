// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:sm_delivery/api/order.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';
import 'package:sm_delivery/models/order_response.dart';
import 'package:sm_delivery/screens/home_screen.dart/widgets/delivery_list_past.dart';

import 'widgets/delivery_list_up.dart';

class home_screen extends StatefulWidget {
  const home_screen({super.key, required this.userDetail});
  final userResponse userDetail;

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  late ScrollController _controller;
  String message = '';
  bool isSelected1 = true;
  bool isSelected2 = false;
  late Future<orderResponse> orderDetails;
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        message = "reach the top";
      });
    }
  }

  int completedOrders(orderResponse orders) {
    int count = 0;
    for (var order in orders.data) {
      if (order.status == '5' || order.status == '3' || order.status == '2') {
        count++;
      }
    }
    return count;
  }

  Future<void> _refreshOrder() async {
    setState(() {
      _controller = ScrollController();
      orderDetails = order_api()
          .order(delivery_boy_id: widget.userDetail.messages.status.userId);
      _controller.addListener(_scrollListener);
    });
  }

  @override
  void initState() {
    _refreshOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.userDetail.messages.status as userStatus;
    return RefreshIndicator(
      onRefresh: _refreshOrder,
      child: FutureBuilder<orderResponse>(
        future: orderDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            orderResponse orderresponse = snapshot.data!;
            List<Order> pending_order = orderresponse.data
                .where((element) =>
                    element.status != '5' &&
                    element.status != '3' &&
                    element.status != '2')
                .toList();
            List<Order> completed_order = orderresponse.data
                .where((element) =>
                    element.status == '5' ||
                    element.status == '3' ||
                    element.status == '2')
                .toList();
            return SafeArea(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoCard(
                          'Confirm Orders',
                          completedOrders(orderresponse).toString(),
                          '28/05',
                          Colors.green),
                      _buildInfoCard(
                          'Left Orders',
                          (orderresponse.data.length -
                                  completedOrders(orderresponse))
                              .toString(),
                          '02/06',
                          Colors.red),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isSelected1 = true;
                            isSelected2 = false;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              'Pending Deliveries',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected1 ? Colors.red : Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                            if (isSelected1)
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 2,
                                color: Colors.red,
                              ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isSelected1 = false;
                            isSelected2 = true;
                          });
                        },
                        child: Column(
                          children: [
                            Text(
                              'Completed Deliveries',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected2 ? Colors.red : Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                            if (isSelected2)
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 2,
                                color: Colors.red,
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                isSelected1
                    ? pending_order.length == 0
                        ? Center(
                            child: Text(
                              'No Pending Orders',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                            ),
                          )
                        : SizedBox()
                    : completed_order.length == 0
                        ? Center(
                            child: Text(
                              'No Completed Orders',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                            ),
                          )
                        : SizedBox(),
                Expanded(
                  child: ListView.builder(
                    itemCount: isSelected1
                        ? pending_order.length
                        : completed_order.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: isSelected1
                            ? delivery_list_up(
                                order: pending_order[index],
                                userDetail: widget.userDetail,
                              )
                            : delivery_list_past(
                                order: completed_order[index],
                                userDetail: widget.userDetail,
                              ),
                      );
                    },
                  ),
                ),
              ],
            ));
          }
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, String amount, String date, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
