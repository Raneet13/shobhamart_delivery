// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';
import 'components/basic_text.dart';
import 'components/drawer.dart';
import 'components/search_bar.dart';
import 'core/theme/base_color.dart';
import 'screens/home_screen.dart/home_screen.dart';
import 'screens/profile_screen.dart/profile_screen.dart';

class navbar extends StatefulWidget {
  const navbar({super.key, this.userDetail});
  final userResponse? userDetail;
  @override
  State<navbar> createState() => _navbarState();
}

class _navbarState extends State<navbar> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: kToolbarHeight,
        centerTitle: true,
        title: basic_text(
          title: 'Shobamart Delivery',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white),
        ),
        // actions: [
        //   Hero(
        //     tag: 'profile',
        //     child: InkWell(
        //       onTap: () {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (context) => profile_screen(
        //               userDetail: widget.userDetail,
        //             ),
        //           ),
        //         );
        //       },
        //       child: CircleAvatar(
        //         radius: 20,
        //         backgroundImage: NetworkImage(
        //             'http://odishasweets.in/jumbotail/uploads/${widget.userDetail!.messages.status.storeImage}'),
        //       ),
        //     ),
        //   ),
        // ],
        backgroundColor: AppColors.primarycolor2,
      ),
      // drawer: drawer(
      //   userDetail: widget.userDetail!,
      // ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                Container(
                    child: Center(
                        child: home_screen(
                  userDetail: widget.userDetail!,
                ))),
                Container(
                    child: Center(
                        child: profile_screen(userDetail: widget.userDetail!))),
                // Container(
                //     child: Center(
                //         child: all_brand_screen(
                //   userDetail: widget.userDetail,
                // ))),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 28,
        selectedLabelStyle:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle:
            TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        selectedItemColor: AppColors.primarycolor2,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.all_inbox_outlined),
          //   label: 'Profile',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
