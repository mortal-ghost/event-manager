import 'package:event_manager/screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/authentication.dart';
import '../services/tasks.dart';
import '../utilities//size_config.dart';
import '../utilities/colors.dart';
import '../utilities/fonts.dart';
import '../utilities/textfield_decorations.dart';
import '../utilities/func.dart' as func;
import '../widgets/auth_intro.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const String routeName = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password;
  bool isLoading = false;

  void _passwordReset(BuildContext context) async  {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: TextFormField(
          onChanged: (value) => _email = value,
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final FirebaseAuth auth = FirebaseAuth.instance;
              final list = await auth.fetchSignInMethodsForEmail(_email);
              if (list.isNotEmpty) {
                try {
                  await auth.sendPasswordResetEmail(email: _email);
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      content: const Text(
                          'Password reset link sent',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                              'OK',
                              style: TextStyle(
                                color: kBlue,
                                fontSize: SizeConfig.textScaleFactor * 20,
                              ),
                          ),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  func.showError(context, e.toString());
                }
              } else {
                Navigator.of(context).pop();
                func.showError(context, 'No account found with this email');
              }
            },
            child: Text(
              "Reset Password",
              style: TextStyle(
                fontSize: SizeConfig.textScaleFactor * 20,
                color: kBlue,
              ),
            ),
          )
        ],
      )
    );
  }

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);
      
      final auth = Provider.of<Authentication>(context, listen: false);
      
      await auth.signInWithEmailAndPassword(_email, _password);
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        setState(() => isLoading = false);
        Provider.of<Tasks>(context, listen: false).fetchAndSetTasks();
        Navigator.of(context).pushReplacementNamed('/calender');
      } else {
        await auth.signOut().then((value) {
          setState(() {
            isLoading = false;
          });
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text(
                    "Please Verify Your Email Before Logging In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                      "A verification email has already been sent to your registered email address."
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                          "Ok",
                          style: TextStyle(
                            color: kBlue,
                            fontSize: SizeConfig.textScaleFactor * 20,
                          )
                      ),
                    ),
                  ],
                );
              }
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    return Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                      child: Stack(
                    children: <Widget>[
                      Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenHeight,
                        child: const Image(
                          image: AssetImage("assets/images/background.jpg"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraint.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const AuthScreenIntro(),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.horizontalBlock * 5,
                                ),
                                height: 450,
                                width: SizeConfig.screenWidth,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(children: <Widget>[
                                    SizedBox(
                                      height: SizeConfig.verticalBlock * 5,
                                    ),
                                    TextFormField(
                                      decoration: textFieldDecoration.copyWith(
                                        labelText: "Email",
                                        prefixIcon: const Icon(Icons.email),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onSaved: (value) => _email = value!,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter your email";
                                        }
                                        if (!value.contains('@') ||
                                            !value.contains('.')) {
                                          return "Please enter a valid email";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: SizeConfig.verticalBlock * 4,
                                    ),
                                    TextFormField(
                                      decoration: textFieldDecoration.copyWith(
                                        labelText: "Password",
                                        prefixIcon: const Icon(Icons.lock),
                                      ),
                                      obscureText: true,
                                      textInputAction: TextInputAction.done,
                                      onSaved: (value) => _password = value!,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter your password";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: SizeConfig.verticalBlock * 4,
                                    ),
                                    GestureDetector(
                                      onTap: () => _passwordReset(context),
                                      child: Text(
                                        "Forgot Password?",
                                        style: Fonts.medium.copyWith(
                                          color: kBlue,
                                          fontSize: SizeConfig.textScaleFactor * 18,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 12
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () => _login(context),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          fixedSize: const Size(1000, 50),
                                          primary: Colors.purple[700],
                                        ),
                                        child: Text(
                                          "Login",
                                          style: Fonts.medium.copyWith(
                                            fontSize: SizeConfig.textScaleFactor * 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.verticalBlock * 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Don't have an account?",
                                          style: Fonts.medium.copyWith(
                                            fontSize: SizeConfig.textScaleFactor * 18,
                                            color: kGrey,
                                          )
                                        ),
                                        SizedBox(
                                          width: SizeConfig.horizontalBlock * 2,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamedAndRemoveUntil(SignUp.routeName, (route) => false);
                                          },
                                          child: Text(
                                            "Sign Up",
                                            style: Fonts.medium.copyWith(
                                              fontSize: SizeConfig.textScaleFactor * 18
                                            )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ));
                },
              ));
  }
}
