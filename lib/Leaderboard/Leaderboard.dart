import 'package:flutter/material.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: RichText(
            text: TextSpan(
                text: "Leader Board",
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
        body: Column(
          children: <Widget>[
            Container(
              height: 300.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 300.0,
                    color: Colors.deepOrange,
                  ),
                  Align(alignment: Alignment(-0.7, 0), child: StackItem()),
                  Align(
                    alignment: Alignment(0, -0.4),
                    child: StackItem(),
                  ),
                  Align(alignment: Alignment(0.7, 0), child: StackItem()),
                ],
              ),
            ),
            TabBar(
              indicatorWeight: 4.0,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xffff6468),
              tabs: <Widget>[
                Tab(
                  text: "Running",
                ),
                Tab(text: "Overall"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Container(
                    height: 100.0,
                    child: ListView.builder(
                      itemBuilder: (context, index) => ProfileItem(
                        index: index + 1,
                      ),
                      shrinkWrap: true,
                      itemCount: 4,
                    ),
                  ),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StackItem extends StatelessWidget {
  final bool large;

  const StackItem({Key key, this.large = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: large ? 90 : 60.0,
          height: large ? 90 : 60.0,
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 70,
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.asset(
                      "assets/johnny.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.9, -0.9),
                child: Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text("2",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ))),
                ),
              ),
            ],
          ),
        ),
        Text("name"),
        Text("info"),
      ],
    );
  }
}

class ProfileItem extends StatelessWidget {
  final int index;

  const ProfileItem({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "$index",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CircleAvatar(
              radius: 70,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.asset(
                    "assets/johnny.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "name",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                "some info",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: index % 3 == 0
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        style: BorderStyle.solid,
                        width: 4.0,
                        color: Colors.green,
                      ),
                    ),
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.add,
                      size: 20.0,
                      color: Colors.green,
                    ),
                  )
                : Text(
                    "following",
                    style: TextStyle(
                      color: Color(0xffff6468),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
