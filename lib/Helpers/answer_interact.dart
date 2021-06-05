import 'package:adhyapak/Answer/add_comment_to_answer.dart';
import 'package:adhyapak/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnswerInteract extends StatefulWidget {
  final answerId, doubtUserId;

  AnswerInteract({@required this.answerId, @required this.doubtUserId});

  @override
  _AnswerInteractState createState() => _AnswerInteractState();
}

class _AnswerInteractState extends State<AnswerInteract> {
  bool isUpVoted;

  @override
  void initState() {
    isUpVoted = null;
    super.initState();
  }

  upVoted() {
    if (isUpVoted == null) {
      Provider.of<DatabaseMethods>(context, listen: false)
          .addAnswerUpVotes(
              context,
              {
                "userid": Provider.of<DatabaseMethods>(context, listen: false)
                    .getInitUserId,
                "name": Provider.of<DatabaseMethods>(context, listen: false)
                    .getInitUserName,
                "photoUrl": Provider.of<DatabaseMethods>(context, listen: false)
                            .initPhotoUrl ==
                        null
                    ? "https://firebasestorage.googleapis.com/v0/b/clima-app-723ef.appspot.com/o/johnny.jpg?alt=media&token=d5b9e202-9d66-4fc9-93db-a8dea8587654"
                    : Provider.of<DatabaseMethods>(context, listen: false)
                        .getInitPhotoUrl,
              },
              widget.answerId,
              Provider.of<DatabaseMethods>(context, listen: false)
                  .getInitUserName)
          .whenComplete(() {
        setState(() {
          isUpVoted = true;
        });
      });
      Provider.of<DatabaseMethods>(context, listen: false).answerUpVotesCount(
          context,
          {
            "upVotes": FieldValue.increment(1),
          },
          widget.answerId);
    } else if (isUpVoted == true) {
      Provider.of<DatabaseMethods>(context, listen: false)
          .deleteAnswerUpVotes(
              context,
              widget.answerId,
              Provider.of<DatabaseMethods>(context, listen: false)
                  .getInitUserName)
          .whenComplete(() {
        setState(() {
          isUpVoted = null;
        });
      });
      Provider.of<DatabaseMethods>(context, listen: false).answerUpVotesCount(
          context,
          {
            "upVotes": FieldValue.increment(-1),
          },
          widget.answerId);
    } else {}
  }

  downVoted() {
    if (isUpVoted == null) {
      Provider.of<DatabaseMethods>(context, listen: false)
          .addAnswerDownVotes(
              context,
              {
                "userid": Provider.of<DatabaseMethods>(context, listen: false)
                    .getInitUserId,
                "name": Provider.of<DatabaseMethods>(context, listen: false)
                    .getInitUserName,
                "photoUrl": Provider.of<DatabaseMethods>(context, listen: false)
                            .initPhotoUrl ==
                        null
                    ? "https://firebasestorage.googleapis.com/v0/b/clima-app-723ef.appspot.com/o/johnny.jpg?alt=media&token=d5b9e202-9d66-4fc9-93db-a8dea8587654"
                    : Provider.of<DatabaseMethods>(context, listen: false)
                        .getInitPhotoUrl,
              },
              widget.answerId,
              Provider.of<DatabaseMethods>(context, listen: false)
                  .getInitUserName)
          .whenComplete(() {
        setState(() {
          isUpVoted = false;
        });
      });
      Provider.of<DatabaseMethods>(context, listen: false).answerDownVotesCount(
          context,
          {
            "downVotes": FieldValue.increment(1),
          },
          widget.answerId);
    } else if (isUpVoted == false) {
      Provider.of<DatabaseMethods>(context, listen: false)
          .deleteAnswerDownVotes(
              context,
              widget.answerId,
              Provider.of<DatabaseMethods>(context, listen: false)
                  .getInitUserName)
          .whenComplete(() {
        setState(() {
          isUpVoted = null;
        });
      });
      Provider.of<DatabaseMethods>(context, listen: false).answerDownVotesCount(
          context,
          {
            "downVotes": FieldValue.increment(-1),
          },
          widget.answerId);
    } else {}
  }

  Widget interactions(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: isUpVoted == null
                ? () => upVoted()
                : isUpVoted == true
                    ? () => upVoted()
                    : () {},
            child: Icon(
              Icons.arrow_upward_sharp,
              color: isUpVoted == null
                  ? Colors.grey
                  : isUpVoted == true
                      ? Colors.green
                      : Colors.grey,
              size: 25,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
              onTap: isUpVoted == null
                  ? () => downVoted()
                  : isUpVoted == false
                      ? () => downVoted()
                      : () {},
              child: Icon(
                Icons.arrow_downward_sharp,
                color: isUpVoted == null
                    ? Colors.grey
                    : isUpVoted == false
                        ? Colors.red
                        : Colors.grey,
                size: 25,
              )),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCommentToAnswer(
                              answerId: widget.answerId,
                              doubtUserId: widget.doubtUserId,
                            )));
              },
              child: Icon(
                Icons.comment_sharp,
                color: Colors.grey,
                size: 25,
              )),
        ],
      ),
    );
  }

  Widget forCheckingDownVotes(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Answers")
            .doc(widget.answerId)
            .collection("DownVotes")
            .where(
              "userid",
              isEqualTo: Provider.of<DatabaseMethods>(context, listen: false)
                  .getInitUserId,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.docs.length != 0) {
            isUpVoted = false;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return interactions(context);
                });
          } else {
            isUpVoted = null;
            return interactions(context);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Answers")
              .doc(widget.answerId)
              .collection("UpVotes")
              .where(
                "userid",
                isEqualTo: Provider.of<DatabaseMethods>(context, listen: false)
                    .getInitUserId,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.docs.length != 0) {
              isUpVoted = true;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return interactions(context);
                  });
            } else {
              return forCheckingDownVotes(context);
            }
          }),
    );
  }
}
