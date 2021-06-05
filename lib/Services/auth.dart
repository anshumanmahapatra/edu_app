import 'package:adhyapak/Helpers/helping_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'database.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  String userUid;

  String get getUserUid => userUid;

  Future logIntoAccount(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      userUid = user.uid;
      print(userUid);
    } catch (e) {
      Provider.of<HelpingWidgets>(context, listen: false)
          .showErrorMessage(context, e.toString());
    }
    notifyListeners();
  }

  Future createAccount(
      BuildContext context, String email, String name, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      userUid = user.uid;
      print(userUid);
    } catch (e) {
      Provider.of<HelpingWidgets>(context, listen: false)
          .showErrorMessage(context, e.toString());
    }
    notifyListeners();
  }

  Future signInWithGoogle(BuildContext context) async {
    bool userExists;
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        UserCredential result =
            await firebaseAuth.signInWithCredential(credential);
        User user = firebaseAuth.currentUser;
        userUid = user.uid;
        print(user.uid);
        User userDetails = result.user;

        Future doesUserExists() async {
          return await FirebaseFirestore.instance
              .collection("Users")
              .where('userid', isEqualTo: userDetails.uid)
              .snapshots()
              .isEmpty;
        }

          doesUserExists().then((value) {
            print(value);
            if(value == true) {
              Provider.of<DatabaseMethods>(context, listen: false)
                  .createUserCollection(context, {
                "userid": userDetails.uid,
                "email": userDetails.email,
                "name": userDetails.displayName,
                "photoUrl": userDetails.photoURL,
                "points": 0,
              });
            }

          });
          Navigator.pushReplacementNamed(context, "/");
      }
    } catch (e) {
      Provider.of<HelpingWidgets>(context, listen: false)
          .showErrorMessage(context, e.toString());
    }
    notifyListeners();
  }

  Future signOut() async {
    User user = firebaseAuth.currentUser;
    print(user.providerData[0].providerId);
    if (user.providerData[0].providerId == 'google.com') {
      await googleSignIn.disconnect();
    }
    await firebaseAuth.signOut();
    return Future.value(true);
  }
}
