
import 'dart:io' ;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
class image extends StatefulWidget {
  const image({Key? key}) : super(key: key);

  @override
  State<image> createState() => _imageState();
}

class _imageState extends State<image> {
  FirebaseStorage firebaseStorage=FirebaseStorage.instance;
  Future<void> image(String source) async{
    final picker=ImagePicker();
    final XFile? picked=await picker.pickImage(source: source=="camera"?ImageSource.camera:ImageSource.gallery);
    if(picked==null){
      return null;
    }
    String filename=picked.name;
    File imagepicked=File(picked.path);
    try {
      await firebaseStorage.ref(filename).putFile(imagepicked);
    }
    catch(e){
      print(e);
    }




  }
  Future<void> multipleimage()async {
    final picker= ImagePicker();
    final List<XFile>? images=await picker.pickMultiImage();
    if(images==null){
      return null;
    }
    else{
      Future.forEach(images, (XFile files) async {
        String filename=files.name;
        File imagefile=File(files.path);
        try{
          await firebaseStorage.ref(filename).putFile(imagefile);
        } on FirebaseException
        catch(e){
          print(e);
        }

      });
    }


  }
  Future<List> loadimages() async {
    List<Map> files=[];
    final ListResult result=await firebaseStorage.ref().listAll();
    final List<Reference> allfiles=result.items;
    await Future.forEach(allfiles, (Reference file) async {
      final String fileURL=await file.getDownloadURL();

      files.add({
        "url":fileURL,
        "path":file.fullPath
      });

    }) ;
  return files;
}
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      body: Column(
        children: [
          MaterialButton(onPressed: (){
            image("camera");

          },
            child: Text('Image Upload'),
          ),
          MaterialButton(onPressed: (){
            image("gallery");
          },
          child: Text('From local storage'),
          ),
          MaterialButton(onPressed: (){
            multipleimage();
          },
            child: Text('Multiple Images'),
          ),
          Expanded(child:
          FutureBuilder(


            future: loadimages(),
            builder: (context, AsyncSnapshot snapshot) {

              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              return


                  ListView.builder(

                    itemCount: snapshot.data.length ?? 0,
                    itemBuilder: (context,index){
                    final Map image=snapshot.data[index];
                    return
                        Row(children: [
                          Expanded(child: Card(
                            child: CachedNetworkImage(imageUrl: image['url'],
                            placeholder: (context,url)=>Image.asset('images/placeholder.png'),
                            errorWidget: (context,url,error)=>Icon(Icons.error_outline),),


                          )),

                        ],);

                    },
                  );
            },

          ))
        ],
      ),


    ));
  }
}
