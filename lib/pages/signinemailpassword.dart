import 'package:flutter/material.dart';
import 'package:midterm/authentication.dart';

class SignInEmailPassword extends StatefulWidget {
  SignInEmailPassword({Key? key}) : super(key: key);

  @override
  _SignInEmailPasswordState createState() => _SignInEmailPasswordState();
}
class _SignInEmailPasswordState extends State<SignInEmailPassword> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController, _passwordController;

  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void dipose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final emailInput = TextFormField(
      autocorrect: false,
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        return null;
      },
      decoration: const InputDecoration(
          labelText: "Email Address",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          hintText: "Enter Email"),
    );
    final passwordInput = TextFormField(
      autocorrect: false,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your password";
        }
        return null;
      },
      decoration: const InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          hintText: "Enter Password"),
    );
    final submit = OutlinedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Loading Data')));
          _email = _emailController.text;
          _password = _passwordController.text;
          _emailController.clear();
          _passwordController.clear();


          setState(() {
            Authentication().signInEmailPassword(_email, _password, context);
          });
        }
      },
      child: const Text('Submit',
          style: TextStyle(
              color: Colors.amberAccent)),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in with email"),
      ),
      backgroundColor: Colors.teal,
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        emailInput,
                        passwordInput,
                        submit,
                      ],
                    )
                ),
              ]
          )
      ),
    );
  }
}
