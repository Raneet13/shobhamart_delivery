// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sm_delivery/api/checkout.dart';
import 'package:sm_delivery/api/order_delivery_status.dart';
import 'package:sm_delivery/api/order_details.dart';
import 'package:sm_delivery/api/update_quantity.dart';
import 'package:sm_delivery/constants.dart/constants.dart';
import 'package:sm_delivery/core/utils/shared_preference.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';
import 'package:sm_delivery/models/order_response.dart';
import 'package:sm_delivery/models/single_product_response.dart';
import 'package:sm_delivery/navbar.dart';
import 'package:sm_delivery/screens/delivery_detailed_screen/widgets/payment_poll.dart';
import 'package:sm_delivery/screens/delivery_detailed_screen/widgets/payment_status.dart';
import 'package:sm_delivery/screens/search_screen.dart/search_screen.dart';
import '../../api/variation.dart';
import '../../components/basic_text.dart';
import '../../components/text_box.dart';
import '../../core/theme/base_color.dart';
import '../../models/order_details_response.dart';

class delivery_detailed_screen extends StatefulWidget {
  const delivery_detailed_screen(
      {super.key, required this.orderresponse, required this.userDetails});
  final Order orderresponse;
  final userResponse userDetails;

  @override
  State<delivery_detailed_screen> createState() =>
      _delivery_detailed_screenState();
}

class _delivery_detailed_screenState extends State<delivery_detailed_screen> {
  late Future<orderDetailedResponse> orderDetailedresponse;
  late Future<List<UserProductResponse>> savedcartDetailedresponse;
  final TextEditingController _cashController = TextEditingController();

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

  Future<void> _refreshCart() async {
    if (!mounted) return;

    setState(() {
      savedcartDetailedresponse = SharedPreferencesService()
          .getUserProductResponses(
              widget.orderresponse.userId, widget.orderresponse.orderId);
    });

    final savedCartResponses = await savedcartDetailedresponse;

    if (mounted) {
      setState(() {
        savedcartDetailedresponse = Future.value(savedCartResponses);
      });
    }
  }

  Future<void> _refreshOrder() async {
    if (!mounted) return;

    setState(() {
      orderDetailedresponse = order_detailed_api().order_detailed(
          order_id: widget.orderresponse.orderId,
          user_id: widget.orderresponse.userId);
      savedcartDetailedresponse = SharedPreferencesService()
          .getUserProductResponses(
              widget.orderresponse.userId, widget.orderresponse.orderId);
    });

    final orderDetails = await orderDetailedresponse;
    final savedCartResponses = await savedcartDetailedresponse;

    for (var order in orderDetails.data) {
      // Fetch variation details
      final futureVariationResponse = await variation_api().variation_details(
        user_id: widget.userDetails.messages.status.userId,
        variation_id: order.variationId,
      );
      print('Variation Response: $futureVariationResponse');

      // Check if an item with the same orderId, productName, and qty exists
      bool itemExists = savedCartResponses.any((savedItem) =>
          savedItem.productName == order.productName &&
          savedItem.userId == widget.orderresponse.userId &&
          savedItem.orderId == order.orderId);

      if (!itemExists) {
        // Add the current order item with variation details to the saved cart list if not already existing
        savedCartResponses.add(UserProductResponse(
          productName: order.productName,
          userId: order.userId,
          orderId: order.orderId,
          qty: double.parse(order.qty).toInt(),
          img: futureVariationResponse
                  .messages.status.variationDetails.isNotEmpty
              ? futureVariationResponse
                  .messages.status.variationDetails[0].image
              : order.img,
          price: futureVariationResponse
                  .messages.status.variationDetails.isNotEmpty
              ? futureVariationResponse
                  .messages.status.variationDetails[0].salePrice
              : order.price,
          variation: futureVariationResponse
                  .messages.status.variationDetails.isNotEmpty
              ? futureVariationResponse
                  .messages.status.variationDetails[0].priceVariationId
              : '',
        ));
      }
    }
    await SharedPreferencesService()
        .storeUserProductResponses(savedCartResponses);

    if (mounted) {
      setState(() {
        savedcartDetailedresponse = Future.value(savedCartResponses);
      });
    }
    await SharedPreferencesService()
        .storeUserProductResponses(savedCartResponses);

    if (mounted) {
      setState(() {
        savedcartDetailedresponse = Future.value(savedCartResponses);
      });
    }
  }

