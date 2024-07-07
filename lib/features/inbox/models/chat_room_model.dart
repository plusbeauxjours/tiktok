class ChatRoomModel {
  final String chatId;
  final int messageAt;
  final String lastText;
  final String createdId;
  final String personIdA;
  final String personIdB;

  ChatRoomModel({
    required this.chatId,
    required this.messageAt,
    required this.lastText,
    required this.createdId,
    required this.personIdA,
    required this.personIdB,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json)
      : chatId = json['chatId'],
        messageAt = json['messageAt'],
        lastText = json['lastText'],
        createdId = json['createdId'],
        personIdA = json['personIdA'],
        personIdB = json['personIdB'];

  Map<String, dynamic> toJson() {
    return {
      "chatId": chatId,
      "messageAt": messageAt,
      "lastText": lastText,
      "createdId": createdId,
      "personIdA": personIdA,
      "personIdB": personIdB
    };
  }
}
