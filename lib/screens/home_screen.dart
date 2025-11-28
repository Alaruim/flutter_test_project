import 'package:flutter/material.dart';
import '../services/token_storage.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userId;
  String? _userEmail;
  bool _isLoading = true;
  String _errorText = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final jwt = await TokenStorage.getJwt();
      final email = await TokenStorage.getEmail();

      if (jwt == null) {
        _goToLogin();
        return;
      }

      setState(() {
        _userEmail = email;
      });

      final userId = await AuthService.getUserId(jwt);

      if (userId == null) {
        final refreshed = await _refreshToken();
        if (!refreshed) {
          _goToLogin();
          return;
        }
      } else {
        setState(() {
          _userId = userId;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _errorText = 'Data upload error';
        _isLoading = false;
      });
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) {
        return false;
      }

      final newTokens = await AuthService.refreshToken(refreshToken);
      if (newTokens != null &&
          newTokens['jwt'] != null &&
          newTokens['refresh_token'] != null) {
        await TokenStorage.saveTokens(
          newTokens['jwt'],
          newTokens['refresh_token'],
        );

        final userId = await AuthService.getUserId(newTokens['jwt']);
        setState(() {
          _userId = userId;
          _isLoading = false;
        });
        return true;
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }
    return false;
  }

  Future<void> _logout() async {
    await TokenStorage.logout();
    _goToLogin();
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF1FFFFFF),
      appBar: AppBar(
        title: Text(
          'Main',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFF6B00),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Authorized',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    SizedBox(height: 40),

                    _buildInfoCard(),

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _loadUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF6B00),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 43),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (_errorText.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          _errorText,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ID:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    _userId ?? 'Failed to upload',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Text('Email: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    _userEmail ?? 'Unknown',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  _userId != null ? 'Active' : 'Error',
                  style: TextStyle(
                    color: _userId != null ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
