import 'package:event_manager/services/authentication.dart';
import 'package:event_manager/utilities/colors.dart';
import 'package:event_manager/utilities/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String? _username = _auth.currentUser?.displayName;
  bool _isLoading = false;

  ImageProvider profilePhoto() {
    if (_auth.currentUser != null) {
      if (_auth.currentUser!.photoURL != null) {
        return NetworkImage(_auth.currentUser!.photoURL!);
      } else {
        return const AssetImage('assets/images/profile_pic.png');
      }
    } else {
      return const AssetImage('assets/images/profile_pic.png');
    }
  }

  void changeName(BuildContext context) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Change name"),
        content: TextFormField(
          initialValue: _username,
          onSaved: (value) => _username = value,
          decoration: const InputDecoration(
            labelText: "Name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              Navigator.of(context).pop();
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                await Provider.of<Authentication>(context, listen: false).changeName(_username!, context);
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: Text("Ok",
                style: TextStyle(
                  color: kBlue,
                  fontSize: SizeConfig.textScaleFactor * 20,
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) =>
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraint.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    color: drawerBackground,
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalBlock * 7,
                      vertical: SizeConfig.verticalBlock * 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isLoading ?
                        const CircularProgressIndicator() :
                        CircleAvatar(
                          radius: SizeConfig.horizontalBlock * 11,
                          backgroundImage: profilePhoto(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ),
      ),
    );
  }
}
