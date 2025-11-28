import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/validators.dart';
import '../services/auth_service.dart';
import 'code_input_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool isLoading = false;
  String errorText = '';
  String? validationError;

  void sendCode() async {
    setState(() {
      errorText = '';
      validationError = null;
    });

    final emailError = Validators.emailValidator(_emailController.text);
    if (emailError != null) {
      setState(() {
        validationError = emailError;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    bool success = await AuthService.sendCodeToEmail(_emailController.text);

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CodeInputScreen(email: _emailController.text),
        ),
      );
    } else {
      setState(() {
        errorText = 'Failed to send code';
      });
    }
  }

  void _clearErrors() {
    if (errorText.isNotEmpty || validationError != null) {
      setState(() {
        errorText = '';
        validationError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: Color(0xF1FFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Row(
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                      SizedBox(width: 4),
                      SvgPicture.asset(
                        'assets/images/User.svg',
                        width: 20,
                        height: 19,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 54),
                
                Image.asset(
                  'assets/images/Main_image.png',
                  width: 296,
                  height: 231,
                ),

                SizedBox(height: 15),

                Text(
                  'Enter Your Email',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2796B),
                  ),
                ),

                SizedBox(height: 46),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Container(
                        height: 43.0,
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter Email',
                            hintStyle: TextStyle(color: Color(0xFF7D7D7D)),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            errorStyle: TextStyle(height: 0, fontSize: 0),
                          ),
                          style: TextStyle(fontSize: 16.0),
                          onChanged: (value) => _clearErrors(),
                        ),
                      ),
                      
                      SizedBox(height: 4),
                      
                      if (validationError != null)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            validationError!,
                            style: TextStyle(
                              color: errorColor,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      
                      if (errorText.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            errorText,
                            style: TextStyle(
                              color: errorColor,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : sendCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B00),
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 43),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Send Code',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}