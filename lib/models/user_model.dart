class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isPro;
  final String? image;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isPro,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      isPro: json['isPro'] as bool? ?? false,
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isPro': isPro,
      'image': image,
    };
  }
}
