import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/notes_repository.dart';
import 'notes_event.dart';
import 'notes_state.dart';


class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository notesRepository;

  NotesBloc(this.notesRepository) : super(NotesLoading()) {
    on<LoadNotesRequested>(_onLoadNotesRequested);
    on<AddNoteRequested>(_onAddNoteRequested);
    on<UpdateNoteRequested>(_onUpdateNoteRequested);
    on<DeleteNoteRequested>(_onDeleteNoteRequested);
  }

  Future<void> _onLoadNotesRequested(
      LoadNotesRequested event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await notesRepository.getNotes(event.userId);
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onAddNoteRequested(
      AddNoteRequested event, Emitter<NotesState> emit) async {
    await notesRepository.addNote(event.userId, event.text);
    add(LoadNotesRequested(event.userId));
  }

  Future<void> _onUpdateNoteRequested(
      UpdateNoteRequested event, Emitter<NotesState> emit) async {
    await notesRepository.updateNote(event.userId, event.noteId, event.text);
    add(LoadNotesRequested(event.userId));
  }

  Future<void> _onDeleteNoteRequested(
      DeleteNoteRequested event, Emitter<NotesState> emit) async {
    await notesRepository.deleteNote(event.userId, event.noteId);
    add(LoadNotesRequested(event.userId));
  }
}