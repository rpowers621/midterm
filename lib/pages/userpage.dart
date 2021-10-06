import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:midterm/authentication.dart';







class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}


class _UserPageState extends State<UserPage> {

  String id =Authentication().getUserId();
  final FirebaseFirestore fb = FirebaseFirestore.instance;




  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("User Page"),
      ),
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
                        child: Text("User: " + document['first_name']),
                        padding: EdgeInsets.all(6),
                      ),
                      Container(
                        child: Text("Registered: " + document['time']),
                      ),

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
   void userInfo(uid)async{
    String he = uid;
  }
}