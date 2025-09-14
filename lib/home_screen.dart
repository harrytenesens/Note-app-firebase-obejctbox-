import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_note_app/authentication/login_page.dart';
import 'package:firebase_note_app/database/bloc_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    void loginOrSignOut() async {
      if (isLoggedIn) {
        await FirebaseAuth.instance.signOut();
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (route) => false,
          );
        }
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your notes',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).focusColor),
                      onPressed: () => loginOrSignOut(),
                      child: (isLoggedIn) ? Text('Sign out') : Text('login'))
                ],
              ),
              // notes
              BlocBuilder<BlocClass, String>(
                builder: (context, state) => StreamBuilder(
                  stream: context.read<BlocClass>().getNotes(),
                  builder: (context, snapshot) {
                    // Show loading only for Firebase when waiting
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        (isLoggedIn || !snapshot.hasData)) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Handle errors
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    // If we have data and it's not empty, show the list
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final noteList = snapshot.data!;

                      return Expanded(
                        child: ListView.builder(
                            itemCount: noteList.length,
                            itemBuilder: (context, index) {
                              final noteIndex = noteList[index];
                              return ListTile(
                                title: Text(noteIndex.content),
                                trailing: IconButton(
                                    onPressed: () => context
                                        .read<BlocClass>()
                                        .add(Delnote(noteIndex.id)),
                                    icon: Icon(Icons.delete)),
                              );
                            }),
                      );
                    }

                    // Default case: no notes found
                    return Center(child: Text('No notes found'));
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              context.read<BlocClass>().openField(context, controller),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
