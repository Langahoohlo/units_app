class UnitEntry {
  Map<dynamic, dynamic> todos;
  String username;
  String? objectId;
  DateTime? created;
  DateTime? updated;

  UnitEntry({
    required this.todos,
    required this.username,
    this.objectId,
    this.created,
    this.updated,
  });

  Map<String, Object?> toJson() => {
        'username': username,
        'todos': todos,
        'created': created,
        'updated': updated,
        'objectId': objectId,
      };

  static UnitEntry fromJson(Map<dynamic, dynamic>? json) => UnitEntry(
        username: json!['username'] as String,
        todos: json['todos'] as Map<dynamic, dynamic>,
        objectId: json['objectId'] as String,
        created: json['created'] as DateTime,
      );
}
