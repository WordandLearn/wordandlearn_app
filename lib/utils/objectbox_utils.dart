import 'package:flutter/foundation.dart';

class ObjectBox {
  // /// The Store of this app.
  // static Duration databaseTTL =
  //     const Duration(minutes: 15); //how long data in the database is active
  // ///
  // late final Store store;

  // ObjectBox._init(this.store);

  // static ObjectBox? _instance;

  static Future<void> getInstance() async {
    if (kIsWeb) {
      throw "Cant Instantiate on Web";
    }
    // if (!kIsWeb) {
    //   if (_instance == null) {
    //     final store = await openStore();
    //     _instance = ObjectBox._init(store);
    //   }
    //   return _instance!;
    // } else {
    //   throw "Cant Instantiate on Web";
    // }
  }

  static deleteInstance() async {
    // if (_instance != null) {
    //   _instance!.store.close();
    // }

    // Directory(_instance!.store.directoryPath).deleteSync(recursive: true);
    // _instance = null;
    //delete from path
    //delete from memory
  }

  // static Future<bool> isTtlExpired(String key) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   if (preferences.containsKey("${key}_lastDatabaseAccess")) {
  //     DateTime lastAccess =
  //         DateTime.parse(preferences.getString("${key}_lastDatabaseAccess")!);
  //     DateTime now = DateTime.now();
  //     Duration difference = now.difference(lastAccess);
  //     if (difference > databaseTTL) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     return true;
  //   }
  // }

  // static Future<void> updateDatabaseAccess(String key) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setString(
  //       "${key}_lastDatabaseAccess", DateTime.now().toString());
  // }
}
