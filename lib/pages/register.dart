import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:midterm/authentication.dart';
import '/driver.dart';



class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}): super(key:key);


  @override
  _RegisterPageState createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  File? _image;

  late TextEditingController _emailController,
      _reEmailController,
      _passwordController,
      _rePasswordController,
      _firstnameController,
      _lastnameController,
      _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _reEmailController = TextEditingController();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _phoneController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _reEmailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();

    super.dispose();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up For Powers Fan Page"),
        ),
        backgroundColor: Colors.teal,
        resizeToAvoidBottomInset: false,
        body: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 5.0),
              TextFormField(
                autocorrect: false,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "EMAIL ADDRESS",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter Email'),
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                autocorrect: false,
                controller: _reEmailController,
                validator: (value) {
                  if (value == null || value != _reEmailController.text) {
                    return 'Email addresses do not match';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "RE ENTER EMAIL ADDRESS",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Re-Enter Email'),
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                autocorrect: false,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "ENTER PASSWORD",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter Password'),
              ),
              const SizedBox(height:5.0),
              TextFormField(
                autocorrect: false,
                controller: _rePasswordController,
                validator: (value) {
                  if (value == null || value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "VERIFY PASSWORD",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Verify Password'),
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                autocorrect: false,
                controller: _firstnameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Enter Firstname",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter Firstname'),
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                autocorrect: false,
                controller: _lastnameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lastname cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Enter Lastname",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: 'Enter Lastname'),
              ),
              const SizedBox(height: 5.0),
              TextFormField(
                autocorrect: false,
                controller: _phoneController,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Phone number cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Enter Phone number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    hintText: "Enter phone number"),
                ),

              OutlinedButton(
                  onPressed:(){
                    getImage(true);
                  },
                  child:const Text("Add Photo",
                    style: TextStyle(
                        color: Colors.amberAccent))),
              OutlinedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Loading Data')));

                    setState(() {
                      signUp();
                    });
                  }
                },
                child: const Text('Submit',
                    style: TextStyle(
                        color: Colors.amberAccent)),
              )
            ])));
  }

  Future getImage(bool gallery) async {
    ImagePicker imagePicker = ImagePicker();
    XFile image;
    // Let user select photo from gallery
    if(gallery) {
      image = (await imagePicker.pickImage(
          source: ImageSource.gallery,imageQuality: 50))!;
    }
    // Otherwise open camera to get new photo
    else{
      image = (await imagePicker.pickImage(
          source: ImageSource.camera,imageQuality: 50))!;
    }
    setState(() {
      _image = File(image.path); // Use if you only need a single picture\

    });
  }
    Future<void> signUp() async {
      try {
        var auth = Authentication().getAuth();
        UserCredential userCredential =
        await auth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        var now =  DateTime.now();
        var formatter = new DateFormat('dd/MM/yyyy');
        String formattedDate = formatter.format(now);

        _db
            .collection("users")
            .doc(userCredential.user!.uid)
            .set({
          "first_name": _firstnameController.text,
          "last_name": _lastnameController.text,
          "phone_number": _phoneController.text,
          "role" : 'customer',
          "uid" : userCredential.user!.uid,
          "time" : formattedDate,
        })
            .then((value) => null)
            .onError((error, stackTrace) => null);
        addImage();

      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Error")));
      } catch (e) {
        print(e);
      }

      setState(() {

      });
    }

  Future<void> addImage() async {
    String id =Authentication().getUserId();

    var storage = FirebaseStorage.instance;
    TaskSnapshot snapshot = await storage
        .ref()
        .child(id)
        .putFile(_image!);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl =
      await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"url": downloadUrl});
    }
    Navigator.pushReplacement(context,MaterialPageRoute(builder:  (con) => AppDriver()));
  }
}


