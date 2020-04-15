import 'dart:convert';

import 'package:covid/covid.dart';
import 'package:covid/screen/details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum Settings { Options, ContactUs }

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  List<Covid> covidCases = [];
  var currentIcon = Icons.search;
  Widget currentBar = Text('Covid-19 Tracker');
  TextEditingController countryName = TextEditingController();
  bool white = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Covid> searchResults = [];
  bool called = true;

  void searchValue(String name) {
    setState(() {
      searchResults = covidCases
          .where((item) => item.name.toLowerCase() == name.toLowerCase())
          .toList();
      print(searchResults);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: currentBar,
        actions: <Widget>[
          IconButton(
              icon: Icon(currentIcon),
              onPressed: () {
                setState(() {
                  if (currentIcon == Icons.search) {
                    currentIcon = Icons.cancel;
                    currentBar = TextField(
                        onSubmitted: (value) {
                          searchValue(value);
                        },
                        controller: countryName,
                        decoration: InputDecoration(
                            hintText: 'Search country!',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textInputAction: TextInputAction.go);
                  } else {
                    setState(() {
                      currentIcon = Icons.search;
                      currentBar = Text('Covid-19 Tracker');
                      searchResults = [];
                    });
                  }
                });
              }),
          PopupMenuButton<Settings>(
              onSelected: (setting) {
                if (setting == Settings.ContactUs) {
                  showAboutDialog(
                      context: context,
                      applicationName: 'COVID tracker',
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Name:'),
                            Text(
                              'Mohamed Abu El-Naga',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Phone/WhatsApp:'),
                            Text('+201006540175',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Email:'),
                            Text('mohamed.abuelnga03@gmail.com',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        )
                      ]);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Settings>>[
                    const PopupMenuItem<Settings>(
                      value: Settings.ContactUs,
                      child: Text('Contact Us'),
                    ),
                  ])
        ],
      ),
      body: FutureBuilder(
        builder: (context, value) {
          if (value.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.1,
            child: ListView.builder(
              itemBuilder: (_, index) {
                if (searchResults.length > 0) {
                  return getItem(covid: searchResults[0]);
                }
                return getItem(covid: covidCases[index]);
              },
              itemCount: searchResults.length > 0 ? 1 : covidCases.length,
            ),
          );
        },
        future: getData(),
      ),
    );
  }

  void reOrder() {
    covidCases.sort((b, a) => b.compareTo(a));
  }

  Future<String> getData() async {
    if (covidCases.length > 1) {
      return '';
    }
    final respon = await http.get(
      'https://covid-193.p.rapidapi.com/statistics',
      headers: {
        "x-rapidapi-host": "covid-193.p.rapidapi.com",
        "x-rapidapi-key": "e9b528aeebmsh9ad7303265128c3p16cf14jsnbf9ab4a6f380"
      },
    );
    var jsonRespone = json.decode(respon.body);
    print((jsonRespone['response'] as List).length);
    for (var covidJson in (jsonRespone['response'] as List)) {
      Covid covid = Covid.fromJson(covidJson);
      covidCases.add(covid);
    }
    reOrder();
    refactor();
    return respon.body;
  }

  List<String> crash = [
    'Dominican-Republic',
    'Bosnia-and-Herzegovina',
    'Oceania',
    'North-Macedonia',
    'Diamond-Princess-',
    'Diamond-Princess',
    'Ivory-Coast',
    'Costa-Rica',
    'Burkina-Faso',
    'Channel-Islands',
    'R&eacute;union',
    'San-Marino',
    'Isle-of-Man',
    'DRC',
    'Sri-Lanka',
    'Faeroe-Islands',
    'El-Salvador',
    'Trinidad-and-Tobago',
    'Congo',
    'French-Guiana',
    'Bermuda',
    'Cabo-Verde',
    'French-Polynesia',
    'Cayman-Islands',
    'Sint-Maarten',
    'Equatorial-Guinea',
    'Macao',
    'Bahamas',
    'Guinea-Bissau',
    'Puerto-Rico',
    'Saint-Martin',
    'Antigua-and-Barbuda',
    'New-Caledonia',
    'US-Virgin-Islands',
    'Saint-Lucia',
    'Saint-Kitts-and-Nevis',
    'St-Vincent-Grenadines',
    'Sao-Tome-and-Principe',
    'Caribbean-Netherlands',
    'PapuA-New-Guinea',
    'Saint-Pierre-Miquelon',
  ];
  void refactor() {
    covidCases.removeWhere((item) => crash.contains(item.name));
    for (var covid in covidCases) {
      int newCases = int.parse(covid.newCase);
      if (newCases > 1000) {
        //covid.setNewCases('${(newCases/1000 as int)}K');
        int play = newCases ~/ 1000;
        print(play);
        covid.setNewCases('${play}K');
      }
      int newDeath = int.parse(covid.newDeath);
      if (newDeath > 1000) {
        //covid.setNewCases('${(newCases/1000 as int)}K');
        int play = newDeath ~/ 1000;
        covid.setNewDeath('${play}K');
      }
    }
  }

  Widget getItem({Covid covid}) {
    if (Image.network(covid.imageUrl) == null) {
      print('null');
      return Container();
    }
    return InkWell(
      child: Card(
        elevation: 12,
        margin: EdgeInsets.symmetric(
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 20),
                  Row(children: [
                    Image.network(
                      covid.imageUrl,
                    ),
                    SizedBox(width: 8),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${covid.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                          Row(children: [
                            Text(
                              'Active:',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '${covid.active}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ]),
                  ]),
                  Expanded(child: Container()),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('${covid.totalCases}',
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.bold)),
                          SizedBox(height: 3),
                          FittedBox(
                            child: Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      (covid.newCase.isNotEmpty &&
                              covid.newCase != null &&
                              covid.newCase != 'null')
                          ? Chip(
                              elevation: 5,
                              label: Text('${covid.newCase}',
                                  style: TextStyle(fontSize: 12)),
                            )
                          : SizedBox(
                              width: 8,
                            ),
                    ],
                  ),
                ],
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 150, 0, 1),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 3),
                                  Text('${covid.recovered}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 3),
                                  Text('Recovered',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 3),
                                Text('${covid.totalDeath}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 3),
                                Text(
                                  'Death',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            (covid.newDeath.isNotEmpty &&
                                    covid.newDeath != null &&
                                    covid.newDeath != 'null')
                                ? Chip(
                                    label: Text(
                                      '${covid.newDeath}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                    elevation: 5,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
