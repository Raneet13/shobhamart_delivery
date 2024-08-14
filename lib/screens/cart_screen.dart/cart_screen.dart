// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/remove_fromcart.dart';
import '../../api/view_cart.dart';
import '../../components/basic_text.dart';
import '../../components/shopping_cart.dart';
import '../../constants.dart/constants.dart';
import '../../core/theme/base_color.dart';
import '../../models/view_cart_response.dart';

class cart_screen extends StatefulWidget {
  const cart_screen({super.key, required this.user, required this.username});
  final String user;
  final String username;

  @override
  State<cart_screen> createState() => _cart_screenState();
}

class _cart_screenState extends State<cart_screen> {
  late Future<viewCartResponse> futureCartResponse;
  final TextEditingController _couponController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String coupon_discount = '0';
  String delivery_charges = '40';
  @override
  void initState() {
    super.initState();
    futureCartResponse = view_cart_api().view_cart(user_id: widget.user);
  }

  Future<void> _refreshCart() async {
    setState(() {
      futureCartResponse = view_cart_api().view_cart(user_id: widget.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: kToolbarHeight,
        automaticallyImplyLeading: false,
        title: basic_text(
          title: '${widget.username}\'s Cart',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: AppColors.primarycolor2,
        actions: [
          shopping_cart(user: widget.user),
        ],
      ),
      body: FutureBuilder<viewCartResponse>(
        future: futureCartResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No Items available'),
                SizedBox(height: 10),
                // InkWell(
                //   onTap: () => Navigator.of(context).pushReplacement(
                //       MaterialPageRoute(builder: (context) => wrapper())),
                //   child: Container(
                //     height: MediaQuery.of(context).size.height * 0.05,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         border: Border.all(
                //             color: AppColors.primarycolor2, width: 2)),
                //     width: MediaQuery.of(context).size.width * 0.6,
                //     child: Center(
                //         child: basic_text(
                //             title: 'Continue Shopping',
                //             style: Theme.of(context).textTheme.titleMedium!)),
                //   ),
                // )
              ],
            ));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No Items available'));
          } else {
            final cartItem = snapshot.data!;
            return cartItem.messages.status.productData.isEmpty
                ? Center(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No Items available'),
                      SizedBox(height: 10),
                      InkWell(
                        // onTap: () => Navigator.of(context).pushReplacement(
                        //     MaterialPageRoute(builder: (context) => wrapper())),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.primarycolor2, width: 2)),
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Center(
                              child: basic_text(
                                  title: 'Search Products and add',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!)),
                        ),
                      )
                    ],
                  ))
                : RefreshIndicator(
                    onRefresh: _refreshCart,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Form(
                            key: _formKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                // Container(
                                //     height: MediaQuery.of(context).size.height *
                                //         0.07,
                                //     width:
                                //         MediaQuery.of(context).size.width * 0.6,
                                //     decoration: BoxDecoration(
                                //       border:
                                //           Border.all(color: AppColors.grey3),
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //     child: TextFormField(
                                //       validator: (value) {
                                //         if (value == null || value.isEmpty) {
                                //           return 'Please enter a coupon code';
                                //         }
                                //         return null;
                                //       },
                                //       controller: _couponController,
                                //       decoration: InputDecoration(
                                //         hintText: 'Enter Coupon Code',
                                //         border: InputBorder.none,
                                //         contentPadding:
                                //             EdgeInsets.only(left: 10),
                                //       ),
                                //     )),
                                // ElevatedButton(
                                //   style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.black),
                                //   onPressed: () async {
                                //     if (_formKey.currentState!.validate()) {
                                //       final couponResponse =
                                //           await add_coupon_api().add_coupon(
                                //               user_id: widget
                                //                   .user.messages.status.userId,
                                //               coupon_code:
                                //                   _couponController.text);
                                //       if (couponResponse
                                //               .messages.responsecode ==
                                //           '01') {
                                //         if (couponResponse.messages.status.contains(
                                //             'your sub total should be more than')) {
                                //           setState(() {
                                //             coupon_discount = '';
                                //           });
                                //           ScaffoldMessenger.of(context)
                                //               .showSnackBar(SnackBar(
                                //             content: Text(
                                //                 couponResponse.messages.status),
                                //           ));
                                //         } else if (couponResponse
                                //             .messages.status
                                //             .contains(
                                //                 'Your Coupon Amount Is')) {
                                //           String extractCouponAmount(
                                //               String message) {
                                //             RegExp regex = RegExp(r'\d+');
                                //             Match? match =
                                //                 regex.firstMatch(message);
                                //             if (match != null) {
                                //               String amountString =
                                //                   match.group(0)!;
                                //               return amountString ?? '0';
                                //             }
                                //             return '0';
                                //           }

                                //           final amount = extractCouponAmount(
                                //               couponResponse.messages.status);
                                //           setState(() {
                                //             coupon_discount = amount;
                                //           });
                                //           ScaffoldMessenger.of(context)
                                //               .showSnackBar(SnackBar(
                                //             content: Text(
                                //                 couponResponse.messages.status),
                                //           ));
                                //         } else if (couponResponse
                                //             .messages.status
                                //             .contains('Invalid CouponCode')) {
                                //           ScaffoldMessenger.of(context)
                                //               .showSnackBar(SnackBar(
                                //             content: Text(
                                //                 couponResponse.messages.status),
                                //           ));
                                //           setState(() {
                                //             coupon_discount = '';
                                //           });
                                //         }
                                //       }
                                //     }
                                //   },
                                //   child: basic_text(
                                //     title: 'Apply',
                                //     style: TextStyle(
                                //         color: Colors.white, fontSize: 14),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(height: 15),
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                cartItem.messages.status.productData.length,
                            itemBuilder: (context, index) {
                              final item =
                                  cartItem.messages.status.productData[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, right: 8),
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.grey3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl:
                                            '$base_url/uploads/${item.primaryImage}',
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.10,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            basic_text(
                                              title: item.productName,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            basic_text(
                                              title:
                                                  '₹${item.varsalePrice == '' ? item.salesPrice : item.varsalePrice}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  'Qunatity: ${item.qty}',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () async {
                                                  await remove_fromcart_api()
                                                      .remove_fromcart(
                                                          cart_id: item.cartId);
                                                  Provider.of<CartNotifier>(
                                                          context,
                                                          listen: false)
                                                      .refreshCart(widget.user);
                                                  await _refreshCart();
                                                },
                                                child: basic_text(
                                                    title: 'Remove',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
          }
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[200],
        height: MediaQuery.of(context).size.height * 0.07,
        child: FutureBuilder<viewCartResponse>(
          future: futureCartResponse,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Container());
            } else if (snapshot.hasError) {
              return Container();
            } else if (!snapshot.hasData) {
              return Center(child: Text('No Items available'));
            } else {
              final cartItem = snapshot.data!;
              int totalAmount =
                  calculateTotal(cartItem.messages.status.productData);
              return cartItem.messages.status.productData.isEmpty
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            basic_text(
                              title: '₹$totalAmount',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => order_summary_screen(
                            //           cartItems:
                            //               cartItem.messages.status.productData,
                            //           couponDiscount: coupon_discount,
                            //           deliveryCharges: delivery_charges,
                            //           coupon_code: _couponController.text,
                            //           user: widget.user,
                            //         )));
                          },
                          child: basic_text(
                            title: 'Checkout',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    );
            }
          },
        ),
      ),
    );
  }

  int calculateTotal(List<viewCartProductData> cartItems) {
    int total = 0;
    for (var item in cartItems) {
      try {
        final price = int.parse(
            item.varsalePrice == '' ? item.salesPrice : item.varsalePrice);
        final quantity = int.parse(item.qty);
        if (coupon_discount == '') {
          total += price * quantity;
        } else {
          total += price * quantity;
        }

        print('Totalss: $total');
      } catch (e) {
        print('Error parsing price or quantity: $e');
      }
    }
    if (coupon_discount != '') {
      total = total - int.parse(coupon_discount);
    } else {
      total = total;
    }
    return total;
  }
}

class cartItem {
  String id;
  String productName;
  String salesPrice;
  String qty;
  String primaryImage;
  String cartId;
  int quantity;

  cartItem({
    required this.id,
    required this.productName,
    required this.salesPrice,
    required this.qty,
    required this.primaryImage,
    required this.cartId,
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier {
  List<cartItem> _cartItems = [];

  List<cartItem> get cartItems => _cartItems;

  void addToCart(cartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void updateQuantity(String cartId, int newQuantity) {
    final itemIndex = _cartItems.indexWhere((item) => item.cartId == cartId);
    if (itemIndex != -1) {
      _cartItems[itemIndex].qty = newQuantity.toString();
      notifyListeners();
    }
  }

  void setCartItems(List<cartItem> items) {
    _cartItems = items;
    notifyListeners();
  }
}
