import 'package:adhyapak/Services/auth.dart';
import 'package:adhyapak/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();
  String name, email, password;
  bool showPassword1, showPassword2, match;

  @override
  void initState() {
    showPassword1 = true;
    showPassword2 = true;
    match = false;
    super.initState();
  }


  @override
  void dispose() {
    textEditingController1.dispose();
    textEditingController2.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: RichText(
            text: TextSpan(
              text: "Sign Up",
              style: TextStyle(
                color: Color(0xFF071E22),
                fontSize: 25,
                fontWeight: FontWeight.bold
              )
            ),
          ),
          backgroundColor:  Color(0xFF99EDCC),
          iconTheme: IconThemeData(color: Color(0xFF071E22)),
          centerTitle: true,
          elevation: 0.0,
        ),
        backgroundColor:  Color(0xFF99EDCC),
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            padding: EdgeInsets.all(10),
            color:  Color(0xFF99EDCC),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20,),
                CircleAvatar(
                  radius: 70,
                  backgroundColor:  Color(0xFF99EDCC),
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/clima-app-723ef.appspot.com/o/WhatsApp%20Image%202021-04-26%20at%2006.31.17.jpeg?alt=media&token=db322abd-99f3-44dc-8443-a4920a829cd7",
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                    null ?
                                loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                    : null,
                              )
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            style: TextStyle(
                              color:  Color(0xFF071E22),
                            ),
                            cursorColor:  Color(0xFF071E22),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Color(0xFF071E22),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color:  Color(0xFF071E22),
                                ),
                              ),
                              labelText: "Name",
                              labelStyle: TextStyle(
                                color: Color(0xFF071E22),
                              ),
                              prefixIcon: Icon(Icons.person_outline_sharp, color: Color(0xFF071E22),),
                            ),
                            validator: (input) {
                              return input.isEmpty ? "Enter Name" : null;
                            },
                            onSaved: (input) {
                              name = input;
                            },
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            style: TextStyle(
                              color:  Color(0xFF071E22),
                            ),
                            cursorColor:  Color(0xFF071E22),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Color(0xFF071E22),
                                  )
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color:  Color(0xFF071E22),
                                ),
                              ),
                              labelText: "Email",
                              labelStyle: TextStyle(
                                color: Color(0xFF071E22),
                              ),
                              prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF071E22),),
                            ),
                            validator: (input) {
                              return input.isEmpty ? "Enter Email" : null;
                            },
                            onSaved: (input) {
                              email = input;
                            },
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            controller: textEditingController1,
                            style: TextStyle(
                              color:  Color(0xFF071E22),
                            ),
                            cursorColor:  Color(0xFF071E22),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: textEditingController1.text.isEmpty
                                      ? Color(0xFF071E22)
                                      : (match
                                      ? Color(0xFF0c7054)
                                      : Colors.red),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: textEditingController1.text.isEmpty
                                      ?  Color(0xFF071E22)
                                      : (match
                                      ? Color(0xFF0c7054)
                                      : Colors.red),
                                ),
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: Color(0xFF071E22),
                              ),
                              prefixIcon: Icon(Icons.lock_outline_sharp, color: Color(0xFF071E22),),
                              suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showPassword1 = !showPassword1;
                                  });
                                },
                                child: showPassword1 == true
                                    ? Icon(Icons.visibility, color: Color(0xFF071E22),)
                                    : Icon(Icons.visibility_off, color: Color(0xFF071E22),),
                              ),
                            ),
                            validator: (input) {
                              if (input.isEmpty) {
                                return "Enter Password";
                              }
                              if (input.length < 8) {
                                return "Password must be greater than or equal to 8 characters";
                              }
                              return null;
                            },
                            obscureText: showPassword1,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: TextFormField(
                            controller: textEditingController2,
                            style: TextStyle(
                              color:  Color(0xFF071E22),
                            ),
                            cursorColor:  Color(0xFF071E22),
                            decoration: InputDecoration(
                              enabledBorder:UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: textEditingController2.text.isEmpty
                                      ? Color(0xFF071E22)
                                      : (match
                                      ? Color(0xFF0c7054)
                                      : Colors.red),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: textEditingController2.text.isEmpty
                                      ?  Color(0xFF071E22)
                                      : (match
                                      ? Color(0xFF0c7054)
                                      : Colors.red),
                                ),
                              ),
                              labelText: "Confirm Password",
                              labelStyle: TextStyle(
                                color: Color(0xFF071E22),
                              ),
                              prefixIcon: Icon(Icons.lock_outline_sharp, color: Color(0xFF071E22),),
                              suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showPassword2 = !showPassword2;
                                  });
                                },
                                child: showPassword2 == true
                                    ? Icon(Icons.visibility, color:Color(0xFF071E22),)
                                    : Icon(Icons.visibility_off, color: Color(0xFF071E22),),
                              ),
                            ),
                            onChanged: (text) {
                              print(text);
                              if (textEditingController1.text.isNotEmpty ==
                                  true) {
                                if (textEditingController1.text.toString() == text) {
                                  setState(() {
                                    match = true;
                                  });
                                }
                                else
                                {
                                  setState(() {
                                    match = false;
                                  });
                                }
                              }
                            },
                            validator: (input) {
                              if (input.isEmpty) {
                                return "Enter the above Password again";
                              }
                              if (textEditingController1.text.toString() !=
                                  input ) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                            obscureText: showPassword2,
                            onSaved: (input) {
                              password = input;
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.1,),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              Provider.of<Authentication>(context,
                                  listen: false)
                                  .createAccount(context, email, name, password)
                                  .whenComplete(() {
                                Provider.of<DatabaseMethods>(context,
                                    listen: false)
                                    .createUserCollection(context, {
                                  "userid": Provider.of<Authentication>(context,
                                      listen: false)
                                      .getUserUid,
                                  "email": email,
                                  "name": name,
                                  "photoUrl" : null,
                                  "points" : 0,
                                });
                                Navigator.pushReplacementNamed(context, "/");
                              });
                            }
                          },
                          child: Text('Sign up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 110, vertical: 15),
                            primary: Color(0xFF1D7874),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an Account?",
                              style: TextStyle(
                                color: Color(0xFF071E22),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              child: Text(
                                "Click here",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color:  Color(0xFF1D7874),
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, "signIn");
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              primary: Colors.lightBlue,
                              padding: EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                            ),
                            child: Text(
                              "Sign Up With Google",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Provider.of<Authentication>(context,
                                  listen: false)
                                  .signInWithGoogle(context);
                            }),
                        SizedBox(height: 50,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
