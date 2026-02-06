import 'dart:math';
import '../data/notes_repository.dart';
import '../models/note.dart';

class NoteService {
  final NotesRepository repo;
  final Random _rnd = Random();

  NoteService(this.repo);

  List<Note> listNotes() => repo.getAll();

  Note createNote({required String title, required String content}) {
    final note = Note(
      id: repo.nextId(),
      title: title,
      content: content,
      status: SyncStatus.pending, // création => pending
    );
    repo.upsert(note);
    return note;
  }

  Note updateNote(Note old, {required String title, required String content}) {
    final updated = old.copyWith(
      title: title,
      content: content,
      status: SyncStatus.pending, // modification => pending
    );
    repo.upsert(updated);
    return updated;
  }

  void deleteNote(Note note) {
    repo.deleteById(note.id);
  }

  /// Sync différée simulée (cours)
  /// - temporisation simulant réseau
  /// - succès: pending -> synced
  /// - échec: aucune perte, pas de blocage
  Future<bool> simulateSync() async {
    await Future.delayed(const Duration(seconds: 2));

    // échec aléatoire (ex: 30%)
    final fail = _rnd.nextInt(10) < 3;
    if (fail) return false;

    final notes = repo.getAll();
    for (final n in notes) {
      if (n.status == SyncStatus.pending) {
        repo.upsert(n.copyWith(status: SyncStatus.synced));
      }
    }
    return true;
  }
}
