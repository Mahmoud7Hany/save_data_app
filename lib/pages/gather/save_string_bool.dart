// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../models/shared_preferences_model.dart';

// حفظ أكثر من قيمة
// Bool و String يتم حفظ
// shared_preferences_model من ملف models مستدعي من SharedPreferences
class SaveStringBool extends StatefulWidget {
  const SaveStringBool({super.key});

  @override
  State<SaveStringBool> createState() => _SaveStringBoolState();
}

class _SaveStringBoolState extends State<SaveStringBool> {
  final TextEditingController textController = TextEditingController();
  String keyString = 'keyString';
  String keyBool = 'keyBool';
  bool isSwitched = false;

  // فتح وقفل
  toggleSwitch(bool value) {
    setState(() {
      isSwitched = value;
      SharedPreferencesUtils.saveBoolData(keyBool, value);

      // يمكنك هنا إضافة رمز يتم تنفيذه عند تغيير الحالة إلى On أو Off
      if (isSwitched) {
        // تم تحويل الزر إلى On
        print('The Switch is On');
      } else {
        // تم تحويل الزر إلى Off
        print('The Switch is Off');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // استدعاء toggleSwitch لتحميل حالة الزر
    SharedPreferencesUtils.loadBoolData(keyBool).then((value) {
      toggleSwitch(value);
    });
    // TextField استدعاء دالة استرجاع القيمة وتحميلها في الحقل المناسب
    // SharedPreferencesUtils.loadStringData(keyString).then((value) {
    //   textController.text = value;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences: SaveMoreThanOneValue'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // زر تشغيل وإيقاف
            Text(
              isSwitched ? 'On' : 'Off',
              style: const TextStyle(fontSize: 24),
            ),
            Switch(
              value: isSwitched,
              onChanged: toggleSwitch,
              activeColor: Colors.green,
              activeTrackColor: Colors.lightGreen,
              inactiveThumbColor: Colors.red,
              inactiveTrackColor: Colors.red[100],
            ),
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Enter Text'),
            ),
            ElevatedButton(
              onPressed: () {
                SharedPreferencesUtils.saveStringData(
                    keyString, textController.text);
                setState(() {});
              },
              child: const Text('Save'),
            ),
            FutureBuilder<String>(
              future: SharedPreferencesUtils.loadStringData(keyString),
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
