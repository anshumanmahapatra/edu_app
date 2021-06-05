
import 'package:adhyapak/Doubt/add_doubt.dart';
import 'package:adhyapak/Doubt/doubt_home.dart';
import 'package:adhyapak/Helpers/essentials.dart';
import 'package:adhyapak/Rural%20Education/rural_home.dart';
import 'package:adhyapak/Services/auth.dart';
import 'package:adhyapak/Services/database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  int selectedIndex;
  bool goBack = false;

  KeyboardVisibilityController keyboardVisibilityController = KeyboardVisibilityController();

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];


  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "start");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<DatabaseMethods>(context, listen: false).initUserData(context);
    this.checkAuthentication();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {

        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[selectedIndex].currentState.maybePop();

        print(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());
        print("keyboard visibile:" + keyboardVisibilityController.isVisible.toString());

        if(isFirstRouteInCurrentTab) {
          if(keyboardVisibilityController.isVisible == false) {
            if(selectedIndex != 0) {
              setState(() {
                Provider.of<Essentials>(context, listen: false).navBarKey.currentState.setPage(0);
                selectedIndex = 0;
              });
            } else {
              setState(() {
                goBack = true;
                Provider.of<DatabaseMethods>(context, listen: false)
                    .initDoubtPost = null;
              });
            }
          }
        }
        if(goBack == false) {
          return goBack;
        } else {
          Provider.of<Authentication>(context, listen: false).signOut();
          return goBack;
        }
      },
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: Provider.of<Essentials>(context, listen: false).navBarKey,
            backgroundColor: Colors.transparent,
            color: Color(0xFF99EDCC),
            items: [
              Icon(Icons.home_outlined, size: 30, color:  Color(0xFF071E22),),
              Icon(Icons.add, size: 30, color:  Color(0xFF071E22),),
              Icon(Icons.school_outlined, size: 30, color:  Color(0xFF071E22),),
            ],
            onTap: (index) {
             setState(() {
               selectedIndex = index;
             });
            },
            height: 50,
            index: 0,
            animationDuration: Duration(milliseconds: 400),
          animationCurve: Curves.easeIn,
          ),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
          ],
        ),
      ),
    );
  }


  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          DoubtHome(),
          AddDoubt(navBarKey: Provider.of<Essentials>(context, listen: false).navBarKey,),
          RuralHome(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}
