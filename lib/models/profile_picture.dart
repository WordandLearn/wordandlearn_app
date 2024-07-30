class ProfilePicture {
  int? id;
  final String imageUrl;
  final String thumbnailUrl;

  ProfilePicture(
      {required this.id, required this.imageUrl, required this.thumbnailUrl});
  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      id: json['id'],
      imageUrl: json['image_url'],
      thumbnailUrl: json['thumbnail_url'],
    );
  }
}
