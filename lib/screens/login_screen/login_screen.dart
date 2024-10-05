// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sm_delivery/api/login.dart';
import 'package:sm_delivery/components/basic_text.dart';
import 'package:sm_delivery/core/theme/base_color.dart';
import 'package:sm_delivery/core/utils/shared_preference.dart';
import 'package:sm_delivery/models/login_details/user_detail.dart';
import 'package:sm_delivery/navbar.dart';
import 'package:sm_delivery/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:sm_delivery/screens/wrapper.dart';

class login_screen extends StatefulWidget {
  const login_screen({Key? key}) : super(key: key);

  @override
  _login_screenState createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      final result = await login_api().login_user(
        username: username,
        password: password,
      );
      // final userData = result.messages.status as userStatus;
      // final errorData = result.messages.status as String;
      if (result.messages.status is String) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid username and password'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        userStatus userData = result.messages.status;
        if (userData.userId.isNotEmpty) {
          await SharedPreferencesService.setString('username', username);
          await SharedPreferencesService.setString('password', password);
          final storedUsername =
              await SharedPreferencesService.getString('username');
          print('here is the stored username: $storedUsername');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Successful'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => wrapper(),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/sobha logo blue.png',
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => forgot_password_screen()));
                    },
                    child: basic_text(
                      title: 'Forgot Password?',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: AppColors.orangered,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primarycolor2,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _login,
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
