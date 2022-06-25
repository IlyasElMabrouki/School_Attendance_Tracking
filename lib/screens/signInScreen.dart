import 'package:flutter/material.dart';
import 'package:shen/screens/signup_screen.dart';
import '../constants/costume_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pwd = '';
  bool showPassword = false;
  bool isValid = false;
  User? user;

  Future signIn() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pwd);
        user = FirebaseAuth.instance.currentUser;
    }
    on FirebaseAuthException catch(e){
      return Text(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              Text(
                                'Login',
                                style: Theme.of(context).textTheme.bodyText1?.copyWith(color: CostumeColors.blue),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero, minimumSize: Size.zero),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                      );
                                    },
                                child: Text('Invited',
                                    style: Theme.of(context).textTheme.bodyText1),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 70.0,
                          ),
                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "Welcome back,\n",
                                style: Theme.of(context).textTheme.headline1,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'User',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.copyWith(color: CostumeColors.blue))
                                ],
                              )),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (email) => email != null && !EmailValidator.validate(email) ?
                                    'enter a valid email' : null,
                                    decoration: const InputDecoration(
                                        hintText: 'Enter your email',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.email)
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        email = val;
                                      });
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
                                                : Icons.visibility_off_outlined
                                            )
                                        )
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        pwd = val;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 40.0,
                                  ),
                                  RawMaterialButton(
                                    elevation: 2.0,
                                    fillColor: CostumeColors.blue,
                                    child: const Text("Log In",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    onPressed: () async {
                                      signIn();
                                    },
                                    constraints: const BoxConstraints.tightFor(
                                      width: 400.0,
                                      height: 50.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0)),
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
