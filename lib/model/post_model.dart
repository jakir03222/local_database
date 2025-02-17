class PostModel {
  final int id;
  final String title;
  final String body;

  PostModel({required this.id, required this.title, required this.body});

  /// Convert JSON to Post Model
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(id: json['id'], title: json['title'], body: json['body']);
  }

  /// Convert Post Model to Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'body': body};
  }

  /// Convert SQLite Map to Post Model
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(id: map['id'], title: map['title'], body: map['body']);
  }
}
