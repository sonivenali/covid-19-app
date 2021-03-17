import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CountryDetailPage extends StatefulWidget {
  final String countryName;

  const CountryDetailPage({Key key, this.countryName}) : super(key: key);

  @override
  _CountryDetailPageState createState() => _CountryDetailPageState();
}

class _CountryDetailPageState extends State<CountryDetailPage> {

  final format = DateFormat('yyyy-MM-dd');
  String apiurl ;
   DetailData data;
   @override
  void initState() {
    super.initState();
  //  apiurl = 'https://api.covid19api.com/country/${widget.countryName}?from=${format.format(DateTime.now().subtract(Duration(days: 1)))}T00:00:00Z&to=${format.format(DateTime.now())}T00:00:00Z';
  apiurl = 'https://api.covid19api.com/live/country/${widget.countryName}';
   print(apiurl);
    print('init state called');
    LoadData();
  }

  
  @override
  Widget build(BuildContext context) {
   return Scaffold(
        body: Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/images/earth.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateFormat('dd MMMM yyyy').format(DateTime.now()),
                style: TextStyle(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                   data != null
                          ? data.country.toString()
                          : 'Loading Data',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: Colors.white54,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Positive',
                      style: TextStyle(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 36),
                      child: Text(
                        'Recover',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      data != null
                          ? data.confirmed.toString()
                          : 'Loading Data',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 23),
                      child: Text(
                        data != null
                            ? data.recovered.toString()
                            : 'Loading Data',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Active',
                      style: TextStyle(color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 36),
                      child: Text(
                        'Died',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      data != null
                          ? data.active.toString():
                               
                          'Loading Data',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 23),
                      child: Text(
                        data != null
                            ? data.deaths.toString()
                            : 'Loading Data',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
           
            ],
          ),
        )
      ],
    ));
  
  } 
   LoadData() async {
    var response = await http.get(apiurl);
    var jsonResponse = jsonDecode(response.body);
    setState(() {
      if(jsonResponse.length>=1){
      data = DetailData.fromJson(jsonResponse[jsonResponse.length-1]);
      }else if(jsonResponse.length==0){
             data = null;
             _showDialog();

     }
      });
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert"),
          content: new Text("Data for this country is not available"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                 Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}




class DetailData {
  String country;
  String countryCode;
  String province;
  String city;
  String cityCode;
  String lat;
  String lon;
  int confirmed;
  int deaths;
  int recovered;
  int active;
  String date;

  DetailData(
      {this.country,
      this.countryCode,
      this.province,
      this.city,
      this.cityCode,
      this.lat,
      this.lon,
      this.confirmed,
      this.deaths,
      this.recovered,
      this.active,
      this.date});

  DetailData.fromJson(Map<String, dynamic> json) {
    country = json['Country'];
    countryCode = json['CountryCode'];
    province = json['Province'];
    city = json['City'];
    cityCode = json['CityCode'];
    lat = json['Lat'];
    lon = json['Lon'];
    confirmed = json['Confirmed'];
    deaths = json['Deaths'];
    recovered = json['Recovered'];
    active = json['Active'];
    date = json['Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Country'] = this.country;
    data['CountryCode'] = this.countryCode;
    data['Province'] = this.province;
    data['City'] = this.city;
    data['CityCode'] = this.cityCode;
    data['Lat'] = this.lat;
    data['Lon'] = this.lon;
    data['Confirmed'] = this.confirmed;
    data['Deaths'] = this.deaths;
    data['Recovered'] = this.recovered;
    data['Active'] = this.active;
    data['Date'] = this.date;
    return data;
  }
}

