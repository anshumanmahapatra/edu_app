import 'package:adhyapak/Constants/constant.dart';
import 'package:adhyapak/Services/auth.dart';
import 'package:adhyapak/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  var settingsList = list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFF99EDCC),
            iconTheme: IconThemeData(color: Color(0xFF071E22)),
            centerTitle: true,
            elevation: 0.0,
            toolbarHeight: 200,
            flexibleSpace: StreamBuilder(
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
                          String points;
                          if(snapshot.data.docs[index]['points'] == 0 ||
                              snapshot.data.docs[index]['points'] == 1) {
                            points = "point";
                          } else {
                            points = "points";
                          }
                          return Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xFF99EDCC),
                            child: Stack(
                              children: [
                                Align(
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  alignment: Alignment.topLeft,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Color(0xFF99EDCC),
                                      child: Container(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Image.network(
                                            snapshot.data.docs[index]['photoUrl'] ==
                                                    null
                                                ? "https://firebasestorage.googleapis.com/v0/b/clima-app-723ef.appspot.com/o/johnny.jpg?alt=media&token=d5b9e202-9d66-4fc9-93db-a8dea8587654"
                                                : snapshot.data.docs[index]
                                                    ['photoUrl'],
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
                                              ));
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(snapshot.data.docs[index]['name'] + " "),
                                        Container(
                                          width: 5,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(" " + snapshot.data.docs[index]['points']
                                            .toString() + " " + points),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
                    return CircularProgressIndicator();
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                leading: settingsList[index]['icon'],
                title: Text(
                    settingsList[index]['title'],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => settingsList[index]['class']));
                },
              );
            },
              childCount: settingsList.length,
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              title: Text('Sign Out', style: TextStyle(color: Colors.blue),),
              onTap: () {
                Provider.of<Authentication>(context, listen: false).signOut();
                Provider.of<DatabaseMethods>(context, listen: false)
                    .initDoubtPost = null;
              },
            ),
          )
        ],
      ),
    );
  }
}


