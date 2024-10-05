// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:sm_delivery/api/forgot_password.dart';
import 'package:sm_delivery/models/forgot_password_response.dart';
import 'package:sm_delivery/screens/otp_screen.dart/otp_screen.dart';
import '../../core/theme/base_color.dart';

class forgot_password_screen extends StatefulWidget {
  const forgot_password_screen({super.key});

  @override
  State<forgot_password_screen> createState() => _forgot_password_screenState();
}

class _forgot_password_screenState extends State<forgot_password_screen> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      )),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Image.asset(
                  'assets/sobha logo blue.png',
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                SizedBox(height: 30),
                Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 10) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'Phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primarycolor2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var otpDetails = await forgot_password_api()
                          .forgot_password(contact_no: _controller.text);
                      if (otpDetails.messages.status ==
                          'Contact No  not found') {
                        String otperror = otpDetails.messages.status;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(otperror),
                          backgroundColor: Colors.red,
                        ));
                      } else if (otpDetails.messages.status
                          is forgotPasswordStatus) {
                        forgotPasswordStatus otpstatus =
                            otpDetails.messages.status;
                        if (otpstatus.otp.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('OTP Sent'),
                            backgroundColor: Colors.green,
                          ));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => otp_screen(
                                        otpDetails: otpDetails,
                                        contact_no: _controller.text,
                                      )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Something Went Wrong'),
                            backgroundColor: Colors.red,
                          ));
                        }
                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: Text(
                      'Get Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Spacer(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
