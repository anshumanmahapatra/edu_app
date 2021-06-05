import 'package:adhyapak/Constants/constant.dart';
import 'package:adhyapak/Helpers/add_photo_popup_card.dart';
import 'package:adhyapak/Helpers/hero_page_route.dart';
import 'package:adhyapak/Services/auth.dart';
import 'package:adhyapak/Services/database.dart';
import 'package:adhyapak/Services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import 'answer_home.dart';

class AddAnswer extends StatefulWidget {
  const AddAnswer({Key key, this.doubtId, this.doubtUserId}) : super(key: key);
  final String doubtId, doubtUserId;

  @override
  _AddAnswerState createState() => _AddAnswerState();
}

class _AddAnswerState extends State<AddAnswer> {
  String answer, answerId, answerPost;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  var subjectData = subjects;

  @override
  void initState() {
    answerId = randomAlphaNumeric(10);
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<Utils>(context, listen: false).deleteAnswerPost(widget.doubtId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Provider.of<DatabaseMethods>(context, listen: false)
                      .addAnswer(
                    context,
                    {
                      "answererUserId":
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      "doubtUserId": widget.doubtUserId,
                      "answerId": answerId,
                      "doubtId": widget.doubtId,
                      "profileUrl": Provider.of<DatabaseMethods>(context,
                                      listen: false)
                                  .initPhotoUrl ==
                              null
                          ? "https://firebasestorage.googleapis.com/v0/b/clima-app-723ef.appspot.com/o/johnny.jpg?alt=media&token=d5b9e202-9d66-4fc9-93db-a8dea8587654"
                          : Provider.of<DatabaseMethods>(context, listen: false)
                              .getInitPhotoUrl,
                      "name":
                          Provider.of<DatabaseMethods>(context, listen: false)
                              .getInitUserName,
                      'answerUrl': answerPost,
                      "answer": answer,
                      "upVotes": 0,
                      "downVotes": 0,
                      "comments": 0,
                      'hasAnswered': false,
                      'hasRejected' : false,
                    },
                    answerId,
                  )
                      .whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnswerHome(
                                  doubtId: widget.doubtId,
                                )));
                    Provider.of<DatabaseMethods>(context, listen: false)
                        .answersCount(
                            context,
                            {
                              "answers": FieldValue.increment(1),
                            },
                            widget.doubtId);
                    Provider.of<Utils>(context, listen: false).deleteAnswerPost(widget.doubtId);
                    setState(() {
                      textEditingController.clear();
                      answerId = randomAlphaNumeric(10);
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
                text: "Add Answer",
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
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("AnswerPost").snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      if(snapshot.data.docs.length != 0) {
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              answerPost =snapshot.data.docs[index]['answerPost'];
                              return Container(
                                  height: 250,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network( snapshot.data.docs[index]['answerPost'],
                                      width: MediaQuery.of(context).size.width - 25,
                                      height: 250,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes !=
                                                null
                                                ? loadingProgress
                                                .cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                            }
                        );
                      } else {
                        return Container(
                          width: 0,
                          height: 0,
                          child: null,
                        );
                      }
                    } else {
                      return Container(
                        width: 0,
                        height: 0,
                        child: null,
                      );
                    }
                  }
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: 'Answer',
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
                          return val.isEmpty ? 'Enter Answer' : null;
                        },
                        onSaved: (input) {
                          answer = input;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                                        builder: (context) => AddPhotoPopUp(
                                              navigationPath: "answer",
                                          id: widget.doubtId,
                                            )));
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
      ),
    );
  }
}
