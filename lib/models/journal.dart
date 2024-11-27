import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Journal({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Journal.empty() :
    id = Uuid().v1(),
    content = "",
    createdAt = DateTime.now(),
    updatedAt = DateTime.now();
  

  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      id: json["id"],
      content: json["content"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return "$content \ncreated_at: $createdAt\nupdated_at:$updatedAt";
  }
}
