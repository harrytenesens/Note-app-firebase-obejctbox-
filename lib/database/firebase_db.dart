import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_note_app/database/abstract_db.dart';
import 'package:firebase_note_app/notemodel.dart';

class FirebaseRepo implements NoteRepo {
    final CollectionReference notesCollection;

  FirebaseRepo({required this.notesCollection});
      
      // @override
      // Stream<List<NoteObj>> getAllNotes() {
      //   return _notesCollection.snapshots().map((snapshot){
      //     return snapshot.docs.map((doc) {
      //       return NoteObj(id: doc.id, content: doc['note'] as String);
      //     }).toList();
      //   });
      // }
      @override
      Stream<List<NoteObj>> getAllNotes() {
        return notesCollection.snapshots().map((snapshot){
          return snapshot.docs.map((doc) {
            return NoteObj(
              id: doc.id, // Use the Firestore document ID
              content: doc['note'] as String,
            );
          }).toList();
        });
      }

      @override
      Future<void> addNote(String content) async {
        await notesCollection.add({'note': content});
      }

      @override 
      Future<void> deleteNote(String id) async {
        await notesCollection.doc(id).delete();
      }

      @override
      Future<void> clearAll() async {
        final snapshot = await notesCollection.get();
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

      }
}