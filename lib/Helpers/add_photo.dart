import 'dart:io';

import 'package:adhyapak/Services/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPhoto extends StatelessWidget {
  const AddPhoto({Key key, this.file, this.navigationPath, this.id}) : super(key: key);
  final File file;
  final String navigationPath, id;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
              text: "Upload Image",
              style: TextStyle(
                  color: Color(0xFF071E22),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Color(0xFF99EDCC),
        iconTheme: IconThemeData(color: Color(0xFF071E22)),
        centerTitle: true,
        elevation: 0.0,
        toolbarHeight: 50,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.all(25),
        child: Column(
            children: <Widget>[
              SizedBox(height: size.height * 0.15,),
              Image.file(file,
          width: MediaQuery.of(context).size.width - 25,
          height: 250,
          fit: BoxFit.cover,
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  if(navigationPath == 'doubt') {
                    Provider.of<Utils>(context, listen: false)
                        .uploadDoubtImageToFirebase(context, file);
                  }
                  else {
                    Provider.of<Utils>(context, listen: false)
                        .uploadAnswerImageToFirebase(context, file, id);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF99EDCC),
                  onPrimary: Color(0xFF071E22),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 10,),
                    Icon(Icons.upload_sharp),
                    Text('Upload the picture'),
                    SizedBox(width: 10,),
                  ],
                ),
              ),
            ]
          ),
      ),
    );
  }
}
