class Notes {
  final String id;
  final String data;
  final DateTime created;
  final DateTime? lastEdited;

  Notes({
    required this.id,
    required this.data,
    required this.created,
    this.lastEdited,
  });
}
