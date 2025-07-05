import '../entities/note.dart';

abstract class NotesRepository {
  Future<List<Note>> getNotes(String userId);
  Future<void> addNote(String userId, String text);
  Future<void> updateNote(String userId, String noteId, String text);
  Future<void> deleteNote(String userId, String noteId);
  Stream<List<Note>> notesStream(String userId);
}