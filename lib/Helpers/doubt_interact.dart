import 'package:adhyapak/Answer/add_answer.dart';
import 'package:adhyapak/Doubt/add_comment.dart';
import 'package:adhyapak/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoubtInteract extends StatefulWidget{
  final doubtId, senderUserId;

  DoubtInteract(
      {@required this.doubtId,
      @required this.senderUserId});

  @override
  _DoubtInteractState createState() => _DoubtInteractState();
}

class _DoubtInteractState extends State<DoubtInteract> {
  bool isUpVoted;

  @override
  void initState() {
    isUpVoted = null;
    super.initState();
  }

  upVoted() {
    if (isUpVoted == null) {
      Provider.of<DatabaseMethods>(context, listen: false)
          .addUpVotes(
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
              widget.doubtId,
              Provider.of<DatabaseMethods>(context, listen: false)
                  .getInitUserName)
          .whenComplete(() {
        setState(() {
          isUpVoted = true;
        });
      });
      Provider.of<DatabaseMethods>(context, listen: false).upVotesCount(
          context,
          {
            "upVotes": FieldValue.increment(1),
          },
          widget.doubtId);
    } else if (isUpVoted == true) {
      Provider.of<DatabaseMethods>(context, listen: false)
          .deleteUpVotes(
              context,
              widget.doubtId,
              Provider.of<DatabaseMethods>(context, listen: false)
                  .getInitUserName)
          .whenComplete(() {
        setState(() {
          isUpVoted = null;
        });
      });
      Provider.of<DatabaseMethods>(context, listen: false).upVotesCount(
          context,
          {
            "upVotes": FieldValue.increment(-1),
          },
          widget.doubtId);
    } else {}
  }

  downVoted() {
    if (isUpVoted == null) {
      Provider.of<DatabaseMethods>(context, listen: false)
          .addDownVotes(
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
              widget.doubtId,
              Provider.of<DatabaseMethods>(context, listen: false)
                  .getInitUserName)
          .whenComplete(() {
        setState(() {
          isUpVoted = false;
        });
      });
      Provider.of<DatabaseMethods>(context, listen: false).downVotesCount(
          context,
          {
            "downVotes": FieldValue.increment(1),
          },
          widget.doubtId);
    } else if (isUpVoted == false) {
      Provider.of<DatabaseMethods>(context, listen: false)
          .deleteDownVotes(
              context,
              widget.doubtId,
              Provider.of<DatabaseMethods>(context, listen: false)
                  .getInitUserName)
          .whenComplete(() {
        setState(() {
          isUpVoted = null;
        });
      });
      Provider.of<DatabaseMethods>(context, listen: false).downVotesCount(
          context,
          {
            "downVotes": FieldValue.increment(-1),
          },
          widget.doubtId);
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
                        builder: (context) => AddComment(
                              doubtId: widget.doubtId,
                              senderUserId: widget.senderUserId,
                            )));
              },
              child: Icon(
                Icons.comment_sharp,
                color: Colors.grey,
                size: 25,
              )),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddAnswer(
                            doubtUserId: widget.senderUserId,
                            doubtId: widget.doubtId,
                          )));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                'Answer',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget forCheckingDownVotes(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Doubt")
            .doc(widget.doubtId)
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
              .collection("Doubt")
              .doc(widget.doubtId)
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
