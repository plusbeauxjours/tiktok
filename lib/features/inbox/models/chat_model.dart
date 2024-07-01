class ChatModel {
  final String id;
  final String userId;

  ChatModel({
    required this.id,
    required this.userId,
  });

  ChatModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
    };
  }
}
