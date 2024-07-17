class StickerUtils {
  static List<String> assetsUrls = [
    "brain_2.png",
    "brain.png",
    "construction-worker.png",
    "duck_read.png",
    "work-tools.png",
    "monkey.png",
    "think.png",
    "painting.png",
    "painting_2.png",
  ];

  static String getRandomSticker() {
    String randomItem = (assetsUrls.toList()..shuffle()).first;

    return "assets/stickers/$randomItem";
  }
}
