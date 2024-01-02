import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:task2/admin.dart';
import 'package:task2/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final DateTime timestamp = DateTime.now();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final userName = TextEditingController();
  final TextEditingController phone = TextEditingController();

  bool isPasswordValid = true; // Track password validation

  Future<void> signUp() async {
    try {
      String emailOrPhone = email.text.trim();
      String userPassword = password.text;

      if (userPassword.length < 6) {
        // Show SnackBar if password is too short
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password should be at least 6 characters.'),
          ),
        );

        // Set isPasswordValid to false to indicate invalid password
        setState(() {
          isPasswordValid = false;
        });

        return; // Return to exit the function if password is too short
      }

      // Reset isPasswordValid to true
      setState(() {
        isPasswordValid = true;
      });

      UserCredential userCredential;
      if (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailOrPhone)) {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailOrPhone,
          password: userPassword,
        );

        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'username': userName.text,
          'email or phone no': emailOrPhone,
          'timestamp': timestamp,
          'phone': phone.text,
          'password': password.text,
        });
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailOrPhone,
          password: userPassword,
        );

        await userCredential.user
            ?.updatePhoneNumber(PhoneAuthProvider.credential(
          verificationId: 'dummy_verification_id',
          smsCode: emailOrPhone,
        ));
      }

      // If registration is successful and password is valid, navigate to admin page
      if (isPasswordValid) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminPage()),
        );
      }

      print('User registered successfully!');
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  controller: userName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter user name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextField(
                  controller: email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextField(
                  controller: phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your phone Number',
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
                    onPressed: signUp,
                    child: const Text("Sign Up"),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already had an account?",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        )),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 15, color: Colors.purple),
                    ),
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
