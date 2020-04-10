import 'dart:convert';
import 'package:covid/covid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

class DetailesScreen extends StatelessWidget {
  Covid covid;
  DetailesScreen(this.covid);
  List<Covid> covidHistory = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(covid.name),
      ),
      body: FutureBuilder<String>(
        builder: (context, value) {
          if (value.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            color: Color(0xffE5E5E5),
            child: StaggeredGridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: mychart1Items("Total Cases", "${covid.totalCases}"),
                ),
              ],
              staggeredTiles: [
                StaggeredTile.extent(4, 250.0),
              ],
            ),
          );
        },
        future: getHistory(covid.name),
      ),
    );
  }

  Future<String> getHistory(String country) async {
    final respone = await http.get(
        'https://covid-193.p.rapidapi.com/history?country=${country}',
        headers: {
          'x-rapidapi-host': "covid-193.p.rapidapi.com",
          'x-rapidapi-key': "e9b528aeebmsh9ad7303265128c3p16cf14jsnbf9ab4a6f380"
        });
    final result = jsonDecode(respone.body);
    print(result['results']);
    for (var covidSrc in result['response']) {
      Covid covid = Covid.fromJson(covidSrc);
      if (covidHistory.length > 0) {
        Covid lastCovid = covidHistory.last;
      } else {
        covidHistory.add(covid);
      }
    }
    for (var i = 0; i < 20; i++) {
    }
    print(covidHistory.length);
  }

  List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.time,
        domainLowerBoundFn: (sales, _) => 60,
        
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  Material mychart1Items(
    String title,
    String priceVal,
  ) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Text(
                          '${title}: ',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Text(
                          priceVal,
                          style: TextStyle(fontSize: 30.0, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Container(
                      width: 370,
                      height: 160,
                      child: charts.LineChart(
                        _createSampleData(),
                        animate: false,
                        defaultRenderer:
                            new charts.LineRendererConfig(includePoints: true),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinearSales {
  final DateTime year;
  final int sales;
  final time;
  LinearSales(this.year, this.sales)
      : time = year.day + monthsToDays(year.month);
}

int monthsToDays(int month) {
  if (month == 1) {
    return 0;
  } else if (month == 3) {
    return 29 + monthsToDays(month - 1);
  } else if (month % 2 == 0) {
    return 31 + monthsToDays(month - 1);
  } else {
    return 30 + monthsToDays(month - 1);
  }
}
