import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_note_app/database/bloc_db.dart';
import 'package:firebase_note_app/database/firebase_db.dart';
import 'package:firebase_note_app/database/objectbox_db.dart';
import 'package:firebase_note_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCheck extends StatelessWidget {
  final ObjectboxRepo objectBoxdb;
  const LoginCheck({super.key, required this.objectBoxdb});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(         
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
           
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            final user = snapshot.data!.uid;
            final firebaseDb = FirebaseRepo(
                notesCollection: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user)
                    .collection('notes'));

            // objectBoxdb.clearAll();

            return BlocProvider(
              create: (context) => BlocClass(database: firebaseDb),
              child: const HomeScreen(),
            );
          } else {
            return BlocProvider(
              create: (context) => BlocClass(database: objectBoxdb),
              child: const HomeScreen(),
            );
          }
        });
  }
}
