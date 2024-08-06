import 'package:word_and_learn/controllers/services/interfaces/user_interface.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:word_and_learn/utils/objectbox_utils.dart';

class UserDatabase implements UserDatabaseInterface {
  @override
  Future<Profile?> getChildProfile() async {
    final ObjectBox objectBox = await ObjectBox.getInstance();
    final box = objectBox.store.box<Profile>();
    List<Profile> profiles = box.getAll();
    if (profiles.isNotEmpty) {
      return profiles.first;
    }
    return null;
  }

  @override
  Future<ProfilePicture?> getProfilePicture() async {
    final ObjectBox objectBox = await ObjectBox.getInstance();
    final box = objectBox.store.box<ProfilePicture>();
    List<ProfilePicture> profilePictures = box.getAll();
    if (profilePictures.isNotEmpty) {
      return profilePictures.first;
    }
    return null;
  }

  @override
  Future<void> saveChildProfile(Profile profile) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();
    final box = objectBox.store.box<Profile>();
    box.removeAll();
    box.put(profile);
  }

  Future<void> updateChildProfile(ChildProfileDetails profileDetails) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();
    final box = objectBox.store.box<Profile>();
    Profile? profile = box.get(profileDetails.id);
    if (profile != null) {
      profile.name = profileDetails.name;
      profile.grade = profileDetails.grade;
      box.put(profile);
    }
  }

  @override
  Future<void> saveProfilePicture(ProfilePicture profilePicture) async {
    final ObjectBox objectBox = await ObjectBox.getInstance();
    final box = objectBox.store.box<ProfilePicture>();
    box.removeAll();
    box.put(profilePicture);
  }

  @override
  Future<void> removeProfilePicture() async {
    final ObjectBox objectBox = await ObjectBox.getInstance();
    final box = objectBox.store.box<ProfilePicture>();
    box.removeAll();
  }
}
