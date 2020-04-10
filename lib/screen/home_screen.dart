import 'dart:convert';

import 'package:covid/covid.dart';
import 'package:covid/screen/details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
              })
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
      if(covid.name!='All')
      covidCases.add(covid);
    }

    reOrder();
    refactor();
    return respon.body;
  }

  void refactor() {
    for (var covid in covidCases) {
      if (covid.name == 'USA') {
        covid.addImage(
            'https://www.gstatic.com/onebox/sports/logos/flags/united_states_icon_square.png');
      } else if (covid.name == 'UK') {
        covid.addImage(
            'https://www.gstatic.com/onebox/sports/logos/flags/united_kingdom_icon_square.png');
      } else if (covid.name == 'Saudi-Arabia') {
        covid.addImage(
            'https://www.gstatic.com/onebox/sports/logos/flags/saudi_arabia_icon_square.png');
      } else if (covid.name == 'UAE') {
        covid.addImage(
            'https://www.gstatic.com/onebox/sports/logos/flags/united_arab_emirates_icon_square.png');
      } else if (covid.name == 'S-Korea') {
        covid.addImage(
            'https://www.gstatic.com/onebox/sports/logos/flags/south_korea_icon_square.png');
      } else if (covid.name == 'South_Africa') {
        covid.addImage(
            'https://www.gstatic.com/onebox/sports/logos/flags/south_africa_icon_square.png');
      } else if (covid.name == 'Czechia') {
        covid.addImage(
            'https://www.gstatic.com/onebox/sports/logos/flags/czech_republic_icon_square.png');
      } else
        covid.addImage(
            'https://www.gstatic.com/onebox/sports/logos/flags/${covid.name.toLowerCase()}_icon_square.png');
    }
  }

  Widget getItem({Covid covid}) {
    return InkWell(
      child: Card(
        elevation: 12,
        margin: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 20),
                  Row(children: [
                    Image.network(covid.imageUrl),
                    SizedBox(width: 8),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${covid.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
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
                                  fontSize: 23, fontWeight: FontWeight.bold)),
                          SizedBox(height: 3),
                          FittedBox(
                            child: Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Text('${covid.newCase}', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  SizedBox(width: 40),
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
                              Icon(
                                Icons.people,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 3),
                                  Text('${covid.recovered}',
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 3),
                                  Text('Recovered',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white))
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
                            Icon(Icons.people, color: Colors.white),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 3),
                                Text('${covid.totalDeath}',
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 3),
                                Text(
                                  'Death',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Text('${covid.newDeath}',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
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
