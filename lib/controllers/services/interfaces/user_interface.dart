import 'package:word_and_learn/models/writing/models.dart';

abstract class UserInterface {
  Future<Profile?> getChildProfile();
  Future<ProfilePicture?> getProfilePicture();
}

abstract class UserDatabaseInterface implements UserInterface {
  Future<void> saveChildProfile(Profile profile);
  Future<void> saveProfilePicture(ProfilePicture profilePicture);
  Future<void> removeProfilePicture();
}
