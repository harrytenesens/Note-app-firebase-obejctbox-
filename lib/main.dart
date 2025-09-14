
import 'package:firebase_note_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_note_app/authentication/login_check.dart';
import 'package:firebase_note_app/database/objectbox_db.dart';
import 'package:firebase_note_app/notemodel.dart';
import 'package:firebase_note_app/objectbox.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late ObjectboxRepo objectboxRepodb;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeObjectbox();
  }

  Future<void> _initializeObjectbox() async {
    final dir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: "${dir.path}/objectbox");
    objectboxRepodb = ObjectboxRepo(store.box<NoteObj>());
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 249, 178)),
        useMaterial3: true,
      ),
      home: LoginCheck(objectBoxdb: objectboxRepodb),
    );
  }
}