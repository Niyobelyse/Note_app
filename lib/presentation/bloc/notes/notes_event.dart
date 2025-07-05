import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
}

class LoadNotesRequested extends NotesEvent {
  final String userId;
  const LoadNotesRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddNoteRequested extends NotesEvent {
  final String userId;
  final String text;
  const AddNoteRequested(this.userId, this.text);

  @override
  List<Object?> get props => [userId, text];
}

class UpdateNoteRequested extends NotesEvent {
  final String userId;
  final String noteId;
  final String text;
  const UpdateNoteRequested(this.userId, this.noteId, this.text);

  @override
  List<Object?> get props => [userId, noteId, text];
}

class DeleteNoteRequested extends NotesEvent {
  final String userId;
  final String noteId;
  const DeleteNoteRequested(this.userId, this.noteId);

  @override
  List<Object?> get props => [userId, noteId];
}