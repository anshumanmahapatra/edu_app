import 'package:adhyapak/Answer/answer_home.dart';
import 'package:adhyapak/Doubt/add_comment.dart';
import 'package:adhyapak/Doubt/doubt_upvotes_downvotes_page.dart';
import 'package:adhyapak/Helpers/doubt_interact.dart';
import 'package:adhyapak/Helpers/helping_widgets.dart';
import 'package:adhyapak/Helpers/upvote_downvote.dart';
import 'package:adhyapak/Services/database.dart';
import 'package:adhyapak/Settings/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoubtHome extends StatefulWidget {
  const DoubtHome({Key key}) : super(key: key);

  @override
  _DoubtHomeState createState() => _DoubtHomeState();
}

class _DoubtHomeState extends State<DoubtHome> {
  var options = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
            child: Icon(Icons.settings),
          ),
          SizedBox(
            width: 20,
          ),
        ],
        title: RichText(
          text: TextSpan(
              text: "Doubts",
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
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Doubt").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length != 0) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      bool showCircle1;
                      bool showCircle2;

                      if (snapshot.data.docs[index]['upVotes'] == 0 ||
                          snapshot.data.docs[index]['downVotes'] == 0) {
                        showCircle1 = true;
                      } else {
                        showCircle1 = false;
                      }

                      if (snapshot.data.docs[index]['answers'] == 0 ||
                          snapshot.data.docs[index]['comments'] == 0) {
                        showCircle2 = true;
                      } else {
                        showCircle2 = false;
                      }

                      return Container(
                        color: Colors.white,
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                                          snapshot.data.docs[index]
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
                                        Text(snapshot.data.docs[index]['name'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            )),
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                       Text(
                                          snapshot.data.docs[index]['points']
                                                  .toString() +
                                              "points",
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        snapshot.data.docs[index]['answered'] ==
                                                true
                                            ? "Answer Accepted"
                                            : "Answer Not Accepted",
                                        style: TextStyle(
                                          color: snapshot.data.docs[index]
                                                      ['answered'] ==
                                                  true
                                              ? Colors.green
                                              : Colors.orange,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                  snapshot.data.docs[index]['userId'] ==
                                          Provider.of<DatabaseMethods>(context,
                                                  listen: false)
                                              .getInitUserId
                                      ? PopupMenuButton(
                                          itemBuilder: (context) {
                                            return List.generate(options.length,
                                                (index) {
                                              return PopupMenuItem(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        options[index]["text"]),
                                                    SizedBox(width: 5),
                                                    options[index]['icon'],
                                                  ],
                                                ),
                                                value: index,
                                              );
                                            });
                                          },
                                          onSelected: (value) {
                                            if (value == 0) {
                                              Provider.of<HelpingWidgets>(
                                                      context,
                                                      listen: false)
                                                  .showDoubtEditSheet(
                                                      context,
                                                      snapshot.data.docs[index]
                                                          ['doubtId'],
                                                      snapshot.data.docs[index]
                                                          ['title'],
                                                      snapshot.data.docs[index]
                                                          ['description'],
                                                      snapshot.data.docs[index]
                                                          ['doubtUrl'],
                                                      snapshot.data.docs[index]
                                                          ['subject']);
                                            } else {
                                              Provider.of<DatabaseMethods>(
                                                      context,
                                                      listen: false)
                                                  .deleteDoubt(
                                                context,
                                                snapshot.data.docs[index]
                                                    ['doubtId'],
                                              );
                                            }
                                          },
                                        )
                                      : Container(
                                          width: 0,
                                          height: 0,
                                          child: null,
                                        ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "Question",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 25),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.blue,
                                      )),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Icon(
                                        Icons.menu_book_outlined,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        snapshot.data.docs[index]['subject'],
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(5),
                              child: ExpandableText(
                                snapshot.data.docs[index]['title'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                expandText: 'show more',
                                collapseText: 'show less',
                                linkColor: Colors.blue,
                                linkStyle: TextStyle(
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: snapshot.data.docs[index]['doubtUrl'] ==
                                      null
                                  ? Container(
                                      width: 0,
                                      height: 0,
                                      child: null,
                                    )
                                  : Image.network(
                                      snapshot.data.docs[index]['doubtUrl'],
                                      width: MediaQuery.of(context).size.width,
                                      height: 250,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
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
                                "Description",
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
                                child: ExpandableText(
                                  snapshot.data.docs[index]['description'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  expandText: 'show more',
                                  collapseText: 'show less',
                                  linkColor: Colors.blue,
                                  linkStyle: TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            DoubtInteract(
                              doubtId: snapshot.data.docs[index]['doubtId'],
                              senderUserId: snapshot.data.docs[index]['userId'],
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              children: <Widget>[
                                Offstage(
                                  offstage:
                                      snapshot.data.docs[index]['upVotes'] == 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DoubtUpVotesDownVotesPage(
                                                      title: "Up Votes",
                                                      bodyContent: Provider.of<
                                                                  UpVotesDownVotes>(
                                                              context,
                                                              listen: false)
                                                          .upVotesDownVotes(
                                                        context,
                                                        "Doubt",
                                                        snapshot.data
                                                                .docs[index]
                                                            ['doubtId'],
                                                        "UpVotes",
                                                      ))));
                                    },
                                    child: Text(
                                      snapshot.data.docs[index]['upVotes'] == 1
                                          ? snapshot.data.docs[index]['upVotes']
                                                  .toString() +
                                              " " +
                                              "Up Vote"
                                          : snapshot.data.docs[index]['upVotes']
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
                                  offstage: snapshot.data.docs[index]
                                          ['downVotes'] ==
                                      0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DoubtUpVotesDownVotesPage(
                                                      title: "Down Votes",
                                                      bodyContent: Provider.of<
                                                                  UpVotesDownVotes>(
                                                              context,
                                                              listen: false)
                                                          .upVotesDownVotes(
                                                              context,
                                                              "Doubt",
                                                              snapshot.data
                                                                          .docs[
                                                                      index]
                                                                  ['doubtId'],
                                                              "DownVotes"))));
                                    },
                                    child: Text(
                                      snapshot.data.docs[index]['downVotes'] ==
                                              1
                                          ? snapshot
                                                  .data.docs[index]['downVotes']
                                                  .toString() +
                                              " " +
                                              "Down Vote"
                                          : snapshot
                                                  .data.docs[index]['downVotes']
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
                                  offstage: snapshot.data.docs[index]
                                          ['comments'] ==
                                      0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddComment(
                                                    senderUserId: snapshot.data
                                                        .docs[index]['userId'],
                                                    doubtId: snapshot.data
                                                        .docs[index]['doubtId'],
                                                  )));
                                    },
                                    child: Text(
                                      snapshot.data.docs[index]['comments'] == 1
                                          ? snapshot
                                                  .data.docs[index]['comments']
                                                  .toString() +
                                              " " +
                                              "Comment"
                                          : snapshot
                                                  .data.docs[index]['comments']
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
                                Offstage(
                                  offstage: showCircle2,
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
                                  offstage:
                                      snapshot.data.docs[index]['answers'] == 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AnswerHome(
                                                    doubtId: snapshot.data
                                                        .docs[index]['doubtId'],
                                                  )));
                                    },
                                    child: Text(
                                      snapshot.data.docs[index]['answers'] == 1
                                          ? snapshot.data.docs[index]['answers']
                                                  .toString() +
                                              " " +
                                              "Answer"
                                          : snapshot.data.docs[index]['answers']
                                                  .toString() +
                                              " " +
                                              "Answers",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ), //answers
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
                      "Be the First One To Post a Doubt",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
