import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_manager/models/groups.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utilities/func.dart' as func;

class Authentication with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        await _auth.currentUser?.updateDisplayName(name);
        FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': DateTime.now(),
        });
        Group category = Group(
          id: "",
          title: "Personal",
          color: Colors.amber,
        );

        final _categoryDatabase = FirebaseFirestore.instance
            .collection('users')
            .doc(user.user!.uid)
            .collection('categories');

        final newId = _categoryDatabase.doc();
        category = category.addId(newId.id);
        newId.set(category.toMap());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }

    Future signInWithGoogle() async {
      try {
        final GoogleSignIn googleUser = GoogleSignIn();
        final GoogleSignInAccount? googleAccount = await googleUser.signIn();

        if (googleAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleAccount.authentication;

          final AuthCredential authCredential = GoogleAuthProvider.credential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken);
              await _auth.signInWithCredential(authCredential);
        }
      } catch (e) {
        rethrow;
      }
    }
  }

   dynamic changeName(String username, BuildContext context) async {
    try {
      await _auth.currentUser?.updateDisplayName(username);
      await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).update({
        'name': username,
      });
    } catch (e) {
      func.showError(context, e.toString());
      rethrow;
    }
  }
}
