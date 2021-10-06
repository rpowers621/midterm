import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'driver.dart';
import 'package:intl/intl.dart';

class Authentication {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String _verificationId = '';
  @override

  getAuth(){
    return _auth;
  }

  getAuthUser(){
    return _auth.currentUser;
  }
  getUserId(){
    User? user =_auth.currentUser;
    String id = user!.uid;
    return id;
  }
   void signInEmailPassword(_email, _password, context) async{
    await Firebase.initializeApp();
    try{
      UserCredential uid = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password);
      Navigator.push(context,MaterialPageRoute(builder:  (context) => AppDriver()));

    }on FirebaseAuthException catch(e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Wrong password")));
      }else if(e.code =='user-not-found')    {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("User not found")));
      }
    }catch (e){
      print(e);
    }

  }
  void signInWithEmail(_email, context) async{

    try{
    _auth.sendSignInLinkToEmail(
        email: _email,
        actionCodeSettings: ActionCodeSettings(
        url: "midterm-621.firebaseapp.com",
        androidPackageName: "com.company.midterm621",
        iOSBundleId: "com.company.midterm621",
        handleCodeInApp: true,
        androidMinimumVersion: "16",
        androidInstallApp: true),
    );
    Navigator.push(context,MaterialPageRoute(builder:  (context) => AppDriver()));
    }on FirebaseAuthException catch(e)
    {}catch(e){
      print(e);
    }



  }
  Future<void>verifyPhone(_phoneNumber, context) async{
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential); };


    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print("Failed: $authException");
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? resendToken]) async {
      _verificationId = verificationId;
    };

      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    print("Id: $_verificationId");
  }

   void signInWithPhone(_sms, context) async{
     try {
       final AuthCredential credential = PhoneAuthProvider.credential(
         verificationId: _verificationId,
         smsCode: _sms,
       );
       print(credential);
       final User? user = (await _auth.signInWithCredential(credential)).user;

       Navigator.push(context,MaterialPageRoute(builder:  (context) => AppDriver()));
     } catch (e) {

       print(_verificationId);
       print(e);
     }

  }
   void signInWithGoogle(context) async{
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('first_name', isEqualTo: googleUser.displayName)
        .limit(1)
        .get();
    final List <DocumentSnapshot> docs = result.docs;
    if (docs.isEmpty) {
      try {
        var now =  DateTime.now();
        var formatter =  DateFormat('dd/MM/yyyy');
        String formattedDate = formatter.format(now);
        _db
            .collection("users")
            .doc()
            .set({
          "first_name": googleUser.displayName,
          "last_name": '',
          "role": 'customer',
          "url": '',
          "uid" : credential,
          "time" : formattedDate,
        })
            .then((value) => null)
            .onError((error, stackTrace) => null);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (con) => AppDriver()));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Error")));
      } catch (e) {
        print(e);
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (con) => AppDriver()));
    }
  }
    void signInAnon(context) async{
     _auth.signInAnonymously().then((result) {
         final User? user = result.user;
     });
     Navigator.pushReplacement(
         context, MaterialPageRoute(builder: (con) => AppDriver()));
   }

   void signOut(BuildContext context) async {
     return showDialog(context: context,
         builder: (context){
           return AlertDialog(
             content: SingleChildScrollView(
               child: Text("Are you sure you'd like to log out?"),
             ),
             actions: <Widget>[
               TextButton(
                 child: Text('Log out'),
                 onPressed: () async {
                   await _auth.signOut();
                   ScaffoldMessenger.of(context)
                       .showSnackBar(const SnackBar(content: Text('User logged out.')));
                   Navigator.pushReplacement(
                       context, MaterialPageRoute(builder: (con) => AppDriver()));
                   ScaffoldMessenger.of(context).clearSnackBars();
                 },
               ),

             ],
           );
         }
     );
   }
}

