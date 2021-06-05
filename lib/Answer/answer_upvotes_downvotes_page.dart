import 'package:flutter/material.dart';

class AnswerUpVotesDownVotesPage extends StatefulWidget {
  final String title;
  final Widget bodyContent;
  AnswerUpVotesDownVotesPage({@required this.title, @required this.bodyContent});
  @override
  _AnswerUpVotesDownVotesPageState createState() => _AnswerUpVotesDownVotesPageState();
}

class _AnswerUpVotesDownVotesPageState extends State<AnswerUpVotesDownVotesPage> {
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
