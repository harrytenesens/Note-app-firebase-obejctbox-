import 'package:firebase_note_app/database/abstract_db.dart';
import 'package:firebase_note_app/notemodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NoteEvent {}

class Addnote extends NoteEvent {
  final String content;
  Addnote(this.content);
}

class Delnote extends NoteEvent {
  final String id;
  Delnote(this.id);
}

class BlocClass extends Bloc<NoteEvent, String> {
  

  final NoteRepo database;
  BlocClass({required this.database}) : super('new task') {

    //adding note
    on<Addnote>((event, emit) async {
      await database.addNote(event.content);
      emit('');
    });

    on<Delnote>((event, emit) async {
      await database.deleteNote(event.id);
      emit('');
    },);
  }
  Stream<List<NoteObj>> getNotes() => database.getAllNotes();

   void openField(BuildContext context, TextEditingController controller){
    showDialog(context: context, builder: (context) => AlertDialog(
      content: TextField(
        controller: controller,
      ),
      actions: [
        TextButton(onPressed: (){
          add(Addnote(controller.text));
          controller.clear();
          Navigator.of(context).pop();
        }, child: const Text('add'),),
      ],
    ));
  }
}