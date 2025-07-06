import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'data/datasources/firebase_auth_datasource.dart';
import 'data/datasources/firestore_notes_datasource.dart';
import 'data/repositories/notes_repository_impl.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/bloc/notes/notes_bloc.dart';
import 'presentation/pages/app_wrapper.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/notes_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            FirebaseAuthDataSource(FirebaseAuth.instance),
          ),
        ),
        RepositoryProvider<NotesRepository>(
          create: (context) => NotesRepositoryImpl(
            FirestoreNotesDataSource(FirebaseFirestore.instance),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              context.read<AuthRepository>(),
            )..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => NotesBloc(
              context.read<NotesRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Notes App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: AppWrapper(),
        ),
      ),
    );
  }
}