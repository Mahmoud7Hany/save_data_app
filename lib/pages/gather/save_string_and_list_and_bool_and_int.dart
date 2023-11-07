// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/shared_preferences_model.dart';

// حفظ أكثر من قيمة
// String and List and Bool and int يتم حفظ
// shared_preferences_model من ملف models مستدعي من SharedPreferences
class SaveStringAndListAndBoolAndInt extends StatefulWidget {
  const SaveStringAndListAndBoolAndInt({super.key});

  @override
  State<SaveStringAndListAndBoolAndInt> createState() =>
      _SaveStringAndListAndBoolAndIntState();
}

class _SaveStringAndListAndBoolAndIntState
    extends State<SaveStringAndListAndBoolAndInt> {
  // Bool الخاص ب
  bool isSwitched = false;
  String keyBool = 'keyBool';

  // فتح وقفل
  toggleSwitch(bool value) async {
    setState(() {
      isSwitched = value;
      // Bool حفظ الداتا
      SharedPreferencesUtils.saveBoolData(keyBool, value);

      if (isSwitched) {
        print('The Switch is On');
      } else {
        print('The Switch is Off');
      }
    });
  }

  // String الخاص ب
  final TextEditingController textController1 = TextEditingController();
  String keyString = 'keyString';

  // int الخاص ب
  int number = 0;
  String keyInt = 'keyInt';

  void incrementNumber() {
    setState(() {
      number++;
      SharedPreferencesUtils.saveIntData(
          keyInt, number); // حفظ الرقم عند زيادته
    });
  }

  void decrementNumber() {
    setState(() {
      if (number > 0) {
        number--;
        SharedPreferencesUtils.saveIntData(
            keyInt, number); // حفظ الرقم عند نقصه
      }
    });
  }

  // List الخاص ب
  List<String> myList = [];
  final TextEditingController textController2 = TextEditingController();

  Future<void> loadIntData(int intValue) async {
    setState(() {
      number = intValue;
    });
  }

  // حفظ
  Future<void> saveList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String listAsString = myList.join(","); // تحويل القائمة إلى سلسلة نصية
    prefs.setString('myList', listAsString); // SharedPreferences حفظ السلسلة في
  }

  // استرجاع
  Future<void> loadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? listAsString =
        prefs.getString('myList'); // SharedPreferences استرجاع السلسلة من
    if (listAsString != null) {
      List<String> list = listAsString.split(","); // تحويل السلسلة إلى قائمة
      setState(() {
        myList = list;
      });
    }
  }

  // SharedPreferences لحذف جميع البيانات من
  Future<void> clearList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('myList');
  }

  // إزالة عنصر من القائمه
  int selectedIndex = 0;
  void removeItem(int index) {
    if (myList.isNotEmpty) {
      setState(() {
        myList.removeAt(index); // حذف العنصر من القائمة
        saveList(); // حفظ القائمة الجديدة في SharedPreferences
        textController1.clear(); // لمسح الحقل بعد الحذف
      });
    }
  }

  // أضف إلى القائمة
  void addToList(String item) {
    setState(() {
      // لاضافه العناصر طبيعي فتلقائي اي عنصر جديد هيضاف في الاسفل
      myList.add(item);

      // لاضافه العنصر الجديد في اعلي الصفحه
      // myList.insert(0, item); // أضف عنصرًا في الأعلى
      saveList();
    });
  }

  @override
  void initState() {
    super.initState();
    // Bool استرجاع البيانات الخاص ب
    SharedPreferencesUtils.loadBoolData(keyBool).then((value) {
      toggleSwitch(value);
    });

    // int استرجاع البيانات الخاصة ب
    SharedPreferencesUtils.loadIntData(keyInt).then((value) {
      loadIntData(value);
    });
    // List استرجاع البيانات من
    loadList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // خاص بالزر تشغيل وايقاف
          const SizedBox(height: 20),
          Row(
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
          // خاص بحقلل الادخال واظهر الانص اللي تم اضافته
          const SizedBox(height: 50),
          TextField(
            controller: textController1,
            decoration: const InputDecoration(labelText: 'Enter Text'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                SharedPreferencesUtils.saveStringData(
                    keyString, textController1.text);
                textController1.clear(); // لمسح الحقل بعد الحفظ
              });
            },
            child: const Text('Save'),
          ),
          const SizedBox(height: 10),
          FutureBuilder<String>(
            // عمل تحديث للصفحه واسترجاع البيانات
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
          // خاص بالرقم يزيد ويقلل
          const SizedBox(height: 50),
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
          // خاص ب قائيمه لاضافه مجموعه وحفظها
          const SizedBox(height: 50),
          TextField(
            controller: textController2,
            decoration: const InputDecoration(labelText: 'Enter Text'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // استدعاء دالة الحذف وتمرير الفهرس (index) للعنصر المراد حذفه
              removeItem(selectedIndex);
            },
            child: const Text('إزالة عنصر'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              clearList();
              setState(() {
                myList.clear();
              });
            },
            child: const Text('مسح القائمة'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              addToList(textController2.text);
              textController2.clear();
            },
            child: const Text('Add to List'),
          ),
          const SizedBox(height: 10),
          const Text('List Items:', style: TextStyle(fontSize: 20)),
          Expanded(
            child: ListView.builder(
              itemCount: myList.length,
              itemBuilder: (context, index) {
                if (myList[index].isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            removeItem(index); // حذف العنصر بعد التحديث
                          },
                          child: const Icon(Icons.delete),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          myList[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
                return Container(); // يتم إرجاع حاوية فارغة إذا كان العنصر فارغًا
              },
            ),
          )
        ],
      ),
    );
  }
}
