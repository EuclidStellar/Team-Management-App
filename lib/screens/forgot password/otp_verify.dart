import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'new_password.dart';

class OTPVerify extends StatefulWidget {
  final String email;

  const OTPVerify({super.key, required this.email});

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  final TextEditingController otpController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<String?> takeOTPAPI(String otp) async {
    final String apiUrl =
        'http://ec2-3-7-70-25.ap-south-1.compute.amazonaws.com:8006/user/verifyOTP/${widget.email}';
    var body = jsonEncode({
      "OTP": otp,
    });
    var headers = {'Content-Type': 'application/json'};
    try {
      var response =
          await http.post(Uri.parse(apiUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        print('OTP verified');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP verified"),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePassword(
              email: widget.email,
            ),
          ),
        );
        print(jsonDecode(response.body));
        return null;
      } else {
        print('Error: ${response.statusCode}');
        print(jsonDecode(response.body));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
        return jsonDecode(response.body)['error'];
      }
    } catch (e) {
      print('Error: $e');
      // return 'An error occurred';
    }
    return null;
  }

  void _verifyOTP(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String otp = otpController.text.trim();
      String? error = await takeOTPAPI(otp);

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('OTP verified successfully!'),
        //     backgroundColor: Colors.green,
        //   ),
        // );
        //   Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ChangePassword(email: widget.email,),
        //   ),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Opacity(
          opacity: 0.5,
          child: Image.asset(
            "lib/assets/back.png",
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      "lib/assets/reset.png",
                      fit: BoxFit.fitWidth,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Enter OTP',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Enter OTP sent to ${widget.email}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'OTP',
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter OTP';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _verifyOTP(context),
                          child: const Text('Verify and proceed'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
