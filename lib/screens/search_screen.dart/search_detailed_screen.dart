// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sm_delivery/core/utils/shared_preference.dart';
import 'package:sm_delivery/models/order_response.dart';
import '../../api/single_product.dart';
import '../../api/variation.dart';
import '../../components/basic_text.dart';
import '../../components/skeletal_text copy.dart';
import '../../constants.dart/constants.dart';
import '../../core/theme/base_color.dart';
import '../../models/search_response.dart';
import '../../models/single_product_response.dart';
import '../../models/variation.dart';

class search_detailed_screen extends StatefulWidget {
  search_detailed_screen(
      {super.key,
      required this.product_data,
      required this.order_data,
      required this.user,
      required this.var_id});
  final searchProductData product_data;
  final Order order_data;
  final String user;
  final String var_id;
  @override
  State<search_detailed_screen> createState() => _search_detailed_screenState();
}

class _search_detailed_screenState extends State<search_detailed_screen> {
  int selectedAttributeIndex = 0;
  int selectedVariationIndex = 0;
  String selected_variation_price = '';
  String variation_id = '';
  late Future<SingleProductResponse> futureProductResponse;
  late Future<variationResponse> futureVariationResponse;
  @override
  void initState() {
    super.initState();
    futureProductResponse = single_product_api()
        .single_product_details(
            user_id: widget.order_data.userId,
            product_id: widget.product_data.productId)
        .then((value) {
      futureVariationResponse = variation_api().variation_details(
          user_id: widget.user,
          variation_id: value.messages.status.attributes.isEmpty
              ? variation_id
              : value.messages.status.attributes[0].variations[0].variationId);
      return value;
    });
  }

  Future<void> _refreshvariant() async {
    setState(() {
      futureVariationResponse = variation_api()
          .variation_details(user_id: widget.user, variation_id: variation_id);
    });
  }

