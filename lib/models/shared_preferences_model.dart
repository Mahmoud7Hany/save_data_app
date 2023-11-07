import 'package:shared_preferences/shared_preferences.dart';

// بتستخدم لو هستخدم وحده واعمل له استرجاع
// class SharedPreferencesUtils {
//   static Future<void> saveData(String key, String value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString(key, value);
//   }

//   static Future<String> loadData(String key) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(key) ?? "القيمة الافتراضية";
//   }
// }

// واعمل لهم استرجاع Bool او Int او String لو حفظ اكتر من داتا مثلا
class SharedPreferencesUtils {
  // String حفظ داتا
  static Future<void> saveStringData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> loadStringData(String key) async {
    // String استرجاع داتا
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "القيمة الافتراضية";
  }

  static Future<void> saveBoolData(String key, bool value) async {
    // Bool حفظ داتا
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool> loadBoolData(String key) async {
    // Bool استرجاع داتا
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<void> saveIntData(String key, int value) async {
    // Int حفظ داتا
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future<int> loadIntData(String key) async {
    // Int استرجاع داتا
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static Future<void> saveData(Map<String, dynamic> data) async {
    // بيحفظ الداتا كلها مره وحده
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data.forEach((key, value) {
      if (value is String) {
        prefs.setString(key, value);
      } else if (value is bool) {
        prefs.setBool(key, value);
      }
    });
  }

  static Future<Map<String, dynamic>> loadAllData(List<String> keys) async {
    // بيعمل استرجاع للداتا كلها مره وحده
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {};
    for (var key in keys) {
      if (prefs.containsKey(key)) {
        if (prefs.getString(key) != null) {
          data[key] = prefs.getString(key);
        } else if (prefs.getBool(key) != null) {
          data[key] = prefs.getBool(key);
        }
      }
    }
    return data;
  }
}
