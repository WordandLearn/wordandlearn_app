const String defaultImageUrl =
    "https://images.unsplash.com/photo-1489673446964-e1f989187ddc?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGdpcmwlMjBjaGlsZHxlbnwwfHwwfHx8MA%3D%3D";

const String baseUrl = "https://loyal-swine-coherent.ngrok-free.app/api/v1";
const String authUrl = "$baseUrl/auth";
const String writingUrl = "$baseUrl/writing";
const String loginEndpoint = "$authUrl/login/";
const String registerEndpoint = "$authUrl/register/";

const String sessionLessonsUrl = "$writingUrl/session";
const String lessonTopicsUrl = "$writingUrl/lesson";
const String topicsUrl = "$writingUrl/topic";
String topicFlashcardsUrl(int topicId) => "$topicsUrl/$topicId/flashcards";
String topicExamplesUrl(int topicId) => "$topicsUrl/$topicId/examples";
String topicExerciseUrl(int topicId) => "$topicsUrl/$topicId/exercise";
