import 'dart:io';

import 'package:adhyapak/Helpers/essentials.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import 'database.dart';

class Utils with ChangeNotifier {
  UploadTask task;
  File imageFile;

  UploadTask get getTask => task;

  File get getInitImageFile => imageFile;

  Future pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    if (pickedFile == null) return;
    final path = pickedFile.path;

    imageFile = File(path);
  }

  Future uploadDoubtImageToFirebase(
      BuildContext context, File imageFile) async {
    String fileName = path.basename(imageFile.path);
    final destination = 'files/$fileName';

    task = DatabaseMethods.uploadFile(destination, imageFile);
    if (task == null) {
      print("task is null");
    }

    TaskSnapshot taskSnapshot = await task.whenComplete(() {});
    if (task == null) return;

    final urlDownload =
        await taskSnapshot.ref.getDownloadURL().whenComplete(() {
      Navigator.maybePop(context).whenComplete(() {
        Navigator.pop(context);
        Provider.of<Essentials>(context, listen: false)
            .navBarKey
            .currentState
            .setPage(1);
      });
      notifyListeners();
    });

    Provider.of<DatabaseMethods>(context, listen: false).initDoubtPost =
        urlDownload;
    print("Download Url of Doubt Picture:");
    print(
        Provider.of<DatabaseMethods>(context, listen: false).getInitDoubtPost);

    notifyListeners();
  }

  Future uploadAnswerImageToFirebase(
      BuildContext context, File imageFile, String id) async {
    String fileName = path.basename(imageFile.path);
    final destination = 'files/$fileName';

    task = DatabaseMethods.uploadFile(destination, imageFile);
    if (task == null) {
      print("task is null");
    }

    TaskSnapshot taskSnapshot = await task.whenComplete(() {});
    if (task == null) return;

    final urlDownload =
        await taskSnapshot.ref.getDownloadURL().whenComplete(() {
      Navigator.maybePop(context).whenComplete(() => Navigator.pop(context));
      notifyListeners();
    });

    addAnswerPost(id, {
      "answerPost": urlDownload,
    });
    print("Download Url of Answer Picture:");
    print(urlDownload);
    notifyListeners();
  }

  Future addAnswerPost(String id, dynamic data) {
    return FirebaseFirestore.instance
        .collection("AnswerPost")
        .doc(id)
        .set(data);
  }

  Future deleteAnswerPost(String id) {
    return FirebaseFirestore.instance
        .collection("AnswerPost")
        .doc(id)
        .delete();
  }
}
