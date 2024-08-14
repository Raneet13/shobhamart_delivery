// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/view_cart.dart';
import '../models/view_cart_response.dart';
import '../screens/cart_screen.dart/cart_screen.dart';

class shopping_cart extends StatefulWidget {
  const shopping_cart({super.key, required this.user});
  final String user;

  @override
  State<shopping_cart> createState() => _shopping_cartState();
}

class _shopping_cartState extends State<shopping_cart> {
  late Future<viewCartResponse> futureCartResponse;

  @override
  void initState() {
    super.initState();
    futureCartResponse = view_cart_api().view_cart(user_id: widget.user);
    Provider.of<CartNotifier>(context, listen: false).refreshCart(widget.user);
  }

  Future<void> _refreshCart() async {
    setState(() {
      futureCartResponse = view_cart_api().view_cart(user_id: widget.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int itemCounts = Provider.of<CartNotifier>(context).itemCount;
    return FutureBuilder<viewCartResponse>(
      future: futureCartResponse,
      builder: (context, snapshot) {
        int itemCount = 0;
        if (snapshot.connectionState == ConnectionState.waiting) {
          itemCount = 0;
        } else if (snapshot.hasError) {
          itemCount = 0;
        } else if (snapshot.hasData) {
          itemCount = snapshot.data!.messages.status.productData.length;
          return Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Navigator.of(context)
                  //     .push(
                  //   MaterialPageRoute(
                  //     builder: (context) => cart_screen(user: widget.user),
                  //   ),
                  // )
                  //     .then((value) {
                  //   Provider.of<CartNotifier>(context, listen: true)
                  //       .refreshCart(widget.user);
                  // });
                },
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              if (itemCounts > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$itemCounts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class CartNotifier extends ChangeNotifier {
  int itemCount = 0;

  Future<void> refreshCart(String userId) async {
    final response = await view_cart_api().view_cart(user_id: userId);
    itemCount = response.messages.status.productData.length;
    notifyListeners();
  }
}
