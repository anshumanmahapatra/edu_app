import 'package:adhyapak/Constants/constant.dart';
import 'package:adhyapak/Services/database.dart';
import 'package:adhyapak/Services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_photo_popup_card.dart';
import 'hero_page_route.dart';

class HelpingWidgets with ChangeNotifier {
  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  showDoubtEditSheet(BuildContext context, String doubtId, String title,
      String description, String doubtUrl, String subject) {
    var size = MediaQuery.of(context).size;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    var subjectData = subjects;

    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        builder: (context) {
          return Container(
              width: size.width,
              height: size.height * 0.8,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Provider.of<Utils>(context, listen: false).deleteAnswerPost(doubtId);
                          },
                          child: Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.red,),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Provider.of<DatabaseMethods>(context, listen: false)
                                  .editDoubt(
                                      context,
                                      {
                                        'doubtUrl': doubtUrl,
                                        "title": title,
                                        "description": description,
                                        "subject": subject,
                                      },
                                      doubtId).whenComplete(() {
                                Navigator.pop(context);
                                Provider.of<Utils>(context, listen: false).deleteAnswerPost(doubtId);
                              });
                            }
                          },
                          child: Icon(
                            Icons.check_sharp,
                            size: 30,
                            color: Colors.green,),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: <Widget>[
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("AnswerPost")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.docs.length != 0) {
                                  return ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        doubtUrl = snapshot.data.docs[index]
                                            ['answerPost'];
                                        return Container(
                                          height: 250,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.network(
                                              doubtUrl,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  25,
                                              height: 250,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent
                                                          loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                        );
                                      });
                                } else {
                                  return Container(
                                    height: doubtUrl == null ? 0 : 250,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: doubtUrl == null
                                          ? Container(
                                              width: 0,
                                              height: 0,
                                              child: null,
                                            )
                                          : Image.network(
                                              doubtUrl,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  25,
                                              height: 250,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent
                                                          loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                  );
                                }
                              } else {
                                return Container(
                                  width: 0,
                                  height: 0,
                                  child: null,
                                );
                              }
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
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
                                initialValue: title,
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
                                initialValue: description,
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
                                value: subject,
                                onChanged: (newValue) {
                                  subject = newValue;
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                            Navigator.of(context).push(
                                                HeroDialogRoute(
                                                    builder: (context) =>
                                                        AddPhotoPopUp(
                                                          navigationPath:
                                                              "answer",
                                                          id: doubtId,
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
                ],
              ),
            );
        });
  }

  showAnswerEditSheet(BuildContext context, String answerId,
      String answer, String answerUrl) {
    var size = MediaQuery.of(context).size;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            width: size.width,
            height: size.height * 0.7,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Provider.of<Utils>(context, listen: false).deleteAnswerPost(answerId);
                        },
                        child: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.red,),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Provider.of<DatabaseMethods>(context, listen: false)
                                .editAnswer(
                                context,
                                {
                                  'answerUrl': answerUrl,
                                  "answer": answer,
                                },
                                answerId).whenComplete(() {
                              Navigator.pop(context);
                              Provider.of<Utils>(context, listen: false).deleteAnswerPost(answerId);
                            });
                          }
                        },
                        child: Icon(
                          Icons.check_sharp,
                          size: 30,
                          color: Colors.green,),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: <Widget>[
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("AnswerPost")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.docs.length != 0) {
                                return ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      answerUrl = snapshot.data.docs[index]
                                      ['answerPost'];
                                      return Container(
                                        height: 250,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          child: Image.network(
                                            answerUrl,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width -
                                                25,
                                            height: 250,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (BuildContext context,
                                                Widget child,
                                                ImageChunkEvent
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                CircularProgressIndicator(
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
                                      );
                                    });
                              } else {
                                return Container(
                                  height: answerUrl == null ? 0 : 250,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: answerUrl == null
                                        ? Container(
                                      width: 0,
                                      height: 0,
                                      child: null,
                                    )
                                        : Image.network(
                                      answerUrl,
                                      width: MediaQuery.of(context)
                                          .size
                                          .width -
                                          25,
                                      height: 250,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent
                                          loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child:
                                          CircularProgressIndicator(
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
                                );
                              }
                            } else {
                              return Container(
                                width: 0,
                                height: 0,
                                child: null,
                              );
                            }
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
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
                              initialValue: answer,
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
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
                                          Navigator.of(context).push(
                                              HeroDialogRoute(
                                                  builder: (context) =>
                                                      AddPhotoPopUp(
                                                        navigationPath:
                                                        "answer",
                                                        id: answerId,
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
              ],
            ),
          );
        });
  }


  showErrorMessage(BuildContext context, String errorMessage) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("ERROR"),
          content: Text(errorMessage),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"))
          ],
        );
      },
    );
  }
}
