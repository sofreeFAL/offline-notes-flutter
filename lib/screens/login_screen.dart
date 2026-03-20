import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../services/note_service.dart';
import 'notes_list_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthService auth;
  final NoteService noteService;

  const LoginScreen({
    super.key,
    required this.auth,
    required this.noteService,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  Future<void> _initAuth() async {
    try {
      await widget.auth.handleRedirect();

      if (widget.auth.isLoggedIn && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => NotesListScreen(service: widget.noteService),
          ),
        );
        return;
      }
    } catch (_) {
      error = "Erreur d'authentification.";
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Connexion",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Veuillez vous connecter"),
                  const SizedBox(height: 20),
                  if (error != null) ...[
                    Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                  ],
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text("Se connecter"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    try {
      await widget.auth.login();
    } catch (_) {
      setState(() {
        error = "Échec de connexion.";
      });
    }
  }
}