class ChatRoomModel {
  final String chatId;
  final String lastMessage;
  final String personIdA;
  final String personIdB;
  final int messageAt;
  final int createdAt;

  ChatRoomModel({
    required this.chatId,
    required this.lastMessage,
    required this.personIdA,
    required this.personIdB,
    required this.messageAt,
    required this.createdAt,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : chatId = json['chatId'],
        lastMessage = json['lastMessage'],
        personIdA = json['personIdA'],
        personIdB = json['personIdB'],
        messageAt = json['messageAt'],
        createdAt = json['createdAt'];

  Map<String, dynamic> toJson() {
    return {
      "chatId": chatId,
      "lastMessage": lastMessage,
      "personIdA": personIdA,
      "personIdB": personIdB,
      "messageAt": messageAt,
      "createdAt": createdAt,
    };
  }

  ChatRoomModel copyWith({
    String? chatId,
    String? lastMessage,
    String? personIdA,
    String? personIdB,
    int? messageAt,
    int? createdAt,
  }) {
    return ChatRoomModel(
      chatId: chatId ?? this.chatId,
      lastMessage: lastMessage ?? this.lastMessage,
      personIdA: personIdA ?? this.personIdA,
      personIdB: personIdB ?? this.personIdB,
      messageAt: messageAt ?? this.messageAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
