// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sm_delivery/api/login.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';
import 'package:sm_delivery/navbar.dart';
import 'package:sm_delivery/screens/login_screen/login_screen.dart';
import '../core/utils/shared_preference.dart';

class wrapper extends StatefulWidget {
  const wrapper({super.key});

  @override
  State<wrapper> createState() => _wrapperState();
}

class _wrapperState extends State<wrapper> {
  @override
  Future<userResponse?> fetchUserDetails() async {
    final username = SharedPreferencesService.getString("username");
    final password = SharedPreferencesService.getString("password");
    print(username);
    print(password);
    if (username != null && password != null) {
      final userDetails = await userDetailsStream(username!, password!).first;
      print('User Details: ${userDetails.toString()}');
      if (userDetails.messages.status is String) {
        return userResponse(
            status: 500,
            error: true,
            messages: userMessages(
                responseCode: '400',
                status: userStatus(
                    userId: '',
                    fullname: '',
                    email: '',
                    contact: '',
                    status: '',
                    storeImage: '',
                    adharNo: '',
                    storeFont: '',
                    adharBack: '',
                    address: '',
                    isLoggedIn: false)));
      } else {
        return userDetails;
      }
    }
    return userResponse(
        status: 500,
        error: true,
        messages: userMessages(
            responseCode: '400',
            status: userStatus(
                userId: '',
                fullname: '',
                email: '',
                contact: '',
                status: '',
                storeImage: '',
                adharNo: '',
                storeFont: '',
                adharBack: '',
                address: '',
                isLoggedIn: false)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<userResponse?>(
      future: fetchUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Container(
            child: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          print('User: $user');
          final userStatus useridStatus = user.messages.status as userStatus;
          if (useridStatus.userId != '') {
            return navbar(
              userDetail: user,
            );
          } else {
            return login_screen();
          }
        } else {
          return login_screen();
        }
      },
    );
  }
}
