import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sm_delivery/api/view_cart.dart';
import 'package:sm_delivery/core/utils/shared_preference.dart';
import 'package:sm_delivery/screens/search_screen.dart/search_screen.dart';

import '../../api/order_details.dart';
import '../../api/update_quantity.dart';
import '../../api/variation.dart';
import '../../components/basic_text.dart';
import '../../constants.dart/constants.dart';
import '../../core/theme/base_color.dart';
import '../../models/login_details/user_detail.dart';
import '../../models/order_details_response.dart';
import '../../models/order_response.dart';
import '../../models/single_product_response.dart';
import '../../navbar.dart';

class UpdateProductScreen extends StatefulWidget {
  UpdateProductScreen(
      {super.key,this.isCompleted, required this.orderresponse, required this.userDetails});
      bool? isCompleted=false;
  final Datum orderresponse;
  final userResponse userDetails;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
   late Future<orderDetailedResponse> orderDetailedresponse;
   late Future<List<UserProductResponse>> savedcartDetailedresponse;
   bool isLoading = false;
   late final FocusNode focusNode;
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
    if (!mounted) return;

 

    orderDetailedresponse = order_detailed_api().order_detailed(
          order_id: widget.orderresponse.orderId??"",
          user_id: widget.orderresponse.products?.first.userId??"");
      
      savedcartDetailedresponse = SharedPreferencesService()
          .getUserProductResponses(
              widget.orderresponse.products?.first.userId??"", widget.orderresponse.orderId??"");
      setState(() { });

    final orderDetails = await orderDetailedresponse;
    // print("Order details");
    // print(orderDetails.data.map((t) => t.img));
    final savedCartResponses = await savedcartDetailedresponse;
     print("shared details");
    print(savedCartResponses.map((t) => t.img));

