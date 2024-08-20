// import 'package:objectbox/objectbox.dart';

// @Entity()
class ProfilePicture {
  // @Id(assignable: true)
  int id;
  final String imageUrl;
  final String thumbnailUrl;

  ProfilePicture(
      {required this.id, required this.imageUrl, required this.thumbnailUrl});
  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      id: json['id'] ?? 0,
      imageUrl: json['image_url'],
      thumbnailUrl: json['thumbnail_url'],
    );
  }
}