  int quantity = 1;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 5 - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      );
    });
  }

  final PageController _pageController = PageController();

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
            title: widget.product_data.productName,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        backgroundColor: AppColors.primarycolor2,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: futureProductResponse,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: SkeletonLoaderDetailedScreen());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No Catagory available'));
            } else {
              SingleProductResponse data = snapshot.data!;
              return Container(
                child: FutureBuilder(
                  future: futureProductResponse,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('No Items available'));
                    } else {
                      SProductData single_product_data =
                          snapshot.data!.messages.status.singleProduct[0];
                      SingleProductResponse? all_data = snapshot.data;
                      return Container(
                          padding: EdgeInsets.all(8),
                          child: FutureBuilder(
                            future: futureVariationResponse,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: SkeletonLoaderDetailedScreen());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData) {
                                return Center(
                                    child: Text('No Items available'));
                              } else {
                                variationResponse variation_data =
                                    snapshot.data;
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    // Product Image
                                    Hero(
                                      tag: 'product',
                                      child: variation_data.messages.status
                                                  .variationDetails.isEmpty &&
                                              data.messages.status
                                                  .productGallery.isNotEmpty
                                          ? Column(
                                              children: [
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25,
                                                  child: PageView.builder(
                                                      controller:
                                                          _pageController,
                                                      onPageChanged:
                                                          (int page) {
                                                        setState(() {
                                                          _currentPage = page;
                                                        });
                                                      },
                                                      itemCount: data
                                                          .messages
                                                          .status
                                                          .productGallery
                                                          .length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        return Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.25,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6)),
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      '$base_url/uploads/${data.messages.status.productGallery[i].image}'),
                                                                  fit: BoxFit
                                                                      .contain)),
                                                        );
                                                      }),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: List.generate(
                                                      data
                                                          .messages
                                                          .status
                                                          .productGallery
                                                          .length, (index) {
                                                    return Container(
                                                      width: 8,
                                                      height: 8,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: _currentPage ==
                                                                index
                                                            ? AppColors
                                                                .primarycolor2
                                                            : Colors.grey,
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ],
                                            )
                                          : Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                              child: Image.network(
                                                '$base_url/uploads/${variation_data.messages.status.variationDetails.isEmpty ? data.messages.status.singleProduct[0].primaryImage : variation_data.messages.status.variationDetails[0].image}',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                    ),
                                    SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: _buildAttributeWidgets(
                                          all_data!.messages.status.attributes),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            all_data.messages.status.attributes
                                                    .isNotEmpty
                                                ? single_product_data
                                                        .productName +
                                                    ' ' +
                                                    '(${all_data.messages.status.attributes[selectedAttributeIndex].attributeName}' +
                                                    ' ' +
                                                    '${all_data.messages.status.attributes[selectedAttributeIndex].variations[selectedVariationIndex].variationName})'
                                                : all_data
                                                    .messages
                                                    .status
                                                    .singleProduct[0]
                                                    .productName,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              basic_text(
                                                  title: variation_data
                                                          .messages
                                                          .status
                                                          .variationDetails
                                                          .isNotEmpty
                                                      ? 'MRP ₹${variation_data.messages.status.variationDetails[0].regularPrice}'
                                                      : 'MRP ₹${all_data.messages.status.singleProduct[0].regularPrice}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                            ],
                                          ),
                                          SizedBox(width: 6),
                                          basic_text(
                                              title: variation_data
                                                      .messages
                                                      .status
                                                      .variationDetails
                                                      .isNotEmpty
                                                  ? '₹${variation_data.messages.status.variationDetails[0].salePrice}'
                                                  : '₹${all_data.messages.status.singleProduct[0].salesPrice}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: Colors.green,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                        ],
                                      ),
                                    ),
                                    // Product Description
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        all_data.messages.status
                                            .singleProduct[0].description,
                                        maxLines: 8,
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove),
                                            onPressed: () {
                                              setState(() {
                                                if (quantity > 1) {
                                                  quantity--;
                                                }
                                              });
                                            },
                                          ),
                                          Text(
                                            quantity.toString(),
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              setState(() {
                                                quantity++;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Add to Cart Button
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.orangered),
                                        onPressed: () async {
                                          if (all_data
                                                      .messages
                                                      .status
                                                      .singleProduct[0]
                                                      .productId !=
                                                  '' ||
                                              variation_id != '') {
                                            //   final result =
                                            //       await add_tocart_api()
                                            //           .add_tocart(
                                            //               user_id: widget.user,
                                            //               product_id: all_data
                                            //                   .messages
                                            //                   .status
                                            //                   .singleProduct[0]
                                            //                   .productId,
                                            //               quantity:
                                            //                   quantity.toString(),
                                            //               variation_id:
                                            //                   variation_id);
                                            //   if (result.messages.status ==
                                            //       'Product Added Successfully') {
                                            //     Provider.of<CartNotifier>(context,
                                            //             listen: false)
                                            //         .refreshCart(widget.user);
                                            //     ScaffoldMessenger.of(context)
                                            //         .showSnackBar(
                                            //       SnackBar(
                                            //         content: Text(
                                            //             'Item Added Successfully to cart'),
                                            //         backgroundColor: Colors.green,
                                            //       ),
                                            //     );
                                            //     Navigator.pop(context);
                                            //   }
                                            // } else {
                                            //   print('Missing Values');
                                            await SharedPreferencesService().onAddToCart(
                                                UserProductResponse(
                                                    userId: widget.user,
                                                    orderId: widget
                                                        .order_data.orderId,
                                                    qty: quantity,
                                                    productName:
                                                        single_product_data
                                                            .productName,
                                                    img: variation_data
                                                            .messages
                                                            .status
                                                            .variationDetails
                                                            .isNotEmpty
                                                        ? variation_data
                                                            .messages
                                                            .status
                                                            .variationDetails[0]
                                                            .image
                                                        : all_data
                                                            .messages
                                                            .status
                                                            .singleProduct[0]
                                                            .primaryImage,
                                                    price: variation_data
                                                            .messages
                                                            .status
                                                            .variationDetails
                                                            .isNotEmpty
                                                        ? variation_data
                                                            .messages
                                                            .status
                                                            .variationDetails[0]
                                                            .salePrice
                                                        : all_data
                                                            .messages
                                                            .status
                                                            .singleProduct[0]
                                                            .salesPrice,
                                                    variation: variation_data
                                                            .messages
                                                            .status
                                                            .variationDetails
                                                            .isNotEmpty
                                                        ? variation_data
                                                            .messages
                                                            .status
                                                            .variationDetails[0]
                                                            .priceVariationId
                                                        : ''),
                                                widget.order_data.userId);
                                            final result =
                                                await SharedPreferencesService()
                                                    .getUserProductResponses(
                                                        widget
                                                            .order_data.userId,
                                                        widget.order_data
                                                            .orderId);
                                            final var_price = variation_data
                                                    .messages
                                                    .status
                                                    .variationDetails
                                                    .isNotEmpty
                                                ? variation_data
                                                    .messages
                                                    .status
                                                    .variationDetails[0]
                                                    .salePrice
                                                : all_data
                                                    .messages
                                                    .status
                                                    .singleProduct[0]
                                                    .salesPrice;
                                            final selectedProduct =
                                                result.where((element) =>
                                                    element.productName ==
                                                        single_product_data
                                                            .productName &&
                                                    element.price == var_price);
                                            if (selectedProduct.isNotEmpty) {
                                              Navigator.pop(context);
                                              Navigator.pop(context, true);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Item Added To cart'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: Text(
                                          'Add to Customer\'s Cart',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ));
                    }
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildAttributeWidgets(List<sAttribute> attributes) {
    List<Widget> widgets = [];
    for (int attrIndex = 0; attrIndex < attributes.length; attrIndex++) {
      var attribute = attributes[attrIndex];
      widgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: attribute.variations.map<Widget>((variation) {
                int varIndex = attribute.variations.indexOf(variation);
                bool isSelected = selectedAttributeIndex == attrIndex &&
                    selectedVariationIndex == varIndex;
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedAttributeIndex = attrIndex;
                      selectedVariationIndex = varIndex;
                      variation_id = attributes[selectedAttributeIndex]
                          .variations[selectedVariationIndex]
                          .variationId;
                      print(variation_id);
                      selected_variation_price = attribute
                              .variations[selectedVariationIndex]
                              .variationPrice ??
                          widget.product_data.salesPrice;
                    });
                    _refreshvariant();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isSelected
                              ? AppColors.primarycolor2
                              : Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected
                          ? AppColors.primarycolor2
                          : AppColors.grey3,
                    ),
                    child: Column(
                      children: [
                        Text(attribute.attributeName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected ? Colors.white : Colors.black)),
                        Text(
                          variation.variationName,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }
    return widgets;
  }
}
