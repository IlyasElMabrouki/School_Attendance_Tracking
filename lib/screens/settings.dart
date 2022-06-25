import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shen/services/FireStorageService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final user = FirebaseAuth.instance.currentUser;
  String fullName = "";

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    Image img = Image.asset('ssk');
    await FireStorageService.loadImage(context, imageName).then((value) {
      img = Image.network(value.toString(), fit: BoxFit.scaleDown);
    });
    return img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2B6DA3),
          title: const Text("Settings"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('teachers')
                .where('loginId', isEqualTo: user?.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("OOPS"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData){
                fullName = snapshot.data!.docs[0]['fullname'];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0,40,0,0),
                  child: FutureBuilder(
                      future: _getImage(context, snapshot.data!.docs[0]['image']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        else if (snapshot.hasError) {
                          return const Center(child: Text("OOPS"));
                        }
                        return Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              CircleAvatar(
                                radius: 100.0,
                                child: ClipRRect(
                                  child: snapshot.data as Widget,
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              Text(fullName,style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(color: Colors.black),),
                              const SizedBox(
                                height: 20,
                              ),
                              RawMaterialButton(
                                elevation: 2.0,
                                fillColor: Color(0xFF2B6DA3),
                                child: const Text("Sign Out",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)
                                ),
                                onPressed: () {
                                  setState(() {
                                    FirebaseAuth.instance.signOut();
                                  });
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
                        );
                      }),
                );
              }
              return const Text('');
            },
          ),
        ),
    );
  }
}
