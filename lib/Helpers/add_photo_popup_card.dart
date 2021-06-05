import 'package:adhyapak/Services/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'add_photo.dart';
import 'custom_rect_tween.dart';

class AddPhotoPopUp extends StatelessWidget {
  const AddPhotoPopUp({Key key, this.navigationPath, this.id})
      : super(key: key);
  final String navigationPath, id;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0.3),
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Hero(
          tag: 'add-photo',
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Color(0xFF99EDCC),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: Container(
              height: 150,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Provider.of<Utils>(context, listen: false)
                          .pickImage(ImageSource.camera)
                          .whenComplete(() {
                        if (navigationPath == "doubt") {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddPhoto(
                                    file: Provider.of<Utils>(context,
                                            listen: false)
                                        .getInitImageFile,
                                    navigationPath: navigationPath,
                                  )));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddPhoto(
                                    file: Provider.of<Utils>(context,
                                            listen: false)
                                        .getInitImageFile,
                                    navigationPath: navigationPath,
                                    id: id,
                                  )));
                        }
                      });
                    },
                    leading: Icon(
                      Icons.camera_enhance_outlined,
                      color: Color(0xFF071E22),
                    ),
                    title: Text("Take A Photo"),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    onTap: () {
                      Provider.of<Utils>(context, listen: false)
                          .pickImage(ImageSource.gallery)
                          .whenComplete(() {
                        if (navigationPath == "doubt") {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddPhoto(
                                    file: Provider.of<Utils>(context,
                                            listen: false)
                                        .getInitImageFile,
                                    navigationPath: navigationPath,
                                  )));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddPhoto(
                                    file: Provider.of<Utils>(context,
                                            listen: false)
                                        .getInitImageFile,
                                    navigationPath: navigationPath,
                                    id: id,
                                  )));
                        }
                      });
                    },
                    leading: Icon(
                      Icons.photo_library_outlined,
                      color: Color(0xFF071E22),
                    ),
                    title: Text("Upload Photo"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
