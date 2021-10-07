import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:midterm/authentication.dart';

import '../driver.dart';
import 'loading.dart';

class EmailSignIn extends StatefulWidget {
  EmailSignIn({Key? key}) : super(key: key);

  @override
  _EmailSignInState createState() => _EmailSignInState();
}
class _EmailSignInState extends State<EmailSignIn>  with WidgetsBindingObserver{

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
   bool _success = false;

  void initState(){
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _emailController = TextEditingController();
  }
  void dipose(){
    _emailController.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  String _email = '';

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: const Text('Sign in with email and link'),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value){
              if(value == null || value.isEmpty){
                return 'Email cannot be empty';
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Authentication().signInWithEmail(_emailController.text);
                }
              },
              child: const Text('Submit'),
            ),
          ),

        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final PendingDynamicLinkData? data =
      await FirebaseDynamicLinks.instance.getInitialLink();
      if( data?.link != null ) {
        Authentication().handleLink(data!.link, _email, context);
      }
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
            final Uri? deepLink = dynamicLink?.link;
            _success = Authentication().handleLink(deepLink!, _email, context);
          }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });
      setState(() {
        _success;
        if(_success){
          Navigator.push(context,MaterialPageRoute(builder:  (context) => AppDriver()));
        }else{
          Loading();
        }
      });
    }
  }

}