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

    if (name == 'All') {
      name = 'World';
      imageUrl =
          'https://www.gstatic.com/images/icons/material/system_gm/1x/language_googblue_24dp.png';
    } else if (name == 'USA') {
      imageUrl =
          'https://www.gstatic.com/onebox/sports/logos/flags/united_states_icon_square.png';
    } else if (name == 'UK') {
      imageUrl =
          'https://www.gstatic.com/onebox/sports/logos/flags/united_kingdom_icon_square.png';
    } else if (name == 'Saudi-Arabia') {
      imageUrl =
          'https://www.gstatic.com/onebox/sports/logos/flags/saudi_arabia_icon_square.png';
    } else if (name == 'UAE') {
      imageUrl =
          'https://www.gstatic.com/onebox/sports/logos/flags/united_arab_emirates_icon_square.png';
    } else if (name == 'S-Korea') {
      imageUrl =
          'https://www.gstatic.com/onebox/sports/logos/flags/south_korea_icon_square.png';
    } else if (name == 'South_Africa') {
      imageUrl =
          'https://www.gstatic.com/onebox/sports/logos/flags/south_africa_icon_square.png';
    } else if (name == 'Czechia') {
      imageUrl =
          'https://www.gstatic.com/onebox/sports/logos/flags/czech_republic_icon_square.png';
    } else if (name == 'Hong-Kong') {
      imageUrl =
          'https://www.gstatic.com/onebox/sports/logos/flags/hong_kong_icon_square.png';
    } else if (name == 'New-Zealand') {
      imageUrl =
          'https://www.gstatic.com/onebox/sports/logos/flags/new_zealand_icon_square.png';
    } else {
      imageUrl =
          'https://www.gstatic.com/onebox/sports/logos/flags/${name.toLowerCase()}_icon_square.png';
      print(name);
    }
  }
  void addImage(String url) {
    imageUrl = url;
  }

  void addName(String nameIn) {
    this.name = nameIn;
  }

  void setNewCases(String cases) {
    this.newCase = cases;
  }

  void setNewDeath(String cases) {
    this.newDeath = cases;
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
