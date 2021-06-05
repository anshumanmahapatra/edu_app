import 'package:adhyapak/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
              text: "Profile",
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
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .where('userid',
                  isEqualTo:
                      Provider.of<DatabaseMethods>(context, listen: false)
                          .initUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: Image.network(
                                  snapshot.data.docs[index]['photoUrl'] == null
                                      ? "https://firebasestorage.googleapis.com/v0/b/clima-app-723ef.appspot.com/o/johnny.jpg?alt=media&token=d5b9e202-9d66-4fc9-93db-a8dea8587654"
                                      : snapshot.data.docs[index]['photoUrl'],
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
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ));
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: size.width,
                            child: TextFormField(
                              initialValue: snapshot.data.docs[index]['name'],
                              readOnly: true,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color(0xFF229062),
                                  )),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color(0xFF229062),
                                  )),
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF229062),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Color(0xFF229062),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: snapshot.data.docs[index]["email"],
                            readOnly: true,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color(0xFF229062),
                                )),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color(0xFF229062),
                                )),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Color(0xFF229062),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color(0xFF229062),
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue:
                                snapshot.data.docs[index]["points"].toString(),
                            readOnly: true,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color(0xFF229062),
                                )),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color(0xFF229062),
                                )),
                                labelText: 'Points',
                                labelStyle: TextStyle(
                                  color: Color(0xFF229062),
                                ),
                                prefixIcon: Icon(
                                  Icons.score,
                                  color: Color(0xFF229062),
                                )),
                          )
                        ],
                      );
                    });
              } else {
                return Container(
                    width: size.width,
                    height: size.height,
                    child: Center(child: Text('User does not exists')));
              }
            } else {
              return Container(
                  height: size.height,
                  width: size.width,
                  child: Center(child: CircularProgressIndicator()));
            }
          },
        ),
      ),
    );
  }
}
