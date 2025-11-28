import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/token_storage.dart';
import 'home_screen.dart';

class CodeInputScreen extends StatefulWidget {
  final String email;
  
  const CodeInputScreen({Key? key, required this.email}) : super(key: key);
  
  @override
  _CodeInputScreenState createState() => _CodeInputScreenState();
}

class _CodeInputScreenState extends State<CodeInputScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String _errorText = '';

  void _confirmCode() async {
    if (_codeController.text.isEmpty) {
      setState(() {
        _errorText = 'Enter the code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    try {
      final response = await AuthService.confirmCode(
        widget.email, 
        _codeController.text
      );

      if (response != null && response['jwt'] != null && response['refresh_token'] != null) {
        await TokenStorage.saveTokens(
          response['jwt'], 
          response['refresh_token'],
          email: widget.email, 
        );
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } else {
        setState(() {
          _errorText = 'Invalid code or server error';
        });
      }
    } catch (e) {
      setState(() {
        _errorText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF1FFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                'Enter the code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              SizedBox(height: 20),
              
              Text(
                'The code has been sent ${widget.email}',
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 40),
              
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Code',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF6B35), width: 2.0),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  focusColor: Color(0xFFFF6B35), 
                  floatingLabelStyle: TextStyle(
                    color: Color(0xFFFF6B35), 
                  ),
                  errorText: _errorText.isNotEmpty ? _errorText : null,
                ),
              ),
              
              SizedBox(height: 20),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _confirmCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF6B00),
                  foregroundColor: Colors.white,
                  minimumSize: Size(100, 43),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: _isLoading 
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
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