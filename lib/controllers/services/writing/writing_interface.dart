import 'package:word_and_learn/models/models.dart';

abstract class WritingInterface {
  Future<Profile?> getChildProfile();
  Future<ProfilePicture?> getProfilePicture();
}

abstract class WritingInterfaceDatabase {
  Future<void> saveChildProfile(Profile profile);
  Future<void> saveProfilePicture(ProfilePicture? picture);
}
