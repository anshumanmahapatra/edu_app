import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(appBar: AppBar(
      automaticallyImplyLeading: false,
      title: RichText(
        text: TextSpan(
            text: "Notifications",
            style: TextStyle(
                color: Color(0xFF071E22),
                fontSize: 20,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      backgroundColor:  Color(0xFF99EDCC),
      iconTheme: IconThemeData(color: Color(0xFF071E22)),
      centerTitle: true,
      elevation: 0.0,
      toolbarHeight: 50,
    ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Center(
          child: Text("Notifications"),
        ),
      ),);
  }
}
