class Note {
  final String id;
  final String data;
  final DateTime created;
  final DateTime? lastEdited;

  Note({
    required this.id,
    required this.data,
    required this.created,
    this.lastEdited,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "data": data,
      "created": created.toString(),
      "lastEdited": lastEdited.toString()
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
        id: map["id"],
        data: map["data"],
        created: DateTime.parse(map['created']),
        lastEdited: DateTime.tryParse(map['lastEdited']));
  }

  Note copyWith({
    String? id,
    String? data,
    DateTime? created,
    DateTime? lastEdited,
  }) =>
      Note(
          id: id ?? this.id,
          data: data ?? this.data,
          created: created ?? this.created,
          lastEdited: lastEdited ?? this.lastEdited);
}
