const String defaultImageUrl =
    "https://st3.depositphotos.com/1767687/16607/v/450/depositphotos_166074422-stock-illustration-default-avatar-profile-icon-grey.jpg";

const String baseUrl = "https://api.wordandlearn.com/api/v1";
const String authUrl = "$baseUrl/auth";
const String writingUrl = "$baseUrl/writing";
const String loginEndpoint = "$authUrl/login/";
const String registerEndpoint = "$authUrl/register/";

const String sessionLessonsUrl = "$writingUrl/session";
const String lessonTopicsUrl = "$writingUrl/lesson";
const String topicsUrl = "$writingUrl/topic";
const String exerciseUrl = "$writingUrl/exercise";
const String exerciseSubmissionUrl = "$writingUrl/exercise/submission";
String topicFlashcardsUrl(int topicId) => "$topicsUrl/$topicId/flashcards";
String topicExamplesUrl(int topicId) => "$topicsUrl/$topicId/examples";
String topicExerciseUrl(int topicId) => "$topicsUrl/$topicId/exercise";

String exerciseUploadUrl(int exerciseId) => "$exerciseUrl/$exerciseId/upload/";
String exerciseSubmissionDetailUrl(int exerciseId) =>
    "$exerciseUrl/$exerciseId/";
String exerciseSubmissionAssessUrl(int exerciseId) =>
    "$exerciseUrl/$exerciseId/assess/";
