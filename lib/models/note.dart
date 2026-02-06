enum SyncStatus { synced, pending }

class Note {
  final int id; // identifiant local
  final String title;
  final String content;
  final SyncStatus status;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.status,
  });

  Note copyWith({
    int? id,
    String? title,
    String? content,
    SyncStatus? status,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "status": status.name, // "pending" / "synced"
    };
  }

  static Note fromMap(Map<dynamic, dynamic> map) {
    final statusStr = (map["status"] as String?) ?? "pending";
    final st = statusStr == "synced" ? SyncStatus.synced : SyncStatus.pending;

    return Note(
      id: map["id"] as int,
      title: (map["title"] as String?) ?? "",
      content: (map["content"] as String?) ?? "",
      status: st,
    );
  }
}
