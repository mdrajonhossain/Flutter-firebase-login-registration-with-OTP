import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthScreen extends StatefulWidget {
  @override
  _EmailAuthScreenState createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await userCredential.user!.sendEmailVerification();

      //Show verification email sent dialogasd
      _showDialog('Verification Email Sent', 'Please check your email for the verification link.');
    } catch (e) {
      // Handle error
      showErrorDialog(e);
    }
  }

  Future<void> login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user!.emailVerified) {
        // Successfully logged in
        _showDialog('Login Successful', 'Welcome!');
      } else {
        // Email not verified
        _showDialog('Email Not Verified', 'Please verify your email first.');
      }
    } catch (e) {
      // Handle error
      showErrorDialog(e);
    }
  }

  Future<void> resendVerificationEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        _showDialog('Verification Email Resent', 'Please check your email for the verification link again.');
      } catch (e) {
        showErrorDialog(e);
      }
    } else if (user?.emailVerified == true) {
      _showDialog('Email Already Verified', 'Your email is already verified.');
    } else {
      // Inform user that they need to register first
      _showDialog('No User Found', 'Please register first to send a verification email.');
    }
  }

  void showErrorDialog(dynamic e) {
    String errorMessage;

    // Customize error messages
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'The email is invalid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        default:
          errorMessage = 'An undefined error occurred.';
      }
    } else {
      errorMessage = e.toString();
    }

    _showDialog('Error', errorMessage);
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'example@gmail.com',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resendVerificationEmail,
              child: Text('Resend Verification Email'),
            ),
          ],
        ),
      ),
    );
  }
}
