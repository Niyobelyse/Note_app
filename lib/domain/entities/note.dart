import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, text, createdAt, updatedAt];
}