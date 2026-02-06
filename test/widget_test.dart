import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:offline_notes/main.dart';
import 'package:offline_notes/data/notes_repository.dart';
import 'package:offline_notes/services/note_service.dart';
import 'package:offline_notes/screens/notes_list_screen.dart';

void main() {
  testWidgets('Offline Notes app starts correctly', (WidgetTester tester) async {
    // Initialisation minimale de Hive pour les tests
    TestWidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Hive.openBox(NotesRepository.boxName);

    // Création des dépendances comme dans main.dart
    final repository = NotesRepository();
    final service = NoteService(repository);

    // Lancement de l'application
    await tester.pumpWidget(
      MaterialApp(
        home: NotesListScreen(service: service),
      ),
    );

    // Vérifications de base (smoke test)
    expect(find.text('Offline Notes'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
