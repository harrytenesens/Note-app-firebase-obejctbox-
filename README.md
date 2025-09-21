### Initializing Objectbox like this in the main is more convenient

```dart
class MyAppState extends State<MyApp> {
  **late ObjectboxRepo objectboxRepodb;
  bool _isLoading = true;**

  @override
  void initState() {
    super.initState();
    **_initializeObjectbox();**
  }

  **Future<void> _initializeObjectbox() async {
    final dir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: "${dir.path}/objectbox");
    objectboxRepodb = ObjectboxRepo(store.box<NoteObj>());
    setState(() {
      _isLoading = false;
    });
  }**

  @override
  Widget build(BuildContext context) {
    **if (_isLoading) {**
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
```

### Used objectbox stream controller to get data immediately

```dart
Stream<List<NoteObj>> getAllNotes() {
  StreamController<List<NoteObj>> controller = StreamController();
  
  // THIS LINE runs immediately when method is called
  controller.add(_box.getAll()); 
  
  _box.query().watch().listen((query) {
    controller.add(_box.getAll());
  });
  
  return controller.stream;
}
```

# How the Database works

![image.png](attachment:7500c6f8-e698-439b-ab77-34a12e5b85b7:image.png)

Then the homescreen uses BlocClass. That way it doesn’t need to know which database it’s using.
