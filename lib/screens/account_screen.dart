import 'dart:io';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shen/constants/costume_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shen/services/FireStorageService.dart';
import 'Sessions.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Map teacher = {};
  int code = 0;
  File? file;
  String filename = "";

  String fullName = "";
  String email = "";
  String password = "";
  String password2 = "";

  String fullNameV = "";
  String emailV = "";
  String idV = "";

  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  int modify = 0;
  bool isValid = false;

  Future signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    if (password != password2) return;
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch(e){
      return Text(e.toString());
    }
  }

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    Image img = Image.asset('test');
    await FireStorageService.loadImage(context, imageName).then((value) {
      img = Image.network(value.toString(), fit: BoxFit.scaleDown);
    });
    return img;
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  Future uploadFile() async {
     if (file == null) return;
     final fileName = basename(file!.path);
     filename = fileName;
     final destination = fileName;
     FireStorageService.uploadFile(destination,file!,fileName);
  }

  @override
  Widget build(BuildContext context) {
    teacher = ModalRoute.of(context)!.settings.arguments as Map;
    code = teacher['invitation_code'];

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('teachers')
              .where('invitationCode', isEqualTo: code)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("OOPS"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            idV = snapshot.data!.docs[0].reference.id;
            fullNameV = snapshot.data!.docs[0]['fullname'];
            emailV = snapshot.data!.docs[0]['email'];
            email = emailV;
            return FutureBuilder(
                future: _getImage(context, snapshot.data!.docs[0]['image']),
                builder: (context,snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if (snapshot.hasError) {
                    return const Center(child: Text("ERROR"));
                  }
                  return SingleChildScrollView(
                    child: SafeArea(
                      left: false,
                      right: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Center(
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero),
                                    onPressed: () => Navigator.pushReplacementNamed(
                                        context, '/signIn'),
                                    child: Text('Login',
                                        style:
                                        Theme.of(context).textTheme.bodyText1)),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Invited',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(color: CostumeColors.blue),
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () async {
                                  await selectFile();
                                  await uploadFile();
                                  CollectionReference teacher = FirebaseFirestore.instance.collection('teachers');
                                    teacher.doc(idV).update({
                                      'image' : filename
                                  });
                                },
                                icon: snapshot.data as Widget,
                                iconSize: 130.0,
                            ),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      initialValue: fullNameV,
                                      onChanged: (val) {
                                        modify++;
                                        fullName = val;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (email) => email != null && !EmailValidator.validate(email) ?
                                      'enter a valid email' : null,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      initialValue: emailV,
                                      onChanged: (val) {
                                        modify += 2;
                                        email = val;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    TextFormField(
                                      obscureText: !showPassword,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) => value != null && value.length < 6 ?
                                      'enter min. 6 characters' : null,
                                      decoration: InputDecoration(
                                          hintText: 'Enter your password',
                                          border: const OutlineInputBorder(),
                                          prefixIcon: const Icon(Icons.lock_outline),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  showPassword = !showPassword;
                                                });
                                              },
                                              icon: Icon(showPassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off_outlined))),
                                      onChanged: (val) {
                                        password = val;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    TextFormField(
                                      obscureText: !showPassword,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) => value != null && value.length < 6 ?
                                      'enter min. 6 characters' : null,
                                      decoration: InputDecoration(
                                          hintText: 'Re-enter your password',
                                          border: const OutlineInputBorder(),
                                          prefixIcon: const Icon(Icons.lock_outline),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  showPassword = !showPassword;
                                                });
                                              },
                                              icon: Icon(showPassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off_outlined))),
                                      onChanged: (val) {
                                        password2 = val;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 40.0,
                                    ),
                                    RawMaterialButton(
                                      elevation: 2.0,
                                      fillColor: CostumeColors.blue,
                                      child: const Text("Sign Up",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 20)),
                                      onPressed: () async {
                                        await signUp();
                                        if (modify == 0) {
                                          fullName = fullNameV;
                                          email = emailV;
                                        }
                                        else if (modify == 1) {
                                          email = emailV;
                                        }
                                        else if (modify == 2) {
                                          fullName = fullNameV;
                                        }
                                        CollectionReference teacher = FirebaseFirestore.instance.collection('teachers');
                                        teacher.doc(idV).update({
                                          'fullname': fullName,
                                          'email': email,
                                          'loginId': FirebaseAuth.instance.currentUser!.uid,
                                        });
                                        CollectionReference session = FirebaseFirestore.instance.collection('session');
                                        QuerySnapshot a = await FirebaseFirestore.instance.collection('session').where('teacherId', isEqualTo: idV).get();
                                        for (int i=0 ; i < a.size ; i++){
                                          session.doc(a.docs[i].id).update({
                                            'teacherId': FirebaseAuth.instance.currentUser!.uid,
                                          });
                                        }
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(builder: (context) => const Sessions()),
                                         );
                                      },
                                      constraints: const BoxConstraints.tightFor(
                                        width: 400.0,
                                        height: 50.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0)
                                      ),
                                    )
                                  ],
                                )),
                          ]),
                        ),
                      ),
                    ),
                  );
                }
            );
          }),
    );
  }
}
