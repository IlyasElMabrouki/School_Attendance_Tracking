import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shen/services/FireStorageService.dart';
import 'package:intl/intl.dart';
import '../constants/costume_colors.dart';
import 'account_screen.dart';
import 'signInScreen.dart';
import 'signup_screen.dart';
import 'studentScreen.dart';
import 'settings.dart' as screens;

class Sessions extends StatefulWidget {
  const Sessions({Key? key}) : super(key: key);

  @override
  _SessionsState createState() => _SessionsState();
}

class _SessionsState extends State<Sessions> {
  final user = FirebaseAuth.instance.currentUser;
  final f = DateFormat('HH:mm');

  Future<Widget> getClassName(String idClass) async {
    DocumentSnapshot a = await FirebaseFirestore.instance
        .collection('classroom')
        .doc(idClass)
        .get();
    return Text(
      a['name'],
      style: TextStyle(color: Colors.white),
    );
  }

  Future<Widget> getClassName1(String idClass) async {
    DocumentSnapshot a = await FirebaseFirestore.instance
        .collection('classroom')
        .doc(idClass)
        .get();
    return Text(
      a['name'],
      style: TextStyle(color: Colors.black),
    );
  }

  Future<Widget> getClassAbr(String idClass) async {
    DocumentSnapshot a = await FirebaseFirestore.instance
        .collection('classroom')
        .doc(idClass)
        .get();
    return Text(a['abbreviation'], style: TextStyle(color: Colors.white),);
  }

  Future<Widget> getClassAbr1(String idClass) async {
    DocumentSnapshot a = await FirebaseFirestore.instance
        .collection('classroom')
        .doc(idClass)
        .get();
    return Text(a['abbreviation'], style: TextStyle(color: Colors.white, fontSize: 30,fontWeight: FontWeight.bold,letterSpacing: 2.0,));
  }

  Future<Widget> getClassNumber(String idClass) async {
    QuerySnapshot a = await FirebaseFirestore.instance
        .collection('students')
        .where('classId', isEqualTo: idClass)
        .get();
    return Text(
      a.size.toString() + ' students',
      style: TextStyle(color: Colors.white),
    );
  }

  Future<Widget> _getImage(BuildContext context) async {
    Image img = Image.asset('ssk');
    QuerySnapshot a = await FirebaseFirestore.instance
        .collection('teachers')
        .where('loginId', isEqualTo: user?.uid)
        .get();
    await FireStorageService.loadImage(context, a.docs[0]['image'])
        .then((value) {
      img = Image.network(value.toString(), fit: BoxFit.scaleDown);
    });
    return img;
  }

  String getDate(Timestamp a) {
    DateTime dt = a.toDate();
    return f.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/signIn': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/account': (context) => const Account(),
        '/session': (context) => const Sessions(),
        '/student': (context) => const Student(),
        '/settings' : (context) => const screens.Settings(),
      },
      home: Scaffold(
        body: SafeArea(
          left: false,
          right: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    height: 30,
                    width: 30,
                    allowDrawingOutsideViewBox: true,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(220, 0, 0, 0),
                  ),
                  FutureBuilder(
                      future: _getImage(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text('');
                        } else if (snapshot.hasError) {
                          return const Center(child: Text("OOPS"));
                        }
                        return IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/settings');
                          },
                          icon: snapshot.data as Widget,
                          iconSize: 50.0,
                        );
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Text("Current Class",style: TextStyle(color: Color(0xFF2B6DA3),fontWeight: FontWeight.bold,fontSize: 20)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('session')
                      .where('teacherId', isEqualTo: user!.uid)
                      .orderBy('startTime')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.data!.size == 0) {
                      return const Center(child: Text("NO SESSIONS FOR TODAY"));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("ERROR"));
                    } else {
                      DocumentSnapshot a = snapshot.data!.docs[0];
                      final List<DocumentSnapshot> userList = snapshot.data!.docs
                          .where((DocumentSnapshot documentSnapshot) =>
                              documentSnapshot['startTime'] !=
                              snapshot.data!.docs[0]['startTime'])
                          .toList();
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/student',
                                  arguments: {
                                    'class_id': a['classId'],
                                    'sessionId': a.reference.id
                                  },
                                );
                              },
                              child: Container(
                                width: 400,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: CostumeColors.blue,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                        ),
                                        FutureBuilder(
                                            future: getClassAbr1(a['classId']),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return snapshot.data as Widget;
                                              }
                                              return const Text("ERROR");
                                            }),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                        ),
                                        FutureBuilder(
                                            future: getClassName(a['classId']),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return snapshot.data as Widget;
                                              }
                                              return const Text("ERROR");
                                            }),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                        ),
                                        FutureBuilder(
                                            future: getClassNumber(a['classId']),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return snapshot.data as Widget;
                                              }
                                              return const Text("ERROR");
                                            }),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10),
                                        ),
                                        Text(
                                          'start : ' + a['startTime'],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 180, 0),
                                        ),
                                        Text(
                                          'end : ' + a['endTime'],
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                              ),
                              Text("Upcoming Classes",style: TextStyle(color: Color(0xFF2B6DA3),fontWeight: FontWeight.bold,fontSize: 20)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView(
                              children: userList.map((session) {
                                return Center(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: FutureBuilder(
                                          future: getClassAbr(session['classId']),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return snapshot.data as Widget;
                                            }
                                            return const Text("ERROR");
                                          }),
                                      backgroundColor: CostumeColors.blue,
                                      radius: 25,
                                    ),
                                    title: FutureBuilder(
                                        future: getClassName1(session['classId']),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return snapshot.data as Widget;
                                          }
                                          return const Text("ERROR");
                                        }),
                                    subtitle: Text(session['startTime'] +
                                        ' ' +
                                        session['endTime']),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/student',
                                        arguments: {
                                          'class_id': session['classId'],
                                          'sessionId': session.reference.id
                                        },
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
