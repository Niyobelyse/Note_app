import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/repositories/notes_repository.dart';
import '../../bloc/notes/notes_bloc.dart';
import '../../bloc/notes/notes_event.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Not authenticated'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              'Your Notes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: context.read<NotesRepository>().notesStream(user.uid),
        builder: (context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          }
          final notes = snapshot.data ?? [];
          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'Nothing here yet—tap ➕ to add a note.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                color: const Color(0xFFEFE8F8),
                margin: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ListTile(
                    title: Center(
                      child: Text(
                        note.text,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _showDeleteDialog(context, note.id),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                        IconButton(
                          onPressed: () => _showEditDialog(context, note),
                          icon: const Icon(Icons.edit, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, user.uid),
        backgroundColor: const Color(0xFF2A95F4),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddDialog(BuildContext context, String userId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter note text'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<NotesBloc>().add(AddNoteRequested(userId, controller.text.trim()));
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Note note) {
    final controller = TextEditingController(text: note.text);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Edit note text'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                context.read<NotesBloc>().add(UpdateNoteRequested(user.uid, note.id, controller.text.trim()));
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String noteId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<NotesBloc>().add(DeleteNoteRequested(user.uid, noteId));
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}