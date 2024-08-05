import 'package:word_and_learn/objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._init(this.store);

  static ObjectBox? _instance;

  static Future<ObjectBox> getInstance() async {
    if (_instance == null) {
      final store = await openStore();
      _instance = ObjectBox._init(store);
    }
    return _instance!;
  }
}
