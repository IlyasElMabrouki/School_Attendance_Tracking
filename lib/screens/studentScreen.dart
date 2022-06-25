import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shen/constants/costume_colors.dart';
import 'package:shen/models/studentModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  Map student = {};
  String classId = "";
  String sessionId = "";
  bool isFirstTime = true;
  List<StudentModel> students = [];
  List<StudentModel> selectedStudents = [];
  final user = FirebaseAuth.instance.currentUser;


  Future<void> getStudents() async {
    QuerySnapshot a = await FirebaseFirestore.instance
        .collection('students')
        .where('classId', isEqualTo: classId)
        .get();
    for (int i = 0; i < a.size; i++) {
      students.add(StudentModel(a.docs[i].id, a.docs[i]['name'], false));
    }
    setState(() {});
    isFirstTime = false;
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    student = ModalRoute.of(context)!.settings.arguments as Map;
    classId = student['class_id'];
    sessionId = student['sessionId'];

    String getInitials(String name) {
      List<String> t = name.split(" ");
      String initials = "";
      for (int y = 0; y < t.length; y++) {
        initials = initials + t[y][0];
      }
      return initials;
    }

    Widget studentItem(String id, String name, bool isSelected, int index) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(getInitials(name),
              style: const TextStyle(color: Colors.white)),
        ),
        title: Text(name),
        trailing: isSelected
            ? const Icon(
          Icons.check_circle,
          color: Colors.blue,
        )
            : const Icon(
          Icons.check_circle_outline,
          color: Colors.grey,
        ),
        onTap: () {
          setState(() {
            students[index].isSelected = !students[index].isSelected;
          });
          if (students[index].isSelected == true) {
            selectedStudents.add(students[index]);
          } else if (students[index].isSelected == false) {
            selectedStudents
                .removeWhere((element) => element.name == students[index].name);
          }
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        left: false,
        right: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(22, 15, 0, 0),
                    child: SvgPicture.asset(
                      'assets/images/logo.svg',
                      height: 30,
                      width: 30,
                      allowDrawingOutsideViewBox: true,
                    ),
                )
              ]
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: isFirstTime ? getStudents() : null,
                builder: (context, snapshot) {
                  return Container();
                }),
            Expanded(
              child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (BuildContext context, int index) {
                    return studentItem(students[index].id, students[index].name,
                        students[index].isSelected, index);
                  }),
            ),
            RawMaterialButton(
              elevation: 2.0,
              fillColor: CostumeColors.blue,
              child: Text("ADD (${selectedStudents.length})",
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: () {
                for (int i = 0; i < selectedStudents.length; i++) {
                  FirebaseFirestore.instance.collection('absence').add(({
                    'studentId': selectedStudents[i].id,
                    'sessionId': sessionId,
                    'time': DateTime.now()
                  }));
                }
                Navigator.pop(context);
              },
              constraints: const BoxConstraints.tightFor(
                width: 200.0,
                height: 50.0,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            )
          ],
        ),
      ),
    );
  }
}
