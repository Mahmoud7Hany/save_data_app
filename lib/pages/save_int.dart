import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// حفظ قيمة واحدة
// فقط Int يتم حفظ
// في نفس الصفحه SharedPreferences
class SaveInt extends StatefulWidget {
  const SaveInt({Key? key}) : super(key: key);

  @override
  _SaveIntState createState() => _SaveIntState();
}

class _SaveIntState extends State<SaveInt> {
int number = 0;

  @override
  void initState() {
    super.initState();
    loadData(); // استدعاء دالة استرجاع الرقم عند تحميل الصفحة
  }

  // SharedPreferences دالة لاسترجاع الرقم من
  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedNumber = prefs.getInt('number');
    setState(() {
      number = savedNumber ?? 0; // قيمة افتراضية إذا لم يتم العثور على قيمة
    });
  }

  // SharedPreferences دالة لحفظ الرقم في
  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('number', number);
  }

  void incrementNumber() {
    setState(() {
      number++;
      saveData(); // حفظ الرقم عند زيادته
    });
  }

  void decrementNumber() {
    setState(() {
      if (number > 0) {
        number--;
        saveData(); // حفظ الرقم عند نقصه
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Counter App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Number: $number',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: incrementNumber,
                    child: const Text('+'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: decrementNumber,
                    child: const Text('-'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
