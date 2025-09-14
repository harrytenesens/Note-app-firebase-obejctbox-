import 'package:objectbox/objectbox.dart';

@Entity()
class NoteObj {
  @Id()
  int objectboxId;
  
  String id;
  String content;
  

  NoteObj({
    this.objectboxId = 0,
    required this.id,
    required this.content,
    
    
  });
}