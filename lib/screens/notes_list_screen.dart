import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';
import 'note_form_screen.dart';

class NotesListScreen extends StatefulWidget {
  final NoteService service;

  const NotesListScreen({super.key, required this.service});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  bool isSyncing = false;

  // 🎨 Couleurs du design (soft / clean)
  static const Color bgColor = Color(0xFFF3F7F9);
  static const Color primaryColor = Color(0xFF5B8DEF);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final notes = widget.service.listNotes();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Notes"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: isSyncing ? null : _sync,
            icon: isSyncing
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.sync),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: notes.isEmpty
            ? _emptyState()
            : ListView.separated(
          itemCount: notes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final note = notes[index];
            return _noteCard(note);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: _createNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  // 🧾 Carte Note (design proche de l’image)
  Widget _noteCard(Note note) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _editNote(note),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: primaryColor.withOpacity(0.15),
              child: const Icon(Icons.note, color: primaryColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _statusChip(note),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                widget.service.deleteNote(note);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔖 Badge Pending / Synced
  Widget _statusChip(Note note) {
    final isPending = note.status == SyncStatus.pending;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isPending
            ? Colors.orange.withOpacity(0.15)
            : Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPending ? "Pending" : "Synced",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isPending ? Colors.orange : Colors.green,
        ),
      ),
    );
  }

  // 📭 Empty state
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.note_alt_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "Aucune note",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text("Ajoutez votre première note"),
        ],
      ),
    );
  }

  // ➕ Créer une note
  Future<void> _createNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteFormScreen(service: widget.service),
      ),
    );
    setState(() {});
  }

  // ✏️ Modifier une note
  Future<void> _editNote(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteFormScreen(
          service: widget.service,
          existing: note,
        ),
      ),
    );
    setState(() {});
  }

  // 🔄 Synchronisation simulée
  Future<void> _sync() async {
    setState(() => isSyncing = true);
    final ok = await widget.service.simulateSync();
    setState(() => isSyncing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? "Synchronisation terminée" : "Échec de synchronisation",
        ),
      ),
    );
    setState(() {});
  }
}
