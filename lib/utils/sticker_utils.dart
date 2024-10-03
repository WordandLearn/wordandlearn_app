class StickerUtils {
  //TODO: Get assets from freepik, https://www.freepik.com/search?format=search&last_filter=page&last_value=2&page=2&query=sad+illustration+animal&type=vector#uuid=8bbe0432-7802-4bc8-97bd-f30fe9bf6e96
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
    "owl_idea.png"
  ];

  static List<String> errorAssetsUrl = [
    "sad dog.png",
    "sad_dirty_dog.png",
    "crying_dog.png",
  ];

  static String getRandomSticker() {
    String randomItem = (assetsUrls.toList()..shuffle()).first;

    return "assets/stickers/$randomItem";
  }

  static String getRandomErrorSticker() {
    String randomItem = (errorAssetsUrl.toList()..shuffle()).first;

    return "assets/stickers/$randomItem";
  }
}
