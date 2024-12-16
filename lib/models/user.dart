class User {
  final String id;
  final String email;
  final String name;
  final String? location;
  final String? bio;
  final String? photoUrl;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.location,
    this.bio,
    this.photoUrl,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      location: map['location'],
      bio: map['bio'],
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'location': location,
      'bio': bio,
      'photoUrl': photoUrl,
    };
  }
}
