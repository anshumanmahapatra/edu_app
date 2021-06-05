import 'package:adhyapak/Answer/add_comment_to_answer.dart';
import 'package:adhyapak/Helpers/answer_interact.dart';
import 'package:adhyapak/Helpers/answer_options.dart';
import 'package:adhyapak/Helpers/upvote_downvote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'answer_upvotes_downvotes_page.dart';

class AnswerHome extends StatefulWidget {
  const AnswerHome({Key key, this.doubtId}) : super(key: key);
  final String doubtId;

  @override
  _AnswerHomeState createState() => _AnswerHomeState();
}

class _AnswerHomeState extends State<AnswerHome> {
  var optionsForAnswerer = [
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

  var optionsForDoubter = [
    {
      "text": "Accept",
      "icon": Icon(
        Icons.check_sharp,
        color: Colors.green,
      ),
    },
    {
      "text": "Reject",
      "icon": Icon(
        Icons.close,
        color: Colors.purple,
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

  var optionsForDoubterAndAnswerer = [
    {
      "text": "Accept",
      "icon": Icon(
        Icons.check_sharp,
        color: Colors.green,
      ),
    },
    {
      "text": "Reject",
      "icon": Icon(
        Icons.close,
        color: Colors.purple,
      ),
    },
    {
      "text": "Edit",
      "icon": Icon(
        Icons.edit,
        color: Colors.orange,
      )
    },
    {
      "text": "Delete",
      "icon": Icon(
        Icons.delete,
        color: Colors.red,
      ),
    },
  ];

  var optionsAfterAcceptance = [
    {
      "text": "Delete",
      "icon": Icon(
        Icons.delete,
        color: Colors.red,
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
              text: "Answers",
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Answers")
            .where("doubtId", isEqualTo: widget.doubtId)
            .snapshots(),
        builder: (context, snapshot2) {
          if (snapshot2.hasData) {
            if (snapshot2.data.docs.length != 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot2.data.docs.length,
                  itemBuilder: (context, index2) {
                    bool showCircle1;
                    if (snapshot2.data.docs[index2]['upVotes'] == 0 ||
                        snapshot2.data.docs[index2]['downVotes'] == 0) {
                      showCircle1 = true;
                    } else {
                      showCircle1 = false;
                    }

                    return Container(
                      decoration: BoxDecoration(
                        border:
                            snapshot2.data.docs[index2]['hasAnswered'] == true
                                ? Border.all(color: Colors.green, width: 2)
                                : snapshot2.data.docs[index2]['hasRejected']
                                    ? Border.all(color: Colors.red, width: 2)
                                    : Border.all(color: Colors.white),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Column(
                        children: <Widget>[
                          Divider(
                            color: Colors.grey,
                          ),
                          Container(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 5,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 20,
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: Image.network(
                                        snapshot2.data.docs[index2]
                                            ['profileUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  child:
                                      Text(snapshot2.data.docs[index2]['name'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          )),
                                ),
                                Spacer(),
                                Offstage(
                                  offstage: snapshot2.data.docs[index2]['hasAnswered'] == false &&
                                      snapshot2.data.docs[index2]['hasRejected'] == false,
                                  child:  snapshot2.data.docs[index2]['hasAnswered'] == true
                                      ? Container(
                                    child:
                                    Text(
                                        "Accepted",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 14,
                                        )),
                                  )
                                      : snapshot2.data.docs[index2]['hasRejected']
                                      ? Container(
                                    child:
                                    Text(
                                      "Rejected",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        )),
                                  )
                                      : Container(
                                    height: 0,
                                    width: 0,
                                    child: null,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Provider.of<AnswerOptions>(context,
                                        listen: false)
                                    .showAnswerOptions(context, snapshot2,
                                        index2, widget.doubtId),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: snapshot2.data.docs[index2]['answerUrl'] ==
                                    null
                                ? Container(
                                    width: 0,
                                    height: 0,
                                    child: null,
                                  )
                                : Image.network(
                                    snapshot2.data.docs[index2]['answerUrl'],
                                    width: MediaQuery.of(context).size.width,
                                    height: 300,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Answer",
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(5),
                              child: Text(
                                snapshot2.data.docs[index2]['answer'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          AnswerInteract(
                            answerId: snapshot2.data.docs[index2]['answerId'],
                            doubtUserId: snapshot2.data.docs[index2]
                                ['doubtUserId'],
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          Row(
                            children: <Widget>[
                              Offstage(
                                offstage:
                                    snapshot2.data.docs[index2]['upVotes'] == 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AnswerUpVotesDownVotesPage(
                                                    title: "Up Votes",
                                                    bodyContent: Provider.of<
                                                                UpVotesDownVotes>(
                                                            context,
                                                            listen: false)
                                                        .upVotesDownVotes(
                                                      context,
                                                      "Answers",
                                                      snapshot2
                                                              .data.docs[index2]
                                                          ['answerId'],
                                                      "UpVotes",
                                                    ))));
                                  },
                                  child: Text(
                                    snapshot2.data.docs[index2]['upVotes'] == 1
                                        ? snapshot2.data.docs[index2]['upVotes']
                                                .toString() +
                                            " " +
                                            "Up Vote"
                                        : snapshot2.data.docs[index2]['upVotes']
                                                .toString() +
                                            " " +
                                            "Up Votes",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ), //upVotes
                              SizedBox(
                                width: 5,
                              ),
                              Offstage(
                                offstage: showCircle1,
                                child: Container(
                                  height: 5,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                  ),
                                ),
                              ), //dot
                              SizedBox(
                                width: 5,
                              ),
                              Offstage(
                                offstage: snapshot2.data.docs[index2]
                                        ['downVotes'] ==
                                    0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AnswerUpVotesDownVotesPage(
                                                    title: "Down Votes",
                                                    bodyContent: Provider.of<
                                                                UpVotesDownVotes>(
                                                            context,
                                                            listen: false)
                                                        .upVotesDownVotes(
                                                            context,
                                                            "Answers",
                                                            snapshot2.data.docs[
                                                                    index2]
                                                                ['answerId'],
                                                            "DownVotes"))));
                                  },
                                  child: Text(
                                    snapshot2.data.docs[index2]['downVotes'] ==
                                            1
                                        ? snapshot2
                                                .data.docs[index2]['downVotes']
                                                .toString() +
                                            " " +
                                            "Down Vote"
                                        : snapshot2
                                                .data.docs[index2]['downVotes']
                                                .toString() +
                                            " " +
                                            "Down Votes",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ), //downVotes
                              Spacer(),
                              Offstage(
                                offstage: snapshot2.data.docs[index2]
                                        ['comments'] ==
                                    0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddCommentToAnswer(
                                                  answerId: snapshot2.data
                                                      .docs[index2]['answerId'],
                                                  doubtUserId: snapshot2
                                                          .data.docs[index2]
                                                      ['doubtUserId'],
                                                )));
                                  },
                                  child: Text(
                                    snapshot2.data.docs[index2]['comments'] == 1
                                        ? snapshot2
                                                .data.docs[index2]['comments']
                                                .toString() +
                                            " " +
                                            "Comment"
                                        : snapshot2
                                                .data.docs[index2]['comments']
                                                .toString() +
                                            " " +
                                            "Comments",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ), //comments
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return Center(
                child: Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Be the First One To Answer",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black54,
                    ),
                  ),
                ),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
