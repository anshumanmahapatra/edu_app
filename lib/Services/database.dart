import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

class DatabaseMethods with ChangeNotifier {
  String initUserEmail, initName, initUserId, initDoubtPost, initPhotoUrl;

  String get getInitUserName => initName;

  String get getInitUserEmail => initUserEmail;

  String get getInitUserId => initUserId;

  String get getInitPhotoUrl => initPhotoUrl;

  String get getInitDoubtPost => initDoubtPost;


  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future updateProfile(
      BuildContext context, String userId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .update(data);
  }

  Future createDoubtCollection(
      BuildContext context, dynamic data, String doubtId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .set(data);
  }

  Future editDoubt (BuildContext context, dynamic data, String doubtId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .update(data);
  }

  Future deleteDoubt(BuildContext context, String doubtId) async {
    return FirebaseFirestore.instance.collection("Doubt").doc(doubtId).delete();
  }

  Future addUpVotes(BuildContext context, dynamic data, String doubtId,
      String upVoteId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .collection("UpVotes")
        .doc(upVoteId)
        .set(data);
  }

  Future upVotesCount(
      BuildContext context, dynamic data, String doubtId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .update(data);
  }

  Future deleteUpVotes(
      BuildContext context, String doubtId, String upVoteId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .collection("UpVotes")
        .doc(upVoteId)
        .delete();
  }

  Future addDownVotes(BuildContext context, dynamic data, String doubtId,
      String downVoteId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .collection("DownVotes")
        .doc(downVoteId)
        .set(data);
  }

  Future downVotesCount(
      BuildContext context, dynamic data, String doubtId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .update(data);
  }

  Future deleteDownVotes(
      BuildContext context, String doubtId, String downVoteId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .collection("DownVotes")
        .doc(downVoteId)
        .delete();
  }

  Future addComments(BuildContext context, dynamic data, String doubtId,
      String commentId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .collection("Comments")
        .doc(commentId)
        .set(data);
  }

  Future commentsCount(
      BuildContext context, dynamic data, String doubtId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .update(data);
  }

  Future deleteComment(
      BuildContext context, String doubtId, String commentId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .collection("Comments")
        .doc(commentId)
        .delete();
  }

  Future editComment(BuildContext context, dynamic data, String doubtId,
      String commentId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .collection("Comments")
        .doc(commentId)
        .update(data);
  }

  Future addAnswer(BuildContext context, dynamic data,
      String answerId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .set(data);
  }

  Future editAnswer(BuildContext context, dynamic data,
      String answerId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .update(data);
  }

  Future deleteAnswer(
      BuildContext context, String answerId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .delete();
  }

  Future answersCount(
      BuildContext context, dynamic data, String doubtId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .update(data);
  }

  Future changeAnsweredState(
      BuildContext context, dynamic data, String doubtId) async {
    return FirebaseFirestore.instance
        .collection("Doubt")
        .doc(doubtId)
        .update(data);
  }


  Future addAnswerUpVotes(BuildContext context, dynamic data,
      String answerId, String upVoteId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .collection("UpVotes")
        .doc(upVoteId)
        .set(data);
  }

  Future answerUpVotesCount(BuildContext context, dynamic data,
      String answerId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .update(data);
  }

  Future deleteAnswerUpVotes(BuildContext context,
      String answerId, String upVoteId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .collection("UpVotes")
        .doc(upVoteId)
        .delete();
  }

  Future addAnswerDownVotes(BuildContext context, dynamic data,
      String answerId, String downVoteId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .collection("DownVotes")
        .doc(downVoteId)
        .set(data);
  }

  Future answerDownVotesCount(
      BuildContext context, dynamic data, String answerId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .update(data);
  }

  Future deleteAnswerDownVotes(BuildContext context,
      String answerId, String downVoteId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .collection("DownVotes")
        .doc(downVoteId)
        .delete();
  }

  Future addAnswerComments(BuildContext context, dynamic data,
      String answerId, String commentId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .collection("Comments")
        .doc(commentId)
        .set(data);
  }

  Future answerCommentsCount(
      BuildContext context, dynamic data, String answerId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .update(data);
  }

  Future deleteAnswerComment(BuildContext context,
      String answerId, String commentId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .collection("Comments")
        .doc(commentId)
        .delete();
  }

  Future editAnswerComment(BuildContext context, dynamic data,
      String answerId, String commentId) async {
    return FirebaseFirestore.instance
        .collection("Answers")
        .doc(answerId)
        .collection("Comments")
        .doc(commentId)
        .update(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      initUserEmail = doc.data()["email"];
      initUserId = doc.data()["userid"];
      initName = doc.data()["name"];
      initPhotoUrl = doc.data()["photoUrl"];
      notifyListeners();
    });
  }

  static UploadTask uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
