// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sm_delivery/api/reset_password.dart';
import 'package:sm_delivery/core/theme/base_color.dart';
import 'package:sm_delivery/core/utils/shared_preference.dart';
import 'package:sm_delivery/screens/login_screen/login_screen.dart';

class password_reset_screen extends StatefulWidget {
  const password_reset_screen({Key? key, required this.contact_no})
      : super(key: key);
  final String contact_no;

  @override
  _password_reset_screenState createState() => _password_reset_screenState();
}

class _password_reset_screenState extends State<password_reset_screen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      String password = _confirmController.text;
      await SharedPreferencesService.setString('password', password);
      final result = await reset_password_api()
          .reset_password(contact_no: widget.contact_no, password: password);
      final storedUsername =
          await SharedPreferencesService.getString('password');
      if (result.messages.status == 'password Reset Succesfully') {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Password Changed"),
            content: const Text("Your password has been changed successfully"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(14),
                  child: const Text("ok"),
                ),
              ),
            ],
          ),
        ).then((value) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => login_screen(),
              ),
            );
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Image.asset(
                'assets/sobha logo blue.png',
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              SizedBox(height: 32),
              const Text(
                'Enter Your New password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 32),
              TextFormField(
                controller: _confirmController,
                decoration: InputDecoration(
                  labelText: 'New Password',
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
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value != _confirmController.text) {
                    return 'Password does not match';
                  }
                  return null;
                },
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
                onPressed: _changePassword,
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
