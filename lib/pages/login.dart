import 'package:midterm/pages/register.dart';
import 'package:midterm/pages/siginphone.dart';
import 'package:midterm/pages/signinemailpassword.dart';
import 'emailSignIn.dart';
import 'package:midterm/authentication.dart';
import 'package:flutter/material.dart';



class Login extends StatefulWidget {
  const Login({Key? key}): super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>{


  @override
  Widget build(BuildContext context){
    final emailPassword = OutlinedButton(
        onPressed: (){
          Navigator.push(
              context,MaterialPageRoute(builder: (con) => SignInEmailPassword()));
        },
        child: const Text("Sign in with email and password",
            style: TextStyle(
                color: Colors.amberAccent)));
    final emailOnly = OutlinedButton(
        onPressed:(){
          Navigator.push(
              context,MaterialPageRoute(builder: (con) => EmailSignIn()));

        }, child:const Text("Sign With Email",
        style: TextStyle(
            color: Colors.amberAccent)));
    final signin = OutlinedButton(
        onPressed: (){
          Navigator.push(
              context,MaterialPageRoute(builder: (con) => const RegisterPage()));
        },
        child: const Text('Sign Up',
            style: TextStyle(
                color: Colors.amberAccent)
        ));
    final google = OutlinedButton.icon(
      icon: Image.asset('assets/googleicon.png', height: 20, width: 20,),
      label: const Text("Sign in With Google",
          style: TextStyle(
              color: Colors.amberAccent)),
      onPressed: (){
        Authentication().signInWithGoogle(context);
      } );
    final facebook=  OutlinedButton.icon(
        icon: Image.asset('assets/facebook.png', height: 20, width: 20,),
        label: const Text("Sign in With Facebook",
            style: TextStyle(
                color: Colors.amberAccent)),
        onPressed: (){
          Authentication().signInWithFacebook(context);
        } );
    final phone = OutlinedButton(
        onPressed:(){
          Navigator.push(
              context,MaterialPageRoute(builder: (con) => const SignInPhone()));},
           child: const Text("Sign in with Phone number",
               style: TextStyle(
                   color: Colors.amberAccent)));
    final anon = OutlinedButton(
        onPressed: (){
          Authentication().signInAnon(context);},
        child:const Text("Sign in Anonymously",
            style: TextStyle(
                color: Colors.amberAccent)));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.teal,
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                    child: Column(
                      children: <Widget> [
                        emailPassword,
                        emailOnly,
                        google,
                        facebook,
                        phone,
                        anon,
                        signin,
                      ],
                    )
                ),
              ]
          )
      ),
    );
  }
}

