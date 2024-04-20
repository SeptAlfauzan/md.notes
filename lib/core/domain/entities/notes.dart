class Note {
  final String id;
  final String? title;
  final String data;
  final DateTime created;
  final DateTime? lastEdited;

  Note({
    required this.id,
    required this.data,
    required this.created,
    this.lastEdited,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "data": data,
      "title": title,
      "created": created.toString(),
      "lastEdited": lastEdited.toString()
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
        id: map["id"],
        title: map["title"],
        data: map["data"],
        created: DateTime.parse(map['created']),
        lastEdited: DateTime.tryParse(map['lastEdited']));
  }

  Note copyWith({
    String? id,
    String? title,
    String? data,
    DateTime? created,
    DateTime? lastEdited,
  }) =>
      Note(
          id: id ?? this.id,
          title: title ?? this.title,
          data: data ?? this.data,
          created: created ?? this.created,
          lastEdited: lastEdited ?? this.lastEdited);
}
