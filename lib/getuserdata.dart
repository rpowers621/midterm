

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class GetUserData{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  void userInfo(fName,img, uid)async{

   print(fName);
   print(uid);


  }


}