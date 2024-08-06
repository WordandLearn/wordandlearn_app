const String defaultImageUrl =
    "https://st3.depositphotos.com/1767687/16607/v/450/depositphotos_166074422-stock-illustration-default-avatar-profile-icon-grey.jpg";

const String baseUrl = "https://api.wordandlearn.com/api/v1";
const String authUrl = "$baseUrl/auth";
const String profileUrl = "$authUrl/me";
const String profilePictureUrl = "$profileUrl/profile_photo/";
const String writingUrl = "$baseUrl/writing";
const String teachersUrl = "$baseUrl/teachers";
const String loginEndpoint = "$authUrl/login/";
const String registerEndpoint = "$authUrl/register/";

const String sessionLessonsUrl = "$writingUrl/session";
const String lessonTopicsUrl = "$writingUrl/lesson";
const String topicsUrl = "$writingUrl/topic";
String topicCompleteUrl(int topicId) => "$topicsUrl/$topicId/complete/";
const String exerciseUrl = "$writingUrl/exercise";
const String exerciseSubmissionUrl = "$writingUrl/exercise/submission";
String topicFlashcardsUrl(int topicId) => "$topicsUrl/$topicId/flashcards";
String flashcardCompletedUrl(int flashcardId) =>
    "$writingUrl/flashcard/$flashcardId/complete/";
String flashcardAudioUrl(int flashcardId) =>
    "$writingUrl/flashcard/$flashcardId/audio/";
String topicExamplesUrl(int topicId) => "$topicsUrl/$topicId/examples";
String exampleCompletedUrl(int exampleId) =>
    "$writingUrl/example/$exampleId/complete/";
String exampleAudioUrl(int exampleId) =>
    "$writingUrl/example/$exampleId/audio/";
String topicExerciseUrl(int topicId) => "$topicsUrl/$topicId/exercise";
String exerciseCompletedUrl(int exerciseId) =>
    "$writingUrl/exercise/$exerciseId/complete/";

String exerciseUploadUrl(int exerciseId) => "$exerciseUrl/$exerciseId/upload/";
String exerciseSubmissionDetailUrl(int exerciseId) =>
    "$exerciseUrl/$exerciseId/";
String exerciseSubmissionAssessUrl(int exerciseId) =>
    "$exerciseUrl/submission/$exerciseId/assess/";

const String compositionUploadUrl = "$writingUrl/composition/upload/";

//Teachers endpoints
const String teacherClassesUrl = "$teachersUrl/class";
String classStudentsUrl(int classId) => "$teacherClassesUrl/$classId/students";
const String uploadCompositionsUrl = "$teachersUrl/upload/";

//Settings endpoints
const String settingsUrl = "$baseUrl/settings";
const String alertSettingsUrl = "$settingsUrl/alert-settings/";
