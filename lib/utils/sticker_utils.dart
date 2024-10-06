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
    "banana_read.png",
    "bear_learn.png",
    "brain_3.png",
    "brain_4.png",
    "cow_globe.png",
    "dog.png",
    "dolphin.png",
    "elephant.png",
    "fox_read.png",
    "geek_rabbit.png",
    "lion_learn.png",
    "rabbit_cap.png",
    "rabbit_math.png",
    "seal_book.png",
    "owl_cap.png",
    "owl_idea.png",
    "tiger_draw.png",
    "ting_book.png",
    "panda_write.png"
  ];

  static List<String> errorAssetsUrl = [
    "sad dog.png",
    "sad_dirty_dog.png",
    "crying_dog.png",
  ];

  static List<String> successAssetsUrl = [
    "monkey_pencil.png",
    "fly_happy.png",
    "panda_happy.png"
  ];

  static String getRandomSticker() {
    String randomItem = (assetsUrls.toList()..shuffle()).first;

    return "assets/stickers/$randomItem";
  }

  static String getRandomErrorSticker() {
    String randomItem = (errorAssetsUrl.toList()..shuffle()).first;

    return "assets/stickers/$randomItem";
  }

  static String getRandomSuccessSticker() {
    String randomItem = (successAssetsUrl.toList()..shuffle()).first;

    return "assets/stickers/$randomItem";
  }
}
