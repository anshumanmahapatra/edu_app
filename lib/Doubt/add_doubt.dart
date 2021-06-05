import 'package:adhyapak/Constants/constant.dart';
import 'package:adhyapak/Helpers/add_photo_popup_card.dart';
import 'package:adhyapak/Helpers/hero_page_route.dart';
import 'package:adhyapak/Services/auth.dart';
import 'package:adhyapak/Services/database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class AddDoubt extends StatefulWidget {
  const AddDoubt({Key key, this.navBarKey}) : super(key: key);
  final GlobalKey<CurvedNavigationBarState> navBarKey;

  @override
  _AddDoubtState createState() => _AddDoubtState();
}

class _AddDoubtState extends State<AddDoubt> {
  String title, description, subject, existingValue, doubtId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  var subjectData = subjects;

  @override
  void initState() {
    doubtId = randomAlphaNumeric(10);
    super.initState();
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    textEditingController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Provider.of<DatabaseMethods>(context, listen: false)
                    .createDoubtCollection(
                  context,
                  {
                    "userId":
                        Provider.of<Authentication>(context, listen: false)
                            .getUserUid,
                    "doubtId": doubtId,
                    "profileUrl": Provider.of<DatabaseMethods>(context,
                                    listen: false)
                                .initPhotoUrl ==
                            null
                        ? "https://firebasestorage.googleapis.com/v0/b/clima-app-723ef.appspot.com/o/johnny.jpg?alt=media&token=d5b9e202-9d66-4fc9-93db-a8dea8587654"
                        : Provider.of<DatabaseMethods>(context, listen: false)
                            .getInitPhotoUrl,
                    "name": Provider.of<DatabaseMethods>(context, listen: false)
                        .getInitUserName,
                    'doubtUrl':
                        Provider.of<DatabaseMethods>(context, listen: false)
                            .initDoubtPost,
                    "title": title,
                    "description": description,
                    "subject": subject,
                    "upVotes": 0,
                    "downVotes": 0,
                    "comments": 0,
                    "answers": 0,
                    "points": 50,
                    "answered": false,
                  },
                  doubtId,
                )
                    .whenComplete(() {
                  setState(() {
                    Provider.of<DatabaseMethods>(context, listen: false)
                        .initDoubtPost = null;
                    textEditingController1.clear();
                    textEditingController2.clear();
                    existingValue = null;
                    widget.navBarKey.currentState.setPage(0);
                    doubtId = randomAlphaNumeric(10);
                  });
                });
              }
            },
            child: Icon(Icons.done_outlined),
          ),
          SizedBox(width: 15),
        ],
        title: RichText(
          text: TextSpan(
              text: "Add Doubt",
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: Provider.of<DatabaseMethods>(context, listen: false)
                              .initDoubtPost ==
                          null
                      ? 0
                      : 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Provider.of<DatabaseMethods>(context, listen: false)
                                .initDoubtPost ==
                            null
                        ? Container(
                            width: 0,
                            height: 0,
                            child: null,
                          )
                        : Image.network(
                            Provider.of<DatabaseMethods>(context, listen: false)
                                .getInitDoubtPost,
                            width: MediaQuery.of(context).size.width - 25,
                            height: 250,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: textEditingController1,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          color: Color(0xFF071E22),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF071E22),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF071E22),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      maxLength: 500,
                      maxLines: 10,
                      minLines: 3,
                      validator: (val) {
                        return val.isEmpty ? 'Enter Title' : null;
                      },
                      onSaved: (input) {
                        title = input;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: textEditingController2,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        hintStyle: TextStyle(
                          color: Color(0xFF071E22),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF071E22),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF071E22),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      maxLength: 1000,
                      maxLines: 20,
                      minLines: 7,
                      validator: (val) {
                        return val.isEmpty ? 'Enter Description' : null;
                      },
                      onSaved: (input) {
                        description = input;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      hint: Text("Subject"),
                      value: existingValue,
                      onChanged: (newValue) {
                        setState(() {
                          existingValue = newValue;
                        });
                      },
                      items: subjectData.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem, child: Text(valueItem));
                      }).toList(),
                      onSaved: (input) {
                        subject = input;
                      },
                      icon: Icon(Icons.arrow_drop_down_outlined),
                      validator: (String val) {
                        return val == null ? "Select a subject" : null;
                      },
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: size.width,
                      height: size.height * 0.15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF99EDCC),
                                  padding: EdgeInsets.all(25),
                                  shape: CircleBorder()),
                              onPressed: () {},
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.crop_free_sharp,
                                    size: 30,
                                    color: Color(0xFF071E22),
                                  ),
                                  Icon(
                                    Icons.image_outlined,
                                    size: 20,
                                    color: Color(0xFF071E22),
                                  ),
                                ],
                              )),
                          Hero(
                            tag: 'add-photo',
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF99EDCC),
                                    padding: EdgeInsets.all(25),
                                    shape: CircleBorder()),
                                onPressed: () {
                                  Navigator.of(context).push(HeroDialogRoute(
                                      builder: (context) => AddPhotoPopUp(navigationPath: "doubt",)));
                                },
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Color(0xFF071E22),
                                )),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF99EDCC),
                                  padding: EdgeInsets.all(25),
                                  shape: CircleBorder()),
                              onPressed: () {},
                              child: Icon(
                                Icons.mic_none_outlined,
                                color: Color(0xFF071E22),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
