import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:midterm/authentication.dart';








class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  File? _image;

  String id =Authentication().getUserId();
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  String age = '';
  String bio = '';
  String img = '';
  String hometown ='';
  String name = '';


  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Home Page"),
          actions: <Widget>[
            FlatButton(
                onPressed: (){
                  getImage(true);
                },
                child: const Icon(Icons.add)
            )
          ]
      ),
      backgroundColor: Colors.amberAccent,
      body:

            StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                   child: CircularProgressIndicator(),
                );
              }
               return ListView(
                 children: snapshot.data!.docs.map((document) {

                 return Container(
                    height: 60,
                    decoration: const BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        color: Colors.teal,
                     ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          Container(
                            child:
                              document['url'].length > 1 ?
                              Image.network(document['url'], height: 50, width: 50,) :
                              Image.asset('assets/blankUser.png', height: 50, width: 50,),
                          ),
                        Container(
                          child: Text( document['first_name']),
                          padding: EdgeInsets.all(6),
                        ),
                        Container(
                          child: Text( document['time']),
                          padding: EdgeInsets.all(2),
                        ),

                        Container(
                          child: RaisedButton.icon(
                              onPressed: () async {
                                setState(() {
                                   age=  document['age'];
                                     bio = document['bio'];
                                     hometown= document['hometown'];
                                    name= document['first_name'];
                                     img = document['url'];
                                });
                                Navigator.push(
                                    context,MaterialPageRoute(builder: (context) =>
                                    SecondScreen(age,
                                      img,
                                      name,
                                      bio,
                                      hometown,
                                    )));
                               //
                              },
                              icon: Icon(Icons.account_circle_outlined ) , label: Text('Visit User')),
                        )

                      ]
                     ),
                    margin:EdgeInsets.all(5.0),

                );

                }).toList(),
                );
            },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Authentication().signOut(context);
        },
        tooltip: 'Log Out',
        child: const Icon(Icons.logout),
      ),
    );

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
          addImage(_image);
    });
  }

  Future<void> addImage(img) async {
    User user = Authentication().getAuthUser();
    String id = user.uid;
    var storage = FirebaseStorage.instance;
    TaskSnapshot snapshot = await storage
        .ref()
        .child(id)
        .putFile(img);
    if (snapshot.state == TaskState.success) {
      final String downloadUrl =
      await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"url": downloadUrl});
      setState(() {

      });
    }

  }
}

class SecondScreen extends StatefulWidget{
  final String age;
  final String img;
  final String name;
  final String bio;
  final String hometown;
  SecondScreen(this.age,this.img,this.name,this.bio,this.hometown);

  @override
  State<StatefulWidget> createState() { return new SecondScreenState();}
}
class SecondScreenState extends State<SecondScreen>{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("User Page"),
      ),
      backgroundColor:Colors.amberAccent ,
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: Text( widget.name,
                  style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 50.0)),
              padding: EdgeInsets.all(30),
            ),
            Container(
              child: widget.img.length > 1 ?
              Image.network(widget.img, height: 200, width: 200,) :
              Image.asset('assets/blankUser.png', height: 200, width: 200,),
            ),
            Container(
              child: Text("Bio: " + widget.bio,
                  style: const TextStyle(
                      color: Colors.teal,
                      fontSize: 20.0)),
              padding: EdgeInsets.all(25),
            ),
            Container(
              child: Text("Age: " + widget.age,
                  style: const TextStyle(
                      color: Colors.teal,
                      fontSize: 20.0)),
              padding: EdgeInsets.all(25),
            ),
            Container(
              child: Text("Hometown: " + widget.hometown,
                  style: const TextStyle(
                      color: Colors.teal,
                      fontSize: 20.0)),
              padding: EdgeInsets.all(25),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Authentication().signOut(context);
        },
        tooltip: 'Log Out',
        child: const Icon(Icons.logout),
      ),
    );

  }


}


