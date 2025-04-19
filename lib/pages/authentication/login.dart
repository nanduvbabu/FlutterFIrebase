import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_auth/local_auth.dart';

class BiometricLoginPage extends StatefulWidget {
  const BiometricLoginPage({Key? key}) : super(key: key);

  @override
  State<BiometricLoginPage> createState() => _BiometricLoginPageState();
}

class _BiometricLoginPageState extends State<BiometricLoginPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // 🔹 Logout Function
  Future<void> _logoutUser() async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged out successfully')),
    );
    Navigator.pushReplacementNamed(context, '/login'); // Redirect to Login Page
  }

  // 🔹 Check if the device supports biometrics
  Future<bool> _isBiometricAvailable() async {
    return await _localAuth.canCheckBiometrics;
  }

  // 🔹 Handle manual login
  Future<void> _loginUser() async {
    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final role = userDoc['role'];

      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/adminHome');
      } else {
        Navigator.pushReplacementNamed(context, '/customerHome');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🔹 Handle Biometric Login
  Future<void> _handleBiometricLogin() async {
    bool isAuthenticated = await _authenticate();

    if (isAuthenticated) {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (userId.isNotEmpty) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        final role = userDoc['role'];

        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/adminHome');
        } else {
          Navigator.pushReplacementNamed(context, '/customerHome');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No saved credentials found.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Biometric authentication failed.')),
      );
    }
  }

  // 🔹 Authenticate using fingerprint/face ID
  Future<bool> _authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to login',
        options: AuthenticationOptions(
          biometricOnly: false, // Allow PIN/password fallback
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Error in biometric authentication: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Fingerprint'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logoutUser, // 🔹 Logout Button
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Email & Password Fields
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),

            // Buttons
            _isLoading
                ? CircularProgressIndicator()
                : Column(
              children: [
                ElevatedButton(
                  onPressed: _loginUser,
                  child: Text('Login'),
                ),
                SizedBox(height: 10),
                FutureBuilder<bool>(
                  future: _isBiometricAvailable(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.data == true) {
                      return ElevatedButton.icon(
                        icon: Icon(Icons.fingerprint),
                        label: Text('Login with Fingerprint'),
                        onPressed: _handleBiometricLogin,
                      );
                    } else {
                      return Container(); // Hide if not supported
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
