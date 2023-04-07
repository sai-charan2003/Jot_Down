import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jot_down/Register.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

import 'Home.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailtextcontroller=TextEditingController();
  final passwordtextcontroller=TextEditingController();
  bool loading=false;
  final auth=FirebaseAuth.instance;
  void dispose() {
    // TODO: implement dispose
    emailtextcontroller.dispose();
    passwordtextcontroller.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData.light(useMaterial3: true),
      home: Scaffold(
        backgroundColor: Color(0xffCDC9C9),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Color(0xffD7DADC),borderRadius: BorderRadius.only(bottomRight: Radius.circular(30.0),bottomLeft: Radius.circular(30.0)
                )
                ),
                height: 345,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
    
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Container(alignment:Alignment.center,child: Image.asset('images/logo.png')),
                    ),
    
    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Container(alignment:Alignment.bottomCenter,child: Text('Login to ',style: GoogleFonts.quicksand(fontSize: 20,fontWeight: FontWeight.w900),),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Container(alignment:Alignment.bottomCenter,child: Text('Jot Down ',style: GoogleFonts.quicksand(fontSize: 20,fontWeight: FontWeight.w900,color: Color(0xff1400FF)),),),
                        ),
    
                      ],
                    )
    
                  ],),
              ),
              SizedBox(height: 50.0,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailtextcontroller,
                  decoration: InputDecoration(labelText: "Email Address",labelStyle: GoogleFonts.quicksand(fontWeight: FontWeight.w500,color: Colors.black,),
    
    
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                      borderSide:BorderSide(width: 3,color: Colors.blue),
    
                    ),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                      borderSide:BorderSide(width: 3,color: Colors.blue),
    
                    ),
                    prefixIcon: Icon(Icons.email_outlined,color: Colors.black,)
    
    
                ),
    
    
                ),
              ),
              //SizedBox(height: 50.0,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 20.0),
                child: TextField(
                  obscureText: true,
                  controller: passwordtextcontroller,
                decoration: InputDecoration(
    
                    labelText: "Password",labelStyle: GoogleFonts.quicksand(fontWeight: FontWeight.w500,color: Colors.black),
    
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                      borderSide:BorderSide(width: 3,color: Colors.blue),
    
                    ),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),
                      borderSide:BorderSide(width: 3,color: Colors.blue),
    
                    ),
                    prefixIcon: Icon(Icons.key,color: Colors.black,)
    
    
                ),
    
    
                ),
              ),
    
              Padding(
    
                padding: EdgeInsets.all(30.0),
                child: Material(
                    borderRadius: BorderRadius.circular(19.0),
                    color: Color(0xff063057)
    
    
    
                    ,child:loading?CircularProgressIndicator():MaterialButton(onPressed: () async {
                      setState(() {
                        loading=true;
                      });
                      if(emailtextcontroller.text==""||passwordtextcontroller.text==""){
                        AnimatedSnackBar.material(
                          'All field are requried',
                          type: AnimatedSnackBarType.warning,
                        ).show(context);
    
                      }
                      else{
                        try {
                          final  user = (await auth.signInWithEmailAndPassword(
                              email: emailtextcontroller.text,
                              password: passwordtextcontroller.text)) ;
                          User data=user.user!;
                          if(user!=null){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home(data)), (route) => false);
                          }
                        } on FirebaseAuthException
                        catch(e){
                          AnimatedSnackBar.material(
                            e.message.toString(),
                            type: AnimatedSnackBarType.error,
                          ).show(context);
    
    
                        }
    
    
                      }
                      setState(() {
                        loading=false;
                      });
    
    
                },child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Login',style: GoogleFonts.roboto(color: Colors.white,fontSize: 24.0,),),
                ),
                )
                ),
              ),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
    
    
              }, child: Text('Don\'t have an account? Register Here'))
            ],
    
    
    
          ),
        ),
      ),
    );
  }
}

