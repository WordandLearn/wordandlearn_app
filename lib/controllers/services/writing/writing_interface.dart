import 'package:word_and_learn/models/writing/models.dart';


abstract class WritingInterface {
  Future<Profile?> getChildProfile();
  Future<ProfilePicture?> getProfilePicture();
}

abstract class WritingInterfaceDatabase implements WritingInterface {
  Future<void> saveChildProfile(Profile profile);
  Future<void> saveProfilePicture(ProfilePicture? picture);
}
