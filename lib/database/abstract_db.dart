
import 'package:firebase_note_app/notemodel.dart';

abstract class NoteRepo{
  Stream<List<NoteObj>> getAllNotes();
  Future<void> addNote(String title);
  Future<void> deleteNote(String noteId);
  Future<void> clearAll();
}