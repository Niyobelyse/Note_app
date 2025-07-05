import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required String id,
    required String text,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          text: text,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}