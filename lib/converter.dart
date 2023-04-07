import 'package:cloud_firestore/cloud_firestore.dart';
class NoteModel{
   late String body;
   late String title;
   late String user;
   late Timestamp time;
   late String id;
   late String? image;
   NoteModel(
   {
     required this.body,
     required this.title,
     required this.user,
     required this.time,
     required this.id,

     this.image
     //required this.image
}
       );


   factory NoteModel.fromJson(DocumentSnapshot snapshot){

     return NoteModel(body: snapshot['body'],
         title: snapshot['title'],
         user: snapshot['user'],
         time: snapshot['date'],
       id: snapshot.id


     );
   }
}
