import 'package:equatable/equatable.dart';
import '../../../domain/entities/note.dart';

abstract class NotesState extends Equatable {
  const NotesState();
}

class NotesLoading extends NotesState {
  @override
  List<Object?> get props => [];
}

class NotesLoaded extends NotesState {
  final List<Note> notes;
  const NotesLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

class NotesError extends NotesState {
  final String message;
  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}