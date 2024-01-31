class TimerUtil {
  static Duration timeToRead(String text) {
    //GETS The approximate time to read a piece of text by a child

    //Average reading speed of a child is 100 words per minute
    //Average word length is 5 characters
    //Average time to read a character is 0.3 seconds
    //Average time to read a word is 1.5 seconds

    List<String> words = text.split(" ");
    int wordCount = words.length;
    int charCount = text.length;
    double time = (wordCount * 0.7) + (charCount * 0.2) * 0.05;
    //return ceiling of time
    return Duration(seconds: time.ceil());
  }
}
