import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jot_down/Home.dart';
import 'package:jot_down/Login.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'Register.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _Welcome_screenState();
}

class _Welcome_screenState extends State<Welcome> {
  bool loading=false;
  final _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xffCDC9C9),

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(height: 345.0,decoration: BoxDecoration(color: Color(0xffD7DADC),borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0),
                ),
                ),
                  child: Stack(

                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Container(alignment:Alignment.center,child: Image.asset('images/logo.png')),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(80.0),
                        child: Container( alignment: Alignment.bottomCenter,child: Text('Jot Down',style: GoogleFonts.quicksand(fontSize: 30,fontWeight: FontWeight.w900,color: Color(0xff1400FF)),),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Container(alignment:Alignment.bottomCenter,child: Text('Scribble your ideas',style: GoogleFonts.quicksand(fontSize: 20,fontWeight: FontWeight.bold),),),
                      )

                    ],),

                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40,top: 95),
                  child: Material(
                      borderRadius: BorderRadius.circular(19.0),
                      color: Color(0xff063057)



                      ,child:MaterialButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                  },child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Register',style: GoogleFonts.roboto(color: Colors.white,fontSize: 24.0,fontWeight:FontWeight.bold),),
                  ),
                  )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40,top: 50),
                  child: Material(
                      borderRadius: BorderRadius.circular(19.0),
                      color: Colors.white




                      ,child:MaterialButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));

                  },child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Login',style: GoogleFonts.roboto(color: Color(0xff063057),fontSize: 24.0,fontWeight: FontWeight.bold),),
                  ),

                  )
                  ),
                ),



              ],),
          )

      ),
    );
  }
}

