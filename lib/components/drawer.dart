// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';
import '../core/theme/base_color.dart';
import 'basic_text.dart';

class drawer extends StatelessWidget {
  drawer({
    super.key,
  });
  final List<Map<String, dynamic>> drawer_list = [
    {
      'icon': Icons.home_outlined,
      'title': 'My Profile',
      'route': '/profile_screen'
    },
    {
      'icon': Icons.place_outlined,
      'title': 'My Address',
      'route': '/address_screen'
    },
    {'icon': Icons.money_off_outlined, 'title': 'My Payments', 'route': ''},
    {
      'icon': Icons.card_travel_outlined,
      'title': 'My Orders',
      'route': '/my_order_screen'
    },
    {
      'icon': Icons.privacy_tip_outlined,
      'title': 'Privacy Policy',
      'route': ''
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width - 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DrawerHeader(
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: NetworkImage(
                  //       'http://odishasweets.in/jumbotail/uploads/${userDetail.gstImage}',
                  //     ),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        // basic_text(
                        //     title: userDetail.address1,
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .headline5!
                        //         .copyWith(
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.bold,
                        //             color: Colors.white)),
                        // SizedBox(width: 10),
                        // basic_text(
                        //     title: '(${userDetail.cityId})',
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .headline5!
                        //         .copyWith(
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.w600,
                        //             color: Colors.white)),
                        // SizedBox(width: 10),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     color: Colors.white,
                        //   ),
                        //   child: Icon(
                        //     Icons.person,
                        //     color: AppColors.primarycolor1,
                        //     size: 25,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: drawer_list.length,
                    itemBuilder: (ctx, i) {
                      return Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 10),
                          child: drawer_menu(
                            icon: drawer_list[i]['icon'],
                            title: drawer_list[i]['title'],
                            route: drawer_list[i]['route'],
                          ));
                    }),
              ],
            ),
          ),
          // Bottom Element of Drawer
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            // height: MediaQuery.of(context).size.height * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: basic_text(
                      title: 'For Qureies',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ),
                SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class border_buttons extends StatelessWidget {
  const border_buttons(
      {super.key, required this.icon, required this.title, this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green,
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.grey[900], size: 30),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                // width: MediaQuery.of(context).size.width * 0.4,
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.clip),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class drawer_menu extends StatelessWidget {
  const drawer_menu({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
  });
  final IconData icon;
  final String title;
  final String route;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.05,
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700], size: 35),
            SizedBox(width: 20),
            basic_text(
              title: title,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.black, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
