// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// حفظ قيمة واحدة
// Bool يتم حفظ
// في نفس الصفحه SharedPreferences
class SaveBool extends StatefulWidget {
  const SaveBool({Key? key}) : super(key: key);

  @override
  _SaveBoolState createState() => _SaveBoolState();
}

class _SaveBoolState extends State<SaveBool> {
  String keyBool = 'keyBool';
  bool isSwitched = false;

  // فتح وقفل
  toggleSwitch(bool value) async {
    // حفظ الداتا
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = value;
      prefs.setBool(keyBool, isSwitched);

      if (isSwitched) {
        print('The Switch is On');
      } else {
        print('The Switch is Off');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadBoolData();
  }

  // استرجاع القيمة
  Future<void> loadBoolData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = prefs.getBool(keyBool) ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Save Bool Value'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
          ],
        ),
      ),
    );
  }
}
