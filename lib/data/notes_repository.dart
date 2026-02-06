import 'package:hive/hive.dart';
import '../models/note.dart';

class NotesRepository {
  static const String boxName = "notesBox";

  Box get _box => Hive.box(boxName);

  List<Note> getAll() {
    final values = _box.values.toList();
    return values
        .whereType<Map>()
        .map((m) => Note.fromMap(m))
        .toList()
      ..sort((a, b) => b.id.compareTo(a.id)); // récent en haut
  }

  int nextId() {
    final lastId = _box.get("lastId", defaultValue: 0) as int;
    final newId = lastId + 1;
    _box.put("lastId", newId);
    return newId;
  }

  void upsert(Note note) {
    // clé = note.id pour retrouver facilement
    _box.put(note.id, note.toMap());
  }

  void deleteById(int id) {
    _box.delete(id);
  }

  void replaceAll(List<Note> notes) {
    // optionnel, utile si tu veux une maj globale
    for (final n in notes) {
      _box.put(n.id, n.toMap());
    }
  }
}
