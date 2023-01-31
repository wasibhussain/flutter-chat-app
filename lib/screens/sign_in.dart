import 'dart:convert';

import 'package:chat_app/methods.dart';
import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign In'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login Here',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        label: Text('Email'), border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                        label: Text('Password'), border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        loginUser(emailController.text, passwordController.text)
                            .then((user) {
                          if (user != null) {
                            setState(() {
                              isLoading = false;
                            });
                            print('Login Success');
                          } else {
                            print('login failed');
                          }
                        });
                      } else {
                        print('please enter fields');
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.94,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                          child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Get.to(const SignUp());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.94,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                          child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