  void _navigateAndRefresh(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => search_screen(
                order_data: widget.orderresponse,
                user: widget.orderresponse.userId,
              )),
    );

    if (result == true) {
      widget.orderresponse.status == 5
          ? setState(() {
              orderDetailedresponse = order_detailed_api().order_detailed(
                  order_id: widget.orderresponse.orderId,
                  user_id: widget.orderresponse.userId);
              savedcartDetailedresponse = SharedPreferencesService()
                  .getUserProductResponses(widget.orderresponse.userId,
                      widget.orderresponse.orderId);
            })
          : _refreshOrder();
    }
  }

  var deliveryCharges = 0;

  @override
  void initState() {
    _refreshOrder();
    orderDetailedresponse = order_detailed_api().order_detailed(
        order_id: widget.orderresponse.orderId,
        user_id: widget.orderresponse.userId);
    super.initState();
  }

  List<String> getProductNameList(List<orderDetails> cartItems,
      List<UserProductResponse> savedcartDetaileddata) {
    List<String> productNameList = [];
    // for (var item in cartItems) {
    //   productNameList.add(item.productName);
    // }
    for (var item in savedcartDetaileddata) {
      productNameList.add(item.productName);
    }
    print('Product Name List: $productNameList');
    return productNameList;
  }

  List<int> getProductqty(List<orderDetails> cartItems,
      List<UserProductResponse> savedcartDetaileddata) {
    List<int> productqtyList = [];

    // for (var item in cartItems) {
    //   final qty = int.tryParse(item.qty) ?? 0;
    //   productqtyList.add(qty);
    // }
    for (var item in savedcartDetaileddata) {
      productqtyList.add(item.qty);
    }
    print('Product qty List: $productqtyList');
    return productqtyList;
  }

  List<String> getProductImgList(List<orderDetails> cartItems,
      List<UserProductResponse> savedcartDetaileddata) {
    List<String> productImgList = [];
    // for (var item in cartItems) {
    //   productImgList.add(item.img);
    // }
    for (var item in savedcartDetaileddata) {
      productImgList.add(item.img);
    }
    print('Product Img List: $productImgList');
    return productImgList;
  }

  List<num> getProductPrice(List<orderDetails> cartItems,
      List<UserProductResponse> savedcartDetaileddata) {
    List<num> productPriceList = [];

    // for (var item in cartItems) {
    //   final qty = double.tryParse(item.price) ?? 0;
    //   print('item price: ${qty}');
    //   productPriceList.add(qty);
    // }
    for (var item in savedcartDetaileddata) {
      final qty = double.tryParse(item.price) ?? 0;
      productPriceList.add(qty);
    }
    print('Product Price List: $productPriceList');
    return productPriceList;
  }

  List<int> getProductVar(List<orderDetails> cartItems,
      List<UserProductResponse> savedcartDetaileddata) {
    List<int> productVarList = [];

    // for (var item in cartItems) {
    //   final qty = int.tryParse(item.variationId) ?? 0;
    //   productVarList.add(qty);
    // }
    for (var item in savedcartDetaileddata) {
      final qty = int.tryParse(item.variation) ?? 0;

      productVarList.add(qty);
    }
    print('Product qty List: $productVarList');
    return productVarList;
  }

  int calculateTotalEach(UserProductResponse data) {
    int total = 0;
    try {
      final price = double.tryParse(data.price) ?? 0.0;

      if (price > 0 && data.qty > 0) {
        total += (price * data.qty).toInt();
      } else {}
    } catch (e) {}
    return total;
  }

  num calculateTotalPrice(List<orderDetails> cartItems,
      List<UserProductResponse> savedcartDetaileddata) {
    num total = 0;
    // for (var item in cartItems) {
    //   print("item price fhebh: ${item.price}, quantity: ${item.qty}");

    //   try {
    //     final price = double.tryParse(item.price) ?? 0.0;
    //     final quantity = int.tryParse(item.qty) ?? 0;
    //     final couponAmount = int.tryParse(item.couponAmount) ?? 0;

    //     if (price > 0 && quantity > 0) {
    //       total += (price * quantity).toInt();
    //       print('Total: $total');
    //     } else {}
    //   } catch (e) {}
    // }
    for (var item in savedcartDetaileddata) {
      try {
        final price = double.tryParse(item.price) ?? 0.0;
        if (price > 0 && item.qty > 0) {
          total += (price * item.qty);
          print('Total2: $total');
        } else {}
      } catch (e) {}
    }
    return total;
  }

  num calculateTotalCompletedPrice(List<orderDetails> cartItems) {
    num total = 0;
    for (var item in cartItems) {
      print("item price fhebh: ${item.price}, quantity: ${item.qty}");

      try {
        final price = double.tryParse(item.price) ?? 0.0;
        final quantity = int.tryParse(item.qty) ?? 0;

        if (price > 0 && quantity > 0) {
          total += (price * quantity);
          print('Total: $total');
        } else {}
      } catch (e) {}
    }
    return total;
  }

  num calculateTotal(List<orderDetails> cartItems,
      List<UserProductResponse> savedcartDetaileddata) {
    num total = 0;

    // for (var item in cartItems) {
    //   try {
    //     final price = double.tryParse(item.price) ?? 0.0;
    //     final quantity = int.tryParse(item.qty) ?? 0;
    //     final couponAmount = int.tryParse(item.couponAmount) ?? 0;

    //     if (price > 0 && quantity > 0) {
    //       total += (price * quantity).toInt();
    //     } else {}
    //   } catch (e) {}
    // }
    for (var item in savedcartDetaileddata) {
      print("item price fhebh: ${item.price}, quantity: ${item.qty}");
      try {
        final price = double.tryParse(item.price) ?? 0.0;
        final quantity = item.qty;
        if (price > 0 && quantity > 0) {
          total += (price * quantity);
        } else {}
      } catch (e) {}
    }

    final couponAmount = int.tryParse(cartItems[0].couponAmount) ?? 0;
    total = total - couponAmount;

    print('Final total after applying coupon: $total');
    return total;
  }

  num calculateTotalCompleted(List<orderDetails> cartItems,
      List<UserProductResponse> savedcartDetaileddata) {
    num total = 0;

    for (var item in cartItems) {
      try {
        final price = double.parse(item.price) ?? 0.0;
        final quantity = int.parse(item.qty) ?? 0;
        final couponAmount = int.parse(item.couponAmount) ?? 0;

        if (price > 0 && quantity > 0) {
          total += (price * quantity);
        } else {}
      } catch (e) {}
    }

    final couponAmount = double.parse(cartItems[0].couponAmount) ?? 0;
    total = total - couponAmount;

    print('Final total after applying coupon: $total');
    return total;
  }

  num finalPrice(num actualPrice, String deliveryCharges, String oldcredit,
      String intrestamount) {
    num finalPrice = 0;
    final shipping =
        double.parse(deliveryCharges == '' ? '0' : deliveryCharges);
    final credit = double.parse(oldcredit == '' ? '0' : oldcredit);
    final intrest = double.parse(intrestamount == '' ? '0' : intrestamount);
    finalPrice = finalPrice + shipping + actualPrice + credit + intrest;
    print('final Price:${finalPrice}');
    return finalPrice;
  }

  num paidAmount(List<TransactionDetails> cartItems) {
    num total = 0;
    for (var items in cartItems) {
      total = total + double.parse(items.paidAmount);
    }
    return total;
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
                icon:
                    const Icon(Icons.arrow_back, size: 30, color: Colors.white),
                onPressed: () async {
                  await SharedPreferencesService().removeItemsByOrderId(
                      widget.orderresponse.orderId,
                      widget.orderresponse.userId);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => navbar(
                                userDetail: widget.userDetails,
                              )),
                      (route) => false);
                },
              );
            },
          ),
          title: basic_text(
              title: widget.orderresponse.orderId,
              style: TextStyle(color: Colors.white, fontSize: 16)),
          actions: [
            widget.orderresponse.status == '5'
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Card(
                      color: Colors.transparent,
                      elevation: 6,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            widget.orderresponse.cutomerName.isEmpty
                                ? ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Unauthorized User'),
                                      backgroundColor: Colors.red,
                                    ),
                                  )
                                : _navigateAndRefresh(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: basic_text(
                                title: 'Add',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 14,
                                        color: AppColors.primarycolor2,
                                        fontWeight: FontWeight.w500)),
                          )),
                    ),
                  ),
          ],
          backgroundColor: AppColors.primarycolor2,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshCart,
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
                    child: FutureBuilder<List<UserProductResponse>>(
                        future: savedcartDetailedresponse,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            List<UserProductResponse> neworderDetails =
                                snapshot.data;
                            // print('New Order Details: $neworderDetails');
                            List<UserProductResponse> filterData =
                                neworderDetails
                                    .where((element) =>
                                        element.userId ==
                                            widget.orderresponse.userId &&
                                        element.orderId ==
                                            widget.orderresponse.orderId)
                                    .toList();
                            print('Filter Data: $filterData');
                            return filterData.isEmpty
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // SizedBox(
                                        //     height: MediaQuery.of(context)
                                        //             .size
                                        //             .height *
                                        //         0.05),
                                        widget.orderresponse.status == '5'
                                            ? ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemCount:
                                                    orderDetails.data.length,
                                                itemBuilder: (context, index) {
                                                  bool isUpdating =
                                                      updateIndices
                                                          .contains(index);
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: InkWell(
                                                      onTap: () {},
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            CachedNetworkImage(
                                                              imageUrl:
                                                                  '$base_url/uploads/${orderDetails.data[index].img}',
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.10,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.23,
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                            SizedBox(width: 10),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.55,
                                                                  child: Text(
                                                                    orderDetails
                                                                        .data[
                                                                            index]
                                                                        .productName,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        overflow:
                                                                            TextOverflow.clip),
                                                                  ),
                                                                ),
                                                                !isUpdating
                                                                    ? Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          basic_text(
                                                                            title:
                                                                                'Quantity: ${orderDetails.data[index].qty}',
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.grey[400],
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                          SizedBox(
                                                                              width: 20),
                                                                          orderDetails.data[0].status == '5' || orderDetails.data[0].status == '3'
                                                                              ? Container()
                                                                              : InkWell(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      if (updateIndices.contains(index)) {
                                                                                        updateIndices.remove(index);
                                                                                      }
                                                                                      updateIndices.add(index);
                                                                                    });
                                                                                  },
                                                                                  child: Text(
                                                                                    'Edit',
                                                                                    style: TextStyle(color: Colors.red),
                                                                                  ),
                                                                                )
                                                                        ],
                                                                      )
                                                                    : Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              IconButton(
                                                                                onPressed: () async {
                                                                                  await SharedPreferencesService().decrementQuantity(
                                                                                    orderDetails.data[index].productName, // Assuming productName is used as identifier
                                                                                    widget.orderresponse.userId,
                                                                                    widget.orderresponse.orderId,
                                                                                  );
                                                                                  setState(() {
                                                                                    new_quan--; // Decrement the UI quantity
                                                                                  });
                                                                                },
                                                                                icon: Icon(Icons.remove),
                                                                              ),
                                                                              Text(new_quan.toString()),
                                                                              IconButton(
                                                                                onPressed: () async {
                                                                                  await SharedPreferencesService().incrementQuantity(
                                                                                    orderDetails.data[index].productName, // Assuming productName is used as identifier
                                                                                    widget.orderresponse.userId,
                                                                                    widget.orderresponse.orderId,
                                                                                  );
                                                                                  setState(() {
                                                                                    new_quan++; // Increment the UI quantity
                                                                                  });
                                                                                },
                                                                                icon: Icon(Icons.add),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              new_quan.toString() != orderDetails.data[index].qty
                                                                                  ? TextButton(
                                                                                      onPressed: () async {
                                                                                        final result = await update_quantity_api().update_quantity(
                                                                                          orders_id: orderDetails.data[index].ordersId,
                                                                                          qty: new_quan.toString(),
                                                                                        );
                                                                                        if (result.message.isNotEmpty) {
                                                                                          _refreshOrder();
                                                                                        }
                                                                                      },
                                                                                      child: basic_text(
                                                                                        title: 'Update',
                                                                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.primarycolor2),
                                                                                      ),
                                                                                    )
                                                                                  : Container(),
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    updateIndices.remove(index);
                                                                                  });
                                                                                },
                                                                                child: basic_text(
                                                                                  title: 'Cancel',
                                                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.red),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                !isUpdating
                                                                    ? Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.65,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              '₹' + orderDetails.data[index].price,
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: AppColors.primarycolor2,
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                          ],
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
                                              )
                                            :
                                            //saved OrderData
                                            Container(
                                                child: SingleChildScrollView(
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                    SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.01),
                                                    ListView.builder(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      shrinkWrap: true,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      itemCount:
                                                          filterData.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: InkWell(
                                                            onTap: () {},
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.9,
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    imageUrl:
                                                                        '$base_url/uploads/${filterData[index].img}',
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.10,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.23,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.55,
                                                                        child:
                                                                            Text(
                                                                          filterData[index]
                                                                              .productName,
                                                                          maxLines:
                                                                              2,
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w500,
                                                                              overflow: TextOverflow.clip),
                                                                        ),
                                                                      ),
                                                                      widget.orderresponse.status ==
                                                                              '5'
                                                                          ? Text(
                                                                              'Quantity: ' + filterData[index].qty.toString(),
                                                                              style: TextStyle(color: Colors.grey),
                                                                            )
                                                                          : Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                InkWell(
                                                                                  onTap: () async {
                                                                                    await SharedPreferencesService().decrementQuantity(
                                                                                      filterData[index].productName,
                                                                                      widget.orderresponse.userId,
                                                                                      widget.orderresponse.orderId,
                                                                                    );
                                                                                    setState(() {
                                                                                      filterData[index].qty--;
                                                                                    });
                                                                                  },
                                                                                  child: Icon(Icons.remove),
                                                                                ),
                                                                                SizedBox(width: 10),
                                                                                Text(filterData[index].qty.toString()),
                                                                                SizedBox(width: 10),
                                                                                InkWell(
                                                                                  onTap: () async {
                                                                                    await SharedPreferencesService().incrementQuantity(
                                                                                      filterData[index].productName,
                                                                                      widget.orderresponse.userId,
                                                                                      widget.orderresponse.orderId,
                                                                                    );
                                                                                    setState(() {
                                                                                      filterData[index].qty++;
                                                                                    });
                                                                                  },
                                                                                  child: Icon(Icons.add),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                      Container(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.65,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              '₹' + filterData[index].price,
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: AppColors.primarycolor2,
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                            TextButton(
                                                                                onPressed: () async {
                                                                                  await SharedPreferencesService().removeSingleItemsByOrderId(filterData[index].orderId, filterData[index].userId, filterData[index].productName).then((value) {
                                                                                    _refreshOrder();
                                                                                  });
                                                                                },
                                                                                child: Text('Delete', style: TextStyle(color: Colors.red, fontSize: 14))),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  ]))),

                                        // widget.orderresponse.status == '5'
                                        //     ? Container()
                                        //     : Padding(
                                        //         padding: const EdgeInsets.all(8.0),
                                        //         child: Column(
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           children: [
                                        //             basic_text(
                                        //                 title: 'Payment Mode',
                                        //                 style: Theme.of(context)
                                        //                     .textTheme
                                        //                     .titleSmall!
                                        //                     .copyWith(
                                        //                         color: AppColors
                                        //                             .primarycolor2,
                                        //                         fontWeight:
                                        //                             FontWeight.w600)),
                                        //             payment_poll(),
                                        //             Container(
                                        //               width: MediaQuery.of(context)
                                        //                       .size
                                        //                       .width *
                                        //                   0.6,
                                        //               child: text_box(
                                        //                   value: _cashController,
                                        //                   height: MediaQuery.of(context)
                                        //                           .size
                                        //                           .height *
                                        //                       0.06,
                                        //                   title: '',
                                        //                   hint: 'Enter Cash Collected',
                                        //                   obsureText: false),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ),
                                        widget.orderresponse.deliveryAddress
                                                .isEmpty
                                            ? Container()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    basic_text(
                                                        title:
                                                            'Delivery Address:',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                                color: AppColors
                                                                    .primarycolor2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                    widget
                                                            .orderresponse
                                                            .deliveryAddress
                                                            .isEmpty
                                                        ? Container()
                                                        : Container(
                                                            width:
                                                                double.infinity,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[200],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                basic_text(
                                                                    title: widget
                                                                        .orderresponse
                                                                        .cutomerName,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        overflow:
                                                                            TextOverflow.clip)),
                                                                basic_text(
                                                                    title: widget
                                                                        .orderresponse
                                                                        .deliveryAddress,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        overflow:
                                                                            TextOverflow.clip)),
                                                                basic_text(
                                                                    title: widget
                                                                            .orderresponse
                                                                            .cityName +
                                                                        ', ' +
                                                                        widget
                                                                            .orderresponse
                                                                            .stateName +
                                                                        '-' +
                                                                        widget
                                                                            .orderresponse
                                                                            .pincode,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        overflow:
                                                                            TextOverflow.clip)),
                                                                basic_text(
                                                                    title: widget
                                                                        .orderresponse
                                                                        .customerContactno,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: AppColors
                                                                            .primarycolor2,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        overflow:
                                                                            TextOverflow.clip)),
                                                              ],
                                                            ),
                                                          )
                                                  ],
                                                ),
                                              ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                basic_text(
                                                  title: 'Price Details',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    basic_text(
                                                      title:
                                                          'Price (${widget.orderresponse.status == '5' ? orderDetails.data.length : filterData.length} items)',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                    widget.orderresponse
                                                                .status ==
                                                            '5'
                                                        ? basic_text(
                                                            title: '₹' +
                                                                calculateTotalCompletedPrice(
                                                                  orderDetails
                                                                      .data,
                                                                ).toStringAsFixed(
                                                                    2),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                    color: Colors
                                                                        .black),
                                                          )
                                                        : basic_text(
                                                            title: '₹' +
                                                                calculateTotalPrice(
                                                                        orderDetails
                                                                            .data,
                                                                        filterData)
                                                                    .toString(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                price_element(
                                                    context,
                                                    'Coupon Discount',
                                                    double.parse(orderDetails
                                                            .data[0]
                                                            .couponAmount)
                                                        .toStringAsFixed(2),
                                                    Colors.green),
                                                SizedBox(height: 10),
                                                price_element(
                                                    context,
                                                    'Delivery Charges',
                                                    '${orderDetails.data[0].shippingCharge != '' ? double.parse(orderDetails.data[0].shippingCharge!).toStringAsFixed(2) : 0.00}',
                                                    Colors.black),
                                                Divider(),
                                                price_element(
                                                    context,
                                                    'Credit Amount',
                                                    '${orderDetails.dueAmount != '' ? orderDetails.dueAmount.toStringAsFixed(2) : 0.00}',
                                                    Colors.black),
                                                price_element(
                                                    context,
                                                    'Intrest Amount',
                                                    '${orderDetails.interestAmount != '' ? orderDetails.interestAmount.toStringAsFixed(2) : 0}',
                                                    Colors.black),
                                                Divider(),
                                                widget.orderresponse.status ==
                                                        '5'
                                                    ? price_element(
                                                        context,
                                                        'Total Amount',
                                                        finalPrice(
                                                                calculateTotalCompleted(
                                                                    orderDetails
                                                                        .data,
                                                                    filterData),
                                                                orderDetails
                                                                            .data[
                                                                                0]
                                                                            .shippingCharge !=
                                                                        null
                                                                    ? orderDetails
                                                                        .data[0]
                                                                        .shippingCharge!
                                                                    : '0.0',
                                                                orderDetails
                                                                    .dueAmount
                                                                    .toString(),
                                                                orderDetails
                                                                    .interestAmount
                                                                    .toString())
                                                            .toString(),
                                                        Colors.black)
                                                    : price_element(
                                                        context,
                                                        'Total Amount',
                                                        finalPrice(
                                                                calculateTotal(
                                                                    orderDetails
                                                                        .data,
                                                                    filterData),
                                                                orderDetails
                                                                    .data[0]
                                                                    .shippingCharge!,
                                                                orderDetails
                                                                    .dueAmount
                                                                    .toString(),
                                                                orderDetails
                                                                    .interestAmount
                                                                    .toString())
                                                            .toStringAsFixed(2),
                                                        Colors.black),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    basic_text(
                                                      title: 'Paid Amount',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                    basic_text(
                                                      title: '₹' +
                                                          paidAmount(orderDetails
                                                                  .transactionDetails)
                                                              .toStringAsFixed(
                                                                  2),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                  ],
                                                ),
                                                // Row(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.spaceBetween,
                                                //   children: [
                                                //     basic_text(
                                                //       title: 'Credit Amount',
                                                //       style: Theme.of(context)
                                                //           .textTheme
                                                //           .bodyLarge!
                                                //           .copyWith(color: Colors.black),
                                                //     ),
                                                //     basic_text(
                                                //       title: '₹' +
                                                //           (finalPrice(
                                                //                       calculateTotal(
                                                //                           orderDetails
                                                //                               .data,
                                                //                           filterData),
                                                //                       orderDetails.data[0]
                                                //                           .shippingCharge!) -
                                                //                   paidAmount(orderDetails
                                                //                       .transactionDetails))
                                                //               .toString(),
                                                //       style: Theme.of(context)
                                                //           .textTheme
                                                //           .bodyLarge!
                                                //           .copyWith(
                                                //               color: Colors.red,
                                                //               fontWeight:
                                                //                   FontWeight.w400),
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                        )
                                      ],
                                    ),
                                  );
                          }
                        }));
              }
            },
          ),
        ),
        bottomNavigationBar: RefreshIndicator(
          onRefresh: _refreshCart,
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
                      color: orderDetails.data[0].status == '5'
                          ? Colors.green
                          : Colors.transparent,
                      child: FutureBuilder(
                          future: savedcartDetailedresponse,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              print(snapshot.error);
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              List<UserProductResponse> neworderDetails =
                                  snapshot.data;
                              List<UserProductResponse> filterData =
                                  neworderDetails
                                      .where((element) =>
                                          element.userId ==
                                          widget.orderresponse.userId)
                                      .toList();
                              return Container(
                                color: Colors.transparent,
                                child: orderDetails.data[0].status == '5'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              'Order Delivered',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      )
                                    : widget.orderresponse.status == '3'
                                        ? Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              'Order Cancelled',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(color: Colors.red),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              // ElevatedButton(
                                              //     style:
                                              //         ElevatedButton.styleFrom(
                                              //             backgroundColor:
                                              //                 Colors.red),
                                              //     onPressed: () async {
                                              //       showDialog(
                                              //           context: context,
                                              //           builder: (context) {
                                              //             return AlertDialog(
                                              //               title: Text(
                                              //                   'Cancel Your Delivery'),
                                              //               content: Text(
                                              //                   'Are you sure you want to cancel the delivery?'),
                                              //               actions: [
                                              //                 TextButton(
                                              //                   onPressed: () {
                                              //                     Navigator.pop(
                                              //                         context);
                                              //                   },
                                              //                   child:
                                              //                       Text('No'),
                                              //                 ),
                                              //                 TextButton(
                                              //                   onPressed:
                                              //                       () async {
                                              //                     final result = await order_delivery_status_api().order_delivery_status(
                                              //                         orderid: widget
                                              //                             .orderresponse
                                              //                             .orderId,
                                              //                         status:
                                              //                             '3');
                                              //                     if (result
                                              //                             .messages
                                              //                             .status ==
                                              //                         'Order Deliverey Succesfully') {
                                              //                       Navigator.pop(
                                              //                           context);
                                              //                     }
                                              //                     Navigator.pop(
                                              //                         context);
                                              //                   },
                                              //                   child:
                                              //                       Text('Yes'),
                                              //                 ),
                                              //               ],
                                              //             );
                                              //           });
                                              //     },
                                              //     child: Padding(
                                              //       padding: const EdgeInsets
                                              //           .symmetric(
                                              //           horizontal: 14),
                                              //       child: basic_text(
                                              //           title: 'Cancel',
                                              //           style: Theme.of(context)
                                              //               .textTheme
                                              //               .bodyText1!
                                              //               .copyWith(
                                              //                   color: Colors
                                              //                       .white,
                                              //                   fontWeight:
                                              //                       FontWeight
                                              //                           .w500)),
                                              //     )),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      minimumSize: Size(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.05),
                                                      backgroundColor: AppColors
                                                          .primarycolor2),
                                                  onPressed: () async {
                                                    // if (final_mode_pay == 3) {
                                                    showPaidAmountDialog(
                                                        context,
                                                        orderDetails,
                                                        filterData,
                                                        orderDetails.data[0]
                                                            .shippingCharge!,
                                                        orderDetails.dueAmount
                                                            .toString(),
                                                        orderDetails
                                                            .interestAmount
                                                            .toString());
                                                    // } else if (final_mode_pay ==
                                                    //     1) {
                                                    //   showCashConfirm(
                                                    //       context,
                                                    //       orderDetails,
                                                    //       filterData);
                                                    // } else {
                                                    //   ScaffoldMessenger.of(
                                                    //           context)
                                                    //       .showSnackBar(SnackBar(
                                                    //           backgroundColor:
                                                    //               Colors.red,
                                                    //           content: Text(
                                                    //               'Please select payment mode')));
                                                    // }
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 14),
                                                    child: basic_text(
                                                        title: 'Submit',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                  )),
                                            ],
                                          ),
                              );
                            }
                          }));
                }
              }),
        ));
  }

  Row price_element(
      BuildContext context, String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        basic_text(
          title: title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.black),
        ),
        basic_text(
          title: '₹${value}',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: color),
        ),
      ],
    );
  }

  Future<dynamic> showCashConfirm(
      BuildContext context,
      orderDetailedResponse orderDetails,
      List<UserProductResponse> filterData) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Your Delivery'),
            content: Text('Are you sure you want to confirm the delivery?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  final userStatus vendorStatus =
                      widget.userDetails.messages.status;
                  if (_cashController.text.isNotEmpty) {
                    final num intrest_amount_paid =
                        double.parse(_cashController.text) -
                            calculateTotalCompletedPrice(
                              orderDetails.data,
                            );
                    print(intrest_amount_paid);
                    final result = await checkout_api().checkout(
                        user_id: widget.orderresponse.userId,
                        vendor_id: vendorStatus.userId,
                        coupon_code: widget.orderresponse.couponCode,
                        cupon_price:
                            double.tryParse(widget.orderresponse.couponAmnt) ??
                                0,
                        order_id: widget.orderresponse.orderId,
                        paymentmode: widget.orderresponse.paymentMode,
                        paid_amount: double.parse(_cashController.text),
                        transaction_id: '',
                        product_name:
                            getProductNameList(orderDetails.data, filterData),
                        qty: getProductqty(orderDetails.data, filterData),
                        product_image:
                            getProductImgList(orderDetails.data, filterData),
                        sale_price:
                            getProductPrice(orderDetails.data, filterData),
                        variation_id:
                            getProductVar(orderDetails.data, filterData),
                        paid_intrest: intrest_amount_paid <= 0
                            ? '0'
                            : intrest_amount_paid.toString());
                    if (result.messages.status ==
                        'Your Order Placed Successfully') {
                      await SharedPreferencesService()
                          .removeItemsByOrderId(widget.orderresponse.orderId,
                              widget.orderresponse.userId)
                          .then((value) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => navbar(
                                      userDetail: widget.userDetails,
                                    )),
                            (route) => false);
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.yellow,
                        content: Text('Please enter collected cash Amount')));
                  }
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

