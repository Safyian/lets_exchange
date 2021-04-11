class UserModel {
  String uid;
  String name;
  String email;
  String image;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
    };
  }

  factory UserModel.fromMap(Map map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      image: map['image'],
    );
  }
}
