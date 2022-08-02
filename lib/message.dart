class Message {
  final String id;
  final String content;
  final bool markAsRead;
  final String userFrom;
  final String userTo;
  final DateTime createAt;
  final bool isMine;

  Message({
    required this.id,
    required this.content,
    required this.markAsRead,
    required this.userFrom,
    required this.userTo,
    required this.createAt,
    required this.isMine,
  });

  Message.create(
      {required this.content, required this.userFrom, required this.userTo})
      : id = '',
        markAsRead = false,
        isMine = true,
        createAt = DateTime.now();

  Message.fromJson(Map<String, dynamic> json, String userId)
      : id = json['id'],
        content = json['content'],
        markAsRead = json['mark_as_read'],
        userFrom = json['user_from'],
        userTo = json['user_to'],
        createAt = DateTime.parse(json['created_at']),
        isMine = json['user_from'] == userId;

  Map toMap() {
    return {
      'content': content,
      'user_from': userFrom,
      'user_to': userTo,
      'mark_as_read': markAsRead,
    };
  }
}
