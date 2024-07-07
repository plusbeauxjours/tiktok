class ChatRoomModel {
  final String chatId;
  final String lastText;
  final String personIdA;
  final String personIdB;
  final int messageAt;
  final int createdAt;

  ChatRoomModel({
    required this.chatId,
    required this.lastText,
    required this.personIdA,
    required this.personIdB,
    required this.messageAt,
    required this.createdAt,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : chatId = json['chatId'],
        lastText = json['lastText'],
        personIdA = json['personIdA'],
        personIdB = json['personIdB'],
        messageAt = json['messageAt'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    return {
      "chatId": chatId,
      "lastText": lastText,
      "personIdA": personIdA,
      "personIdB": personIdB,
      "messageAt": messageAt,
      "createdAt": createdAt,
    };
  }

  ChatRoomModel copyWith({
    String? chatId,
    String? lastText,
    String? personIdA,
    String? personIdB,
    int? messageAt,
    int? createdAt,
  }) {
    return ChatRoomModel(
      chatId: chatId ?? this.chatId,
      lastText: lastText ?? this.lastText,
      personIdA: personIdA ?? this.personIdA,
      personIdB: personIdB ?? this.personIdB,
      messageAt: messageAt ?? this.messageAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
