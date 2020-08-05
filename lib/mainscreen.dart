import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List restaurantData;
  double screenHeight, screenWidth;
  // bool _visible = false;
  String curtype = "Recent";
  String titlecenter = "No restaurant found";
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: History',
      style: optionStyle,
    ),
    Text(
      'Index 2: Bookmarked',
      style: optionStyle,
    ),
    Text(
      'Index 3: Account',
      style: optionStyle,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'Food Domains',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        brightness: Brightness.light,
        // textTheme: GoogleFonts.anaheimTextTheme(
        //   Theme.of(context).textTheme,
        // ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Restaurant List',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Visibility(
                child: Card(
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FlatButton(
                              color: Color.fromRGBO(255, 191, 0, 50),
                              onPressed: () => _sortItem("Canteen"),
                              padding: EdgeInsets.all(10.0),
                              child: Text("Canteen"),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Column(
                          children: <Widget>[
                            FlatButton(
                              color: Color.fromRGBO(255, 191, 0, 50),
                              onPressed: () => _sortItem("Cafe"),
                              padding: EdgeInsets.all(10.0),
                              child: Text("Cafe"),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
            )),
            restaurantData == null
                ? Flexible(
                    child: Container(
                        child: Center(
                    child: Text(titlecenter),
                  )))
                : Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (screenWidth / screenHeight) / 0.8,
                        children: List.generate(restaurantData.length, (index) {
                          return Container(
                              child: Card(
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () => _onImageDisplay(index),
                                    child: Container(
                                      height: screenHeight / 5,
                                      width: screenWidth / 3,
                                      child: ClipRRect(
                                          child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            "https://twindmime.000webhostapp.com/food_domains/images/${restaurantData[index]['imagename']}",
                                        placeholder: (context, url) =>
                                            new CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                      )),
                                    ),
                                  ),
                                  Text(restaurantData[index]['name'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  Text(restaurantData[index]['location'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  Text(restaurantData[index]['hours'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  Text(restaurantData[index]['contact'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                          ));
                        })))
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            title: Text('Bookmarked'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Account'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      ),
    );
  }

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              color: Colors.black,
              height: screenHeight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: screenWidth,
                      width: screenWidth / 1.5,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          image: DecorationImage(
                              fit: BoxFit.scaleDown,
                              image: NetworkImage(
                                  "https://twindmime.000webhostapp.com/food_domains/images/${restaurantData[index]['imagename']}")))),
                  Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(restaurantData[index]['category'],
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text(restaurantData[index]['name'],
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text(restaurantData[index]['location'],
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text(restaurantData[index]['hours'],
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          Text(restaurantData[index]['contact'],
                              maxLines: 1,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ]),
                  )
                ],
              ),
            ));
      },
    );
  }

  void _loadData() {
    String urlLoadJobs =
        "https://twindmime.000webhostapp.com/food_domains/get_restaurants.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        restaurantData = extractdata["category"];
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _sortItem(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://twindmime.000webhostapp.com/food_domains/get_restaurants.php";
      http.post(urlLoadJobs, body: {
        "category": type,
      }).then((res) {
        setState(() {
          curtype = type;
          var extractdata = json.decode(res.body);
          restaurantData = extractdata["category"];
          FocusScope.of(context).requestFocus(new FocusNode());
          pr.hide();
        });
      }).catchError((err) {
        print(err);
        pr.hide();
      });
      pr.hide();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
