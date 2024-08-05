import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_and_learn/constants/constants.dart';
import 'package:word_and_learn/controllers/services/auth/user_database.dart';
import 'package:word_and_learn/controllers/services/interfaces/user_interface.dart';
import 'package:word_and_learn/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:word_and_learn/utils/exceptions.dart';
import 'package:word_and_learn/utils/http_client.dart';
import 'package:word_and_learn/utils/objectbox_utils.dart';

mixin UserProfileMixin implements UserInterface {
  final UserDatabase userDatabase = UserDatabase();
  final HttpClient client = HttpClient();

  @override
  Future<Profile?> getChildProfile() async {
    Profile? profile = await userDatabase.getChildProfile();
    if (profile != null) {
      return profile;
    } else {
      http.Response res = await client.get(profileUrl);
      HttpResponse response = HttpResponse.fromResponse(res);
      if (response.isSuccess) {
        profile = Profile.fromJson(response.data['profile']);
        userDatabase.saveChildProfile(profile);
        return profile;
      } else {
        throw HttpFetchException(
            "Could not Fetch Profile", response.statusCode);
      }
    }
  }

  Future<void> logout() async {
    ObjectBox.deleteInstance();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  @override
  Future<ProfilePicture?> getProfilePicture() async {
    ProfilePicture? profilePicture = await userDatabase.getProfilePicture();
    if (profilePicture != null) {
      return profilePicture;
    } else {
      http.Response res = await client.get(profilePictureUrl);
      HttpResponse<ProfilePicture> response = HttpResponse.fromResponse(res);
      if (response.isSuccess) {
        profilePicture = ProfilePicture.fromJson(response.data);
        userDatabase.saveProfilePicture(profilePicture);
        return profilePicture;
      } else {
        throw HttpFetchException(
            "Could not fetch profile picture", response.statusCode);
      }
    }
  }
}
