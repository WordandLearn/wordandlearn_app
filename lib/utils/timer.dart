import 'dart:math';

class TimerUtil {
  static Duration timeToRead(String text) {
    // Constants for estimation (adjusted for a 12-year-old kid)
    const double wordsPerMinute = 150.0; // Adjusted for faster reading
    const double averageWordLength = 5.5; // Adjusted for longer words
    const double timePerCharacter =
        0.25; // in seconds, adjusted for quicker character processing
    const double timePerWord =
        1.2; // in seconds, adjusted for faster word recognition
    const double powerFactor = 0.8; // Power factor for non-linearity

    // Split the text into words
    List<String> words = text.split(" ");
    int wordCount = words.length;
    int charCount = text.length;

    // Calculate time based on word and character count using a power function
    double time = pow(wordCount.toDouble(), powerFactor) * timePerWord +
        (charCount * averageWordLength * timePerCharacter);

    // Apply adjustment for a 12-year-old kid's reading speed
    time /= wordsPerMinute / 60.0;
    time *= 0.05;

    // Return ceiling of time
    return Duration(seconds: time.ceil());
  }
}