    for (var order in orderDetails.data) {
    //   // Fetch variation details
      final futureVariationResponse = await variation_api().variation_details(
        user_id: order.deliveryBoyId??"",
        variation_id: order.variationId,
      );
      print('Variation Response: ${futureVariationResponse
                  .messages.status.variationDetails.isNotEmpty
              ? futureVariationResponse
                  .messages.status.variationDetails[0].toJson()
              :" No Variation"}');

      // Check if an item with the same orderId, productName, and qty exists
      bool itemExists = savedCartResponses.any((savedItem) =>
          savedItem.productName == order.productName &&
          savedItem.userId == widget.orderresponse.products?.first.userId &&
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
              : '', productId: order.productId, addressId: order.addressId??"", paymentMode: order.paymentMode, couponCode: order.couponCode, deliveryboyId: order.deliveryBoyId, otp:  order.OTP,
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
  
  Future<void> _refreshCart() async {
    if (!mounted) return;

    setState(() {
      
      savedcartDetailedresponse = SharedPreferencesService()
          .getUserProductResponses(
              widget.orderresponse.products?.first.userId??"", widget.orderresponse.orderId??"");
    });

    final savedCartResponses = await savedcartDetailedresponse;

    if (mounted) {
      setState(() {
        savedcartDetailedresponse = Future.value(savedCartResponses);
      });
    }
  }

   
    void _navigateAndRefresh(BuildContext context) async {
      final response = await orderDetailedresponse;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => search_screen(
                otp: response.data.first.OTP,
                order_data: widget.orderresponse,
                user: widget.orderresponse.products?.first.userId??"",
              )),
    );

    if (result == true) {
      widget.orderresponse.orderStatus == "5"
          ? setState(() {
              orderDetailedresponse = order_detailed_api().order_detailed(
                  order_id: widget.orderresponse.orderId??"",
                  user_id: widget.orderresponse.products?.first.userId??"");
              // savedcartDetailedresponse = SharedPreferencesService()
              //     .getUserProductResponses(widget.orderresponse.products?.first.userId??"",
              //         widget.orderresponse.orderId??"");
            })
          : _refreshOrder();
    }
  }
    @override
  void initState() {
    focusNode = FocusNode();
    _refreshOrder();
    // orderDetailedresponse = order_detailed_api().order_detailed(
    //     order_id: widget.orderresponse.orderId??"",
    //     user_id: widget.orderresponse.products?.first.userId??"");
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
       return SafeArea(
      child: Scaffold(
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
                        widget.orderresponse.orderId??"",
                        widget.orderresponse.products?.first.userId??"");
                        Navigator.pop(context);
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => navbar(
                    //               userDetail: widget.userDetails,
                    //             )),
                    //     (route) => false);
                  },
                );
              },
            ),
            title: basic_text(
                title: widget.orderresponse.orderId??"",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            actions: [
              widget.orderresponse.orderStatus == '5'
                  ? Container()
                  :widget.isCompleted==true?SizedBox():  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Card(
                        color: Colors.transparent,
                        elevation: 6,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              widget.orderresponse.products?.first.customerName==null|| widget.orderresponse.products?.first.customerName==""
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
                                      .labelLarge!
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
          body: FutureBuilder(
            future: orderDetailedresponse,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                orderDetailedResponse orderDetails = snapshot.data;
                // print('Order Details: ${orderDetails}');
                return SingleChildScrollView(
                  child: Container(
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
                                              widget.orderresponse.products?.first.userId &&
                                          element.orderId ==
                                              widget.orderresponse.orderId)
                                      .toList();
                              print('Filter Data: ${filterData.map((t)=>t.img)}');
                              return filterData.length==0
                                  ? Center(
                                      child: SizedBox(),
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
                                          // widget.orderresponse.orderStatus == '5'
                                          //     ? ListView.builder(
                                          //         scrollDirection: Axis.vertical,
                                          //         shrinkWrap: true,
                                          //         physics:
                                          //             BouncingScrollPhysics(),
                                          //         itemCount:
                                          //             orderDetails.data.length,
                                          //         itemBuilder: (context, index) {
                                          //           bool isUpdating =
                                          //               updateIndices
                                          //                   .contains(index);
                                          //           return Padding(
                                          //             padding:
                                          //                 EdgeInsets.all(8.0),
                                          //             child: Container(
                                          //               padding:
                                          //                   EdgeInsets.all(4),
                                          //               width: MediaQuery.of(
                                          //                           context)
                                          //                       .size
                                          //                       .width *
                                          //                   0.9,
                                          //               decoration:
                                          //                   BoxDecoration(
                                          //                 border: Border.all(
                                          //                     color:
                                          //                         Colors.grey),
                                          //                 borderRadius:
                                          //                     BorderRadius
                                          //                         .circular(10),
                                          //               ),
                                          //               child: Row(
                                          //                 children: [
                                          //                   CachedNetworkImage(
                                          //                     imageUrl:
                                          //                         '$base_url/uploads/${orderDetails.data[index].img}',
                                          //                     height: MediaQuery.of(
                                          //                                 context)
                                          //                             .size
                                          //                             .height *
                                          //                         0.10,
                                          //                     width: MediaQuery.of(
                                          //                                 context)
                                          //                             .size
                                          //                             .width *
                                          //                         0.23,
                                          //                     fit: BoxFit
                                          //                         .contain,
                                          //                   ),
                                          //                   SizedBox(width: 10),
                                          //                   Column(
                                          //                     crossAxisAlignment:
                                          //                         CrossAxisAlignment
                                          //                             .start,
                                          //                     children: [
                                          //                       Container(
                                          //                         width: MediaQuery.of(
                                          //                                     context)
                                          //                                 .size
                                          //                                 .width *
                                          //                             0.55,
                                          //                         child: Text(
                                          //                           orderDetails
                                          //                               .data[
                                          //                                   index]
                                          //                               .productName,
                                          //                           maxLines: 2,
                                          //                           style: TextStyle(
                                          //                               fontSize:
                                          //                                   16,
                                          //                               color: Colors
                                          //                                   .black,
                                          //                               fontWeight:
                                          //                                   FontWeight
                                          //                                       .w500,
                                          //                               overflow:
                                          //                                   TextOverflow.clip),
                                          //                         ),
                                          //                       ),
                                          //                       !isUpdating
                                          //                           ? Row(
                                          //                               mainAxisAlignment:
                                          //                                   MainAxisAlignment.spaceBetween,
                                          //                               children: [
                                          //                                 basic_text(
                                          //                                   title:
                                          //                                       'Quantity: ${orderDetails.data[index].qty}',
                                          //                                   style: TextStyle(
                                          //                                       fontSize: 12,
                                          //                                       color: Colors.grey[400],
                                          //                                       fontWeight: FontWeight.w500),
                                          //                                 ),
                                          //                                 SizedBox(
                                          //                                     width: 20),
                                          //                                 orderDetails.data[0].status == '5' || orderDetails.data[0].status == '3'
                                          //                                     ? Container()
                                          //                                     : InkWell(
                                          //                                         onTap: () {
                                          //                                           setState(() {
                                          //                                             if (updateIndices.contains(index)) {
                                          //                                               updateIndices.remove(index);
                                          //                                             }
                                          //                                             updateIndices.add(index);
                                          //                                           });
                                          //                                         },
                                          //                                         child: Text(
                                          //                                           'Edit',
                                          //                                           style: TextStyle(color: Colors.red),
                                          //                                         ),
                                          //                                       )
                                          //                               ],
                                          //                             )
                                          //                           : Row(
                                          //                               mainAxisAlignment:
                                          //                                   MainAxisAlignment.spaceBetween,
                                          //                               children: [
                                          //                                 Row(
                                          //                                   mainAxisAlignment:
                                          //                                       MainAxisAlignment.spaceBetween,
                                          //                                   crossAxisAlignment:
                                          //                                       CrossAxisAlignment.center,
                                          //                                   children: [
                                          //                                     IconButton(
                                          //                                       onPressed: () async {
                                          //                                         await SharedPreferencesService().decrementQuantity(
                                          //                                           orderDetails.data[index].productName, // Assuming productName is used as identifier
                                          //                                           widget.orderresponse.products?.first.userId??"",
                                          //                                           widget.orderresponse.orderId??"",
                                          //                                         );
                                          //                                         setState(() {
                                          //                                           new_quan--; // Decrement the UI quantity
                                          //                                         });
                                          //                                       },
                                          //                                       icon: Icon(Icons.remove),
                                          //                                     ),
                                          //                                     Text(new_quan.toString()),
                                          //                                     IconButton(
                                          //                                       onPressed: () async {
                                          //                                         await SharedPreferencesService().incrementQuantity(
                                          //                                           orderDetails.data[index].productName, // Assuming productName is used as identifier
                                          //                                           widget.orderresponse.products?.first.userId??"",
                                          //                                           widget.orderresponse.orderId??"",
                                          //                                         );
                                          //                                         setState(() {
                                          //                                           new_quan++; // Increment the UI quantity
                                          //                                         });
                                          //                                       },
                                          //                                       icon: Icon(Icons.add),
                                          //                                     ),
                                          //                                   ],
                                          //                                 ),
                                          //                                 Row(
                                          //                                   children: [
                                          //                                     new_quan.toString() != orderDetails.data[index].qty
                                          //                                         ? TextButton(
                                          //                                             onPressed: () async {
                                          //                                               final result = await update_quantity_api().update_quantity(
                                          //                                                 orders_id: orderDetails.data[index].ordersId,
                                          //                                                 qty: new_quan.toString(),
                                          //                                               );
                                          //                                               if (result.message.isNotEmpty) {
                                          //                                                 _refreshOrder();
                                          //                                               }
                                          //                                             },
                                          //                                             child: basic_text(
                                          //                                               title: 'Update',
                                          //                                               style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.primarycolor2),
                                          //                                             ),
                                          //                                           )
                                          //                                         : Container(),
                                          //                                     TextButton(
                                          //                                       onPressed: () {
                                          //                                         setState(() {
                                          //                                           updateIndices.remove(index);
                                          //                                         });
                                          //                                       },
                                          //                                       child: basic_text(
                                          //                                         title: 'Cancel',
                                          //                                         style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.red),
                                          //                                       ),
                                          //                                     ),
                                          //                                   ],
                                          //                                 ),
                                          //                               ],
                                          //                             ),
                                          //                       !isUpdating
                                          //                           ? Container(
                                          //                               width: MediaQuery.of(context).size.width *
                                          //                                   0.65,
                                          //                               child:
                                          //                                   Row(
                                          //                                 mainAxisAlignment:
                                          //                                     MainAxisAlignment.spaceBetween,
                                          //                                 children: [
                                          //                                   Text(
                                          //                                     '₹' + orderDetails.data[index].price,
                                          //                                     style: TextStyle(
                                          //                                       fontSize: 16,
                                          //                                       color: AppColors.primarycolor2,
                                          //                                       fontWeight: FontWeight.w400,
                                          //                                     ),
                                          //                                   ),
                                          //                                 ],
                                          //                               ),
                                          //                             )
                                          //                           : Container(),
                                          //                     ],
                                          //                   ),
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //           );
                                          //         },
                                          //       )
                                          //     :
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
                                                                        widget.orderresponse.orderStatus ==
                                                                                '5'
                                                                            ? Text(
                                                                                'Quantity: ' + filterData[index].qty.toString(),
                                                                                style: TextStyle(color: Colors.grey),
                                                                              )
                                                                            : Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                 widget.isCompleted ==true?SizedBox():  InkWell(
                                                                                    onTap: () async {
                                                                                      await SharedPreferencesService().decrementQuantity(
                                                                                        filterData[index].productName,
                                                                                        widget.orderresponse.products?.first.userId??"",
                                                                                        widget.orderresponse.orderId??"",
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
                                                                                 widget.isCompleted ==true?SizedBox():  InkWell(
                                                                                    onTap: () async {
                                                                                      await SharedPreferencesService().incrementQuantity(
                                                                                        filterData[index].productName,
                                                                                        widget.orderresponse.products?.first.userId??"",
                                                                                        widget.orderresponse.orderId??"",
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
                                                                            widget.isCompleted ==true?SizedBox():  TextButton(
                                                                                  onPressed: () async {
                                                                                    // await SharedPreferencesService().removeSingleItemsByOrderId(filterData[index].orderId, filterData[index].userId, filterData[index].productName).then((value) {
                                                                                    //   _refreshOrder();
                                                                                      
                                                                                    // });

                                                                                    final response = await orderDetailedresponse;

                                                                                      // remove from API orders (in-memory, not server side)
                                                                                      response.data.removeWhere((item) =>
                                                                                        item.orderId == filterData[index].orderId &&
                                                                                        item.userId == filterData[index].userId &&
                                                                                        item.productName == filterData[index].productName,
                                                                                      );

                                                                                      // remove from saved local cart
                                                                                      await SharedPreferencesService().removeSingleItemsByOrderId(
                                                                                        filterData[index].orderId,
                                                                                        filterData[index].userId,
                                                                                        filterData[index].productName,
                                                                                      );

                                                                                      // update UI
                                                                                      if (mounted) {
                                                                                        setState(() {
                                                                                          // refresh savedcart list
                                                                                          savedcartDetailedresponse = SharedPreferencesService()
                                                                                              .getUserProductResponses(
                                                                                                widget.orderresponse.products?.first.userId ?? "",
                                                                                                widget.orderresponse.orderId ?? "",
                                                                                              );

                                                                                          // keep updated orderDetailedresponse
                                                                                          orderDetailedresponse = Future.value(response);
                                                                                        });
                                                                                      }
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
                          })),
                );
              }
            },
          ),
          bottomNavigationBar: FutureBuilder(
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
                                          widget.orderresponse.products?.first.userId)
                                      .toList();
                              return filterData.length==0
                                  ? Center(
                                      child: SizedBox(),
                                    )
                                  : Container(
                                color: Colors.transparent,
                                child:widget.orderresponse.orderStatus  == '5'
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
                                    : widget.orderresponse.orderStatus == '3'
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
                                              //               .labelLarge!
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
                                                    // print(filterData.map((t)=>t.variation));
                                                    if (isLoading ==false) {
                                                      setState(() {
                                                      isLoading=true;
                                                    });
                                                      savedcartDetailedresponse = SharedPreferencesService()
                                                          .getUserProductResponses(
                                                  widget.orderresponse.products?.first.userId??"", widget.orderresponse.orderId??"");
                                                  final savedCartResponses = await savedcartDetailedresponse;
                                                  // print(savedCartResponses.map((t)=>t.img));
                                                    view_cart_api().checkout_api(orderId: savedCartResponses.first.orderId, product: savedCartResponses).then((v)async{
                                                     if (!mounted) return;
                                                     setState(() {
                                                       isLoading=false;
                                                     });
                                                      if (v){
                                              await SharedPreferencesService().removeItemsByOrderId(
                        widget.orderresponse.orderId??"",
                        widget.orderresponse.products?.first.userId??"").then((c){
                           if (!mounted) return;
                                              if (mounted) Navigator.pop(context,true);
                        });
                                             
                                              
                                            }
                                                    });
                                                    }
                                                 },
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 14),
                                                    child:isLoading?SizedBox(height: 20,width: 20, child: Center(child: CircularProgressIndicator(),)): basic_text(
                                                        title: 'Submit',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge!
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
                          })
                          
                          )
          
        
   
    );
 
  }
}