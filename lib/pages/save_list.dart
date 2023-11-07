// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// حفظ قيمة واحدة
// فقط List يتم حفظ
// في نفس الصفحه SharedPreferences
class SaveList extends StatefulWidget {
  const SaveList({Key? key}) : super(key: key);

  @override
  _SaveListState createState() => _SaveListState();
}

class _SaveListState extends State<SaveList> {
  final TextEditingController textController = TextEditingController();
  List<String> myList = [];

  @override
  void initState() {
    super.initState();
    loadList();
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
        textController.clear(); // لمسح الحقل بعد الحذف
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Preferences: Save List'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Enter Text'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // استدعاء دالة الحذف وتمرير الفهرس (index) للعنصر المراد حذفه
                removeItem(selectedIndex);
              },
              child: const Text('Remove Item'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                clearList();
                setState(() {
                  myList.clear();
                });
              },
              child: const Text('Clear List'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                addToList(textController.text);
                textController.clear();
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
            ),
          ],
        ),
      ),
    );
  }
}