//Real Box
  void showPaidAmountDialog(
      BuildContext context,
      orderDetailedResponse orderDetails,
      List<UserProductResponse> filterData,
      String deliveryCharges,
      String oldcredit,
      String intrestamount) {
    double _rating = 0.0;
    TextEditingController _reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Your Paid Amount',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              basic_text(
                  title:
                      'Total Amount: ${finalPrice(calculateTotal(orderDetails.data, filterData), deliveryCharges, oldcredit, intrestamount)}',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              text_box(
                value: _reviewController,
                title: 'Username',
                hint: 'Paid Amount',
                height: MediaQuery.of(context).size.height * 0.08,
                obsureText: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your review';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(40, 50),
                backgroundColor: AppColors.primarycolor2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final input_amount = calculateCredit(
                    finalPrice(calculateTotal(orderDetails.data, filterData),
                            deliveryCharges, oldcredit, intrestamount)
                        .toDouble(),
                    double.parse(_reviewController.text));
                final num intrest_amount_paid =
                    double.parse(_reviewController.text) -
                        calculateTotalCompletedPrice(
                          orderDetails.data,
                        );
                print('Input Amount: ${input_amount}');
                if (input_amount < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Paid Amount Should be less than or equal to Total Amount'),
                      backgroundColor: Colors.red));
                  return;
                } else {
                  final result = await checkout_api().checkout(
                      user_id: widget.orderresponse.userId,
                      vendor_id: widget.userDetails.messages.status.userId,
                      coupon_code: widget.orderresponse.couponCode,
                      cupon_price:
                          double.tryParse(widget.orderresponse.couponAmnt) ?? 0,
                      order_id: widget.orderresponse.orderId,
                      paymentmode: widget.orderresponse.paymentMode,
                      paid_amount: double.parse(_reviewController.text),
                      transaction_id: '',
                      product_name:
                          getProductNameList(orderDetails.data, filterData),
                      qty: getProductqty(orderDetails.data, filterData),
                      product_image:
                          getProductImgList(orderDetails.data, filterData),
                      sale_price:
                          getProductPrice(orderDetails.data, filterData),
                      variation_id:
                          getProductVar(orderDetails.data, filterData),
                      paid_intrest: intrest_amount_paid <= 0
                          ? '0'
                          : intrest_amount_paid.toString());
                  if (result.messages.status ==
                      'Your Order Placed Successfully') {
                    await SharedPreferencesService()
                        .removeItemsByOrderId(widget.orderresponse.orderId,
                            widget.orderresponse.userId)
                        .then((value) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => navbar(
                                    userDetail: widget.userDetails,
                                  )),
                          (route) => false);
                    });
                  }
                }
              },
              child: Text('Submit',
                  style: TextStyle(fontFamily: 'Roboto', color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  double calculateCredit(double totalAmount, double paidAmount) {
    return totalAmount - paidAmount;
  }
}
