import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sm_delivery/api/forgot_password.dart';
import 'package:sm_delivery/models/forgot_password_response.dart';
import 'package:sm_delivery/screens/password_reset_screen/password_reset_screen.dart';
import '../../core/theme/base_color.dart';

class otp_screen extends StatefulWidget {
  const otp_screen(
      {super.key, required this.otpDetails, required this.contact_no});
  final forgotPasswordResponse otpDetails;
  final String contact_no;
  @override
  State<otp_screen> createState() => _otp_screenState();
}

class _otp_screenState extends State<otp_screen> {
  bool isTapped = false;
  final TextEditingController _controller = TextEditingController();
  String otp = '';
  late Timer _timer;
  int _start = 40;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    setState(() {
      _isButtonDisabled = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isButtonDisabled = false;
          _start = 40;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void validate_otp() {
    if (otp == '') {
      if (_controller.text == widget.otpDetails.messages.status.otp) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => password_reset_screen(
              contact_no: widget.contact_no,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else if (otp != '') {
      if (_controller.text == otp) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => password_reset_screen(
              contact_no: widget.contact_no,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              const Text(
                'Shobamart',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Enter the OTP sent to ${widget.contact_no}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.opacity_sharp),
                  labelText: 'Verification code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: _isButtonDisabled
                        ? null
                        : () async {
                            startTimer();
                            final result = await forgot_password_api()
                                .forgot_password(contact_no: widget.contact_no);
                            forgotPasswordStatus otpstatus =
                                result.messages.status;
                            if (otpstatus.otp.isNotEmpty) {
                              setState(() {
                                otp = otpstatus.otp;
                              });
                            }
                          },
                    child: Text(
                      _isButtonDisabled
                          ? 'Resend Code ($_start s)'
                          : 'Resend Code',
                      style: TextStyle(
                        color: _isButtonDisabled
                            ? Colors.grey
                            : AppColors.primarycolor2,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primarycolor2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  validate_otp();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: const Text(
                    'Verify Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
