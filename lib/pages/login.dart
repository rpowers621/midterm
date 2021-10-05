import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:midterm/pages/register.dart';
import 'package:midterm/pages/siginphone.dart';
import 'emailSignIn.dart';
import 'loading.dart';
import 'package:midterm/authentication.dart';
import 'package:midterm/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class Login extends StatefulWidget {
  const Login({Key? key}): super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login>{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController,
      _passwordController,
      _phoneNumberController;

  get model => null;

  @override
  void initState(){
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
  bool _loading =false;
  String _password = '';
  String _email = '';
  String _phoneNumber= '';

  @override
  Widget build(BuildContext context){
    final eInput = TextFormField(
      autocorrect: false,
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        return null;
      },
      decoration: const  InputDecoration(
          labelText: "Email Address",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          hintText: "Enter Email"),
    );
    final pInput = TextFormField(
      autocorrect: false,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your password";
        }
        return null;
      },
      obscureText: true,
      decoration: const  InputDecoration(
        labelText: "Password",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        hintText: "Enter Password",
        suffixIcon: Padding(
          padding: EdgeInsets.all(20),
          child: Icon(Icons.lock_rounded),
        )
        ,

      ),
    );
    final submit = OutlinedButton(
      onPressed:(){
        if(_formKey.currentState!.validate()){
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Loading Data')));
          _email = _emailController.text;
          _password = _passwordController.text;

          _emailController.clear();
          _passwordController.clear();

          setState(() {
            _loading = true;
            Authentication().signInEmailPassword(_email, _password, context);
          });
        }
      },
      child: const Text('Submit',
          style: TextStyle(
              color: Colors.amberAccent)),
    );
    final emailOnly = OutlinedButton(
        onPressed:(){
          Navigator.push(
              context,MaterialPageRoute(builder: (con) => EmailSignIn()));
          ;
        }, child:Text("Sign With Email"));
    final signin = OutlinedButton(
        onPressed: (){
          Navigator.push(
              context,MaterialPageRoute(builder: (con) => const RegisterPage()));
        },
        child: const Text('Sign Up',
            style: TextStyle(
                color: Colors.amberAccent)
        ));
    final google = IconButton(
      icon: Image.asset('assets/googleicon.png'),
      iconSize: 20,
      onPressed: (){
        Authentication().signInWithGoogle(context);
      }, );
    final phone = OutlinedButton(
        onPressed:(){
          Navigator.push(
              context,MaterialPageRoute(builder: (con) => const SignInPhone()));},
           child: Text("Sign in with Phone number"));
    final anon = OutlinedButton(
        onPressed: (){
          Authentication().signInAnon(context);},
        child:Text("Sign in Anonymously"));

    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget> [
                        eInput,
                        pInput,
                        submit,
                        emailOnly,
                        signin,
                        google,
                        phone,
                        anon
                      ],
                    )
                ),

              ]
          )
      ),
    );
  }
}

