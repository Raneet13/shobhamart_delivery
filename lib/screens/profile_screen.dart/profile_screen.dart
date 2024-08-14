// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sm_delivery/components/basic_text.dart';
import 'package:sm_delivery/constants.dart/constants.dart';
import 'package:sm_delivery/core/theme/base_color.dart';
import 'package:sm_delivery/core/utils/shared_preference.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';
import 'package:sm_delivery/screens/documents_screen/documents_screen.dart';
import 'package:sm_delivery/screens/wrapper.dart';

class profile_screen extends StatelessWidget {
  const profile_screen({Key? key, required this.userDetail}) : super(key: key);
  final userResponse? userDetail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   toolbarHeight: kToolbarHeight,
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //       icon: Icon(Icons.arrow_back, size: 30, color: Colors.white)),
      //   title: basic_text(
      //     title: 'My Profile',
      //     style: Theme.of(context)
      //         .textTheme
      //         .headline6!
      //         .copyWith(color: Colors.white),
      //   ),
      //   backgroundColor: AppColors.primarycolor2,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Personal details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'profile',
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primarycolor2,
                            width: 2,
                          ),
                          image: DecorationImage(
                              image: NetworkImage(
                                  '$base_url/uploads/${userDetail!.messages.status.storeImage}'),
                              fit: BoxFit.contain)),
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'addhar No:' + userDetail!.messages.status.adharNo,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primarycolor2),
                      ),
                      Text(
                        userDetail!.messages.status.fullname,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(userDetail!.messages.status.email),
                      Text(userDetail!.messages.status.contact),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: basic_text(
                            title: userDetail!.messages.status.address,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: AppColors.grey3,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.clip)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _buildMenuItem('Documents', () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => document_screen(
                        userDetail: userDetail,
                      )));
            }),
            // _buildMenuItem('Past Orders', () {}),
            // _buildMenuItem('Pending Orders', () {}),
            // _buildMenuItem('Help', () {}),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  SharedPreferencesService.setString('username', '');
                  SharedPreferencesService.setString('password', '');
                  if (SharedPreferencesService.getString('username') == '' &&
                      SharedPreferencesService.getString('password') == '') {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => wrapper()));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangered,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                ),
                child: basic_text(
                  title: 'Log Out',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
