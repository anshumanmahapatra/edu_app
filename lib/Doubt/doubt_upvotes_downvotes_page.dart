import 'package:flutter/material.dart';

class DoubtUpVotesDownVotesPage extends StatefulWidget {
  final String title;
  final Widget bodyContent;
  DoubtUpVotesDownVotesPage({@required this.title, @required this.bodyContent});
  @override
  _DoubtUpVotesDownVotesPageState createState() => _DoubtUpVotesDownVotesPageState();
}

class _DoubtUpVotesDownVotesPageState extends State<DoubtUpVotesDownVotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
              text: widget.title,
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
      body: widget.bodyContent,
    );
  }
}
