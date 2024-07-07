class ChatRoomModel {
  final String chatId;
  final String messageAt;
  final String lastText;
  final String createdAt;
  final String personIdA;
  final String personIdB;

  ChatRoomModel({
    required this.chatId,
    required this.messageAt,
    required this.lastText,
    required this.createdAt,
    required this.personIdA,
    required this.personIdB,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : chatId = json['chatId'],
        messageAt = json['messageAt'],
        lastText = json['lastText'],
        createdAt = json['createdAt'],
        personIdA = json['personIdA'],
        personIdB = json['personIdB'];

  Map<String, dynamic> toJson() {
    return {
      "chatId": chatId,
      "messageAt": messageAt,
      "lastText": lastText,
      "createdAt": createdAt,
      "personIdA": personIdA,
      "personIdB": personIdB
    };
  }
}
