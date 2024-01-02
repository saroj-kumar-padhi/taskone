import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task2/admin.dart';
import 'package:task2/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailOrPhone = TextEditingController();
  final TextEditingController password = TextEditingController();

  // Future<void> signIn() async {
  //   try {
  //     String emailOrPhoneNumber = emailOrPhone.text.trim();

  //     UserCredential userCredential;

  //     // Check if the input is a valid email address
  //     if (RegExp(
  //             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //         .hasMatch(emailOrPhoneNumber)) {
  //       userCredential = await _auth.signInWithEmailAndPassword(
  //         email: emailOrPhoneNumber,
  //         password: password.text,
  //       );
  //     } else {
  //       // If not a valid email, assume it's a phone number
  //       userCredential = await _auth.signInWithEmailAndPassword(
  //         email:
  //             '', // Firebase requires an email, but we won't use it for authentication
  //         password: password.text,
  //       );

  //       // Additional steps for phone number authentication
  //       await userCredential.user
  //           ?.updatePhoneNumber(PhoneAuthProvider.credential(
  //         verificationId:
  //             'dummy_verification_id', // Replace with actual verification ID
  //         smsCode:
  //             emailOrPhoneNumber, // Assuming phone number is entered in place of the email
  //       ));
  //     }

  //     print('User signed in successfully!');
  //   } catch (e) {
  //     print('Error during sign in: $e');
  //   }
  // }
  //h

  Future<void> signIn() async {
    try {
      String emailOrPhoneNumber = emailOrPhone.text.trim();
      String enteredPassword = password.text;

      // Query Firestore to find a user with matching email or phone
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email or phone no', isEqualTo: emailOrPhoneNumber)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // User with provided email or phone found
        // Check if the entered password matches the stored password
        var userData = querySnapshot.docs.first.data();
        var storedPassword = userData['password'];

        if (enteredPassword == storedPassword) {
          print('User signed in successfully!');
          // Navigate to the desired screen after successful sign-in
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
          );
        } else {
          print('Incorrect password');
          // Handle incorrect password
        }
      } else {
        print('User not found');
        // Handle user not found
      }
    } catch (e) {
      print('Error during sign in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset(
                'animations/Animation - 1704005789456.json',
                height: 300,
                reverse: true,
                repeat: true,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextField(
                  controller: emailOrPhone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email or phone number',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextField(
                  controller: password,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter password',
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // side: BorderSide(color: Colors.yellow, width: 5),

                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminPage()),
                      );
                    },
                    child: const Text("Login"),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Create an account?",
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage())),
                    child: Text("Sign Up",
                        style: TextStyle(fontSize: 15, color: Colors.purple)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
