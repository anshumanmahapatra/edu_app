import 'package:adhyapak/Helpers/helping_widgets.dart';
import 'package:adhyapak/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnswerOptions extends ChangeNotifier {
  showAnswerOptions(
      BuildContext context, dynamic snapshot2, int index2, String doubtId) {
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

    var optionsAfterAcceptanceForDoubterAndAnswerer = [
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

    return SizedBox(
      width: 40,
      height: 40,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Doubt')
              .where('doubtId', isEqualTo: doubtId)
              .snapshots(),
          builder: (context, snapshot1) {
            if (snapshot1.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot1.data.docs.length,
                  itemBuilder: (context, index1) {
                    return Container(
                      child: snapshot2.data.docs[index2]['doubtUserId'] ==
                              Provider.of<DatabaseMethods>(context,
                                      listen: false)
                                  .getInitUserId
                          ? snapshot2.data.docs[index2]['answererUserId'] ==
                                  Provider.of<DatabaseMethods>(context,
                                          listen: false)
                                      .getInitUserId
                              ? PopupMenuButton(
                                  iconSize: 18.0,
                                  itemBuilder: (context) {
                                    if (snapshot2.data.docs[index2]
                                                ['hasAnswered'] ==
                                            false &&
                                        snapshot2.data.docs[index2]
                                                ['hasRejected'] ==
                                            false &&
                                        snapshot1.data.docs[index1]
                                                ['answered'] ==
                                            false) {
                                      return List.generate(
                                          optionsForDoubterAndAnswerer.length,
                                          (index) {
                                        return PopupMenuItem(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(optionsForDoubterAndAnswerer[
                                                  index]["text"]),
                                              SizedBox(width: 5),
                                              optionsForDoubterAndAnswerer[
                                                  index]['icon'],
                                            ],
                                          ),
                                          value: index,
                                        );
                                      });
                                    } else {
                                      return List.generate(
                                          optionsAfterAcceptanceForDoubterAndAnswerer
                                              .length, (index) {
                                        return PopupMenuItem(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  optionsAfterAcceptanceForDoubterAndAnswerer[
                                                      index]["text"]),
                                              SizedBox(width: 5),
                                              optionsAfterAcceptanceForDoubterAndAnswerer[
                                                  index]['icon'],
                                            ],
                                          ),
                                          value: index,
                                        );
                                      });
                                    }
                                  },
                                  onSelected: (value) {
                                    if (snapshot2.data.docs[index2]
                                                ['hasAnswered'] ==
                                            false &&
                                        snapshot2.data.docs[index2]
                                                ['hasRejected'] ==
                                            false &&
                                        snapshot1.data.docs[index1]
                                                ['answered'] ==
                                            false) {
                                      if (value == 0) {
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .updateProfile(
                                                context,
                                                snapshot2.data.docs[index2]
                                                    ['answererUserId'],
                                                {
                                              "points": FieldValue.increment(
                                                  snapshot1.data.docs[index1]
                                                      ['points'])
                                            });
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .changeAnsweredState(
                                                context,
                                                {
                                                  "answered": true,
                                                },
                                                doubtId);
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .editAnswer(
                                                context,
                                                {
                                                  'hasAnswered': true,
                                                },
                                                snapshot2.data.docs[index2]
                                                    ['answerId']);
                                      } else if (value == 1) {
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .changeAnsweredState(
                                                context,
                                                {
                                                  "points":
                                                      FieldValue.increment(25),
                                                },
                                                doubtId);
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .editAnswer(
                                                context,
                                                {
                                                  'hasRejected': true,
                                                },
                                                snapshot2.data.docs[index2]
                                                    ['answerId']);
                                      } else if (value == 2) {
                                        Provider.of<HelpingWidgets>(context, listen: false)
                                            .showAnswerEditSheet(context, snapshot2.data.docs[index2]['answerId'],
                                            snapshot2.data.docs[index2]['answer'],
                                            snapshot2.data.docs[index2]['answerUrl']);
                                      } else {
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .deleteAnswer(
                                          context,
                                          snapshot2.data.docs[index2]
                                              ['answerId'],
                                        );
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .answersCount(
                                                context,
                                                {
                                                  "answers":
                                                      FieldValue.increment(-1),
                                                },
                                                doubtId);
                                      }
                                    } else {
                                      if (value == 0) {
                                        Provider.of<HelpingWidgets>(context, listen: false)
                                            .showAnswerEditSheet(context, snapshot2.data.docs[index2]['answerId'],
                                            snapshot2.data.docs[index2]['answer'],
                                            snapshot2.data.docs[index2]['answerUrl']);
                                      } else {
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .deleteAnswer(
                                          context,
                                          snapshot2.data.docs[index2]
                                              ['answerId'],
                                        );
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .answersCount(
                                                context,
                                                {
                                                  "answers":
                                                      FieldValue.increment(-1),
                                                },
                                                doubtId);
                                      }
                                    }
                                  },
                                )
                              : PopupMenuButton(
                                  itemBuilder: (context) {
                                    if (snapshot2.data.docs[index2]
                                                ['hasAnswered'] ==
                                            false &&
                                        snapshot2.data.docs[index2]
                                                ['hasRejected'] ==
                                            false &&
                                        snapshot1.data.docs[index1]
                                                ['answered'] ==
                                            false) {
                                      return List.generate(
                                          optionsForDoubter.length, (index) {
                                        return PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Text(optionsForDoubter[index]
                                                  ["text"]),
                                              SizedBox(width: 5),
                                              optionsForDoubter[index]['icon'],
                                            ],
                                          ),
                                          value: index,
                                        );
                                      });
                                    } else {
                                      return List.generate(
                                          optionsAfterAcceptance.length,
                                          (index) {
                                        return PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Text(optionsAfterAcceptance[index]
                                                  ["text"]),
                                              SizedBox(width: 5),
                                              optionsAfterAcceptance[index]
                                                  ['icon'],
                                            ],
                                          ),
                                          value: index,
                                        );
                                      });
                                    }
                                  },
                                  onSelected: (value) {
                                    if (snapshot2.data.docs[index2]
                                                ['hasAnswered'] ==
                                            false &&
                                        snapshot2.data.docs[index2]
                                                ['hasRejected'] ==
                                            false &&
                                        snapshot1.data.docs[index1]
                                                ['answered'] ==
                                            false) {
                                      if (value == 0) {
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .updateProfile(
                                                context,
                                                snapshot2.data.docs[index2]
                                                    ['answererUserId'],
                                                {
                                              "points": FieldValue.increment(
                                                  snapshot1.data.docs[index1]
                                                      ['points'])
                                            });
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .changeAnsweredState(
                                                context,
                                                {
                                                  "answered": true,
                                                },
                                                doubtId);
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .editAnswer(
                                                context,
                                                {
                                                  'hasAnswered': true,
                                                },
                                                snapshot2.data.docs[index2]
                                                    ['answerId']);
                                      } else if (value == 1) {
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .changeAnsweredState(
                                                context,
                                                {
                                                  "points":
                                                      FieldValue.increment(25),
                                                },
                                                doubtId);
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .editAnswer(
                                                context,
                                                {
                                                  'hasRejected': true,
                                                },
                                                snapshot2.data.docs[index2]
                                                    ['answerId']);
                                      } else {
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .deleteAnswer(
                                          context,
                                          snapshot2.data.docs[index2]
                                              ['answerId'],
                                        );
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .answersCount(
                                                context,
                                                {
                                                  "answers":
                                                      FieldValue.increment(-1),
                                                },
                                                doubtId);
                                      }
                                    } else {
                                      if (value == 0) {
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .deleteAnswer(
                                          context,
                                          snapshot2.data.docs[index2]
                                              ['answerId'],
                                        );
                                        Provider.of<DatabaseMethods>(context,
                                                listen: false)
                                            .answersCount(
                                                context,
                                                {
                                                  "answers":
                                                      FieldValue.increment(-1),
                                                },
                                                doubtId);
                                      }
                                    }
                                  },
                                )
                          : (snapshot2.data.docs[index2]['answererUserId'] ==
                                  Provider.of<DatabaseMethods>(context,
                                          listen: false)
                                      .getInitUserId)
                              ? PopupMenuButton(
                                  iconSize: 18.0,
                                  itemBuilder: (context) {
                                    return List.generate(
                                        optionsForAnswerer.length, (index) {
                                      return PopupMenuItem(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(optionsForAnswerer[index]
                                                ["text"]),
                                            SizedBox(width: 5),
                                            optionsForAnswerer[index]['icon'],
                                          ],
                                        ),
                                        value: index,
                                      );
                                    });
                                  },
                                  onSelected: (value) {
                                    if (value == 0) {
                                      Provider.of<HelpingWidgets>(context, listen: false)
                                          .showAnswerEditSheet(context, snapshot2.data.docs[index2]['answerId'],
                                          snapshot2.data.docs[index2]['answer'],
                                          snapshot2.data.docs[index2]['answerUrl']);
                                    } else {
                                      Provider.of<DatabaseMethods>(context,
                                              listen: false)
                                          .deleteAnswer(
                                        context,
                                        snapshot2.data.docs[index2]['answerId'],
                                      );
                                      Provider.of<DatabaseMethods>(context,
                                              listen: false)
                                          .answersCount(
                                              context,
                                              {
                                                "answers":
                                                    FieldValue.increment(-1),
                                              },
                                              doubtId);
                                    }
                                  },
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                  child: null,
                                ),
                    );
                  });
            } else {
              return Container(
                width: 0,
                height: 0,
                child: null,
              );
            }
          }),
    );
  }
}
