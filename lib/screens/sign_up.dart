import 'package:event_manager/utilities/fonts.dart';
import 'package:event_manager/utilities/textfield_decorations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/func.dart' as func;
import '../services/authentication.dart';
import '../utilities/colors.dart';
import '../utilities/size_config.dart';
import '../widgets/auth_intro.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static const String routeName = '/signUp';
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email, _password, _name;
  bool _isLoading = false;
  bool _showPassword = false;
  final TextEditingController _passwordController = TextEditingController();

  void _togglePassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      final auth = Provider.of<Authentication>(context, listen: false);
      try {
        await auth.signUpWithEmailAndPassword(_email, _password, _name);
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text(
                  "Account created successfully",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text("A verification email has been sent to "
                    "${FirebaseAuth.instance.currentUser!.email!}."
                    " You will now be redirected to the login screen."),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await auth.signOut();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: Text("Ok",
                        style: TextStyle(
                          color: kBlue,
                          fontSize: SizeConfig.textScaleFactor * 20,
                        )),
                  ),
                ],
              );
            });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        func.showError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraint) => SingleChildScrollView(
                    child: Stack(
                      children: [
                        SizedBox(
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
                                  height: 550,
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
                                    child: ListView(
                                      children: [
                                        TextFormField(
                                          decoration: textFieldDecoration.copyWith(
                                            labelText: "Name",
                                            prefixIcon: const Icon(
                                              Icons.person,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter your name";
                                            }
                                            return null;
                                          },
                                          onChanged: (value) => _name = value,
                                          keyboardType: TextInputType.name,
                                          textInputAction: TextInputAction.next,
                                        ),
                                        const SizedBox(height: 18),
                                        TextFormField(
                                          decoration: textFieldDecoration.copyWith(
                                            labelText: "Email",
                                            prefixIcon: const Icon(Icons.email),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter your email";
                                            }
                                            if (!value.contains('@') || !value.contains('.')) {
                                              return "Please enter a valid email";
                                            }
                                            return null;
                                          },
                                          onChanged: (value) => _email = value,
                                          keyboardType: TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                        ),
                                        const SizedBox(height: 18),
                                        TextFormField(
                                          decoration: textFieldDecoration.copyWith(
                                            labelText: "Password",
                                            prefixIcon: const Icon(
                                              Icons.lock,
                                            ),
                                            suffix: Container(
                                              height: SizeConfig.textScaleFactor * 15,
                                              child: IconButton(
                                                padding: const EdgeInsets.all(0),
                                                icon: _showPassword
                                                    ? const Icon(Icons.visibility)
                                                    : const Icon(Icons.visibility_off,),
                                                onPressed: _togglePassword,
                                              ),
                                            )
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter your password";
                                            }
                                            if (value.length < 6) {
                                              return "Password must be at least 6 characters";
                                            }
                                            return null;
                                          },
                                          onChanged: (value) => _password = value,
                                          onSaved: (value) => _passwordController.text = value!,
                                          obscureText: !_showPassword,
                                          onFieldSubmitted: (value) => _passwordController.text = value,
                                          controller: _passwordController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                        ),
                                        const SizedBox(height: 18),
                                        TextFormField(
                                          decoration: textFieldDecoration.copyWith(
                                            labelText: "Confirm Password",
                                            prefixIcon: const Icon(
                                              Icons.lock,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please confirm your password";
                                            }
                                            if (value != _passwordController.text) {
                                              return "Passwords do not match";
                                            }
                                            return null;
                                          },
                                          obscureText: true,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                        ),
                                        const SizedBox(height: 18),
                                        Container(
                                          margin: const EdgeInsets.symmetric(vertical: 12),
                                          child: ElevatedButton(
                                            onPressed: signUp,
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              fixedSize: const Size(1000, 50),
                                              primary: Colors.purple[700],
                                            ),
                                            child: Text(
                                              "Sign Up",
                                              style: Fonts.medium.copyWith(
                                                fontSize: SizeConfig.horizontalBlock * 5,
                                              )
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Already have an account?",
                                              style: Fonts.medium.copyWith(
                                                fontSize: SizeConfig.textScaleFactor * 18,
                                                color: kGrey
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pushReplacementNamed('/login');
                                              },
                                              child: Text(
                                                "Login",
                                                style: Fonts.bold.copyWith(
                                                  fontSize: SizeConfig.textScaleFactor * 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
    );
  }
}
