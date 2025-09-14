// Replace your entire ObjectboxRepo class with this:
import 'dart:async';
import 'package:firebase_note_app/database/abstract_db.dart';
import 'package:firebase_note_app/notemodel.dart';
import 'package:firebase_note_app/objectbox.g.dart';

class ObjectboxRepo implements NoteRepo {
  final Box<NoteObj> _box;
  StreamSubscription? _subscription;
  // StreamController<List<NoteObj>>? _controller;

  ObjectboxRepo(this._box);

  @override
  Stream<List<NoteObj>> getAllNotes() {
  StreamController<List<NoteObj>> controller = StreamController();
  
  // Emit current data immediately
  controller.add(_box.getAll());
  
  // Listen for changes and emit updates
  _box.query().watch().listen((query) {
    controller.add(_box.getAll());
  });
  
  return controller.stream;
}

// @override
// Stream<List<NoteObj>> getAllNotes() {
//     // Cancel old subscription and close old controller
//     _subscription?.cancel();
//     _controller?.close();  // ← Added this!
    
//     // Create new controller
//     _controller = StreamController<List<NoteObj>>();  // ← Added this!
    
//     // Emit current data immediately
//     _controller!.add(_box.getAll());  // ← Added this!
    
//     _subscription = _box.query().watch().listen((query) {
//       if (!_controller!.isClosed) {  // ← Safety check
//         _controller!.add(_box.getAll());
//       }
//     });
    
//     return _controller!.stream;
//   }

  @override
  Future<void> addNote(String content) async {
    final String newId = DateTime.now().millisecondsSinceEpoch.toString();
    _box.put(NoteObj(id: newId, content: content));
  }

  @override
  Future<void> deleteNote(String id) async {
    final query = _box.query(NoteObj_.id.equals(id)).build();
    //finds the note using the string id then inside the note it just uses the objectbox id to del
    /*
    NoteObj(
    string id = 205780295
    objectboxID = 3
    content = 'example'
    )
    because it can only access the string id from homescreen
    */
    final noteToDelete = query.findFirst();
    query.close();
    if (noteToDelete != null) {
      _box.remove(noteToDelete.objectboxId);
    }
  }


  @override
  Future<void> clearAll() async {
    _box.removeAll();
  }

  void dispose() {
    _subscription?.cancel();
    // _controller?.close();
  }
}