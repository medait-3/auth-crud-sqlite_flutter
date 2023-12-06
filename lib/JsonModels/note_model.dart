class NoteModel {
  final int? noteId;
  final String noteTitle;
  final String noteContent;
  final String createdAt;
  final int? userId;

  NoteModel({
    this.noteId,
    required this.noteTitle,
    required this.noteContent,
    required this.createdAt,
    this.userId,
  });

  factory NoteModel.fromMap(Map<String, dynamic> json) => NoteModel(
        noteId: json["noteId"],
        noteTitle: json["noteTitle"],
        noteContent: json["noteContent"],
        createdAt: json["createdAt"],
        userId: json["usrId"],
      );

  Map<String, dynamic> toMap() => {
        "noteId": noteId,
        "noteTitle": noteTitle,
        "noteContent": noteContent,
        "createdAt": createdAt,
        "usrId":userId,
      };
}
