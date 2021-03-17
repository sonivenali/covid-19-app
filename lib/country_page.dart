import 'dart:convert';

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quick_app/country_detail_page.dart';

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  final apiurl = 'https://api.covid19api.com/countries';
  List<Country_Data> data;

  @override
  void initState() {
    super.initState();
    print('init state called');
    LoadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Countries',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: data==null?Center(child: CircularProgressIndicator()): ListView.builder(
        itemBuilder: (context, position) {
          return GestureDetector(onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CountryDetailPage(
                            countryName: data[position].iSO2,
                            )));
          },
                      child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //Flags.getFlag(country: data[position].iSO2, height: 50, width: 50),
                  Text(data[position].country,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );
        },
        itemCount: data.length,
      ),
    );
  }

  LoadData() async {
    var response = await http.get(apiurl);
    setState(() {
      Iterable l = json.decode(response.body);
      data = l.map((map) => Country_Data.fromJson(map)).toList();
      data.sort((a,b)=>a.country.compareTo(b.country));
    
//data = l.map((Map<String,dynamic> model)=> Country_Data.fromJson(model)).toList();
    });
  }
}

class Country_Data {
  String country;
  String slug;
  String iSO2;

  Country_Data({this.country, this.slug, this.iSO2});

  Country_Data.fromJson(Map<String, dynamic> json) {
    country = json['Country'];
    slug = json['Slug'];
    iSO2 = json['ISO2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Country'] = this.country;
    data['Slug'] = this.slug;
    data['ISO2'] = this.iSO2;
    return data;
  }
}
