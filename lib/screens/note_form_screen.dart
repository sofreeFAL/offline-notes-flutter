import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NoteFormScreen extends StatefulWidget {
  final NoteService service;
  final Note? existing;

  const NoteFormScreen({
    super.key,
    required this.service,
    this.existing,
  });

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  //  mêmes couleurs que l'écran liste
  static const Color bgColor = Color(0xFFF3F7F9);
  static const Color primaryColor = Color(0xFF5B8DEF);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  late final TextEditingController titleController;
  late final TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.existing?.title ?? "");
    contentController =
        TextEditingController(text: widget.existing?.content ?? "");
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(isEdit ? "Modifier la note" : "Nouvelle note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _CardContainer(
              child: Column(
                children: [
                  _label("Titre"),
                  const SizedBox(height: 6),
                  _inputField(
                    controller: titleController,
                    hint: "Ex: Courses",
                    maxLines: 1,
                  ),
                  const SizedBox(height: 14),
                  _label("Contenu"),
                  const SizedBox(height: 6),
                  _inputField(
                    controller: contentController,
                    hint: "Écris ta note ici...",
                    maxLines: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _save,
                child: Text(isEdit ? "Mettre à jour" : "Enregistrer"),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Toute modification est enregistrée localement (Offline-First).",
              style: const TextStyle(color: textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 1.2),
        ),
      ),
    );
  }

  void _save() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le titre est obligatoire")),
      );
      return;
    }

    if (widget.existing == null) {
      widget.service.createNote(title: title, content: content);
    } else {
      widget.service.updateNote(widget.existing!, title: title, content: content);
    }

    Navigator.pop(context);
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }
}
