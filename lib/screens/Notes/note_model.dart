class NoteModel {
  int? id;
  String title;
  String description;
  String creationDate;
  bool pinned;
  String color;

  NoteModel({
    this.id,
    required this.title,
    required this.description,
    required this.creationDate,
    this.pinned = false,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'creationDate': creationDate,
      'pinned': pinned ? 1 : 0,
      'color': color,
    };
  }

  static NoteModel fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      creationDate: map['creationDate'],
      pinned: map['pinned'] == 1,
      color: map['color'],
    );
  }
}
