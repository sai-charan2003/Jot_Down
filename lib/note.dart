import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jot_down/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'package:panara_dialogs/panara_dialogs.dart';

class Note extends StatefulWidget {
  Note(this.user);
  User user;

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  String? filename;
  File? imagefile;
  bool submit = false;
  bool image = false;
  bool uploaded = true;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User loggedinuser;
  final _auth = FirebaseAuth.instance;
  Future<void> uploadimage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      setState(() {
        filename = image.name;
        imagefile = File(image.path);
        uploaded = false;
      });
    }
  }

  Future<void> deleteimage(String ref) async {
    await firebaseStorage.ref(ref).delete();
  }

  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }

  void getdata() async {
    final details = await _auth.currentUser;
    try {
      if (details != null) {
        loggedinuser = details;
      }
    } catch (e) {
      print(e);
    }
  }

  final title = TextEditingController();
  final body = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Row(
              children: [
                uploaded
                    ? IconButton(
                        onPressed: () {
                          uploadimage();
                        },
                        icon: Icon(Icons.add_a_photo_rounded))
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            imagefile = null;
                            uploaded = true;
                          });
                        },
                        child: Text(
                          'Delete Image',
                          style: GoogleFonts.quicksand(color: Colors.white),
                        ),
                        // style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      ),
                IconButton(
                    onPressed: () async {
                      PanaraConfirmDialog.show(
                        context,
                        title: "Are You Sure",
                        message: "Do you really want to delete the note?",
                        confirmButtonText: "Confirm",
                        cancelButtonText: "Cancel",
                        onTapCancel: () {
                          Navigator.pop(context);
                        },
                        onTapConfirm: () async {
                          Navigator.pop(context);

                          Navigator.pop(context);
                        },
                        panaraDialogType: PanaraDialogType.warning,
                        barrierDismissible:
                            false, // optional parameter (default is true)
                      );
                    },
                    icon: Icon(Icons.delete_outline_outlined))
              ],
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      child: imagefile != null
                          ? Flexible(child: Image.file(imagefile!))
                          : null),
                  Flexible(
                    child: TextField(
                      controller: title,
                      //maxLines: 2,
                      maxLength: 50,

                      decoration: InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w800, fontSize: 25)),
                      cursorColor: Colors.black,
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w900, fontSize: 30.0),
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: body,
                      maxLines: 300,
                      decoration: InputDecoration(
                          hintText: 'Body',
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w800, fontSize: 25)),
                      cursorColor: Colors.black,
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500, fontSize: 25.0),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: submit
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            //print('sfhjksadhfkjsdhfjksahfkjshfjksahfjksdhfjsadhfjksahfjkashfjksahfjksahfjksahfjkashfjkhasjkfhjaksf');

                            setState(() {
                              submit = true;
                            });
                            if (imagefile != null) {
                              image = true;

                              String imageurl = await firebaseStorage
                                  .ref(filename)
                                  .putFile(imagefile!)
                                  .then((result) {
                                return result.ref.getDownloadURL();
                              });
                              await firestore.collection('note').add({
                                'title': title.text,
                                'body': body.text,
                                'date': FieldValue.serverTimestamp(),
                                'user': loggedinuser.uid,
                                'imageurl': imageurl,
                                'path': imagefile!.path
                              });
                            } else {
                              await firestore.collection('note').add({
                                'title': title.text,
                                'body': body.text,
                                'date': FieldValue.serverTimestamp(),
                                'user': loggedinuser.uid,
                                'imageurl': null
                              });
                            }

                            Navigator.pop(context);
                            setState(() {
                              submit = false;
                            });
                          },
                          child: Text(
                            'Add Note',
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.w700, fontSize: 20.0),
                          ),
                          // style: ElevatedButton.styleFrom(primary: Colors.pink),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
