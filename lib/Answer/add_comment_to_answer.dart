import 'package:adhyapak/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class AddCommentToAnswer extends StatefulWidget {
  final String answerId, doubtUserId;

  AddCommentToAnswer({@required this.answerId, @required this.doubtUserId});

  @override
  _AddCommentToAnswerState createState() => _AddCommentToAnswerState();
}

class _AddCommentToAnswerState extends State<AddCommentToAnswer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  String comment, commentId;
  bool notEditing;

  var optionsForCommenter = [
    {
      "text": "Edit",
      "icon": Icon(
        Icons.edit,
        color: Colors.orange,
      ),
    },
    {
      "text": "Delete",
      "icon": Icon(
        Icons.delete,
        color: Colors.red,
      ),
    },
  ];

  var optionsForSender = [
    {
      "text": "Delete",
      "icon": Icon(
        Icons.delete,
        color: Colors.red,
      ),
    },
  ];

  @override
  void initState() {
    super.initState();
    notEditing = true;
    commentId = randomAlphaNumeric(10);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
              text: "Comments",
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
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Answers")
                .doc(widget.answerId)
                .collection("Comments")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(snapshot.data.docs.length !=0) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 24,
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.network(
                                        snapshot.data.docs[index]['photoUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                title: RichText(
                                  text: TextSpan(
                                      text: snapshot.data.docs[index]['name'] +
                                          "  ",
                                      style: TextStyle(
                                        color: Color(0xFF229062),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: snapshot.data.docs[index]
                                            ['comment'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ]),
                                ),
                                trailing: snapshot.data.docs[index]['doubtUserId'] ==
                                    Provider.of<DatabaseMethods>(context,
                                        listen: false)
                                        .getInitUserId
                                    ? snapshot.data.docs[index]
                                ['commenterUserId'] ==
                                    Provider.of<DatabaseMethods>(
                                        context,
                                        listen: false)
                                        .getInitUserId
                                    ? PopupMenuButton(
                                  iconSize: 18.0,
                                  itemBuilder: (context) {
                                    return List.generate(
                                        optionsForCommenter.length,
                                            (index) {
                                          return PopupMenuItem(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                    optionsForCommenter[
                                                    index]["text"]),
                                                SizedBox(width: 5),
                                                optionsForCommenter[
                                                index]['icon'],
                                              ],
                                            ),
                                            value: index,
                                          );
                                        });
                                  },
                                  onSelected: (value) {
                                    if (value == 0) {
                                      setState(() {
                                        textEditingController.text =
                                        snapshot.data
                                            .docs[index]
                                        ['comment'];
                                        commentId = snapshot
                                            .data.docs[index]
                                        ['commentId'];
                                        notEditing = false;
                                      });
                                    } else {
                                      Provider.of<DatabaseMethods>(
                                          context,
                                          listen: false)
                                          .deleteAnswerComment(
                                          context,
                                          widget.answerId,
                                          snapshot.data
                                              .docs[index]
                                          ['commentId']);
                                      Provider.of<DatabaseMethods>(
                                          context,
                                          listen: false)
                                          .answerCommentsCount(
                                          context,
                                          {
                                            "comments":
                                            FieldValue
                                                .increment(
                                                -1),
                                          },
                                          widget.answerId);
                                    }
                                  },
                                )
                                    : PopupMenuButton(
                                  itemBuilder: (context) {
                                    return List.generate(
                                        optionsForSender.length,
                                            (index) {
                                          return PopupMenuItem(
                                            child: Row(
                                              children: [
                                                Text(optionsForSender[
                                                index]["text"]),
                                                SizedBox(width: 5),
                                                optionsForSender[index]
                                                ['icon'],
                                              ],
                                            ),
                                            value: index,
                                          );
                                        });
                                  },
                                  onSelected: (value) {
                                    if (value == 0) {
                                      Provider.of<DatabaseMethods>(
                                          context,
                                          listen: false)
                                          .deleteAnswerComment(
                                          context,
                                          widget.answerId,
                                          snapshot.data
                                              .docs[index]
                                          ['commentId']);
                                      Provider.of<DatabaseMethods>(
                                          context,
                                          listen: false)
                                          .answerCommentsCount(
                                          context,
                                          {
                                            "comments":
                                            FieldValue
                                                .increment(
                                                -1),
                                          },
                                          widget.answerId);
                                    }
                                  },
                                )
                                    : (snapshot.data.docs[index]
                                ['commenterUserId'] ==
                                    Provider.of<DatabaseMethods>(
                                        context,
                                        listen: false)
                                        .getInitUserId)
                                    ? PopupMenuButton(
                                  iconSize: 18.0,
                                  itemBuilder: (context) {
                                    return List.generate(
                                        optionsForCommenter.length,
                                            (index) {
                                          return PopupMenuItem(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                    optionsForCommenter[
                                                    index]["text"]),
                                                SizedBox(width: 5),
                                                optionsForCommenter[
                                                index]['icon'],
                                              ],
                                            ),
                                            value: index,
                                          );
                                        });
                                  },
                                  onSelected: (value) {
                                    if (value == 0) {
                                      setState(() {
                                        textEditingController.text =
                                        snapshot.data
                                            .docs[index]
                                        ['comment'];
                                        commentId = snapshot
                                            .data.docs[index]
                                        ['commentId'];
                                        notEditing = false;
                                      });
                                    } else {
                                      Provider.of<DatabaseMethods>(
                                          context,
                                          listen: false)
                                          .deleteAnswerComment(
                                          context,
                                          widget.answerId,
                                          snapshot.data
                                              .docs[index]
                                          ['commentId']);
                                      Provider.of<DatabaseMethods>(
                                          context,
                                          listen: false)
                                          .answerCommentsCount(
                                          context,
                                          {
                                            "comments":
                                            FieldValue
                                                .increment(
                                                -1),
                                          },
                                          widget.answerId);
                                    }
                                  },
                                )
                                    : Container(
                                  width: 0,
                                  height: 0,
                                  child: null,
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        );
                      });
                }
                else {
                  return Center(
                    child: Container(
                      child: Text("Be the First One to Comment"),
                    ),
                  );
                }
              } else {
                return Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          )),
          Column(
            children: [
              Offstage(
                offstage: notEditing,
                child: Container(
                  height: 50,
                  color:  Color(0xFF99EDCC),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Text("Editing",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap:() {
                          setState(() {
                            notEditing = true;
                            textEditingController.clear();
                          });
                        },
                        child: Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          Provider.of<DatabaseMethods>(context, listen: false)
                                      .initPhotoUrl ==
                                  null
                              ? "https://firebasestorage.googleapis.com/v0/b/clima-app-723ef.appspot.com/o/johnny.jpg?alt=media&token=d5b9e202-9d66-4fc9-93db-a8dea8587654"
                              : Provider.of<DatabaseMethods>(context, listen: false)
                                  .getInitPhotoUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                                child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ));
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: textEditingController,
                        onSaved: (String value) {
                          comment = value;
                        },
                        validator: (input) {
                          return input.isEmpty ? "Leave a Comment" : null;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 7,
                        minLines: 1,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0xFF229062),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color(0xFF229062),
                              )),
                          hintText: "Leave a Comment",
                          hintStyle: TextStyle(
                            color: Color(0xFF229062),
                          ),
                        ),
                        maxLength: 300,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Provider.of<DatabaseMethods>(context, listen: false)
                            .addAnswerComments(
                          context,
                          {
                            "comment": comment,
                            "commentId": commentId,
                            "commenterUserId":
                                Provider.of<DatabaseMethods>(context, listen: false)
                                    .getInitUserId,
                            "hasEdited": false,
                            'doubtUserId': widget.doubtUserId,
                            "name":
                                Provider.of<DatabaseMethods>(context, listen: false)
                                    .getInitUserName,
                            "photoUrl": Provider.of<DatabaseMethods>(context,
                                            listen: false)
                                        .initPhotoUrl ==
                                    null
                                ? "https://firebasestorage.googleapis.com/v0/b/clima-app-723ef.appspot.com/o/johnny.jpg?alt=media&token=d5b9e202-9d66-4fc9-93db-a8dea8587654"
                                : Provider.of<DatabaseMethods>(context,
                                        listen: false)
                                    .getInitPhotoUrl,
                          },
                          widget.answerId,
                          commentId,
                        )
                            .whenComplete(() {
                              if(notEditing == true) {
                                Provider.of<DatabaseMethods>(context, listen: false)
                                    .answerCommentsCount(
                                    context,
                                    {
                                      "comments": FieldValue.increment(1),
                                    },
                                    widget.answerId);
                              } else {
                                Provider.of<DatabaseMethods>(context, listen: false)
                                    .editAnswerComment(context, {
                                      "hasEdited" : true,
                                }, widget.answerId, commentId);
                              }
                          setState(() {
                            if(notEditing == false) {
                              notEditing = true;
                            }
                            commentId = randomAlphaNumeric(10);
                            textEditingController.clear();
                          });
                        });
                      }
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      primary: Color(0xFF229062),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
