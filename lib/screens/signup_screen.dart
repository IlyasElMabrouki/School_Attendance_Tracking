import 'package:flutter/material.dart';
import 'package:shen/constants/costume_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings.dart' as screens;
import 'account_screen.dart';
import 'signInScreen.dart';
import 'Sessions.dart';
import 'studentScreen.dart';
import 'package:shen/themes/main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int invitationCode = 0;

  Future<int> collectionSize(int invitationCode) async {
      QuerySnapshot a = await FirebaseFirestore.instance.collection('teachers').where('invitationCode', isEqualTo: invitationCode).get();
      setState(() {});
      if (a.size > 0 && a.docs[0]['loginId'] != ""){
        return 2;
      }
      if (a.size > 0){
        return 1;
      }
      return 0;
  }

  final theme = ShenTheme.light();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shen',
      routes: {
        '/account': (context) => const Account(),
      },
      home: Scaffold(
       body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: SafeArea(
            left: false,
            right: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero, minimumSize: Size.zero),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Login',
                                style: Theme.of(context).textTheme.bodyText1)),
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
                    Column(children: [
                      const SizedBox(
                        height: 50.0,
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Welcome home,\n",
                            style: Theme.of(context).textTheme.headline1,
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Teacher',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.copyWith(color: CostumeColors.blue))
                            ],
                          )),
                      const SizedBox(
                        height: 60.0,
                      ),
                      Text('Enter your invitation code',
                          style: Theme.of(context).textTheme.headline3),
                      const SizedBox(
                        height: 10.0,
                      ),
                      PinCodeTextField(
                        appContext: context,
                        length: 4,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        onChanged: (value) {
                          invitationCode = int.parse(value);
                        },
                        pinTheme: PinTheme(
                          activeColor: Colors.black,
                          inactiveColor: Colors.black,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      FutureBuilder(
                          future: collectionSize(invitationCode),
                          builder: (context,snapshot){
                              return RawMaterialButton(
                                elevation: 2.0,
                                fillColor: CostumeColors.blue,
                                child: const Text("Validate",
                                    style: TextStyle(color: Colors.white, fontSize: 20)),
                                onPressed: () {
                                  if (snapshot.data == 1){
                                    Navigator.pushReplacementNamed(context, '/account', arguments: {
                                      'invitation_code': invitationCode
                                    });
                                  }
                                  else if (snapshot.data == 2){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("Code have an Account"),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                  else if (snapshot.data == 0){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("Invalid Invitation Code"),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                },
                                constraints: const BoxConstraints.tightFor(
                                  width: 400.0,
                                  height: 50.0,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              );
                          }
                      ),

                    ])
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
