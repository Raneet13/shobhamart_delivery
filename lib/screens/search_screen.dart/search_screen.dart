// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sm_delivery/models/order_response.dart';
import 'package:sm_delivery/screens/search_screen.dart/search_detailed_screen.dart';
import '../../api/search.dart';
import '../../constants.dart/constants.dart';
import '../../core/theme/base_color.dart';
import '../../models/search_response.dart';

class search_screen extends StatefulWidget {
  const search_screen(
      {Key? key, required this.order_data, required this.user, this.username})
      : super(key: key);
  final Order order_data;
  final String user;
  final String? username;
  @override
  _search_screenState createState() => _search_screenState();
}

class _search_screenState extends State<search_screen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<searchProductData> _suggestions = [];

  List<String> _searchHistory = [];
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _fetchSuggestions(_searchController.text);
      } else {
        setState(() {
          _suggestions = [];
        });
      }
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    try {
      searchProductResponse data = await search_api().search(query: query);
      List<searchProductData> suggestions = data.products;
      setState(() {
        _suggestions = suggestions;
      });
    } catch (e) {
      print('Error fetching suggestions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 10,
        backgroundColor: AppColors.primarycolor2,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.longestSide * 0.06,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Products and add',
                border: InputBorder.none,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColors.grey3, fontSize: 14),
              ),
            )),
        // actions: [shopping_cart(user: widget.user)],
      ),
      body: Column(
        children: [
          _suggestions.isEmpty && _searchController.text != ''
              ? Expanded(
                  child: Center(
                    child: FutureBuilder<void>(
                      future: Future.delayed(Duration(milliseconds: 500)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.connectionState ==
                                ConnectionState.active) {
                          return CircularProgressIndicator();
                        } else {
                          return Text(
                            'No Such Product Found',
                            style: TextStyle(fontSize: 20),
                          );
                        }
                      },
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => search_detailed_screen(
                                      product_data: _suggestions[index],
                                      order_data: widget.order_data,
                                      user: widget.user,
                                      var_id: _suggestions[index].productId,
                                    )));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              children: [
                                Container(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '$base_url/uploads/${_suggestions[index].primaryImage}',
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    height:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(_suggestions[index].productName,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          overflow: TextOverflow.clip,
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
