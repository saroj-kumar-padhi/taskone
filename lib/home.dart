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

  @override
  Widget build(BuildContext context) {
    final DateTime timestamp = DateTime.now();
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    final userName = TextEditingController();
    final TextEditingController phone = TextEditingController();

    Future<void> signUp() async {
      try {
        String emailOrPhone = email.text.trim();

        UserCredential userCredential;

        if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(emailOrPhone)) {
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: emailOrPhone,
            password: password.text,
          );

          await _firestore
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
            'username': userName.text,
            'email or phone no': emailOrPhone,
            'timestamp': timestamp,
            'phone': phone.text,
            'password': password.text,
          });
        } else {
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: emailOrPhone,
            password: password.text,
          );

          await userCredential.user
              ?.updatePhoneNumber(PhoneAuthProvider.credential(
            verificationId: 'dummy_verification_id',
            smsCode: emailOrPhone,
          ));
        }

        print('User registered successfully!');
      } catch (e) {
        print('Error during registration: $e');
      }
    }

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
              // New user, navigate to admin page

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await signUp();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminPage()),
                      );
                    },
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
                      "Sign in",
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
