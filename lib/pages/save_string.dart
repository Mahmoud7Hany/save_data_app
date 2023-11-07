import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// حفظ قيمة واحدة
// فقط String يتم حفظ
// في نفس الصفحه SharedPreferences
class SaveString extends StatefulWidget {
  const SaveString({super.key});

  @override
  State<SaveString> createState() => _SaveStringState();
}

class _SaveStringState extends State<SaveString> {
  final TextEditingController textController = TextEditingController();

  Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> loadData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "القيمة الافتراضية";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences : SaveSingleValue'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Enter Text'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  saveData('user_text', textController.text);
                });
              },
              child: const Text('Save'),
            ),
            FutureBuilder<String>(
              future: loadData('user_text'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text('Saved Text: ${snapshot.data}');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
