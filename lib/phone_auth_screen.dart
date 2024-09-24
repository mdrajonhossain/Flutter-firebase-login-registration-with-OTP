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

  String? verificationId;
  bool isEmailVerified = false;

  Future<void> register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await userCredential.user!.sendEmailVerification();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Verification Email Sent'),
          content: Text('Please check your email for the verification link.'),
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
    } catch (e) {
      // Handle error
      print(e);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
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
  }

  Future<void> login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user!.emailVerified) {
        // Successfully logged in
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: Text('Login Successful'),
              content: Text('Welcome!'),
              actions: [
              TextButton(
              onPressed: () {
        Navigator.of(context).pop();
        },
          child: Text('OK'),
          ],
          ],
        ),
    );
    } else {
    // Email not verified
    showDialog(
    context: context,
    builder: (context) => AlertDialog(
    title: Text('Email Not Verified'),
    content: Text('Please verify your email first.'),
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
    } catch (e) {
    // Handle error
    print(e);
    showDialog(
    context: context,
    builder: (context) => AlertDialog(
    title: Text('Error'),
    content: Text(e.toString()),
    actions: [
    TextButton(
    onPressed: () {
    Navigator.of(context).pop();
    },
    child: Text('OK'),
    ],
    ],
    ),
    );
    }
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
          ],
        ),
      ),
    );
  }
}
