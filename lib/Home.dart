import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jot_down/converter.dart';
import 'package:jot_down/editnote.dart';
import 'package:jot_down/note.dart';
import 'package:jot_down/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  Home(this.user);
  User user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   //late User loggedinuser;


  final _auth=FirebaseAuth.instance;
  final firestone= FirebaseFirestore.instance;
  @override
  // void initState() {
  //   // TODO: implement initState
  //   getdata();
  //   super.initState();
  // }
  //  void getdata()async{
  //    final loggedinuser= await _auth.currentUser;
  //    // try {
  //    //   if (details != null) {
  //    //     loggedinuser = details;
  //    //   }
  //    // }
  //    // catch(e){
  //    //   print(e);
  //    // }
  //
  //
  //
  //  }

  Widget build(BuildContext context) {
   //final user=loggedinuser.uid;
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      
      home: Scaffold(
    
        body: Stack(children:  <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 40.0,right: 10.0),
            child: Container(
              alignment: Alignment.topRight,
              child: ElevatedButton(
    
    
                onPressed: () {
                  _auth.signOut();
                  GoogleSignIn().signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Welcome()), (route) => false);
                },
                child: Icon(Icons.logout),
                style: ElevatedButton.styleFrom(
                //primary: Colors.white,
    
    
    
    
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: StreamBuilder(
    
              stream: firestone.collection('note').where('user',isEqualTo: widget.user.uid).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
                  itemCount: snapshot.hasData?snapshot.data!.docs.length:0,
                  itemBuilder: (_,index){
                  NoteModel note=NoteModel.fromJson(snapshot.data!.docs[index]);
                  return GestureDetector(
                    onTap: (){Navigator.push(context,PageTransition(child: edit(snapshot.data!.docs[index],note), type: PageTransitionType.rightToLeft));},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(),borderRadius: BorderRadius.circular(20.0)
                      ),
                      margin: EdgeInsets.all(20),
    
                      color: Colors.transparent,
                      elevation: 0,
    
                      child: Column(children: [
                        Text(note.title,style: GoogleFonts.quicksand(fontWeight: FontWeight.w800),),
                        SizedBox(height: 8.0,),
                        Text(note.body,maxLines: 2,style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),)
    
    
                      ],),
    
    
    
                    ),
                  );
    
                  }
    
    
                );
              }
            ),
          ),
    
          Padding(
            padding: const EdgeInsets.only(top: 40.0,left: 10.0),
            child: Container(alignment: Alignment.topLeft,child: Text('Jot Down',style: GoogleFonts.quicksand(fontSize: 30,fontWeight: FontWeight.w900),)),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(onPressed: (){
                Navigator.push(context,PageTransition(child: Note(widget.user), type: PageTransitionType.fade));
              }, child: Text('New Note',style: GoogleFonts.quicksand(fontWeight: FontWeight.w700,fontSize: 20.0),
    
              ),
                // style: ElevatedButton.styleFrom(primary: Colors.pink),
              ),
            ),
          )
    
        ],),
    
    
    
        ),
    );
  }
}
