import 'package:word_and_learn/controllers/services/interfaces/user_interface.dart';
import 'package:word_and_learn/models/models.dart';

class UserDatabase implements UserDatabaseInterface {
  @override
  Future<Profile?> getChildProfile() async {
    return null;
  }

  @override
  Future<ProfilePicture?> getProfilePicture() async {
    return null;
  }

  @override
  Future<void> saveChildProfile(Profile profile) async {}

  @override
  Future<void> saveProfilePicture(ProfilePicture profilePicture) async {}
}
