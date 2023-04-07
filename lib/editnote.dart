import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jot_down/converter.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class edit extends StatefulWidget {
  edit(this.data, this.note);
  DocumentSnapshot data;

  NoteModel note;

  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  late bool imagepresent;
  bool resubmit = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  String? imagefile;
  bool image = false;
  File? name;
  String? imagelink;
  String? filename;

  void initState() {
    // TODO: implement initState
    super.initState();
    body = TextEditingController(text: widget.data['body']);
    title = TextEditingController(text: widget.data['title']);

    if (widget.data['imageurl'] != null) {
      image = true;
      imagepresent = true;
      imagefile = widget.data['imageurl'];
    } else {
      image = false;
      imagepresent = false;
    }
  }

  Future<void> uploadimage() async {
    final picker = ImagePicker();
    final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile == null) {
      return null;
    } else {
      setState(() async {
        filename = xFile.name;
        imagepresent = true;

        name = File(xFile.path);

        imagelink = await FirebaseStorage.instance
            .ref(filename)
            .putFile(name!)
            .then((result) {
          return result.ref.getDownloadURL();
        });

        widget.data.reference.update({'imageurl': imagelink});
        setState(() {
          image = true;
          imagepresent = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Row(
            children: <Widget>[
              imagepresent
                  ? ElevatedButton(
                      onPressed: () {
                        PanaraConfirmDialog.show(
                          context,
                          title: "Do you really want to delete the note",
                          message: "Once deleted you cannot recover it back",
                          confirmButtonText: "Confirm Delete",
                          cancelButtonText: "Cancel",
                          onTapCancel: () {
                            Navigator.pop(context);
                          },
                          onTapConfirm: () {
                            widget.data.reference.update({'imageurl': null});
                            imagepresent = false;
                            setState(() {
                              image = false;
                            });
                            Navigator.pop(context);
                          },
                          panaraDialogType: PanaraDialogType.warning,
                          barrierDismissible: false,
                        );
                      },
                      child: Text('Delete Image'),
                    )
                  : GestureDetector(
                      child: Icon(
                        Icons.add_a_photo_rounded,
                        
                      ),
                      onTap: uploadimage,
                    ),
              IconButton(
                onPressed: () async {
                  PanaraConfirmDialog.show(
                    context,
                    title: "Are You Sure",
                    message: "Do you really want to delete the Image?",
                    confirmButtonText: "Confirm",
                    cancelButtonText: "Cancel",
                    onTapCancel: () {
                      Navigator.pop(context);
                    },
                    onTapConfirm: () async {
                      Navigator.pop(context);
                      await firestore
                          .collection('note')
                          .doc(widget.note.id)
                          .delete();
                      Navigator.pop(context);
                    },
                    panaraDialogType: PanaraDialogType.warning,
                    barrierDismissible:
                        false, // optional parameter (default is true)
                  );
                },
                icon: Icon(
                  Icons.delete_outline_outlined,
                  
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                imagepresent
                    ? Container(
                        child: Flexible(
                            child: CachedNetworkImage(
                        imageUrl: widget.data['imageurl'],
                        placeholder: (context, url) =>
                            Image.asset('images/placeholder.png'),
                      )))
                    : SizedBox.shrink(),
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w800, fontSize: 25)),
                  
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w900, fontSize: 30.0),
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
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                alignment: Alignment.bottomRight,
                child: resubmit
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            resubmit = true;
                          });

                          widget.data.reference.update({
                            'title': title.text,
                            'body': body.text,
                          });

                          Navigator.pop(context);
                          setState(() {
                            resubmit = false;
                          });
                        },
                        child: Text(
                          'Save',
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
    );
  }
}
