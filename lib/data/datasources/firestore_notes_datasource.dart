import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class FirestoreNotesDataSource {
  final FirebaseFirestore _firestore;

  FirestoreNotesDataSource(this._firestore);

  Future<List<NoteModel>> getNotes(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => NoteModel.fromFirestore(doc)).toList();
  }

  Future<void> addNote(String userId, String text) async {
    final now = DateTime.now();
    final noteModel = NoteModel(
      id: '',
      text: text,
      createdAt: now,
      updatedAt: now,
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add(noteModel.toFirestore());
  }

  Future<void> updateNote(String userId, String noteId, String text) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .update({
      'text': text,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> deleteNote(String userId, String noteId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  Stream<List<NoteModel>> notesStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => NoteModel.fromFirestore(doc)).toList());
  }
}