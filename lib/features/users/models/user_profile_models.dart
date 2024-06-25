class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final String username;
  final String birthday;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.username,
    required this.birthday,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        bio = "",
        link = "",
        username = "",
        birthday = "";

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        link = json["link"],
        username = json["username"],
        birthday = json["birthday"];

  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
      "username": username,
      "birthday": birthday,
    };
  }
}
