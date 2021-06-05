import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpVotesDownVotes with ChangeNotifier {

  Widget upVotesDownVotes (BuildContext context, String collectionId, String docId, String interactionId) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
        .collection(collectionId)
        .doc(docId)
        .collection(interactionId)
        .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data.docs.length != 0) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 24,
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.network(snapshot.data.docs[index]['photoUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.25 - 50,
                          child: Text(snapshot.data.docs[index]['name'],
                              style: TextStyle(
                                color: Color(0xFF229062),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        )
                      ],
                    ),
                  );
                });
          } else {
            return Center(
              child: Container(
                child: Text("Be the First One to Engage with the Post"),
              ),
            );
          }
        });
  }
}