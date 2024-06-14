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
  Future<userResponse?> fetchUserDetails() async {
    final username = SharedPreferencesService.getString("username");
    final password = SharedPreferencesService.getString("password");
    if (username != '' && password != '') {
      final userDetails = await userDetailsStream(username!, password!).first;
      print('User Details: ${userDetails.toString()}');
      return userDetails;
    }
    return null;
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
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          print('User: $user');
          // print(user.messages.status.userId);
          if (user.messages.status.userId != '') {
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
