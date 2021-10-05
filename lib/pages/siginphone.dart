import 'package:flutter/material.dart';
import 'package:midterm/authentication.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SignInPhone extends StatefulWidget {
  const SignInPhone({Key? key}) : super(key: key);

  @override
  _SignInPhoneState createState() => _SignInPhoneState();
}
class _SignInPhoneState extends State<SignInPhone> {

  //final _formKey = GlobalKey<FormState>();
  final SmsAutoFill _autoFill = SmsAutoFill();
  late TextEditingController
  _phoneController,
  _smsController;

  void initState(){
    super.initState();
    _phoneController = TextEditingController();
    _smsController = TextEditingController();
  }
  void dipose(){
    _phoneController.dispose();
    _smsController.dispose();
    super.dispose();
  }

  String _phone = '';
  String _sms = '';
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in with phone number"),
      ),
      backgroundColor: Colors.teal,
      body: Padding(padding: const EdgeInsets.all(6),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone number (+1 xxx-xxx-xxxx)'),
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                 alignment: Alignment.center,
                 child: RaisedButton(
                  color: Colors.greenAccent[400],
                  child: Text("Verify Number"),
                  onPressed: () async {
                    Authentication().verifyPhone(_phoneController.text, context);
                  },
                ),
              ),
              TextFormField(
                controller: _smsController,
                decoration: const InputDecoration(labelText: 'Verification code'),
               ),
               Container(
                 padding: const EdgeInsets.only(top: 10.0),
                 alignment: Alignment.center,
                  child: RaisedButton(
                    color: Colors.greenAccent[200],
                     onPressed: () async {
                        Authentication().signInWithPhone(_smsController.text, context);
                      },
                    child: Text("Sign in")),
                ),
            ],
          )
      ),
    ),
    );
  }
}