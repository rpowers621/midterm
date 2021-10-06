import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:midterm/authentication.dart';
import 'package:midterm/pages/login.dart';
import 'pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDriver extends StatelessWidget {
  AppDriver({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Authentication().getAuthUser() == null ? const Login() : HomePage();
  }
}

