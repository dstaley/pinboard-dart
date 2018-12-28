import 'package:meta/meta.dart';

import './pinboard_client.dart';
import './pinboard_shared.dart';

/// A class representing a Pinboard Note.
class Note {
  /// The ID of the note.
  String id;

  /// A SHA1 hash of the note text.
  String hash;

  /// The title of the note.
  String title;

  /// The length of the note.
  String length;

  /// The text of the note.
  String text;

  /// The datetime the note was created.
  // ignore: non_constant_identifier_names
  DateTime created_at;

  /// The datetime the note was last updated.
  // ignore: non_constant_identifier_names
  DateTime updated_at;

  /// Create an instance of Note.
  Note({
    this.id,
    this.hash,
    this.title,
    this.length,
    // ignore: non_constant_identifier_names
    this.created_at,
    // ignore: non_constant_identifier_names
    this.updated_at,
    this.text,
  });

  /// Create a Note from a JSON response.
  factory Note.fromJson(Map<String, Object> json) {
    return Note(
      id: json['id'],
      hash: json['hash'],
      title: json['title'],
      length: json['length'].runtimeType == int
          ? json['length'].toString()
          : json['length'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
      text: json.containsKey('text') ? json['text'] : null,
    );
  }

  String toString() {
    var properties = {
      'id': id,
      'hash': hash,
      'title': title,
      'length': length,
      'created_at': created_at,
      'updated_at': updated_at,
      'text': text,
    };
    return 'Note$properties';
  }
}

/// The response when calling `notes.list`.
class NotesResponse {
  /// The number of notes.
  int count;

  /// A list of all notes.
  List<Note> notes;

  /// Create an instance of a NoteResponse.
  NotesResponse({
    this.count,
    this.notes,
  });

  /// Create a NotesResponse from JSON.
  factory NotesResponse.fromJson(Map<String, Object> json) {
    return NotesResponse(
      count: json['count'],
      notes: List<Note>.from(
          (json['notes'] as List).map<Note>((Object p) => Note.fromJson(p))),
    );
  }

  String toString() {
    var properties = {
      'count': count,
      'notes': notes,
    };
    return 'NotesResponse$properties';
  }
}

/// Class containing the methods for the `notes` resource of the Pinboard API.
class NotesResource extends PinboardResource {
  /// Create an instance of NotesResource.
  NotesResource(PinboardClient _pb) : super(_pb, path: 'notes');

  /// Returns a list of the user's notes
  Future<NotesResponse> list() async {
    var response = await this.request<Map>(
      method: 'list',
    );
    return NotesResponse.fromJson(response);
  }

  /// Returns an individual user note.
  Future<Note> get({@required String id}) async {
    var response = await this.request<Map>(
      method: id,
    );
    return Note.fromJson(response);
  }
}
