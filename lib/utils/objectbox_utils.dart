import 'dart:io';

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

  static deleteInstance() async {
    if (_instance != null) {
      _instance!.store.close();
    }

    Directory(_instance!.store.directoryPath).deleteSync(recursive: true);
    _instance = null;
    //delete from path
    //delete from memory
  }
}
