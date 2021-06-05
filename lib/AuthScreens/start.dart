import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/" ); //correction
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }


  navigateToSignIn() async {
    Navigator.pushNamed(context, "signIn");
  }

  navigateToSignUp() async {
    Navigator.pushNamed(context, "signUp");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF99EDCC),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 150.0),
              CircleAvatar(
                radius: 70,
                backgroundColor:  Color(0xFF99EDCC),
                child:  Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.network("https://firebasestorage.googleapis.com/v0/b/clima-app-723ef.appspot.com/o/WhatsApp%20Image%202021-04-26%20at%2006.31.17.jpeg?alt=media&token=db322abd-99f3-44dc-8443-a4920a829cd7",
                      fit: BoxFit.fill,
                      loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null ?
                              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                  : null,
                            )
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                margin: EdgeInsets.fromLTRB(35.0, 0.0, 35.0, 0.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Welcome to ', style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF261320)
                  ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.all(5),
                child: Text('ADHYAPAK -',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:  Color(0xFF071E22),
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text('where Students are their own Teachers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:   Color(0xFF071E22),
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),),
              ),
              SizedBox(height: 30.0),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: navigateToSignIn,
                    child: Text('SIGN IN', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary:  Color(0xFF1D7874),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: navigateToSignUp,
                    child: Text('SIGN UP', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white  ,
                    ),),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary:  Color(0xFF1D7874),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}


