class MessageModel {
  final String messageId;
  final String text;
  final String userId;
  final int createdAt;
  final bool hasDeleted;

  MessageModel({
    required this.messageId,
    required this.text,
    required this.userId,
    required this.createdAt,
    required this.hasDeleted,
  });

  MessageModel.fromJson(Map<String, dynamic> json)
      : messageId = json['messageId'],
        text = json['text'],
        userId = json['userId'],
        createdAt = json['createdAt'],
        hasDeleted = json['hasDeleted'];

  Map<String, dynamic> toJson() {
    return {
      "messageId": messageId,
      "text": text,
      "userId": userId,
      "createdAt": createdAt,
      "hasDeleted": hasDeleted,
    };
  }
}
