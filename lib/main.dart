import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'auth/auth_service.dart';
import 'data/notes_repository.dart';
import 'services/note_service.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Hive (persistance locale)
  await Hive.initFlutter();
  await Hive.openBox(NotesRepository.boxName);

  // Injection simple des dépendances
  final repository = NotesRepository();
  final noteService = NoteService(repository);
  final authService = AuthService();

  runApp(MyApp(
    noteService: noteService,
    authService: authService,
  ));
}

class MyApp extends StatelessWidget {
  final NoteService noteService;
  final AuthService authService;

  const MyApp({
    super.key,
    required this.noteService,
    required this.authService,
  });

  // Couleurs globales (identiques aux écrans)
  static const Color primaryColor = Color(0xFF5B8DEF);
  static const Color bgColor = Color(0xFFF3F7F9);
  static const Color textPrimary = Color(0xFF1F2937);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          background: bgColor,
        ),

        scaffoldBackgroundColor: bgColor,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: textPrimary),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryColor, width: 1.2),
          ),
        ),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: textPrimary),
          titleMedium: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: LoginScreen(
        auth: authService,
        noteService: noteService,
      ),
    );
  }
}