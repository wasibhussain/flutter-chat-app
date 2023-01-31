import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

Future<User?> createUser(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({'name': name, 'email': email, 'status': "Unavailable"});
      print('Account created Successfully');

      return user;
    } else {
      print('Account creation failed');
      return user;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<User?> loginUser(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print('User Loggedin Successfully');
      Get.to(HomeScreen());
      return user;
    } else {
      print('Login failed');
      return user;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future logOut() async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut();
    Get.to(SignIn());
  } catch (e) {
    print(e.toString());
  }
}
