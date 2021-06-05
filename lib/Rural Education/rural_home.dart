import 'package:flutter/material.dart';

class RuralHome extends StatefulWidget {
  const RuralHome({Key key}) : super(key: key);

  @override
  _RuralHomeState createState() => _RuralHomeState();
}

class _RuralHomeState extends State<RuralHome> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: RichText(
          text: TextSpan(
              text: "Rural Education",
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
          child: Text("Rural Education"),
        ),
      ),
    );
  }
}
