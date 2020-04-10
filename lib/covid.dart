import 'package:flutter/cupertino.dart';

class Covid implements Comparable {
  String name = '';
  String active = '';
  int totalCases = 0;
  String newCase = '';
  int totalDeath = 0;
  String newDeath = '';
  String recovered = '';
  String critical = '';
  String imageUrl = '';

  Covid(
      {this.name,
      this.active,
      this.totalCases,
      this.newCase,
      this.totalDeath,
      this.newDeath,
      this.recovered});

  Covid.fromJson(jsonObject) {
    name = '${jsonObject['country']}';
    newCase = '${jsonObject['cases']['new']}';
    active = '${jsonObject['cases']['active']}';
    critical = '${jsonObject['cases']['critical']}';
    recovered = '${jsonObject['cases']['recovered']}';
    totalCases = jsonObject['cases']['total'] as int;
    totalDeath = jsonObject['deaths']['total'] as int;
    newDeath = '${jsonObject['deaths']['new']}';
  }
  void addImage(String url) {
    imageUrl = url;
  }

  void addName(String nameIn) {
    this.name = nameIn;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'name:$name\nactive:$active\ntotal:$totalCases\ncritical:$critical\nrecovered:$recovered\ntotalCases:$totalCases\ntotalDeath:$totalDeath\n-----------\n';
  }

  @override
  int compareTo(other) {
    if (this.totalCases == null || other == null) {
      return null;
    }

    if (this.totalCases < other.totalCases) {
      return 1;
    }

    if (this.totalCases > other.totalCases) {
      return -1;
    }

    if (this.totalCases == other.totalCases) {
      return 0;
    }

    return null;
  }
}
