import '../../domain/entities/user.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/firestore_notes_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<User?> getCurrentUser() => dataSource.getCurrentUser();

  @override
  Future<User> signUp(String email, String password) =>
      dataSource.signUp(email, password);

  @override
  Future<User> signIn(String email, String password) =>
      dataSource.signIn(email, password);

  @override
  Future<void> signOut() => dataSource.signOut();
}

class NotesRepositoryImpl implements NotesRepository {
  final FirestoreNotesDataSource dataSource;

  NotesRepositoryImpl(this.dataSource);

  @override
  Future<List<Note>> getNotes(String userId) => dataSource.getNotes(userId);

  @override
  Future<void> addNote(String userId, String text) =>
      dataSource.addNote(userId, text);

  @override
  Future<void> updateNote(String userId, String noteId, String text) =>
      dataSource.updateNote(userId, noteId, text);

  @override
  Future<void> deleteNote(String userId, String noteId) =>
      dataSource.deleteNote(userId, noteId);

  @override
  Stream<List<Note>> notesStream(String userId) => dataSource.notesStream(userId);
}